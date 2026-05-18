using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace GrowWealth.Pages.Member
{
    public partial class CoursePage : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCoursePage();
            }
        }

        private void LoadCoursePage()
        {
            try
            {
                int courseId = GetCourseId();

                if (courseId == 0)
                {
                    ShowEmptyCourse();
                    return;
                }

                LoadCourseDetails(courseId);
                LoadCourseModules(courseId);
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Course page cannot load yet. " + ex.Message;
            }
        }

        private int GetCourseId()
        {
            int courseId;

            if (int.TryParse(Request.QueryString["courseId"], out courseId) && courseId > 0)
            {
                return courseId;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT TOP 1 CourseID FROM Course ORDER BY CourseID";

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

        private void LoadCourseDetails(int courseId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT CourseID, Title, Description, DifficultyLevel, Status " +
                             "FROM Course WHERE CourseID = @CourseID";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@CourseID", courseId);

                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    lblCourseTitle.Text = dr["Title"].ToString();
                    lblCourseDescription.Text = dr["Description"].ToString();
                    lblDifficulty.Text = dr["DifficultyLevel"].ToString();
                    lblCourseStatus.Text = dr["Status"].ToString();
                }
                else
                {
                    ShowEmptyCourse();
                }
            }
        }

        private void LoadCourseModules(int courseId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT ModuleID, Title, OrderIndex, EstimatedMinutes, " +
                             "CASE " +
                             "WHEN LEN(ISNULL(Content, '')) > 90 THEN LEFT(Content, 90) + '...' " +
                             "WHEN LEN(ISNULL(Content, '')) = 0 THEN 'No content preview yet.' " +
                             "ELSE Content " +
                             "END AS ShortContent " +
                             "FROM Module " +
                             "WHERE CourseID = @CourseID " +
                             "ORDER BY OrderIndex";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@CourseID", courseId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptModules.DataSource = dt;
                rptModules.DataBind();

                int totalMinutes = 0;

                foreach (DataRow row in dt.Rows)
                {
                    if (row["EstimatedMinutes"] != DBNull.Value)
                    {
                        totalMinutes += Convert.ToInt32(row["EstimatedMinutes"]);
                    }
                }

                lblTotalModules.Text = dt.Rows.Count.ToString();
                lblTotalMinutes.Text = totalMinutes + " min";
                lblCourseMeta.Text = dt.Rows.Count + " modules · Estimated " + totalMinutes + " min";
            }
        }

        private void ShowEmptyCourse()
        {
            lblCourseTitle.Text = "No course found";
            lblCourseDescription.Text = "Please add a course from the admin page first.";
            lblDifficulty.Text = "N/A";
            lblCourseMeta.Text = "0 modules";
            lblTotalModules.Text = "0";
            lblTotalMinutes.Text = "0 min";
            lblCourseStatus.Text = "No data";
        }
    }
}