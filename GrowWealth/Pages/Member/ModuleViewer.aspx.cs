using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace GrowWealth.Pages.Member
{
    public partial class ModuleViewer : Page
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
                int moduleId;
                if (!int.TryParse(Request.QueryString["moduleId"], out moduleId))
                {
                    Response.Redirect("~/Pages/Member/CoursePage.aspx");
                    return;
                }
                LoadModule(moduleId);
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

        private void LoadModule(int moduleId)
        {
            int userId = GetCurrentUserId();
            int courseId = 0;
            int orderIndex = 0;
            string courseTitle = "";
            int readingTime = 0;
            int quizQCount = 0;
            bool isCompleted = false;
            DateTime? completedAt = null;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand cmd = new SqlCommand(
                    @"SELECT m.Title, m.Content, m.OrderIndex, m.EstimatedMinutes, m.CourseID,
                             c.Title AS CourseTitle
                      FROM Module m
                      INNER JOIN Course c ON m.CourseID = c.CourseID
                      WHERE m.ModuleID = @ModuleID", conn);
                cmd.Parameters.AddWithValue("@ModuleID", moduleId);

                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    if (!rd.Read())
                    {
                        rd.Close();
                        Response.Redirect("~/Pages/Member/CoursePage.aspx");
                        return;
                    }

                    litModuleTitle.Text = Server.HtmlEncode(rd["Title"].ToString());
                    litModuleContent.Text = rd["Content"].ToString();
                    orderIndex = Convert.ToInt32(rd["OrderIndex"]);
                    readingTime = Convert.ToInt32(rd["EstimatedMinutes"]);
                    courseId = Convert.ToInt32(rd["CourseID"]);
                    courseTitle = rd["CourseTitle"].ToString();
                }

                litCrumbCourse.Text = Server.HtmlEncode(courseTitle);
                lnkCrumbCourse.NavigateUrl = "~/Pages/Member/CoursePage.aspx?id=" + courseId;
                lnkBackCourse.NavigateUrl = "~/Pages/Member/CoursePage.aspx?id=" + courseId;
                litCrumbOrder.Text = orderIndex.ToString();
                litReadingTime.Text = readingTime.ToString();
                litInfoOrder.Text = orderIndex.ToString();
                litInfoTime.Text = readingTime.ToString();

                SqlCommand cmdQz = new SqlCommand(
                    @"SELECT q.QuizID, (SELECT COUNT(*) FROM Question WHERE QuizID = q.QuizID) AS QCount
                      FROM Quiz q WHERE q.ModuleID = @ModuleID", conn);
                cmdQz.Parameters.AddWithValue("@ModuleID", moduleId);
                using (SqlDataReader rd2 = cmdQz.ExecuteReader())
                {
                    if (rd2.Read())
                    {
                        quizQCount = Convert.ToInt32(rd2["QCount"]);
                        int qid = Convert.ToInt32(rd2["QuizID"]);
                        ViewState["QuizID"] = qid;
                    }
                }
                litQuizQCount.Text = quizQCount.ToString();
                litInfoQuiz.Text = quizQCount.ToString();

                SqlCommand cmdProg = new SqlCommand(
                    @"SELECT IsCompleted, CompletedAt FROM UserProgress
                      WHERE UserID = @UserID AND ModuleID = @ModuleID", conn);
                cmdProg.Parameters.AddWithValue("@UserID", userId);
                cmdProg.Parameters.AddWithValue("@ModuleID", moduleId);
                using (SqlDataReader rd3 = cmdProg.ExecuteReader())
                {
                    if (rd3.Read())
                    {
                        isCompleted = Convert.ToBoolean(rd3["IsCompleted"]);
                        if (rd3["CompletedAt"] != DBNull.Value)
                        {
                            completedAt = Convert.ToDateTime(rd3["CompletedAt"]);
                        }
                    }
                }
            }

            if (isCompleted)
            {
                pnlAlreadyDone.Visible = true;
                litCompletedDate.Text = completedAt.HasValue ? completedAt.Value.ToString("dd MMM yyyy") : "—";
                litInfoStatus.Text = "Completed";
                btnMarkComplete.Text = "Re-take quiz &rarr;";
            }
            else
            {
                litInfoStatus.Text = "In progress";
            }

            int prevId = 0;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    @"SELECT TOP 1 ModuleID FROM Module
                      WHERE CourseID = @CourseID AND OrderIndex < @Order
                      ORDER BY OrderIndex DESC", conn);
                cmd.Parameters.AddWithValue("@CourseID", courseId);
                cmd.Parameters.AddWithValue("@Order", orderIndex);
                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                {
                    prevId = Convert.ToInt32(result);
                }
            }

            if (prevId == 0)
            {
                btnPrev.Enabled = false;
            }
            else
            {
                ViewState["PrevModuleID"] = prevId;
            }

            ViewState["CurrentModuleID"] = moduleId;
            ViewState["CourseID"] = courseId;

            LoadSidebar(courseId, moduleId, userId);
        }

        private void LoadSidebar(int courseId, int currentModuleId, int userId)
        {
            string sql = @"
                SELECT m.ModuleID, m.Title, m.OrderIndex,
                       CASE WHEN up.IsCompleted = 1 THEN 1 ELSE 0 END AS DoneFlag
                FROM Module m
                LEFT JOIN UserProgress up
                    ON up.ModuleID = m.ModuleID AND up.UserID = @UserID
                WHERE m.CourseID = @CourseID
                ORDER BY m.OrderIndex";

            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);
                cmd.Parameters.AddWithValue("@CourseID", courseId);
                new SqlDataAdapter(cmd).Fill(dt);
            }

            dt.Columns.Add("LinkClass", typeof(string));
            foreach (DataRow row in dt.Rows)
            {
                string cls = "mv-mod-link";
                if (Convert.ToInt32(row["ModuleID"]) == currentModuleId) cls += " current";
                if (Convert.ToInt32(row["DoneFlag"]) == 1) cls += " done";
                row["LinkClass"] = cls;
            }

            rptSideModules.DataSource = dt;
            rptSideModules.DataBind();
        }

        protected void btnPrev_Click(object sender, EventArgs e)
        {
            if (ViewState["PrevModuleID"] != null)
            {
                Response.Redirect("~/Pages/Member/ModuleViewer.aspx?moduleId=" + ViewState["PrevModuleID"]);
            }
        }

        protected void btnMarkComplete_Click(object sender, EventArgs e)
        {
            if (ViewState["CurrentModuleID"] == null) return;
            int moduleId = Convert.ToInt32(ViewState["CurrentModuleID"]);
            int userId = GetCurrentUserId();
            if (userId == 0) return;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand check = new SqlCommand(
                    "SELECT COUNT(*) FROM UserProgress WHERE UserID = @UserID AND ModuleID = @ModuleID", conn);
                check.Parameters.AddWithValue("@UserID", userId);
                check.Parameters.AddWithValue("@ModuleID", moduleId);
                int existing = Convert.ToInt32(check.ExecuteScalar());

                if (existing == 0)
                {
                    SqlCommand ins = new SqlCommand(
                        @"INSERT INTO UserProgress (UserID, ModuleID, IsCompleted, CompletedAt)
                          VALUES (@UserID, @ModuleID, 1, GETDATE())", conn);
                    ins.Parameters.AddWithValue("@UserID", userId);
                    ins.Parameters.AddWithValue("@ModuleID", moduleId);
                    ins.ExecuteNonQuery();
                }
                else
                {
                    SqlCommand upd = new SqlCommand(
                        @"UPDATE UserProgress SET IsCompleted = 1, CompletedAt = GETDATE()
                          WHERE UserID = @UserID AND ModuleID = @ModuleID", conn);
                    upd.Parameters.AddWithValue("@UserID", userId);
                    upd.Parameters.AddWithValue("@ModuleID", moduleId);
                    upd.ExecuteNonQuery();
                }
            }

            if (ViewState["QuizID"] != null)
            {
                Response.Redirect("~/Pages/Member/Quiz.aspx?quizId=" + ViewState["QuizID"]);
            }
            else if (ViewState["CourseID"] != null)
            {
                Response.Redirect("~/Pages/Member/CoursePage.aspx?id=" + ViewState["CourseID"]);
            }
            else
            {
                Response.Redirect("~/Pages/Member/Dashboard.aspx");
            }
        }
    }
}
