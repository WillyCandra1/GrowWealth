using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

using System.Web.Security;

namespace GrowWealth.Pages.Public
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.IsAuthenticated)
            {
                Response.Redirect("~/Default.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // trim the variable ensuring it clean
                string email = txtEmail.Text.Trim();
                string password = txtPassword.Text.Trim();

                string connStr = ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;
                
                try 
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        // User Validation
                        string sql = "SELECT UserID, FullName FROM [User] WHERE Email = @Email AND PasswordHash = @Password AND AccountStatus = 'Active'";
                        SqlCommand cmd = new SqlCommand(sql, conn);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Password", password);

                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            // Successful login found
                            int userId = (int)reader["UserID"];
                            string fullName = reader["FullName"].ToString();
                            reader.Close(); // Close reader to allow new command on same connection

                            // Log the success login
                            LogLoginAttempt(conn, userId, true);
                            
                            // 3. Authenticate
                            FormsAuthentication.SetAuthCookie(fullName, chkRememberMe.Checked);
                            Response.Redirect("~/Default.aspx");
                        }
                        else
                        {
                            reader.Close();
                            // Log fail login attempt
                            LogLoginAttempt(conn, null, false);

                            // showing error message when already failed
                            pnlError.Visible = true;
                            litErrorMsg.Text = "Invalid email or password.";
                        }
                    }
                }
                catch (Exception ex)
                {
                    pnlError.Visible = true;
                    litErrorMsg.Text = "An error occurred. Please try again later.";
                }
            }
        }

        private void LogLoginAttempt(SqlConnection conn, int? userId, bool isSuccess)
        {
            try
            {
                string sql = "INSERT INTO Login_Log (UserID, IpAddress, DeviceInfo, LoginSuccess) " +
                             "VALUES (@UserID, @Ip, @Device, @Success)";
                
                SqlCommand cmd = new SqlCommand(sql, conn);

                // Insert the userid
                if (userId != null)
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                }
                else
                {
                    cmd.Parameters.AddWithValue("@UserID", DBNull.Value);
                }

                cmd.Parameters.AddWithValue("@Ip", Request.UserHostAddress);
                
                // Get browser/device info safely
                string device = Request.UserAgent;
                if (device == null)
                {
                    device = "Unknown";
                }
                else if (device.Length > 255)
                {
                    device = device.Substring(0, 252) + "...";
                }
                
                cmd.Parameters.AddWithValue("@Device", device);
                cmd.Parameters.AddWithValue("@Success", isSuccess);

                cmd.ExecuteNonQuery();
            }
            catch (Exception)
            {
                // Silently fail logging so user isn't blocked from the app
            }
        }

        protected void chkRememberMe_CheckedChanged(object sender, EventArgs e)
        {

        }

        protected void txtEmail_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
