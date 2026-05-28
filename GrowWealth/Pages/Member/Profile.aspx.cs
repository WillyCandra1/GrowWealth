using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
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
            if (!Request.IsAuthenticated)
            {
                Response.Redirect("~/Pages/Public/Login.aspx");
                return;
            }

            if (Master != null)
            {
                System.Web.UI.HtmlControls.HtmlForm form = (System.Web.UI.HtmlControls.HtmlForm)Master.FindControl("form1");
                if (form != null) form.Enctype = "multipart/form-data";
            }

            if (!IsPostBack)
            {
                if (Request.QueryString["saved"] == "1")
                {
                    ShowSuccess("Your profile has been updated.");
                }
                LoadProfile();
            }
        }

        private int GetCurrentUserId()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT UserID FROM [User] WHERE FullName = @Name", conn);
                cmd.Parameters.AddWithValue("@Name", Context.User.Identity.Name);
                conn.Open();
                object result = cmd.ExecuteScalar();
                return (result == null || result == DBNull.Value) ? 0 : Convert.ToInt32(result);
            }
        }

        private void LoadProfile()
        {
            int userId = GetCurrentUserId();
            if (userId == 0)
            {
                FormsAuthentication.SignOut();
                Response.Redirect("~/Pages/Public/Login.aspx");
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    @"SELECT FullName, Email, ProfilePicture, AccountStatus, CreatedAt
                      FROM [User] WHERE UserID = @UserID", conn);
                cmd.Parameters.AddWithValue("@UserID", userId);
                conn.Open();
                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    if (rd.Read())
                    {
                        string fullName = rd["FullName"].ToString();
                        string email = rd["Email"].ToString();
                        string profilePic = rd["ProfilePicture"] == DBNull.Value ? "" : rd["ProfilePicture"].ToString();
                        string status = rd["AccountStatus"].ToString();
                        DateTime created = Convert.ToDateTime(rd["CreatedAt"]);

                        txtFullName.Text = fullName;
                        txtEmail.Text = email;
                        litFullNameDisplay.Text = Server.HtmlEncode(fullName);
                        litEmailDisplay.Text = Server.HtmlEncode(email);
                        litMemberSince.Text = created.ToString("MMM yyyy");
                        litStatus.Text = status;

                        if (status.Equals("Suspended", StringComparison.OrdinalIgnoreCase))
                        {
                            badgeStatus.Attributes["class"] = "status-pill suspended";
                        }

                        if (!string.IsNullOrEmpty(profilePic))
                        {
                            imgProfile.ImageUrl = ResolveUrl(profilePic);
                            imgProfile.Visible = true;
                            litInitials.Text = "";   
                        }
                        else
                        {
                            imgProfile.Visible = false;  
                            litInitials.Text = BuildInitials(fullName);
                        }
                    }
                }
            }

            LoadStats(userId);
        }

        private void LoadStats(int userId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand c1 = new SqlCommand(
                    "SELECT COUNT(*) FROM Enrollment WHERE UserID = @UserID", conn);
                c1.Parameters.AddWithValue("@UserID", userId);
                litStatCourses.Text = c1.ExecuteScalar().ToString();

                SqlCommand c2 = new SqlCommand(
                    "SELECT COUNT(*) FROM UserProgress WHERE UserID = @UserID AND IsCompleted = 1", conn);
                c2.Parameters.AddWithValue("@UserID", userId);
                litStatModules.Text = c2.ExecuteScalar().ToString();

                SqlCommand c3 = new SqlCommand(
                    @"SELECT AVG(CAST(Score AS FLOAT) * 100.0 / NULLIF(TotalQuestions, 0))
                      FROM Quiz_Attempt WHERE UserID = @UserID", conn);
                c3.Parameters.AddWithValue("@UserID", userId);
                object avg = c3.ExecuteScalar();
                litStatScore.Text = (avg == null || avg == DBNull.Value) ? "0" : Convert.ToInt32(avg).ToString();
            }
        }

        private string BuildInitials(string fullName)
        {
            if (string.IsNullOrWhiteSpace(fullName)) return "?";
            string[] parts = fullName.Trim().Split(' ');
            if (parts.Length == 1) return parts[0].Substring(0, 1).ToUpper();
            return (parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1)).ToUpper();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int userId = GetCurrentUserId();
            if (userId == 0) return;

            string newFullName = txtFullName.Text.Trim();
            string newEmail = txtEmail.Text.Trim().ToLower();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand cmdDup = new SqlCommand(
                    "SELECT COUNT(*) FROM [User] WHERE Email = @Email AND UserID <> @UserID", conn);
                cmdDup.Parameters.AddWithValue("@Email", newEmail);
                cmdDup.Parameters.AddWithValue("@UserID", userId);
                int dupCount = Convert.ToInt32(cmdDup.ExecuteScalar());
                if (dupCount > 0)
                {
                    ShowError("That email is already used by another account.");
                    return;
                }

                string profilePicPath = null;
                if (fuProfilePic.HasFile)
                {
                    string ext = Path.GetExtension(fuProfilePic.FileName).ToLower();
                    if (ext != ".jpg" && ext != ".jpeg" && ext != ".png")
                    {
                        ShowError("Profile picture must be a JPG or PNG file.");
                        return;
                    }
                    if (fuProfilePic.PostedFile.ContentLength > 2 * 1024 * 1024)
                    {
                        ShowError("Profile picture must be 2 MB or smaller.");
                        return;
                    }

                    string folder = Server.MapPath("~/Assets/images/profiles/");
                    if (!Directory.Exists(folder))
                    {
                        Directory.CreateDirectory(folder);
                    }

                    string fileName = "user_" + userId + "_" + DateTime.Now.Ticks + ext;
                    string fullPath = Path.Combine(folder, fileName);
                    fuProfilePic.SaveAs(fullPath);
                    profilePicPath = "~/Assets/images/profiles/" + fileName;
                }

                bool wantsPasswordChange =
                    !string.IsNullOrEmpty(txtCurrentPassword.Text) ||
                    !string.IsNullOrEmpty(txtNewPassword.Text) ||
                    !string.IsNullOrEmpty(txtConfirmPassword.Text);

                if (wantsPasswordChange)
                {
                    if (string.IsNullOrEmpty(txtCurrentPassword.Text) ||
                        string.IsNullOrEmpty(txtNewPassword.Text) ||
                        string.IsNullOrEmpty(txtConfirmPassword.Text))
                    {
                        ShowError("Fill in all three password fields to change your password.");
                        return;
                    }

                    SqlCommand cmdPw = new SqlCommand(
                        "SELECT PasswordHash FROM [User] WHERE UserID = @UserID", conn);
                    cmdPw.Parameters.AddWithValue("@UserID", userId);
                    string storedPw = cmdPw.ExecuteScalar().ToString();
                    if (storedPw != txtCurrentPassword.Text)
                    {
                        ShowError("Current password is incorrect.");
                        return;
                    }

                    SqlCommand cmdUpdAll = new SqlCommand(
                        @"UPDATE [User]
                          SET FullName = @FullName, Email = @Email, PasswordHash = @Pw" +
                          (profilePicPath != null ? ", ProfilePicture = @Pic" : "") +
                          " WHERE UserID = @UserID", conn);
                    cmdUpdAll.Parameters.AddWithValue("@FullName", newFullName);
                    cmdUpdAll.Parameters.AddWithValue("@Email", newEmail);
                    cmdUpdAll.Parameters.AddWithValue("@Pw", txtNewPassword.Text);
                    cmdUpdAll.Parameters.AddWithValue("@UserID", userId);
                    if (profilePicPath != null)
                    {
                        cmdUpdAll.Parameters.AddWithValue("@Pic", profilePicPath);
                    }
                    cmdUpdAll.ExecuteNonQuery();
                }
                else
                {
                    SqlCommand cmdUpd = new SqlCommand(
                        @"UPDATE [User]
                          SET FullName = @FullName, Email = @Email" +
                          (profilePicPath != null ? ", ProfilePicture = @Pic" : "") +
                          " WHERE UserID = @UserID", conn);
                    cmdUpd.Parameters.AddWithValue("@FullName", newFullName);
                    cmdUpd.Parameters.AddWithValue("@Email", newEmail);
                    cmdUpd.Parameters.AddWithValue("@UserID", userId);
                    if (profilePicPath != null)
                    {
                        cmdUpd.Parameters.AddWithValue("@Pic", profilePicPath);
                    }
                    cmdUpd.ExecuteNonQuery();
                }
            }

            if (Context.User.Identity.Name != newFullName)
            {
                FormsAuthentication.SetAuthCookie(newFullName, false);
            }

            txtCurrentPassword.Text = "";
            txtNewPassword.Text = "";
            txtConfirmPassword.Text = "";

            Response.Redirect("~/Pages/Member/Profile.aspx?saved=1");
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            int userId = GetCurrentUserId();
            if (userId == 0) return;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction tx = conn.BeginTransaction();
                try
                {
                    string[] cleanup = new string[]
                    {
                        "DELETE FROM Quiz_Attempt WHERE UserID = @UserID",
                        "DELETE FROM UserProgress WHERE UserID = @UserID",
                        "DELETE FROM Enrollment WHERE UserID = @UserID",
                        "DELETE FROM Login_Log WHERE UserID = @UserID",
                        "DELETE FROM InvestmentSimulation WHERE UserID = @UserID",
                        "DELETE FROM [User] WHERE UserID = @UserID"
                    };

                    foreach (string sql in cleanup)
                    {
                        SqlCommand cmd = new SqlCommand(sql, conn, tx);
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.ExecuteNonQuery();
                    }

                    tx.Commit();
                }
                catch
                {
                    tx.Rollback();
                    ShowError("Could not delete your account. Please try again.");
                    return;
                }
            }

            FormsAuthentication.SignOut();
            Session.Abandon();
            Response.Redirect("~/Default.aspx");
        }

        private void ShowSuccess(string msg)
        {
            pnlSuccess.Visible = true;
            pnlError.Visible = false;
            litSuccessMsg.Text = Server.HtmlEncode(msg);
        }

        private void ShowError(string msg)
        {
            pnlError.Visible = true;
            pnlSuccess.Visible = false;
            litErrorMsg.Text = Server.HtmlEncode(msg);
        }
    }
}
