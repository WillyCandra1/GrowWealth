using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace GrowWealth.Pages.Member
{
    public partial class ModuleViewer : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadModule();
            }
        }

        private void LoadModule()
        {
            int moduleId;

            bool hasModuleId = int.TryParse(Request.QueryString["moduleId"], out moduleId);

            if (!hasModuleId || moduleId <= 0)
            {
                moduleId = GetFirstModuleId();
            }

            if (moduleId == 0)
            {
                lblMessage.Text = "No module found.";
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT m.Title AS ModuleTitle, m.Content, m.EstimatedMinutes, c.Title AS CourseTitle " +
                             "FROM Module m " +
                             "INNER JOIN Course c ON m.CourseID = c.CourseID " +
                             "WHERE m.ModuleID = @ModuleID";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@ModuleID", moduleId);

                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    lblCourseTitle.Text = dr["CourseTitle"].ToString();
                    lblModuleTitle.Text = dr["ModuleTitle"].ToString();
                    lblEstimatedMinutes.Text = dr["EstimatedMinutes"].ToString();

                    string content = dr["Content"].ToString();

                    if (string.IsNullOrWhiteSpace(content))
                    {
                        content = "This module content has not been added yet.";
                    }

                    litContent.Text = "<p>" + Server.HtmlEncode(content).Replace("\n", "<br />") + "</p>";
                }
                else
                {
                    lblMessage.Text = "Module not found.";
                }
            }
        }

        private int GetFirstModuleId()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT TOP 1 ModuleID FROM Module ORDER BY OrderIndex";

                SqlCommand cmd = new SqlCommand(sql, conn);

                conn.Open();
                object result = cmd.ExecuteScalar();

                if (result != null)
                {
                    return Convert.ToInt32(result);
                }
            }

            return 0;
        }
    }
}