using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace GrowWealth.Pages.Admin
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboardNumbers();
                LoadRecentUsers();
                LoadCourses();
            }
        }

        private void LoadDashboardNumbers()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    lblUsers.Text = GetCount(conn, "SELECT COUNT(*) FROM [User]").ToString();
                    lblCourses.Text = GetCount(conn, "SELECT COUNT(*) FROM Course WHERE Status = 'Active'").ToString();
                    lblModules.Text = GetCount(conn, "SELECT COUNT(*) FROM Module").ToString();

                    // If QuizAttempt table does not exist yet, this will be handled safely.
                    lblQuizAttempts.Text = GetCountSafe(conn, "SELECT COUNT(*) FROM Quiz_Attempt").ToString();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Dashboard data cannot be loaded yet. " + ex.Message;
            }
        }

        private int GetCount(SqlConnection conn, string sql)
        {
            SqlCommand cmd = new SqlCommand(sql, conn);
            return Convert.ToInt32(cmd.ExecuteScalar());
        }

        private int GetCountSafe(SqlConnection conn, string sql)
        {
            try
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
            catch
            {
                return 0;
            }
        }

        private void LoadRecentUsers()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "SELECT TOP 5 FullName, Email, Role, CreatedAt " +
                                 "FROM [User] " +
                                 "ORDER BY CreatedAt DESC";

                    SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvUsers.DataSource = dt;
                    gvUsers.DataBind();
                }
            }
            catch
            {
                // Keep page working even if user table columns are different.
            }
        }

        private void LoadCourses()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "SELECT TOP 5 Title, DifficultyLevel, Status " +
                                 "FROM Course " +
                                 "ORDER BY CourseID DESC";

                    SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvCourses.DataSource = dt;
                    gvCourses.DataBind();
                }
            }
            catch
            {
                // Keep page working even if course table is empty.
            }
        }
    }
}