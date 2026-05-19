using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace GrowWealth
{
    public partial class _Default : Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.IsAuthenticated)
            {
                Response.Redirect("~/Pages/Member/Dashboard.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadFeaturedCourses();
            }
        }

        private void LoadFeaturedCourses()
        {
            string sql = @"
                SELECT TOP 3
                    c.CourseID, c.Title, c.Description, c.Difficulty, c.EstimatedHours,
                    (SELECT COUNT(*) FROM Module WHERE CourseID = c.CourseID) AS ModuleCount
                FROM Course c
                WHERE c.IsActive = 1
                ORDER BY c.CourseID";

            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                new SqlDataAdapter(sql, conn).Fill(dt);
            }

            rptFeatured.DataSource = dt;
            rptFeatured.DataBind();
        }
    }
}
