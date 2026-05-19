using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.Security;
using System.Web.UI;

namespace GrowWealth.Master
{
    public partial class after_landing : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated)
            {
                Response.Redirect("~/Pages/Public/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserChip();
                CheckAdminRole();
            }
            HighlightActiveLink();
        }

        private void LoadUserChip()
        {
            string fullName = Context.User.Identity.Name;
            litUserName.Text = Server.HtmlEncode(fullName);

            string profilePicPath = null;
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "SELECT ProfilePicture FROM [User] WHERE FullName = @Name", conn);
                    cmd.Parameters.AddWithValue("@Name", fullName);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                    {
                        profilePicPath = result.ToString();
                    }
                }
            }
            catch { }

            if (!string.IsNullOrEmpty(profilePicPath))
            {
                imgAvatar.ImageUrl = ResolveUrl(profilePicPath);
                imgAvatar.Visible = true;
                litAvatarInitials.Visible = false;
            }
            else
            {
                litAvatarInitials.Text = BuildInitials(fullName);
            }
        }

        private string BuildInitials(string fullName)
        {
            if (string.IsNullOrWhiteSpace(fullName)) return "?";
            string[] parts = fullName.Trim().Split(' ');
            if (parts.Length == 1) return parts[0].Substring(0, 1).ToUpper();
            return (parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1)).ToUpper();
        }

        private void CheckAdminRole()
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "SELECT RoleID FROM [User] WHERE FullName = @Name AND AccountStatus = 'Active'", conn);
                    cmd.Parameters.AddWithValue("@Name", Context.User.Identity.Name);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null && Convert.ToInt32(result) == 1)
                    {
                        pnlAdminLinks.Visible = true;
                    }
                }
            }
            catch { }
        }

        private void HighlightActiveLink()
        {
            string currentFile = Path.GetFileName(Request.Url.AbsolutePath).ToLower();

            if (currentFile == "dashboard.aspx")
                lnkDashboard.CssClass = "active";
            else if (currentFile == "coursepage.aspx" || currentFile == "moduleviewer.aspx" || currentFile == "quiz.aspx")
                lnkCourses.CssClass = "active";
            else if (currentFile == "virtuallab.aspx")
                lnkVirtualLab.CssClass = "active";
            else if (currentFile == "profile.aspx")
                lnkProfile.CssClass = "active";
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Session.Abandon();
            Response.Redirect("~/Default.aspx");
        }
    }
}
