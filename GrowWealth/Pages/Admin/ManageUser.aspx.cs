using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GrowWealth.Pages.Admin
{
    public partial class ManageUser : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // redirect if not logged in
            if (!Request.IsAuthenticated)
            {
                FormsAuthentication.RedirectToLoginPage();
                return;
            }

            // only admin can see this page
            if (!CheckIfAdmin())
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStats();
                LoadUsers("", "", "");
            }
        }

        bool CheckIfAdmin()
        {
            bool isAdmin = false;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT RoleID FROM [User] WHERE FullName = @Name AND AccountStatus = 'Active'", conn);
                cmd.Parameters.AddWithValue("@Name", Context.User.Identity.Name);
                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null && Convert.ToInt32(result) == 1)
                {
                    isAdmin = true;
                }
            }
            return isAdmin;
        }

        // helper to get initials for the avatar circle
        protected string GetInitials(string fullName)
        {
            if (string.IsNullOrWhiteSpace(fullName))
                return "?";

            string[] parts = fullName.Trim().Split(' ');
            if (parts.Length == 1)
                return parts[0][0].ToString().ToUpper();

            return (parts[0][0].ToString() + parts[parts.Length - 1][0].ToString()).ToUpper();
        }

        void LoadStats()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT COUNT(*) AS Total, " +
                             "SUM(CASE WHEN RoleID = 1 THEN 1 ELSE 0 END) AS Admins, " +
                             "SUM(CASE WHEN RoleID = 2 THEN 1 ELSE 0 END) AS Members, " +
                             "SUM(CASE WHEN AccountStatus = 'Active' THEN 1 ELSE 0 END) AS Active " +
                             "FROM [User]";

                SqlCommand cmd = new SqlCommand(sql, conn);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    lbl_UserCount.Text = dr["Total"].ToString();
                    lbl_AdminCount.Text = dr["Admins"].ToString();
                    lbl_MemberCount.Text = dr["Members"].ToString();
                    lbl_ActiveCount.Text = dr["Active"].ToString();
                }
            }
        }

        void LoadUsers(string search, string roleId, string status)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT u.UserID, u.FullName, u.Email, u.UserProfession, " +
                             "u.AccountStatus, u.CreatedAt, r.RoleName, u.RoleID " +
                             "FROM [User] u " +
                             "INNER JOIN Role r ON u.RoleID = r.RoleID " +
                             "WHERE (@Search = '' OR u.FullName LIKE '%' + @Search + '%' OR u.Email LIKE '%' + @Search + '%') " +
                             "AND (@RoleID IS NULL OR u.RoleID = @RoleID) " +
                             "AND (@Status = '' OR u.AccountStatus = @Status) " +
                             "ORDER BY u.CreatedAt DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@Search", search);
                cmd.Parameters.Add("@RoleID", SqlDbType.Int).Value =
                    string.IsNullOrEmpty(roleId) ? (object)DBNull.Value : Convert.ToInt32(roleId);
                cmd.Parameters.AddWithValue("@Status", status);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gv_Users.DataSource = dt;
                gv_Users.DataBind();
            }
        }

        protected void btn_Search_Click(object sender, EventArgs e)
        {
            LoadUsers(txt_Search.Text.Trim(), ddl_RoleFilter.SelectedValue, ddl_StatusFilter.SelectedValue);
        }

        protected void gv_Users_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int userId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "DeleteUser")
            {
                // dont let admin delete their own account
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand check = new SqlCommand("SELECT FullName FROM [User] WHERE UserID = @ID", conn);
                    check.Parameters.AddWithValue("@ID", userId);
                    conn.Open();
                    string name = check.ExecuteScalar()?.ToString();

                    if (name == Context.User.Identity.Name)
                    {
                        ShowMessage("You cannot delete your own account!", false);
                        LoadUsers("", "", "");
                        return;
                    }

                    SqlCommand cmd = new SqlCommand("DELETE FROM [User] WHERE UserID = @ID", conn);
                    cmd.Parameters.AddWithValue("@ID", userId);
                    cmd.ExecuteNonQuery();
                }
                ShowMessage("User deleted!", true);
                LoadStats();
                LoadUsers(txt_Search.Text.Trim(), ddl_RoleFilter.SelectedValue, ddl_StatusFilter.SelectedValue);
            }
            else if (e.CommandName == "EditUser")
            {
                // load user data into edit modal
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM [User] WHERE UserID = @ID", conn);
                    cmd.Parameters.AddWithValue("@ID", userId);
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        hf_EditUserID.Value = dr["UserID"].ToString();
                        txt_EditFullName.Text = dr["FullName"].ToString();
                        txt_EditEmail.Text = dr["Email"].ToString();
                        txt_EditProfession.Text = dr["UserProfession"].ToString();
                        ddl_EditRole.SelectedValue = dr["RoleID"].ToString();
                        ddl_EditStatus.SelectedValue = dr["AccountStatus"].ToString();
                    }
                }
                hf_ShowEdit.Value = "1";
                LoadUsers(txt_Search.Text.Trim(), ddl_RoleFilter.SelectedValue, ddl_StatusFilter.SelectedValue);
            }
        }

        protected void btn_AddUser_Click(object sender, EventArgs e)
        {
            // validate required fields
            if (string.IsNullOrWhiteSpace(txt_FullName.Text) ||
                string.IsNullOrWhiteSpace(txt_Email.Text) ||
                string.IsNullOrWhiteSpace(txt_Password.Text))
            {
                ShowMessage("Please fill in all required fields.", false);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // check if email already exists
                SqlCommand checkEmail = new SqlCommand("SELECT COUNT(*) FROM [User] WHERE Email = @Email", conn);
                checkEmail.Parameters.AddWithValue("@Email", txt_Email.Text.Trim());
                conn.Open();

                int count = (int)checkEmail.ExecuteScalar();
                if (count > 0)
                {
                    ShowMessage("This email is already registered.", false);
                    return;
                }

                string sql = "INSERT INTO [User] (RoleID, FullName, Email, PasswordHash, UserProfession, AccountStatus) " +
                             "VALUES (@RoleID, @FullName, @Email, @Password, @Profession, @Status)";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@RoleID", Convert.ToInt32(ddl_Role.SelectedValue));
                cmd.Parameters.AddWithValue("@FullName", txt_FullName.Text.Trim());
                cmd.Parameters.AddWithValue("@Email", txt_Email.Text.Trim());
                cmd.Parameters.AddWithValue("@Password", txt_Password.Text);
                cmd.Parameters.AddWithValue("@Profession", txt_Profession.Text.Trim());
                cmd.Parameters.AddWithValue("@Status", ddl_AccountStatus.SelectedValue);
                cmd.ExecuteNonQuery();
            }

            // clear form
            txt_FullName.Text = "";
            txt_Email.Text = "";
            txt_Password.Text = "";
            txt_Profession.Text = "";

            ShowMessage("User added successfully!", true);
            LoadStats();
            LoadUsers("", "", "");
        }

        protected void btn_UpdateUser_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txt_EditFullName.Text) ||
                string.IsNullOrWhiteSpace(txt_EditEmail.Text))
            {
                ShowMessage("Name and email are required.", false);
                hf_ShowEdit.Value = "1";
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "UPDATE [User] SET FullName = @FullName, Email = @Email, " +
                             "RoleID = @RoleID, UserProfession = @Profession, AccountStatus = @Status " +
                             "WHERE UserID = @ID";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@FullName", txt_EditFullName.Text.Trim());
                cmd.Parameters.AddWithValue("@Email", txt_EditEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@RoleID", Convert.ToInt32(ddl_EditRole.SelectedValue));
                cmd.Parameters.AddWithValue("@Profession", txt_EditProfession.Text.Trim());
                cmd.Parameters.AddWithValue("@Status", ddl_EditStatus.SelectedValue);
                cmd.Parameters.AddWithValue("@ID", Convert.ToInt32(hf_EditUserID.Value));
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            hf_ShowEdit.Value = "0";
            ShowMessage("User updated successfully!", true);
            LoadStats();
            LoadUsers(txt_Search.Text.Trim(), ddl_RoleFilter.SelectedValue, ddl_StatusFilter.SelectedValue);
        }

        void ShowMessage(string msg, bool success)
        {
            lbl_Message.Text = msg;
            lbl_Message.CssClass = success ? "alert-success" : "alert-error";
            lbl_Message.Visible = true;
        }
    }
}
