using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Security;
using System.Web.UI;

namespace GrowWealth.Pages.Member
{
    public partial class Profile : Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Safety: master page enforces auth, but double-check here.
            if (!Request.IsAuthenticated)
            {
                Response.Redirect("~/Pages/Public/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProfile();
            }
        }

        /// <summary>
        /// Fetches the current user's row from [User] and fills the form fields.
        /// </summary>
        private void LoadProfile()
        {
            string sql = @"
                SELECT UserID, FullName, Email, AccountStatus, CreatedAt
                FROM [User]
                WHERE FullName = @Name";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@Name", Context.User.Identity.Name);

                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        string fullName = reader["FullName"].ToString();
                        string email = reader["Email"].ToString();
                        string status = reader["AccountStatus"].ToString();
                        DateTime createdAt = Convert.ToDateTime(reader["CreatedAt"]);

                        // Display section (read-only)
                        litFullName.Text = Server.HtmlEncode(fullName);
                        litEmailDisplay.Text = Server.HtmlEncode(email);
                        litMemberSince.Text = createdAt.ToString("MMMM yyyy");
                        litInitials.Text = GetInitials(fullName);
                        litStatus.Text = status;

                        if (string.Equals(status, "Suspended", StringComparison.OrdinalIgnoreCase))
                        {
                            badgeStatus.Attributes["class"] = "status-badge suspended";
                        }

                        // Editable section (form fields)
                        txtFullName.Text = fullName;
                        txtEmail.Text = email;
                    }
                    else
                    {
                        // Couldn't load — sign out cleanly.
                        FormsAuthentication.SignOut();
                        Response.Redirect("~/Pages/Public/Login.aspx");
                    }
                }
            }
        }

        /// <summary>
        /// Returns 1-2 uppercase initials from a full name, e.g. "Ahmad Zaki" → "AZ".
        /// </summary>
        private string GetInitials(string fullName)
        {
            if (string.IsNullOrWhiteSpace(fullName)) return "?";
            string[] parts = fullName.Trim().Split(' ');
            if (parts.Length == 1)
                return parts[0].Substring(0, 1).ToUpper();
            return (parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1)).ToUpper();
        }

        /// <summary>
        /// Saves edits to FullName / Email, and optionally updates the password
        /// if all three password fields are filled in.
        /// </summary>
        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string newFullName = txtFullName.Text.Trim();
            string newEmail = txtEmail.Text.Trim();
            string currentPassword = txtCurrentPassword.Text;
            string newPassword = txtNewPassword.Text;

            // Detect password change intent.
            bool wantsPasswordChange = !string.IsNullOrEmpty(newPassword) ||
                                       !string.IsNullOrEmpty(currentPassword);

            if (wantsPasswordChange)
            {
                if (string.IsNullOrEmpty(currentPassword))
                {
                    ShowError("Please enter your current password to change it.");
                    return;
                }
                if (string.IsNullOrEmpty(newPassword))
                {
                    ShowError("Please enter a new password.");
                    return;
                }
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // 1. Check the email isn't already used by a DIFFERENT user.
                    SqlCommand checkEmail = new SqlCommand(
                        "SELECT COUNT(*) FROM [User] WHERE Email = @Email AND FullName <> @OldName",
                        conn);
                    checkEmail.Parameters.AddWithValue("@Email", newEmail);
                    checkEmail.Parameters.AddWithValue("@OldName", Context.User.Identity.Name);

                    if (Convert.ToInt32(checkEmail.ExecuteScalar()) > 0)
                    {
                        ShowError("That email address is already in use.");
                        return;
                    }

                    // 2. If user wants to change password, verify current password matches.
                    if (wantsPasswordChange)
                    {
                        SqlCommand checkPwd = new SqlCommand(
                            "SELECT COUNT(*) FROM [User] " +
                            "WHERE FullName = @Name AND PasswordHash = @CurPwd", conn);
                        checkPwd.Parameters.AddWithValue("@Name", Context.User.Identity.Name);
                        checkPwd.Parameters.AddWithValue("@CurPwd", currentPassword);

                        if (Convert.ToInt32(checkPwd.ExecuteScalar()) == 0)
                        {
                            ShowError("Current password is incorrect.");
                            return;
                        }
                    }

                    // 3. Run the UPDATE.
                    string updateSql;
                    if (wantsPasswordChange)
                    {
                        updateSql = "UPDATE [User] SET FullName = @NewName, Email = @Email, " +
                                    "PasswordHash = @NewPwd WHERE FullName = @OldName";
                    }
                    else
                    {
                        updateSql = "UPDATE [User] SET FullName = @NewName, Email = @Email " +
                                    "WHERE FullName = @OldName";
                    }

                    SqlCommand update = new SqlCommand(updateSql, conn);
                    update.Parameters.AddWithValue("@NewName", newFullName);
                    update.Parameters.AddWithValue("@Email", newEmail);
                    update.Parameters.AddWithValue("@OldName", Context.User.Identity.Name);
                    if (wantsPasswordChange)
                    {
                        update.Parameters.AddWithValue("@NewPwd", newPassword);
                    }

                    int rowsAffected = update.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        // If the FullName changed, refresh the auth cookie so the
                        // top bar and other lookups still work.
                        if (newFullName != Context.User.Identity.Name)
                        {
                            FormsAuthentication.SetAuthCookie(newFullName, false);
                        }

                        // Clear the password fields so they don't linger on screen.
                        txtCurrentPassword.Text = "";
                        txtNewPassword.Text = "";
                        txtConfirmPassword.Text = "";

                        ShowSuccess("Profile updated successfully.");

                        // Reload the display section using the new values.
                        LoadProfile();
                    }
                    else
                    {
                        ShowError("Update failed. Please try again.");
                    }
                }
            }
            catch (Exception ex)
            {
                // In production you'd log the exception. For coursework we show a generic message.
                ShowError("An error occurred: " + ex.Message);
            }
        }

        /// <summary>
        /// Permanently deletes the user's account.
        /// CASCADE constraints in the DB will remove enrollments, progress, attempts, etc.
        /// </summary>
        protected void btnDelete_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "DELETE FROM [User] WHERE FullName = @Name", conn);
                    cmd.Parameters.AddWithValue("@Name", Context.User.Identity.Name);

                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        FormsAuthentication.SignOut();
                        Session.Abandon();
                        Response.Redirect("~/Default.aspx");
                    }
                    else
                    {
                        ShowError("Could not delete account. Please try again.");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("An error occurred: " + ex.Message);
            }
        }

        private void ShowError(string msg)
        {
            pnlSuccess.Visible = false;
            pnlError.Visible = true;
            litErrorMsg.Text = Server.HtmlEncode(msg);
        }

        private void ShowSuccess(string msg)
        {
            pnlError.Visible = false;
            pnlSuccess.Visible = true;
            litSuccessMsg.Text = Server.HtmlEncode(msg);
        }
    }
}