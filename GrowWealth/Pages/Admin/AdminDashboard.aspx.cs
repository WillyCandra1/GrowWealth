using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace GrowWealth.Pages.Admin
{
    public partial class AdminDashboard : Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStats();
                LoadRecentUsers();
                LoadActivityFeed();
                LoadCoursesTable();
            }
        }

        private void LoadStats()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand c1 = new SqlCommand("SELECT COUNT(*) FROM [User]", conn);
                litTotalUsers.Text = c1.ExecuteScalar().ToString();

                SqlCommand c1a = new SqlCommand("SELECT COUNT(*) FROM [User] WHERE AccountStatus = 'Active'", conn);
                litActiveUsers.Text = c1a.ExecuteScalar().ToString();

                SqlCommand c2 = new SqlCommand("SELECT COUNT(*) FROM Course WHERE IsActive = 1", conn);
                litTotalCourses.Text = c2.ExecuteScalar().ToString();

                SqlCommand c3 = new SqlCommand("SELECT COUNT(*) FROM Module", conn);
                litTotalModules.Text = c3.ExecuteScalar().ToString();

                SqlCommand c4 = new SqlCommand("SELECT COUNT(*) FROM Quiz", conn);
                litTotalQuizzes.Text = c4.ExecuteScalar().ToString();

                SqlCommand c5 = new SqlCommand("SELECT COUNT(*) FROM Quiz_Attempt", conn);
                litTotalAttempts.Text = c5.ExecuteScalar().ToString();

                SqlCommand c6 = new SqlCommand(
                    "SELECT AVG(CAST(Score AS FLOAT) * 100.0 / NULLIF(TotalQuestions, 0)) FROM Quiz_Attempt", conn);
                object avg = c6.ExecuteScalar();
                litAvgScore.Text = (avg == null || avg == DBNull.Value) ? "0" : Convert.ToInt32(avg).ToString();
            }
        }

        private void LoadRecentUsers()
        {
            string sql = @"
                SELECT TOP 8 u.FullName, u.Email, r.RoleName, u.AccountStatus, u.CreatedAt
                FROM [User] u
                INNER JOIN Role r ON u.RoleID = r.RoleID
                ORDER BY u.CreatedAt DESC";

            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                new SqlDataAdapter(sql, conn).Fill(dt);
            }

            dt.Columns.Add("RoleClass", typeof(string));
            dt.Columns.Add("StatusClass", typeof(string));
            dt.Columns.Add("CreatedAtFmt", typeof(string));
            foreach (DataRow row in dt.Rows)
            {
                string role = row["RoleName"].ToString();
                row["RoleClass"] = (role == "Admin") ? "admin" : "member";
                row["StatusClass"] = (row["AccountStatus"].ToString() == "Active") ? "" : "suspended";
                row["CreatedAtFmt"] = Convert.ToDateTime(row["CreatedAt"]).ToString("dd MMM yyyy");
            }

            rptRecentUsers.DataSource = dt;
            rptRecentUsers.DataBind();
        }

        private void LoadActivityFeed()
        {
            string sql = @"
                SELECT TOP 10 Description, ActivityTime, ActivityType FROM (
                    SELECT
                        u.FullName + ' scored ' +
                        CAST(CAST(qa.Score * 100.0 / NULLIF(qa.TotalQuestions, 0) AS INT) AS NVARCHAR(10)) +
                        '% on ' + qz.Title AS Description,
                        qa.AttemptedAt AS ActivityTime,
                        'quiz' AS ActivityType
                    FROM Quiz_Attempt qa
                    INNER JOIN Quiz qz ON qa.QuizID = qz.QuizID
                    INNER JOIN [User] u ON qa.UserID = u.UserID

                    UNION ALL

                    SELECT
                        u.FullName + ' enrolled in ' + c.Title AS Description,
                        e.EnrolledAt AS ActivityTime,
                        'enroll' AS ActivityType
                    FROM Enrollment e
                    INNER JOIN Course c ON e.CourseID = c.CourseID
                    INNER JOIN [User] u ON e.UserID = u.UserID

                    UNION ALL

                    SELECT
                        u.FullName + ' registered an account' AS Description,
                        u.CreatedAt AS ActivityTime,
                        'register' AS ActivityType
                    FROM [User] u
                ) AS combined
                ORDER BY ActivityTime DESC";

            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                new SqlDataAdapter(sql, conn).Fill(dt);
            }

            dt.Columns.Add("IconClass", typeof(string));
            dt.Columns.Add("IconText", typeof(string));
            dt.Columns.Add("RelativeTime", typeof(string));
            foreach (DataRow row in dt.Rows)
            {
                string type = row["ActivityType"].ToString();
                if (type == "quiz") { row["IconClass"] = "gold"; row["IconText"] = "Q"; }
                else if (type == "enroll") { row["IconClass"] = "blue"; row["IconText"] = "+"; }
                else { row["IconClass"] = ""; row["IconText"] = "&#9733;"; }

                row["RelativeTime"] = ToRelativeTime(Convert.ToDateTime(row["ActivityTime"]));
            }

            rptFeed.DataSource = dt;
            rptFeed.DataBind();
        }

        private void LoadCoursesTable()
        {
            string sql = @"
                SELECT
                    c.CourseID, c.Title, c.Difficulty,
                    (SELECT COUNT(*) FROM Module WHERE CourseID = c.CourseID) AS ModuleCount,
                    (SELECT COUNT(*) FROM Enrollment WHERE CourseID = c.CourseID) AS EnrolCount,
                    ISNULL((
                        SELECT AVG(CAST(qa.Score AS FLOAT) * 100.0 / NULLIF(qa.TotalQuestions, 0))
                        FROM Quiz_Attempt qa
                        INNER JOIN Quiz qz ON qa.QuizID = qz.QuizID
                        INNER JOIN Module m ON qz.ModuleID = m.ModuleID
                        WHERE m.CourseID = c.CourseID
                    ), 0) AS AvgScore
                FROM Course c
                WHERE c.IsActive = 1
                ORDER BY c.CourseID";

            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                new SqlDataAdapter(sql, conn).Fill(dt);
            }

            dt.Columns.Add("AvgScoreFmt", typeof(string));
            foreach (DataRow row in dt.Rows)
            {
                double avg = (row["AvgScore"] == DBNull.Value) ? 0 : Convert.ToDouble(row["AvgScore"]);
                row["AvgScoreFmt"] = Math.Round(avg, 0).ToString();
            }

            rptCoursesTable.DataSource = dt;
            rptCoursesTable.DataBind();
        }

        private string ToRelativeTime(DateTime when)
        {
            TimeSpan span = DateTime.Now - when;
            if (span.TotalMinutes < 1) return "just now";
            if (span.TotalMinutes < 60) return (int)span.TotalMinutes + " min ago";
            if (span.TotalHours < 24) return (int)span.TotalHours + "h ago";
            if (span.TotalDays < 7) return (int)span.TotalDays + "d ago";
            if (span.TotalDays < 30) return ((int)(span.TotalDays / 7)) + "w ago";
            return when.ToString("dd MMM yyyy");
        }
    }
}
