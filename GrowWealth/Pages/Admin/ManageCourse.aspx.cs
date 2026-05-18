using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GrowWealth.Pages.Admin
{
    public partial class ManageCourse : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // check if user is logged in
            if (!Request.IsAuthenticated)
            {
                FormsAuthentication.RedirectToLoginPage();
                return;
            }

            // only admin can access this page
            if (!CheckIfAdmin())
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStats();
                LoadCourses("", "");
            }
        }

        bool CheckIfAdmin()
        {
            bool isAdmin = false;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT RoleID FROM [User] WHERE FullName = @Name AND AccountStatus = 'Active'", conn);
                cmd.Parameters.AddWithValue("@Name", Context.User.Identity.Name);
                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null && Convert.ToInt32(result) == 1)
                {
                    isAdmin = true;
                }
            }
            return isAdmin;
        }

        void LoadStats()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT COUNT(*) AS Total, " +
                             "SUM(CASE WHEN Status = 'Published' THEN 1 ELSE 0 END) AS Published, " +
                             "SUM(CASE WHEN Status = 'Draft' THEN 1 ELSE 0 END) AS Draft, " +
                             "SUM(CASE WHEN Status = 'Archived' THEN 1 ELSE 0 END) AS Archived " +
                             "FROM Course";

                SqlCommand cmd = new SqlCommand(sql, conn);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    lbl_TotalCount.Text = dr["Total"].ToString();
                    lbl_PublishedCount.Text = dr["Published"].ToString();
                    lbl_DraftCount.Text = dr["Draft"].ToString();
                    lbl_ArchivedCount.Text = dr["Archived"].ToString();
                }
            }
        }

        void LoadCourses(string search, string status)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT c.CourseID, c.Title, c.DifficultyLevel, c.Status, c.CreatedAt, " +
                             "COUNT(e.EnrollmentID) AS EnrollCount " +
                             "FROM Course c " +
                             "LEFT JOIN Enrollment e ON c.CourseID = e.CourseID " +
                             "WHERE (@Search = '' OR c.Title LIKE '%' + @Search + '%') " +
                             "AND (@Status = '' OR c.Status = @Status) " +
                             "GROUP BY c.CourseID, c.Title, c.DifficultyLevel, c.Status, c.CreatedAt " +
                             "ORDER BY c.CreatedAt DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@Search", search);
                cmd.Parameters.AddWithValue("@Status", status);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gv_Courses.DataSource = dt;
                gv_Courses.DataBind();
            }
        }

        protected void btn_Search_Click(object sender, EventArgs e)
        {
            LoadCourses(txt_Search.Text.Trim(), ddl_StatusFilter.SelectedValue);
        }

        protected void gv_Courses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int courseId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "DeleteCourse")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM Course WHERE CourseID = @ID", conn);
                    cmd.Parameters.AddWithValue("@ID", courseId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                ShowMessage("Course deleted!", true);
                LoadStats();
                LoadCourses(txt_Search.Text.Trim(), ddl_StatusFilter.SelectedValue);
            }
            else if (e.CommandName == "EditCourse")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM Course WHERE CourseID = @ID", conn);
                    cmd.Parameters.AddWithValue("@ID", courseId);
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        hf_EditCourseID.Value = dr["CourseID"].ToString();
                        txt_EditTitle.Text = dr["Title"].ToString();
                        txt_EditDescription.Text = dr["Description"].ToString();
                        txt_EditThumbnail.Text = dr["ThumbnailURL"].ToString();
                        ddl_EditDifficulty.SelectedValue = dr["DifficultyLevel"].ToString();
                        ddl_EditStatus.SelectedValue = dr["Status"].ToString();
                    }
                }
                hf_ShowEdit.Value = "1";
                LoadCourses(txt_Search.Text.Trim(), ddl_StatusFilter.SelectedValue);
            }
        }

        protected void btn_AddCourse_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txt_Title.Text))
            {
                ShowMessage("Please enter a course title.", false);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "INSERT INTO Course (Title, Description, DifficultyLevel, ThumbnailURL, Status) " +
                             "VALUES (@Title, @Desc, @Diff, @Thumb, @Status)";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@Title", txt_Title.Text.Trim());
                cmd.Parameters.AddWithValue("@Desc", txt_Description.Text.Trim());
                cmd.Parameters.AddWithValue("@Diff", ddl_Difficulty.SelectedValue);
                cmd.Parameters.AddWithValue("@Thumb", txt_Thumbnail.Text.Trim());
                cmd.Parameters.AddWithValue("@Status", ddl_Status.SelectedValue);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            // clear the form
            txt_Title.Text = "";
            txt_Description.Text = "";
            txt_Thumbnail.Text = "";

            ShowMessage("Course added successfully!", true);
            LoadStats();
            LoadCourses("", "");
        }

        protected void btn_UpdateCourse_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txt_EditTitle.Text))
            {
                ShowMessage("Course title cannot be empty.", false);
                hf_ShowEdit.Value = "1";
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "UPDATE Course SET Title = @Title, Description = @Desc, " +
                             "DifficultyLevel = @Diff, ThumbnailURL = @Thumb, Status = @Status " +
                             "WHERE CourseID = @ID";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@Title", txt_EditTitle.Text.Trim());
                cmd.Parameters.AddWithValue("@Desc", txt_EditDescription.Text.Trim());
                cmd.Parameters.AddWithValue("@Diff", ddl_EditDifficulty.SelectedValue);
                cmd.Parameters.AddWithValue("@Thumb", txt_EditThumbnail.Text.Trim());
                cmd.Parameters.AddWithValue("@Status", ddl_EditStatus.SelectedValue);
                cmd.Parameters.AddWithValue("@ID", Convert.ToInt32(hf_EditCourseID.Value));
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            hf_ShowEdit.Value = "0";
            ShowMessage("Course updated successfully!", true);
            LoadStats();
            LoadCourses(txt_Search.Text.Trim(), ddl_StatusFilter.SelectedValue);
        }

        void ShowMessage(string msg, bool success)
        {
            lbl_Message.Text = msg;
            lbl_Message.CssClass = success ? "alert-success" : "alert-error";
            lbl_Message.Visible = true;
        }
    }
}
