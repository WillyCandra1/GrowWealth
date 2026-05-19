using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace GrowWealth.Pages.Member
{
    public partial class Dashboard : Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated)
            {
                Response.Redirect("~/Pages/Public/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                int userId = GetCurrentUserId();
                if (userId == 0)
                {
                    System.Web.Security.FormsAuthentication.SignOut();
                    Response.Redirect("~/Pages/Public/Login.aspx");
                    return;
                }

                litWelcomeName.Text = Server.HtmlEncode(GetFirstName(Context.User.Identity.Name));
                litToday.Text = DateTime.Now.ToString("dddd, dd MMMM yyyy");

                LoadStatCards(userId);
                LoadCourseProgress(userId);
                LoadRecentQuizScores(userId);
                LoadRecentActivity(userId);
            }
        }

        private int GetCurrentUserId()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT UserID FROM [User] WHERE FullName = @Name", conn);
                cmd.Parameters.AddWithValue("@Name", Context.User.Identity.Name);
                conn.Open();
                object result = cmd.ExecuteScalar();
                return (result == null || result == DBNull.Value) ? 0 : Convert.ToInt32(result);
            }
        }

        private string GetFirstName(string fullName)
        {
            if (string.IsNullOrWhiteSpace(fullName)) return "learner";
            int space = fullName.IndexOf(' ');
            return (space > 0) ? fullName.Substring(0, space) : fullName;
        }

        private void LoadStatCards(int userId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand cmd1 = new SqlCommand(
                    "SELECT COUNT(*) FROM Enrollment WHERE UserID = @UserID", conn);
                cmd1.Parameters.AddWithValue("@UserID", userId);
                int courseCount = Convert.ToInt32(cmd1.ExecuteScalar());
                litCoursesEnrolled.Text = courseCount.ToString();
                litCoursesTrend.Text = courseCount == 0
                    ? "Browse the catalogue to get started"
                    : "Across your learning journey";

                SqlCommand cmd2a = new SqlCommand(
                    "SELECT COUNT(*) FROM UserProgress WHERE UserID = @UserID AND IsCompleted = 1", conn);
                cmd2a.Parameters.AddWithValue("@UserID", userId);
                int modulesDone = Convert.ToInt32(cmd2a.ExecuteScalar());

                SqlCommand cmd2b = new SqlCommand(
                    @"SELECT COUNT(*) FROM Module m
                      INNER JOIN Enrollment e ON e.CourseID = m.CourseID
                      WHERE e.UserID = @UserID", conn);
                cmd2b.Parameters.AddWithValue("@UserID", userId);
                int modulesTotal = Convert.ToInt32(cmd2b.ExecuteScalar());

                litModulesCompleted.Text = modulesDone.ToString();
                litModulesTotal.Text = modulesTotal.ToString();
                if (modulesTotal == 0)
                {
                    litModulesTrend.Text = "Enrol in a course to begin";
                }
                else
                {
                    int pct = modulesDone * 100 / modulesTotal;
                    litModulesTrend.Text = pct + "% of your enrolled material";
                }

                SqlCommand cmd3 = new SqlCommand(
                    @"SELECT AVG(CAST(Score AS FLOAT) * 100.0 / NULLIF(TotalQuestions, 0))
                      FROM Quiz_Attempt WHERE UserID = @UserID", conn);
                cmd3.Parameters.AddWithValue("@UserID", userId);
                object avg = cmd3.ExecuteScalar();

                SqlCommand cmd4 = new SqlCommand(
                    "SELECT COUNT(*) FROM Quiz_Attempt WHERE UserID = @UserID", conn);
                cmd4.Parameters.AddWithValue("@UserID", userId);
                int attemptCount = Convert.ToInt32(cmd4.ExecuteScalar());

                if (avg == null || avg == DBNull.Value)
                {
                    litAvgQuizScore.Text = "—";
                    litQuizTrend.Text = "Complete a quiz to see your score";
                }
                else
                {
                    int avgPct = Convert.ToInt32(avg);
                    litAvgQuizScore.Text = avgPct.ToString();
                    litQuizTrend.Text = "Across " + attemptCount + " attempt" + (attemptCount == 1 ? "" : "s");
                }
            }
        }

        private void LoadCourseProgress(int userId)
        {
            string sql = @"
                SELECT
                    c.CourseID,
                    c.Title AS CourseTitle,
                    (SELECT COUNT(*) FROM Module m WHERE m.CourseID = c.CourseID) AS TotalModules,
                    (SELECT COUNT(*) FROM UserProgress up
                        INNER JOIN Module m2 ON up.ModuleID = m2.ModuleID
                        WHERE up.UserID = @UserID
                          AND up.IsCompleted = 1
                          AND m2.CourseID = c.CourseID) AS CompletedModules
                FROM Course c
                INNER JOIN Enrollment e ON e.CourseID = c.CourseID
                WHERE e.UserID = @UserID
                ORDER BY e.EnrolledAt DESC";

            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);
                new SqlDataAdapter(cmd).Fill(dt);
            }

            dt.Columns.Add("PercentComplete", typeof(int));
            foreach (DataRow row in dt.Rows)
            {
                int total = Convert.ToInt32(row["TotalModules"]);
                int done = Convert.ToInt32(row["CompletedModules"]);
                row["PercentComplete"] = (total == 0) ? 0 : (done * 100 / total);
            }

            litCourseCount.Text = dt.Rows.Count + " enrolled";

            if (dt.Rows.Count == 0)
            {
                pnlNoCourses.Visible = true;
                btnContinue.Enabled = false;
            }
            else
            {
                rptCourseProgress.DataSource = dt;
                rptCourseProgress.DataBind();
            }
        }

        private void LoadRecentQuizScores(int userId)
        {
            string sql = @"
                SELECT TOP 5
                    qz.Title AS QuizTitle,
                    CAST(qa.Score * 100.0 / NULLIF(qa.TotalQuestions, 0) AS INT) AS ScorePercent,
                    qa.AttemptedAt
                FROM Quiz_Attempt qa
                INNER JOIN Quiz qz ON qa.QuizID = qz.QuizID
                WHERE qa.UserID = @UserID
                ORDER BY qa.AttemptedAt DESC";

            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);
                new SqlDataAdapter(cmd).Fill(dt);
            }

            dt.Columns.Add("AttemptedDate", typeof(string));
            foreach (DataRow row in dt.Rows)
            {
                DateTime when = Convert.ToDateTime(row["AttemptedAt"]);
                row["AttemptedDate"] = when.ToString("dd MMM yyyy");
            }

            if (dt.Rows.Count == 0)
            {
                pnlNoQuizzes.Visible = true;
            }
            else
            {
                rptRecentQuizzes.DataSource = dt;
                rptRecentQuizzes.DataBind();
            }
        }

        private void LoadRecentActivity(int userId)
        {
            string sql = @"
                SELECT TOP 8 Description, ActivityTime, ActivityType FROM (
                    SELECT
                        'Completed quiz: ' + qz.Title +
                        ' &mdash; scored ' +
                        CAST(CAST(qa.Score * 100.0 / NULLIF(qa.TotalQuestions, 0) AS INT) AS NVARCHAR(10)) + '%'
                            AS Description,
                        qa.AttemptedAt AS ActivityTime,
                        'quiz' AS ActivityType
                    FROM Quiz_Attempt qa
                    INNER JOIN Quiz qz ON qa.QuizID = qz.QuizID
                    WHERE qa.UserID = @UserID

                    UNION ALL

                    SELECT
                        'Completed module: ' + m.Title AS Description,
                        up.CompletedAt AS ActivityTime,
                        'module' AS ActivityType
                    FROM UserProgress up
                    INNER JOIN Module m ON up.ModuleID = m.ModuleID
                    WHERE up.UserID = @UserID AND up.IsCompleted = 1 AND up.CompletedAt IS NOT NULL

                    UNION ALL

                    SELECT
                        'Enrolled in course: ' + c.Title AS Description,
                        e.EnrolledAt AS ActivityTime,
                        'enroll' AS ActivityType
                    FROM Enrollment e
                    INNER JOIN Course c ON e.CourseID = c.CourseID
                    WHERE e.UserID = @UserID
                ) AS combined
                ORDER BY ActivityTime DESC";

            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);
                new SqlDataAdapter(cmd).Fill(dt);
            }

            dt.Columns.Add("RelativeTime", typeof(string));
            dt.Columns.Add("IconClass", typeof(string));
            dt.Columns.Add("IconText", typeof(string));
            foreach (DataRow row in dt.Rows)
            {
                DateTime when = Convert.ToDateTime(row["ActivityTime"]);
                row["RelativeTime"] = ToRelativeTime(when);

                string type = row["ActivityType"].ToString();
                if (type == "quiz") { row["IconClass"] = "quiz"; row["IconText"] = "Q"; }
                else if (type == "enroll") { row["IconClass"] = "enroll"; row["IconText"] = "+"; }
                else { row["IconClass"] = ""; row["IconText"] = "&#10003;"; }
            }

            if (dt.Rows.Count == 0)
            {
                pnlNoActivity.Visible = true;
            }
            else
            {
                rptRecentActivity.DataSource = dt;
                rptRecentActivity.DataBind();
            }
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

        protected void btnContinue_Click(object sender, EventArgs e)
        {
            int userId = GetCurrentUserId();
            if (userId == 0) return;

            string sql = @"
                SELECT TOP 1 m.ModuleID
                FROM Module m
                INNER JOIN Enrollment e ON e.CourseID = m.CourseID
                LEFT JOIN UserProgress up
                    ON up.ModuleID = m.ModuleID AND up.UserID = @UserID
                WHERE e.UserID = @UserID
                  AND (up.IsCompleted IS NULL OR up.IsCompleted = 0)
                ORDER BY e.EnrolledAt DESC, m.OrderIndex ASC";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);
                conn.Open();
                object result = cmd.ExecuteScalar();

                if (result != null && result != DBNull.Value)
                {
                    int moduleId = Convert.ToInt32(result);
                    Response.Redirect("~/Pages/Member/ModuleViewer.aspx?moduleId=" + moduleId);
                }
                else
                {
                    Response.Redirect("~/Pages/Member/CoursePage.aspx");
                }
            }
        }
    }
}
