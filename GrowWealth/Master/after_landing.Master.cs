using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GrowWealth
{
    public partial class after_landing : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Force users to log in. If they aren't, kick them to Login page.
            if (!Request.IsAuthenticated)
            {
                Response.Redirect("~/Pages/Public/Login.aspx");
                return;
            }

            // 2. Show the logged-in user's name in the top bar.
            //    The auth cookie stores the FullName (set in Login.aspx.cs).
            litUserName.Text = Context.User.Identity.Name;

            // 3. Check if the user is an Admin. If yes, show admin links in sidebar.
            CheckAdminRole();

            // 4. Highlight the currently-active sidebar link.
            HighlightActiveLink();
        }


        private void CheckAdminRole()
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "SELECT RoleID FROM [User] " +
                                 "WHERE FullName = @Name AND AccountStatus = 'Active'";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@Name", Context.User.Identity.Name);

                    conn.Open();
                    object result = cmd.ExecuteScalar();

                    if (result != null && Convert.ToInt32(result) == 1)
                    {
                        pnlAdminLinks.Visible = true;
                    }
                }
            }
            catch
            {
                // Silently ignore. Non-critical: the worst case is admin links don't appear.
            }
        }


        private void HighlightActiveLink()
        {
            string currentFile = Path.GetFileName(Request.Url.AbsolutePath).ToLower();

            if (currentFile == "dashboard.aspx")
                lnkDashboard.CssClass = "active";
            else if (currentFile == "coursepage.aspx" || currentFile == "moduleviewer.aspx")
                lnkCourses.CssClass = "active";
            else if (currentFile == "virtuallab.aspx")
                lnkVirtualLab.CssClass = "active";
            else if (currentFile == "profile.aspx")
                lnkProfile.CssClass = "active";
        }
    }
}