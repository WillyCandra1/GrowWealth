using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GrowWealth.Pages.Admin
{
    public partial class ManageQuiz : Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCourses();
            }
        }

        private void LoadCourses()
        {
            ddlCourse.Items.Clear();
            ddlCourse.Items.Add(new ListItem("-- Select course --", ""));

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT CourseID, Title FROM Course ORDER BY Title", conn);
                conn.Open();
                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        ddlCourse.Items.Add(new ListItem(rd["Title"].ToString(), rd["CourseID"].ToString()));
                    }
                }
            }

            ddlModule.Items.Clear();
            ddlModule.Items.Add(new ListItem("-- Select course first --", ""));
            ddlModule.Enabled = false;
        }

        protected void ddlCourse_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlModule.Items.Clear();
            pnlQuiz.Visible = false;
            ClearAlerts();

            if (string.IsNullOrEmpty(ddlCourse.SelectedValue))
            {
                ddlModule.Items.Add(new ListItem("-- Select course first --", ""));
                ddlModule.Enabled = false;
                return;
            }

            ddlModule.Items.Add(new ListItem("-- Select module --", ""));
            ddlModule.Enabled = true;

            int courseId = int.Parse(ddlCourse.SelectedValue);
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT ModuleID, Title, OrderIndex FROM Module WHERE CourseID = @CourseID ORDER BY OrderIndex", conn);
                cmd.Parameters.AddWithValue("@CourseID", courseId);
                conn.Open();
                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        string label = rd["OrderIndex"] + ". " + rd["Title"];
                        ddlModule.Items.Add(new ListItem(label, rd["ModuleID"].ToString()));
                    }
                }
            }
        }

        protected void ddlModule_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlQuiz.Visible = false;
            ClearAlerts();

            if (string.IsNullOrEmpty(ddlModule.SelectedValue)) return;

            int moduleId = int.Parse(ddlModule.SelectedValue);
            LoadQuizForModule(moduleId);
        }

        private void LoadQuizForModule(int moduleId)
        {
            int quizId = 0;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(
                    "SELECT QuizID, Title, PassMark FROM Quiz WHERE ModuleID = @ModuleID", conn);
                cmd.Parameters.AddWithValue("@ModuleID", moduleId);
                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    if (rd.Read())
                    {
                        quizId = Convert.ToInt32(rd["QuizID"]);
                        litQuizTitle.Text = Server.HtmlEncode(rd["Title"].ToString());
                        txtPassMark.Text = rd["PassMark"].ToString();
                    }
                }

                if (quizId == 0)
                {
                    rd_CloseAndCreate(conn, moduleId, out quizId);
                }

                SqlCommand cmdCount = new SqlCommand(
                    "SELECT COUNT(*) FROM Quiz_Attempt WHERE QuizID = @QuizID", conn);
                cmdCount.Parameters.AddWithValue("@QuizID", quizId);
                litAttemptCount.Text = cmdCount.ExecuteScalar().ToString();
            }

            ViewState["QuizID"] = quizId;
            LoadQuestions(quizId);
            pnlQuiz.Visible = true;
        }

        private void rd_CloseAndCreate(SqlConnection conn, int moduleId, out int quizId)
        {
            SqlCommand cmdMod = new SqlCommand(
                "SELECT Title FROM Module WHERE ModuleID = @ModuleID", conn);
            cmdMod.Parameters.AddWithValue("@ModuleID", moduleId);
            string modTitle = cmdMod.ExecuteScalar().ToString();

            SqlCommand ins = new SqlCommand(
                @"INSERT INTO Quiz (ModuleID, Title, PassMark)
                  OUTPUT INSERTED.QuizID
                  VALUES (@ModuleID, @Title, 60)", conn);
            ins.Parameters.AddWithValue("@ModuleID", moduleId);
            ins.Parameters.AddWithValue("@Title", modTitle + " quiz");
            quizId = Convert.ToInt32(ins.ExecuteScalar());

            litQuizTitle.Text = Server.HtmlEncode(modTitle + " quiz");
            txtPassMark.Text = "60";
        }

        private void LoadQuestions(int quizId)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    @"SELECT QuestionID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, OrderIndex
                      FROM Question WHERE QuizID = @QuizID ORDER BY OrderIndex, QuestionID", conn);
                cmd.Parameters.AddWithValue("@QuizID", quizId);
                new SqlDataAdapter(cmd).Fill(dt);
            }

            rptQuestions.DataSource = dt;
            rptQuestions.DataBind();

            litQuestionCount.Text = dt.Rows.Count.ToString();
            pnlEmpty.Visible = (dt.Rows.Count == 0);
            pnlQuestions.Visible = (dt.Rows.Count > 0);
        }

        protected void btnSavePassMark_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            if (ViewState["QuizID"] == null) return;

            int quizId = Convert.ToInt32(ViewState["QuizID"]);
            int passMark = int.Parse(txtPassMark.Text);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "UPDATE Quiz SET PassMark = @PassMark WHERE QuizID = @QuizID", conn);
                cmd.Parameters.AddWithValue("@PassMark", passMark);
                cmd.Parameters.AddWithValue("@QuizID", quizId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            ShowSuccess("Pass mark updated.");
        }

        protected void btnSaveAll_Click(object sender, EventArgs e)
        {
            if (ViewState["QuizID"] == null) return;
            int quizId = Convert.ToInt32(ViewState["QuizID"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                foreach (RepeaterItem item in rptQuestions.Items)
                {
                    TextBox qtText = (TextBox)item.FindControl("qtText");
                    TextBox qtA = (TextBox)item.FindControl("qtA");
                    TextBox qtB = (TextBox)item.FindControl("qtB");
                    TextBox qtC = (TextBox)item.FindControl("qtC");
                    TextBox qtD = (TextBox)item.FindControl("qtD");
                    RadioButton rbA = (RadioButton)item.FindControl("rbOptA");
                    RadioButton rbB = (RadioButton)item.FindControl("rbOptB");
                    RadioButton rbC = (RadioButton)item.FindControl("rbOptC");
                    RadioButton rbD = (RadioButton)item.FindControl("rbOptD");

                    if (qtText == null || string.IsNullOrEmpty(qtText.Attributes["data-qid"])) continue;
                    int qid = int.Parse(qtText.Attributes["data-qid"]);

                    string correct = "A";
                    if (rbB != null && rbB.Checked) correct = "B";
                    else if (rbC != null && rbC.Checked) correct = "C";
                    else if (rbD != null && rbD.Checked) correct = "D";

                    SqlCommand cmd = new SqlCommand(
                        @"UPDATE Question
                          SET QuestionText = @QT, OptionA = @A, OptionB = @B,
                              OptionC = @C, OptionD = @D, CorrectOption = @Correct
                          WHERE QuestionID = @QID", conn);
                    cmd.Parameters.AddWithValue("@QT", qtText.Text);
                    cmd.Parameters.AddWithValue("@A", qtA.Text);
                    cmd.Parameters.AddWithValue("@B", qtB.Text);
                    cmd.Parameters.AddWithValue("@C", qtC.Text);
                    cmd.Parameters.AddWithValue("@D", qtD.Text);
                    cmd.Parameters.AddWithValue("@Correct", correct);
                    cmd.Parameters.AddWithValue("@QID", qid);
                    cmd.ExecuteNonQuery();
                }
            }

            ShowSuccess("All question changes saved.");
            LoadQuestions(quizId);
        }

        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            if (ViewState["QuizID"] == null) return;
            int quizId = Convert.ToInt32(ViewState["QuizID"]);

            int nextOrder = 1;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmdOrder = new SqlCommand(
                    "SELECT ISNULL(MAX(OrderIndex), 0) + 1 FROM Question WHERE QuizID = @QuizID", conn);
                cmdOrder.Parameters.AddWithValue("@QuizID", quizId);
                nextOrder = Convert.ToInt32(cmdOrder.ExecuteScalar());

                SqlCommand cmd = new SqlCommand(
                    @"INSERT INTO Question (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, OrderIndex)
                      VALUES (@QuizID, @QT, @A, @B, @C, @D, 'A', @Order)", conn);
                cmd.Parameters.AddWithValue("@QuizID", quizId);
                cmd.Parameters.AddWithValue("@QT", "New question — click to edit.");
                cmd.Parameters.AddWithValue("@A", "Option A");
                cmd.Parameters.AddWithValue("@B", "Option B");
                cmd.Parameters.AddWithValue("@C", "Option C");
                cmd.Parameters.AddWithValue("@D", "Option D");
                cmd.Parameters.AddWithValue("@Order", nextOrder);
                cmd.ExecuteNonQuery();
            }

            ShowSuccess("New question added — edit it below and save.");
            LoadQuestions(quizId);
        }

        protected void rptQuestions_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteQuestion")
            {
                int qid = Convert.ToInt32(e.CommandArgument);
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "DELETE FROM Question WHERE QuestionID = @QID", conn);
                    cmd.Parameters.AddWithValue("@QID", qid);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                ShowSuccess("Question deleted.");
                if (ViewState["QuizID"] != null)
                {
                    LoadQuestions(Convert.ToInt32(ViewState["QuizID"]));
                }
            }
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
