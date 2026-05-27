using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GrowWealth.Pages.Public
{
    public partial class Register : Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.IsAuthenticated)
            {
                Response.Redirect("~/Pages/Member/Dashboard.aspx");
            }
        }

        protected void cvTerms_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = chkTerms.Checked;
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim().ToLower();
            string password = txtPassword.Text;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand cmdDup = new SqlCommand(
                    "SELECT COUNT(*) FROM [User] WHERE Email = @Email", conn);
                cmdDup.Parameters.AddWithValue("@Email", email);
                int dup = Convert.ToInt32(cmdDup.ExecuteScalar());

                if (dup > 0)
                {
                    ShowError("The email already been used.");
                    return;
                }

                SqlCommand cmdIns = new SqlCommand(
                    @"INSERT INTO [User] (FullName, Email, PasswordHash, RoleID, AccountStatus, CreatedAt)
                      VALUES (@FullName, @Email, @Password, 2, 'Active', GETDATE())", conn);
                cmdIns.Parameters.AddWithValue("@FullName", fullName);
                cmdIns.Parameters.AddWithValue("@Email", email);
                cmdIns.Parameters.AddWithValue("@Password", password);
                cmdIns.ExecuteNonQuery();
            }

            FormsAuthentication.SetAuthCookie(fullName, false);
            Response.Redirect("~/Pages/Member/Dashboard.aspx");
        }

        private void ShowError(string msg)
        {
            pnlError.Visible = true;
            litError.Text = Server.HtmlEncode(msg);
        }
    }
}
