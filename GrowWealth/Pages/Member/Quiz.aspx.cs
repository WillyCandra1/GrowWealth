using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GrowWealth.Pages.Member
{
    public partial class Quiz : Page
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
                int quizId;
                if (!int.TryParse(Request.QueryString["quizId"], out quizId))
                {
                    Response.Redirect("~/Pages/Member/CoursePage.aspx");
                    return;
                }

                LoadQuiz(quizId);
                Session["QuizID"] = quizId;
                Session["CurrentQuestionIndex"] = 0;
                Session["Answers"] = new Dictionary<int, string>();
                ShowQuestion(0);
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

        private void LoadQuiz(int quizId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand cmdQ = new SqlCommand(
                    @"SELECT q.Title, q.PassMark, q.ModuleID, m.CourseID
                      FROM Quiz q
                      INNER JOIN Module m ON q.ModuleID = m.ModuleID
                      WHERE q.QuizID = @QuizID", conn);
                cmdQ.Parameters.AddWithValue("@QuizID", quizId);

                using (SqlDataReader rd = cmdQ.ExecuteReader())
                {
                    if (!rd.Read())
                    {
                        rd.Close();
                        Response.Redirect("~/Pages/Member/CoursePage.aspx");
                        return;
                    }

                    litQuizTitle.Text = Server.HtmlEncode(rd["Title"].ToString());
                    Session["PassMark"] = Convert.ToInt32(rd["PassMark"]);
                    Session["ModuleID"] = Convert.ToInt32(rd["ModuleID"]);
                    Session["CourseID"] = Convert.ToInt32(rd["CourseID"]);
                }

                DataTable dt = new DataTable();
                SqlCommand cmdQs = new SqlCommand(
                    @"SELECT QuestionID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, OrderIndex
                      FROM Question WHERE QuizID = @QuizID ORDER BY OrderIndex, QuestionID", conn);
                cmdQs.Parameters.AddWithValue("@QuizID", quizId);
                new SqlDataAdapter(cmdQs).Fill(dt);

                Session["Questions"] = dt;
            }
        }

        private void ShowQuestion(int index)
        {
            DataTable dt = (DataTable)Session["Questions"];
            if (dt == null || dt.Rows.Count == 0) return;

            if (index < 0) index = 0;
            if (index >= dt.Rows.Count) index = dt.Rows.Count - 1;

            Session["CurrentQuestionIndex"] = index;
            DataRow row = dt.Rows[index];

            litCurrentNum.Text = (index + 1).ToString();
            litTotalNum.Text = dt.Rows.Count.ToString();
            litQNumLabel.Text = (index + 1).ToString();
            litQuestionText.Text = Server.HtmlEncode(row["QuestionText"].ToString());

            int pct = ((index + 1) * 100) / dt.Rows.Count;
            progressFill.Style["width"] = pct + "%";

            rblOptions.Items.Clear();
            rblOptions.Items.Add(new ListItem("A.  " + row["OptionA"].ToString(), "A"));
            rblOptions.Items.Add(new ListItem("B.  " + row["OptionB"].ToString(), "B"));
            rblOptions.Items.Add(new ListItem("C.  " + row["OptionC"].ToString(), "C"));
            rblOptions.Items.Add(new ListItem("D.  " + row["OptionD"].ToString(), "D"));

            int questionId = Convert.ToInt32(row["QuestionID"]);
            var answers = (Dictionary<int, string>)Session["Answers"];
            if (answers.ContainsKey(questionId))
            {
                ListItem found = rblOptions.Items.FindByValue(answers[questionId]);
                if (found != null) found.Selected = true;
            }

            litAnsweredCount.Text = answers.Count.ToString();

            btnPrev.Enabled = index > 0;
            bool isLast = (index == dt.Rows.Count - 1);
            btnNext.Visible = !isLast;
            btnSubmit.Visible = isLast;

            pnlAlert.Visible = false;
        }

        private void SaveCurrentAnswer()
        {
            DataTable dt = (DataTable)Session["Questions"];
            int index = Convert.ToInt32(Session["CurrentQuestionIndex"]);
            if (dt == null || index >= dt.Rows.Count) return;

            int questionId = Convert.ToInt32(dt.Rows[index]["QuestionID"]);
            var answers = (Dictionary<int, string>)Session["Answers"];

            if (rblOptions.SelectedItem != null)
            {
                answers[questionId] = rblOptions.SelectedValue;
            }

            Session["Answers"] = answers;
        }

        protected void btnPrev_Click(object sender, EventArgs e)
        {
            SaveCurrentAnswer();
            int index = Convert.ToInt32(Session["CurrentQuestionIndex"]);
            ShowQuestion(index - 1);
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            if (rblOptions.SelectedItem == null)
            {
                pnlAlert.Visible = true;
                litAlertMsg.Text = "Please select an answer before continuing.";
                return;
            }
            SaveCurrentAnswer();
            int index = Convert.ToInt32(Session["CurrentQuestionIndex"]);
            ShowQuestion(index + 1);
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (rblOptions.SelectedItem == null)
            {
                pnlAlert.Visible = true;
                litAlertMsg.Text = "Please select an answer before submitting.";
                return;
            }

            SaveCurrentAnswer();

            DataTable dt = (DataTable)Session["Questions"];
            var answers = (Dictionary<int, string>)Session["Answers"];

            if (answers.Count < dt.Rows.Count)
            {
                pnlAlert.Visible = true;
                litAlertMsg.Text = "Please answer all questions before submitting. You've answered " + answers.Count + " of " + dt.Rows.Count + ".";
                int firstUnanswered = 0;
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    int qid = Convert.ToInt32(dt.Rows[i]["QuestionID"]);
                    if (!answers.ContainsKey(qid))
                    {
                        firstUnanswered = i;
                        break;
                    }
                }
                ShowQuestion(firstUnanswered);
                pnlAlert.Visible = true;
                return;
            }

            int correct = 0;
            int total = dt.Rows.Count;
            foreach (DataRow row in dt.Rows)
            {
                int qid = Convert.ToInt32(row["QuestionID"]);
                string correctOpt = row["CorrectOption"].ToString();
                if (answers.ContainsKey(qid) && answers[qid] == correctOpt)
                {
                    correct++;
                }
            }

            int quizId = Convert.ToInt32(Session["QuizID"]);
            int userId = GetCurrentUserId();
            int passMark = Convert.ToInt32(Session["PassMark"]);
            int scorePct = (total == 0) ? 0 : (correct * 100 / total);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(
                    @"INSERT INTO Quiz_Attempt (UserID, QuizID, Score, TotalQuestions, AttemptedAt)
                      VALUES (@UserID, @QuizID, @Score, @Total, GETDATE())", conn);
                cmd.Parameters.AddWithValue("@UserID", userId);
                cmd.Parameters.AddWithValue("@QuizID", quizId);
                cmd.Parameters.AddWithValue("@Score", correct);
                cmd.Parameters.AddWithValue("@Total", total);
                cmd.ExecuteNonQuery();
            }

            pnlQuestion.Visible = false;
            pnlResult.Visible = true;

            litResultPct.Text = scorePct.ToString();
            litResultCorrect.Text = correct.ToString();
            litResultTotal.Text = total.ToString();
            litResultPassMark.Text = passMark.ToString();

            bool passed = scorePct >= passMark;
            if (passed)
            {
                resultIconWrap.Attributes["class"] = "result-icon pass";
                litResultIcon.Text = "&#10003;";
                litResultTitle.Text = "Great work — you passed!";
                litResultDetail.Text = "You scored above the pass mark. Keep going to maintain your momentum.";
            }
            else
            {
                resultIconWrap.Attributes["class"] = "result-icon fail";
                litResultIcon.Text = "&#10007;";
                litResultTitle.Text = "Not quite there yet";
                litResultDetail.Text = "Review the module material and give the quiz another try when you're ready.";
            }
        }

        protected void btnRetry_Click(object sender, EventArgs e)
        {
            int quizId = Convert.ToInt32(Session["QuizID"]);
            Response.Redirect("~/Pages/Member/Quiz.aspx?quizId=" + quizId);
        }

        protected void btnBackToCourse_Click(object sender, EventArgs e)
        {
            if (Session["CourseID"] != null)
            {
                Response.Redirect("~/Pages/Member/CoursePage.aspx?id=" + Session["CourseID"]);
            }
            else
            {
                Response.Redirect("~/Pages/Member/CoursePage.aspx");
            }
        }
    }
}
