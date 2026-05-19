using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.Security;
using System.Web.UI;

namespace GrowWealth.Master
{
    public partial class Admin : MasterPage
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Context.User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Pages/Public/Login.aspx");
                return;
            }

            VerifyAdminRole();

            if (!IsPostBack)
            {
                litUserName.Text = Server.HtmlEncode(Context.User.Identity.Name);
                HighlightActiveLink();
            }
        }

        private void VerifyAdminRole()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT RoleID FROM [User] WHERE FullName = @Name", conn);
                cmd.Parameters.AddWithValue("@Name", Context.User.Identity.Name);
                conn.Open();
                object result = cmd.ExecuteScalar();
                int roleId = (result == null || result == DBNull.Value) ? 0 : Convert.ToInt32(result);

                if (roleId != 1)
                {
                    Response.Redirect("~/Pages/Member/Dashboard.aspx");
                }
            }
        }

        private void HighlightActiveLink()
        {
            string currentFile = Path.GetFileName(Request.Url.AbsolutePath).ToLower();

            if (currentFile == "admindashboard.aspx")
                lnkDashboard.CssClass = "admin-sidebar-link active";
            else if (currentFile == "managecourse.aspx")
                lnkCourses.CssClass = "admin-sidebar-link active";
            else if (currentFile == "manageuser.aspx")
                lnkUsers.CssClass = "admin-sidebar-link active";
            else if (currentFile == "managequiz.aspx")
                lnkQuizzes.CssClass = "admin-sidebar-link active";
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Session.Abandon();
            Response.Redirect("~/Default.aspx");
        }
    }
}
