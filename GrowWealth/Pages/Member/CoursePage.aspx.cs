using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GrowWealth.Pages.Member
{
    public partial class CoursePage : Page
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
                string id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    int courseId;
                    if (int.TryParse(id, out courseId))
                    {
                        ShowDetail(courseId);
                        return;
                    }
                }
                ShowCatalogue();
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

        private void ShowCatalogue()
        {
            pnlCatalogue.Visible = true;
            pnlDetail.Visible = false;

            int userId = GetCurrentUserId();

            string sql = @"
                SELECT
                    c.CourseID, c.Title, c.Description, c.Difficulty, c.EstimatedHours,
                    (SELECT COUNT(*) FROM Module WHERE CourseID = c.CourseID) AS ModuleCount,
                    (SELECT COUNT(*) FROM Enrollment WHERE CourseID = c.CourseID AND UserID = @UserID) AS EnrolledFlag,
                    (SELECT COUNT(*) FROM UserProgress up
                        INNER JOIN Module m ON up.ModuleID = m.ModuleID
                        WHERE up.UserID = @UserID AND up.IsCompleted = 1 AND m.CourseID = c.CourseID) AS CompletedModules
                FROM Course c
                WHERE c.IsActive = 1
                ORDER BY c.CourseID";

            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);
                new SqlDataAdapter(cmd).Fill(dt);
            }

            dt.Columns.Add("IsEnrolled", typeof(bool));
            dt.Columns.Add("PercentComplete", typeof(int));
            foreach (DataRow row in dt.Rows)
            {
                row["IsEnrolled"] = Convert.ToInt32(row["EnrolledFlag"]) > 0;
                int total = Convert.ToInt32(row["ModuleCount"]);
                int done = Convert.ToInt32(row["CompletedModules"]);
                row["PercentComplete"] = (total == 0) ? 0 : (done * 100 / total);
            }

            rptCourses.DataSource = dt;
            rptCourses.DataBind();
        }

        private void ShowDetail(int courseId)
        {
            pnlCatalogue.Visible = false;
            pnlDetail.Visible = true;

            int userId = GetCurrentUserId();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand cmd = new SqlCommand(
                    "SELECT Title, Description, Difficulty, EstimatedHours FROM Course WHERE CourseID = @CourseID AND IsActive = 1", conn);
                cmd.Parameters.AddWithValue("@CourseID", courseId);
                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    if (!rd.Read())
                    {
                        Response.Redirect("~/Pages/Member/CoursePage.aspx");
                        return;
                    }
                    litCourseTitle.Text = Server.HtmlEncode(rd["Title"].ToString());
                    litCourseDesc.Text = Server.HtmlEncode(rd["Description"].ToString());
                    string diff = rd["Difficulty"].ToString();
                    litDifficulty.Text = diff;
                    litMetaLevel.Text = diff;
                    litMetaHours.Text = rd["EstimatedHours"].ToString();
                    tagDifficulty.Attributes["class"] = "course-tag " + diff.ToLower();
                }
            }

            string moduleSql = @"
                SELECT
                    m.ModuleID, m.Title, m.OrderIndex, m.EstimatedMinutes,
                    CASE WHEN up.IsCompleted = 1 THEN 1 ELSE 0 END AS DoneFlag
                FROM Module m
                LEFT JOIN UserProgress up
                    ON up.ModuleID = m.ModuleID AND up.UserID = @UserID
                WHERE m.CourseID = @CourseID
                ORDER BY m.OrderIndex";

            DataTable dtMods = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(moduleSql, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);
                cmd.Parameters.AddWithValue("@CourseID", courseId);
                new SqlDataAdapter(cmd).Fill(dtMods);
            }

            dtMods.Columns.Add("StatusClass", typeof(string));
            dtMods.Columns.Add("StatusIcon", typeof(string));
            dtMods.Columns.Add("ActionLabel", typeof(string));

            bool foundActive = false;
            int doneCount = 0;
            int timeInvested = 0;
            foreach (DataRow row in dtMods.Rows)
            {
                bool done = Convert.ToInt32(row["DoneFlag"]) == 1;
                if (done)
                {
                    row["StatusClass"] = "done";
                    row["StatusIcon"] = "&#10003;";
                    row["ActionLabel"] = "Review &rarr;";
                    doneCount++;
                    timeInvested += Convert.ToInt32(row["EstimatedMinutes"]);
                }
                else if (!foundActive)
                {
                    row["StatusClass"] = "active";
                    row["StatusIcon"] = row["OrderIndex"].ToString();
                    row["ActionLabel"] = "Start &rarr;";
                    foundActive = true;
                }
                else
                {
                    row["StatusClass"] = "locked";
                    row["StatusIcon"] = row["OrderIndex"].ToString();
                    row["ActionLabel"] = "Open &rarr;";
                }
            }

            rptModules.DataSource = dtMods;
            rptModules.DataBind();

            litMetaModules.Text = dtMods.Rows.Count.ToString();
            litDoneCount.Text = doneCount.ToString();
            litTotalCount.Text = dtMods.Rows.Count.ToString();
            litTimeInvested.Text = timeInvested.ToString();

            int totalMods = dtMods.Rows.Count;
            int pct = (totalMods == 0) ? 0 : (doneCount * 100 / totalMods);
            litPctSidebar.Text = pct.ToString();
            sidebarFill.Style["width"] = pct + "%";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmdQz = new SqlCommand(
                    @"SELECT COUNT(*) FROM Quiz_Attempt qa
                      INNER JOIN Quiz qz ON qa.QuizID = qz.QuizID
                      INNER JOIN Module m ON qz.ModuleID = m.ModuleID
                      WHERE qa.UserID = @UserID
                        AND m.CourseID = @CourseID
                        AND CAST(qa.Score AS FLOAT) * 100.0 / NULLIF(qa.TotalQuestions, 0) >= 60", conn);
                cmdQz.Parameters.AddWithValue("@UserID", userId);
                cmdQz.Parameters.AddWithValue("@CourseID", courseId);
                conn.Open();
                litQuizzesPassed.Text = cmdQz.ExecuteScalar().ToString();
            }

            ViewState["CurrentCourseId"] = courseId;
        }

        protected void rptCourses_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int courseId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EnrolCourse")
            {
                int userId = GetCurrentUserId();
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand check = new SqlCommand(
                        "SELECT COUNT(*) FROM Enrollment WHERE UserID = @UserID AND CourseID = @CourseID", conn);
                    check.Parameters.AddWithValue("@UserID", userId);
                    check.Parameters.AddWithValue("@CourseID", courseId);
                    conn.Open();
                    int existing = Convert.ToInt32(check.ExecuteScalar());

                    if (existing == 0)
                    {
                        SqlCommand ins = new SqlCommand(
                            "INSERT INTO Enrollment (UserID, CourseID, EnrolledAt) VALUES (@UserID, @CourseID, GETDATE())", conn);
                        ins.Parameters.AddWithValue("@UserID", userId);
                        ins.Parameters.AddWithValue("@CourseID", courseId);
                        ins.ExecuteNonQuery();
                    }
                }
                Response.Redirect("~/Pages/Member/CoursePage.aspx?id=" + courseId);
            }
            else if (e.CommandName == "ViewCourse")
            {
                Response.Redirect("~/Pages/Member/CoursePage.aspx?id=" + courseId);
            }
        }

        protected void lnkBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Pages/Member/CoursePage.aspx");
        }

        protected void btnStartOrContinue_Click(object sender, EventArgs e)
        {
            if (ViewState["CurrentCourseId"] == null) return;
            int courseId = Convert.ToInt32(ViewState["CurrentCourseId"]);
            int userId = GetCurrentUserId();

            string sql = @"
                SELECT TOP 1 m.ModuleID
                FROM Module m
                LEFT JOIN UserProgress up
                    ON up.ModuleID = m.ModuleID AND up.UserID = @UserID
                WHERE m.CourseID = @CourseID
                  AND (up.IsCompleted IS NULL OR up.IsCompleted = 0)
                ORDER BY m.OrderIndex ASC";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);
                cmd.Parameters.AddWithValue("@CourseID", courseId);
                conn.Open();
                object result = cmd.ExecuteScalar();

                if (result != null && result != DBNull.Value)
                {
                    Response.Redirect("~/Pages/Member/ModuleViewer.aspx?moduleId=" + Convert.ToInt32(result));
                }
                else
                {
                    SqlCommand cmdFirst = new SqlCommand(
                        "SELECT TOP 1 ModuleID FROM Module WHERE CourseID = @CourseID ORDER BY OrderIndex", conn);
                    cmdFirst.Parameters.AddWithValue("@CourseID", courseId);
                    object first = cmdFirst.ExecuteScalar();
                    if (first != null && first != DBNull.Value)
                    {
                        Response.Redirect("~/Pages/Member/ModuleViewer.aspx?moduleId=" + Convert.ToInt32(first));
                    }
                }
            }
        }
    }
}
