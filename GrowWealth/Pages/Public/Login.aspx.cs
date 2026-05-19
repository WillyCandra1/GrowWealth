using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Security;
using System.Web.UI;

namespace GrowWealth.Pages.Public
{
    public partial class Login : Page
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

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = txtEmail.Text.Trim().ToLower();
            string password = txtPassword.Text;

            int userId = 0;
            int roleId = 0;
            string fullName = "";
            string accountStatus = "";
            bool credentialsOk = false;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    @"SELECT UserID, FullName, PasswordHash, RoleID, AccountStatus
                      FROM [User] WHERE Email = @Email", conn);
                cmd.Parameters.AddWithValue("@Email", email);
                conn.Open();

                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    if (rd.Read())
                    {
                        userId = Convert.ToInt32(rd["UserID"]);
                        fullName = rd["FullName"].ToString();
                        string storedPw = rd["PasswordHash"].ToString();
                        roleId = Convert.ToInt32(rd["RoleID"]);
                        accountStatus = rd["AccountStatus"].ToString();
                        credentialsOk = (storedPw == password);
                    }
                }

                if (!credentialsOk)
                {
                    LogLoginAttempt(conn, userId, false, "Invalid credentials");
                    ShowError("That email and password combination doesn't match any account.");
                    return;
                }

                if (!accountStatus.Equals("Active", StringComparison.OrdinalIgnoreCase))
                {
                    LogLoginAttempt(conn, userId, false, "Account suspended");
                    ShowError("This account is currently suspended. Please contact support.");
                    return;
                }

                SqlCommand upd = new SqlCommand(
                    "UPDATE [User] SET LastLogin = GETDATE() WHERE UserID = @UserID", conn);
                upd.Parameters.AddWithValue("@UserID", userId);
                upd.ExecuteNonQuery();

                LogLoginAttempt(conn, userId, true, null);
            }

            FormsAuthentication.SetAuthCookie(fullName, chkRemember.Checked);

            if (roleId == 1)
            {
                Response.Redirect("~/Pages/Admin/AdminDashboard.aspx");
            }
            else
            {
                Response.Redirect("~/Pages/Member/Dashboard.aspx");
            }
        }

        private void LogLoginAttempt(SqlConnection conn, int userId, bool success, string failReason)
        {
            try
            {
                SqlCommand cmd = new SqlCommand(
                    @"INSERT INTO Login_Log (UserID, LoginTime, IPAddress, Success, FailReason)
                      VALUES (@UserID, GETDATE(), @IP, @Success, @Reason)", conn);
                cmd.Parameters.AddWithValue("@UserID", userId > 0 ? (object)userId : DBNull.Value);
                cmd.Parameters.AddWithValue("@IP", Request.UserHostAddress ?? "unknown");
                cmd.Parameters.AddWithValue("@Success", success);
                cmd.Parameters.AddWithValue("@Reason", string.IsNullOrEmpty(failReason) ? (object)DBNull.Value : failReason);
                cmd.ExecuteNonQuery();
            }
            catch { }
        }

        private void ShowError(string msg)
        {
            pnlError.Visible = true;
            litError.Text = Server.HtmlEncode(msg);
        }
    }
}
