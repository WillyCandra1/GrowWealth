using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GrowWealth.Pages.Admin
{
    public partial class ManageCourse : Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCourses();
                int courseId;
                if (int.TryParse(Request.QueryString["expand"], out courseId))
                {
                    ShowModulesPanel(courseId);
                }
            }
        }

        private void LoadCourses()
        {
            string sql = @"
                SELECT
                    c.CourseID, c.Title, c.Description, c.Difficulty, c.EstimatedHours, c.IsActive,
                    (SELECT COUNT(*) FROM Module WHERE CourseID = c.CourseID) AS ModuleCount,
                    (SELECT COUNT(*) FROM Enrollment WHERE CourseID = c.CourseID) AS EnrolCount
                FROM Course c
                ORDER BY c.CourseID";

            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                new SqlDataAdapter(sql, conn).Fill(dt);
            }
            rptCourses.DataSource = dt;
            rptCourses.DataBind();
        }

        protected void btnNewCourse_Click(object sender, EventArgs e)
        {
            txtTitle.Text = "";
            txtDescription.Text = "";
            txtHours.Text = "6";
            ddlDifficulty.SelectedValue = "Beginner";
            chkActive.Checked = true;
            ViewState["EditCourseID"] = null;
            litCourseFormHeader.Text = "New course";
            pnlCourseForm.Visible = true;
            pnlModuleForm.Visible = false;
            ClearAlerts();
        }

        protected void btnSaveCourse_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                if (ViewState["EditCourseID"] == null)
                {
                    SqlCommand cmd = new SqlCommand(
                        @"INSERT INTO Course (Title, Description, Difficulty, EstimatedHours, IsActive)
                          VALUES (@Title, @Description, @Difficulty, @Hours, @Active)", conn);
                    cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                    cmd.Parameters.AddWithValue("@Difficulty", ddlDifficulty.SelectedValue);
                    cmd.Parameters.AddWithValue("@Hours", int.Parse(txtHours.Text));
                    cmd.Parameters.AddWithValue("@Active", chkActive.Checked);
                    cmd.ExecuteNonQuery();

                    ShowSuccess("Course created successfully.");
                }
                else
                {
                    int courseId = Convert.ToInt32(ViewState["EditCourseID"]);
                    SqlCommand cmd = new SqlCommand(
                        @"UPDATE Course
                          SET Title = @Title, Description = @Description, Difficulty = @Difficulty,
                              EstimatedHours = @Hours, IsActive = @Active
                          WHERE CourseID = @CourseID", conn);
                    cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                    cmd.Parameters.AddWithValue("@Difficulty", ddlDifficulty.SelectedValue);
                    cmd.Parameters.AddWithValue("@Hours", int.Parse(txtHours.Text));
                    cmd.Parameters.AddWithValue("@Active", chkActive.Checked);
                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    cmd.ExecuteNonQuery();

                    ShowSuccess("Course updated successfully.");
                }
            }

            pnlCourseForm.Visible = false;
            ViewState["EditCourseID"] = null;
            LoadCourses();
        }

        protected void btnCancelCourse_Click(object sender, EventArgs e)
        {
            pnlCourseForm.Visible = false;
            ViewState["EditCourseID"] = null;
            ClearAlerts();
        }

        protected void rptCourses_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int courseId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditCourse")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "SELECT Title, Description, Difficulty, EstimatedHours, IsActive FROM Course WHERE CourseID = @CourseID", conn);
                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    conn.Open();
                    using (SqlDataReader rd = cmd.ExecuteReader())
                    {
                        if (rd.Read())
                        {
                            txtTitle.Text = rd["Title"].ToString();
                            txtDescription.Text = rd["Description"].ToString();
                            ddlDifficulty.SelectedValue = rd["Difficulty"].ToString();
                            txtHours.Text = rd["EstimatedHours"].ToString();
                            chkActive.Checked = Convert.ToBoolean(rd["IsActive"]);
                        }
                    }
                }
                ViewState["EditCourseID"] = courseId;
                litCourseFormHeader.Text = "Edit course";
                pnlCourseForm.Visible = true;
                pnlModuleForm.Visible = false;
                ClearAlerts();
            }
            else if (e.CommandName == "ViewModules")
            {
                ShowModulesPanel(courseId);
            }
            else if (e.CommandName == "DeleteCourse")
            {
                DeleteCourse(courseId);
            }
        }

        private void ShowModulesPanel(int courseId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmdName = new SqlCommand(
                    "SELECT Title FROM Course WHERE CourseID = @CourseID", conn);
                cmdName.Parameters.AddWithValue("@CourseID", courseId);
                conn.Open();
                object name = cmdName.ExecuteScalar();
                if (name == null)
                {
                    ShowError("Course not found.");
                    return;
                }
                litExpandedCourse.Text = Server.HtmlEncode(name.ToString());
            }

            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT ModuleID, Title, OrderIndex, EstimatedMinutes FROM Module WHERE CourseID = @CourseID ORDER BY OrderIndex", conn);
                cmd.Parameters.AddWithValue("@CourseID", courseId);
                new SqlDataAdapter(cmd).Fill(dt);
            }
            rptModulesInCourse.DataSource = dt;
            rptModulesInCourse.DataBind();

            ViewState["ExpandedCourseID"] = courseId;
            pnlModuleList.Visible = true;
        }

        private void DeleteCourse(int courseId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction tx = conn.BeginTransaction();
                try
                {
                    SqlCommand c1 = new SqlCommand(
                        @"DELETE FROM Quiz_Attempt
                          WHERE QuizID IN (
                              SELECT q.QuizID FROM Quiz q
                              INNER JOIN Module m ON q.ModuleID = m.ModuleID
                              WHERE m.CourseID = @CourseID)", conn, tx);
                    c1.Parameters.AddWithValue("@CourseID", courseId);
                    c1.ExecuteNonQuery();

                    SqlCommand c2 = new SqlCommand(
                        @"DELETE FROM Question
                          WHERE QuizID IN (
                              SELECT q.QuizID FROM Quiz q
                              INNER JOIN Module m ON q.ModuleID = m.ModuleID
                              WHERE m.CourseID = @CourseID)", conn, tx);
                    c2.Parameters.AddWithValue("@CourseID", courseId);
                    c2.ExecuteNonQuery();

                    SqlCommand c3 = new SqlCommand(
                        @"DELETE FROM Quiz
                          WHERE ModuleID IN (SELECT ModuleID FROM Module WHERE CourseID = @CourseID)", conn, tx);
                    c3.Parameters.AddWithValue("@CourseID", courseId);
                    c3.ExecuteNonQuery();

                    SqlCommand c4 = new SqlCommand(
                        @"DELETE FROM UserProgress
                          WHERE ModuleID IN (SELECT ModuleID FROM Module WHERE CourseID = @CourseID)", conn, tx);
                    c4.Parameters.AddWithValue("@CourseID", courseId);
                    c4.ExecuteNonQuery();

                    SqlCommand c5 = new SqlCommand(
                        "DELETE FROM Module WHERE CourseID = @CourseID", conn, tx);
                    c5.Parameters.AddWithValue("@CourseID", courseId);
                    c5.ExecuteNonQuery();

                    SqlCommand c6 = new SqlCommand(
                        "DELETE FROM Enrollment WHERE CourseID = @CourseID", conn, tx);
                    c6.Parameters.AddWithValue("@CourseID", courseId);
                    c6.ExecuteNonQuery();

                    SqlCommand c7 = new SqlCommand(
                        "DELETE FROM Course WHERE CourseID = @CourseID", conn, tx);
                    c7.Parameters.AddWithValue("@CourseID", courseId);
                    c7.ExecuteNonQuery();

                    tx.Commit();
                }
                catch
                {
                    tx.Rollback();
                    ShowError("Could not delete course.");
                    return;
                }
            }

            pnlModuleList.Visible = false;
            ShowSuccess("Course deleted successfully.");
            LoadCourses();
        }

        protected void btnNewModule_Click(object sender, EventArgs e)
        {
            if (ViewState["ExpandedCourseID"] == null) return;

            int courseId = Convert.ToInt32(ViewState["ExpandedCourseID"]);
            txtModuleTitle.Text = "";
            txtModuleContent.Text = "";
            txtModuleMinutes.Text = "15";

            int nextOrder = 1;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT ISNULL(MAX(OrderIndex), 0) + 1 FROM Module WHERE CourseID = @CourseID", conn);
                cmd.Parameters.AddWithValue("@CourseID", courseId);
                conn.Open();
                nextOrder = Convert.ToInt32(cmd.ExecuteScalar());

                SqlCommand cmdName = new SqlCommand(
                    "SELECT Title FROM Course WHERE CourseID = @CourseID", conn);
                cmdName.Parameters.AddWithValue("@CourseID", courseId);
                litModuleCourseName.Text = Server.HtmlEncode(cmdName.ExecuteScalar().ToString());
            }
            txtModuleOrder.Text = nextOrder.ToString();

            ViewState["EditModuleID"] = null;
            litModuleFormHeader.Text = "New module";
            pnlModuleForm.Visible = true;
            pnlCourseForm.Visible = false;
            ClearAlerts();
        }

        protected void btnSaveModule_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            if (ViewState["ExpandedCourseID"] == null) return;

            int courseId = Convert.ToInt32(ViewState["ExpandedCourseID"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                if (ViewState["EditModuleID"] == null)
                {
                    SqlCommand cmd = new SqlCommand(
                        @"INSERT INTO Module (CourseID, Title, Content, OrderIndex, EstimatedMinutes)
                          VALUES (@CourseID, @Title, @Content, @Order, @Min)", conn);
                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    cmd.Parameters.AddWithValue("@Title", txtModuleTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@Content", txtModuleContent.Text);
                    cmd.Parameters.AddWithValue("@Order", int.Parse(txtModuleOrder.Text));
                    cmd.Parameters.AddWithValue("@Min", int.Parse(txtModuleMinutes.Text));
                    cmd.ExecuteNonQuery();
                    ShowSuccess("Module created successfully.");
                }
                else
                {
                    int moduleId = Convert.ToInt32(ViewState["EditModuleID"]);
                    SqlCommand cmd = new SqlCommand(
                        @"UPDATE Module
                          SET Title = @Title, Content = @Content, OrderIndex = @Order, EstimatedMinutes = @Min
                          WHERE ModuleID = @ModuleID", conn);
                    cmd.Parameters.AddWithValue("@Title", txtModuleTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@Content", txtModuleContent.Text);
                    cmd.Parameters.AddWithValue("@Order", int.Parse(txtModuleOrder.Text));
                    cmd.Parameters.AddWithValue("@Min", int.Parse(txtModuleMinutes.Text));
                    cmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    cmd.ExecuteNonQuery();
                    ShowSuccess("Module updated successfully.");
                }
            }

            pnlModuleForm.Visible = false;
            ViewState["EditModuleID"] = null;
            ShowModulesPanel(courseId);
        }

        protected void btnCancelModule_Click(object sender, EventArgs e)
        {
            pnlModuleForm.Visible = false;
            ViewState["EditModuleID"] = null;
            ClearAlerts();
        }

        protected void rptModulesInCourse_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int moduleId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditModule")
            {
                int courseId = 0;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "SELECT CourseID, Title, Content, OrderIndex, EstimatedMinutes FROM Module WHERE ModuleID = @ModuleID", conn);
                    cmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    conn.Open();
                    using (SqlDataReader rd = cmd.ExecuteReader())
                    {
                        if (rd.Read())
                        {
                            courseId = Convert.ToInt32(rd["CourseID"]);
                            txtModuleTitle.Text = rd["Title"].ToString();
                            txtModuleContent.Text = rd["Content"].ToString();
                            txtModuleOrder.Text = rd["OrderIndex"].ToString();
                            txtModuleMinutes.Text = rd["EstimatedMinutes"].ToString();
                        }
                    }

                    SqlCommand cmdName = new SqlCommand(
                        "SELECT Title FROM Course WHERE CourseID = @CourseID", conn);
                    cmdName.Parameters.AddWithValue("@CourseID", courseId);
                    litModuleCourseName.Text = Server.HtmlEncode(cmdName.ExecuteScalar().ToString());
                }

                ViewState["EditModuleID"] = moduleId;
                ViewState["ExpandedCourseID"] = courseId;
                litModuleFormHeader.Text = "Edit module";
                pnlModuleForm.Visible = true;
                pnlCourseForm.Visible = false;
                ClearAlerts();
            }
            else if (e.CommandName == "DeleteModule")
            {
                DeleteModule(moduleId);
            }
        }

        private void DeleteModule(int moduleId)
        {
            int courseId = 0;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction tx = conn.BeginTransaction();
                try
                {
                    SqlCommand cmdCourse = new SqlCommand(
                        "SELECT CourseID FROM Module WHERE ModuleID = @ModuleID", conn, tx);
                    cmdCourse.Parameters.AddWithValue("@ModuleID", moduleId);
                    courseId = Convert.ToInt32(cmdCourse.ExecuteScalar());

                    SqlCommand c1 = new SqlCommand(
                        "DELETE FROM Quiz_Attempt WHERE QuizID IN (SELECT QuizID FROM Quiz WHERE ModuleID = @ModuleID)", conn, tx);
                    c1.Parameters.AddWithValue("@ModuleID", moduleId);
                    c1.ExecuteNonQuery();

                    SqlCommand c2 = new SqlCommand(
                        "DELETE FROM Question WHERE QuizID IN (SELECT QuizID FROM Quiz WHERE ModuleID = @ModuleID)", conn, tx);
                    c2.Parameters.AddWithValue("@ModuleID", moduleId);
                    c2.ExecuteNonQuery();

                    SqlCommand c3 = new SqlCommand(
                        "DELETE FROM Quiz WHERE ModuleID = @ModuleID", conn, tx);
                    c3.Parameters.AddWithValue("@ModuleID", moduleId);
                    c3.ExecuteNonQuery();

                    SqlCommand c4 = new SqlCommand(
                        "DELETE FROM UserProgress WHERE ModuleID = @ModuleID", conn, tx);
                    c4.Parameters.AddWithValue("@ModuleID", moduleId);
                    c4.ExecuteNonQuery();

                    SqlCommand c5 = new SqlCommand(
                        "DELETE FROM Module WHERE ModuleID = @ModuleID", conn, tx);
                    c5.Parameters.AddWithValue("@ModuleID", moduleId);
                    c5.ExecuteNonQuery();

                    tx.Commit();
                }
                catch
                {
                    tx.Rollback();
                    ShowError("Could not delete module.");
                    return;
                }
            }

            ShowSuccess("Module deleted successfully.");
            LoadCourses();
            if (courseId > 0) ShowModulesPanel(courseId);
        }

        private void ShowSuccess(string msg)
        {
            pnlSuccess.Visible = true;
            pnlError.Visible = false;
            litSuccess.Text = Server.HtmlEncode(msg);
        }

        private void ShowError(string msg)
        {
            pnlError.Visible = true;
            pnlSuccess.Visible = false;
            litError.Text = Server.HtmlEncode(msg);
        }

        private void ClearAlerts()
        {
            pnlSuccess.Visible = false;
            pnlError.Visible = false;
        }
    }
}
