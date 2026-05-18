using System;
using System.Collections.Generic;
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
            // The master page already enforces authentication, but check here too
            // as defense-in-depth (in case this page is hit with a stale session).
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
                    // Could not match the auth cookie to a user. Sign out and reload.
                    System.Web.Security.FormsAuthentication.SignOut();
                    Response.Redirect("~/Pages/Public/Login.aspx");
                    return;
                }

                litWelcomeName.Text = GetFirstName(Context.User.Identity.Name);

                LoadStatCards(userId);
                LoadCourseProgress(userId);
                LoadRecentQuizScores(userId);
                LoadRecentActivity(userId);
            }
        }

        /// <summary>
        /// Resolves the current user ID from the auth cookie (which stores FullName).
        /// </summary>
        private int GetCurrentUserId()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT UserID FROM [User] WHERE FullName = @Name";
                SqlCommand cmd = new SqlCommand(sql, conn);
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

        /// <summary>
        /// Loads the three top stat cards: courses enrolled, modules completed,
        /// and average quiz score.
        /// </summary>
        private void LoadStatCards(int userId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Courses enrolled
                SqlCommand cmd1 = new SqlCommand(
                    "SELECT COUNT(*) FROM Enrollment WHERE UserID = @UserID", conn);
                cmd1.Parameters.AddWithValue("@UserID", userId);
                litCoursesEnrolled.Text = cmd1.ExecuteScalar().ToString();

                // Modules completed
                SqlCommand cmd2 = new SqlCommand(
                    "SELECT COUNT(*) FROM UserProgress WHERE UserID = @UserID AND IsCompleted = 1",
                    conn);
                cmd2.Parameters.AddWithValue("@UserID", userId);
                litModulesCompleted.Text = cmd2.ExecuteScalar().ToString();

                // Average quiz score across all attempts
                SqlCommand cmd3 = new SqlCommand(
                    "SELECT AVG(CAST(Score AS FLOAT) * 100.0 / NULLIF(TotalQuestions, 0)) " +
                    "FROM Quiz_Attempt WHERE UserID = @UserID", conn);
                cmd3.Parameters.AddWithValue("@UserID", userId);
                object avg = cmd3.ExecuteScalar();
                if (avg == null || avg == DBNull.Value)
                {
                    litAvgQuizScore.Text = "0%";
                }
                else
                {
                    litAvgQuizScore.Text = Convert.ToInt32(avg) + "%";
                }
            }
        }

        /// <summary>
        /// For each enrolled course, calculates how many modules the user has
        /// completed and binds the result to the course-progress repeater.
        /// </summary>
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

            // Add a calculated PercentComplete column.
            dt.Columns.Add("PercentComplete", typeof(int));
            foreach (DataRow row in dt.Rows)
            {
                int total = Convert.ToInt32(row["TotalModules"]);
                int done = Convert.ToInt32(row["CompletedModules"]);
                row["PercentComplete"] = (total == 0) ? 0 : (done * 100 / total);
            }

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

        /// <summary>
        /// Loads the 3 most recent quiz attempts for this user.
        /// </summary>
        private void LoadRecentQuizScores(int userId)
        {
            string sql = @"
                SELECT TOP 3
                    qz.Title AS QuizTitle,
                    CAST(qa.Score * 100.0 / NULLIF(qa.TotalQuestions, 0) AS INT) AS ScorePercent
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

        /// <summary>
        /// Builds the "recent activity" feed by combining quiz attempts,
        /// completed modules, and enrolments from the database.
        /// </summary>
        private void LoadRecentActivity(int userId)
        {
            // We UNION three activity sources, then take the most recent 6 rows.
            string sql = @"
                SELECT TOP 6 Description, ActivityTime FROM (
                    SELECT
                        'Completed quiz: ' + qz.Title +
                        ' — Score ' +
                        CAST(CAST(qa.Score * 100.0 / NULLIF(qa.TotalQuestions, 0) AS INT) AS NVARCHAR(10)) + '%'
                            AS Description,
                        qa.AttemptedAt AS ActivityTime
                    FROM Quiz_Attempt qa
                    INNER JOIN Quiz qz ON qa.QuizID = qz.QuizID
                    WHERE qa.UserID = @UserID

                    UNION ALL

                    SELECT
                        'Completed module: ' + m.Title AS Description,
                        up.CompletedAt AS ActivityTime
                    FROM UserProgress up
                    INNER JOIN Module m ON up.ModuleID = m.ModuleID
                    WHERE up.UserID = @UserID AND up.IsCompleted = 1 AND up.CompletedAt IS NOT NULL

                    UNION ALL

                    SELECT
                        'Enrolled in course: ' + c.Title AS Description,
                        e.EnrolledAt AS ActivityTime
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

            // Add a friendly "RelativeTime" column (e.g. "2 days ago").
            dt.Columns.Add("RelativeTime", typeof(string));
            foreach (DataRow row in dt.Rows)
            {
                DateTime when = Convert.ToDateTime(row["ActivityTime"]);
                row["RelativeTime"] = ToRelativeTime(when);
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
            if (span.TotalMinutes < 1) return "Just now";
            if (span.TotalMinutes < 60) return (int)span.TotalMinutes + " min ago";
            if (span.TotalHours < 24) return (int)span.TotalHours + "h ago";
            if (span.TotalDays < 30) return (int)span.TotalDays + "d ago";
            return when.ToString("dd MMM yyyy");
        }

        /// <summary>
        /// "Continue learning" button: jump to the first incomplete module in the
        /// course with the most recent activity. If everything is completed, go
        /// to the courses page.
        /// </summary>
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
                    // Nothing to continue — send them to the course list.
                    Response.Redirect("~/Pages/Member/CoursePage.aspx");
                }
            }
        }
    }
}