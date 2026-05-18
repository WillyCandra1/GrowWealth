using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace GrowWealth.Pages.Admin
{
    public partial class ManageQuiz : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCourses();
            }
        }
        protected void Course_SelectedIndexChanged(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT ModuleID, Title, OrderIndex FROM Module WHERE CourseID = @CourseID ORDER BY OrderIndex";
                SqlCommand command = new SqlCommand(sql, conn);
                command.Parameters.AddWithValue("@CourseID", CourseList.SelectedValue);

                conn.Open();
                SqlDataReader reader = command.ExecuteReader();

                ModuleList.Items.Clear();
                ModuleList.Items.Add(new ListItem("Select a Module: ", ""));
                while (reader.Read())
                {
                    ModuleList.Items.Add(new ListItem(
                        "Module " + reader["OrderIndex"].ToString() + " - " + reader["Title"].ToString(),
                        reader["ModuleID"].ToString()
                    ));
                }
            }
            QuizHeader.Visible = false;
            QuestionList.DataSource = null;
            QuestionList.DataBind();
            ViewState["QuizID"] = null;
        }
        protected void LoadCourses()
        {
            string connStr = ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

            using(SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT CourseID, Title FROM Course WHERE Status = 'Active'";
                SqlCommand command = new SqlCommand(sql, conn);

                conn.Open();
                SqlDataReader reader = command.ExecuteReader();

                CourseList.Items.Clear();
                CourseList.Items.Add(new ListItem("Select a Course: ", ""));
                while (reader.Read())
                {
                    CourseList.Items.Add(new ListItem(
                        reader["Title"].ToString(),
                        reader["CourseID"].ToString()
                    ));
                }
            }
        }

        protected void loadButtonClick(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

            using(SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT q.QuizID, q.Title, q.PassMarkPercent, COUNT(qn.QuestionID) as QuestionCount
                                FROM Quiz q 
                                LEFT JOIN Question qn ON q.QuizID = qn.QuizID
                                WHERE q.ModuleID = @ModuleID
                                GROUP BY q.QuizID, q.Title, q.PassMarkPercent";

                SqlCommand command = new SqlCommand(sql, conn);
                command.Parameters.AddWithValue("@ModuleID", ModuleList.SelectedValue);

                conn.Open();
                SqlDataReader reader = command.ExecuteReader();

                if (reader.Read())
                {
                    string quizID = reader["QuizID"].ToString();
                    quizTitle.Text = reader["Title"].ToString();
                    quizData.Text = reader["QuestionCount"] + " Questions - Passing Marks: " + reader["PassMarkPercent"] + "%";
                    QuizHeader.Visible = true;
                    ViewState["QuizID"] = quizID;
                    reader.Close();
                    LoadQuestion(quizID);
                }
                else
                {
                    quizTitle.Text = "No Quiz Found for this Module.";
                    quizData.Text = "";
                    QuizHeader.Visible = true;
                    reader.Close();

                    QuestionList.DataSource = null;
                    QuestionList.DataBind();
                    ViewState["QuizID"] = null; 
                }

            }
        }
        protected void LoadQuestion(string quizID)
        {
            string connStr = ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT QuestionID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectAnswer FROM Question WHERE QuizID = @QuizID";
                SqlCommand command = new SqlCommand(sql, conn);
                command.Parameters.AddWithValue("@QuizID", quizID);

                conn.Open();
                SqlDataAdapter data = new SqlDataAdapter(command);
                DataTable table = new DataTable();
                data.Fill(table);

                QuestionList.DataSource = table;
                QuestionList.DataBind();
            }
        }
        protected void QuestionList_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Delete")
            {
                string questionID = e.CommandArgument.ToString();
                string connStr = ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "DELETE FROM Question WHERE QuestionID = @QuestionID";
                    SqlCommand command = new SqlCommand(sql, conn);
                    command.Parameters.AddWithValue("@QuestionID", questionID);

                    conn.Open();
                    command.ExecuteNonQuery();
                }
                loadButtonClick(null, null);
            }
            if(e.CommandName == "Edit")
            {
                string questionID = e.CommandArgument.ToString();
                ViewState["EditQuestionID"] = questionID;
                AddQuestions.Visible = true;
                questionTitle.Text = "Edit Question";

                string connStr = ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = @"SELECT QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectAnswer FROM Question WHERE QuestionID = @QuestionID";

                    SqlCommand command = new SqlCommand(sql, conn);
                    command.Parameters.AddWithValue("@QuestionID", questionID);

                    conn.Open();
                    SqlDataReader reader = command.ExecuteReader();

                    if (reader.Read())
                    {
                        questionText.Text = reader["QuestionText"].ToString();
                        TextOptionA.Text = reader["OptionA"].ToString();
                        TextOptionB.Text = reader["OptionB"].ToString();
                        TextOptionC.Text = reader["OptionC"].ToString();
                        TextOptionD.Text = reader["OptionD"].ToString();
                        CorrectAnswerList.SelectedValue = reader["CorrectAnswer"].ToString();
                    }
                }
                saveQuestion.Text = "Save Changes";
            }
        }
        protected void addQuestionClick(object sender, EventArgs e)
        {
            AddQuestions.Visible = true; 
        }
        protected void cancelButtonClick(object sender, EventArgs e)
        {
            AddQuestions.Visible = false;
            ViewState["EditQuestionID"] = null;
            saveQuestion.Text = "Save Question";
            questionTitle.Text = "Add New Question";
        }
        protected void saveButtonClick(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand command;
                if (ViewState["EditQuestionID"] != null)
                {
                    string sql = @"UPDATE Question
                           SET QuestionText = @QuestionText, OptionA = @OptionA, OptionB = @OptionB, OptionC = @OptionC, OptionD = @OptionD, CorrectAnswer = @CorrectAnswer WHERE QuestionID = @QuestionID";

                    command = new SqlCommand(sql, conn);
                    command.Parameters.AddWithValue("@QuestionID", ViewState["EditQuestionID"]);
                }
                else
                {
                    string sql = @"INSERT INTO Question
                           (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectAnswer) VALUES
                           (@QuizID, @QuestionText, @OptionA, @OptionB, @OptionC, @OptionD, @CorrectAnswer)";

                    command = new SqlCommand(sql, conn);
                    command.Parameters.AddWithValue("@QuizID", ViewState["QuizID"]);
                }

                command.Parameters.AddWithValue("@QuestionText", questionText.Text);
                command.Parameters.AddWithValue("@OptionA", TextOptionA.Text);
                command.Parameters.AddWithValue("@OptionB", TextOptionB.Text);
                command.Parameters.AddWithValue("@OptionC", TextOptionC.Text);
                command.Parameters.AddWithValue("@OptionD", TextOptionD.Text);
                command.Parameters.AddWithValue("@CorrectAnswer", CorrectAnswerList.SelectedValue);

                conn.Open();
                command.ExecuteNonQuery();
            }
            ViewState["EditQuestionID"] = null;
            AddQuestions.Visible = false;
            saveQuestion.Text = "Save Question";
            questionTitle.Text = "Add New Question";

            loadButtonClick(null, null);
        }
        protected void editPassingMarksClick(object sender, EventArgs e)
        {
            EditPassMarks.Visible = true;
        }
        protected void cancelPassingMarksClick(object sender, EventArgs e)
        {
            EditPassMarks.Visible = false;
        }
        protected void savePassingMarksClick(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "UPDATE Quiz SET PassMarkPercent = @PassMark WHERE QuizID = @QuizID";
                SqlCommand command = new SqlCommand(sql, conn);
                command.Parameters.AddWithValue("@PassMark", passMarks.Text);
                command.Parameters.AddWithValue("@QuizID", ViewState["QuizID"]);

                conn.Open();
                command.ExecuteNonQuery();
            }

            EditPassMarks.Visible = false;
            loadButtonClick(null, null);
        }
    }
}