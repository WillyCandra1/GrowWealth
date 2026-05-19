using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GrowWealth.Pages.Admin
{
    public partial class ManageUser : Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUsers();
            }
        }

        private void LoadUsers()
        {
            StringBuilder sql = new StringBuilder(@"
                SELECT u.UserID, u.FullName, u.Email, u.AccountStatus, u.CreatedAt,
                       u.RoleID, r.RoleName
                FROM [User] u
                INNER JOIN Role r ON u.RoleID = r.RoleID
                WHERE 1 = 1");

            string search = (txtSearch.Text ?? "").Trim();
            string roleFilter = ddlFilterRole.SelectedValue;
            string statusFilter = ddlFilterStatus.SelectedValue;

            if (!string.IsNullOrEmpty(search))
            {
                sql.Append(" AND (u.FullName LIKE @Search OR u.Email LIKE @Search)");
            }
            if (!string.IsNullOrEmpty(roleFilter))
            {
                sql.Append(" AND u.RoleID = @RoleID");
            }
            if (!string.IsNullOrEmpty(statusFilter))
            {
                sql.Append(" AND u.AccountStatus = @Status");
            }

            sql.Append(" ORDER BY u.CreatedAt DESC");

            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(sql.ToString(), conn);
                if (!string.IsNullOrEmpty(search))
                    cmd.Parameters.AddWithValue("@Search", "%" + search + "%");
                if (!string.IsNullOrEmpty(roleFilter))
                    cmd.Parameters.AddWithValue("@RoleID", roleFilter);
                if (!string.IsNullOrEmpty(statusFilter))
                    cmd.Parameters.AddWithValue("@Status", statusFilter);

                new SqlDataAdapter(cmd).Fill(dt);
            }

            dt.Columns.Add("RoleClass", typeof(string));
            dt.Columns.Add("StatusClass", typeof(string));
            dt.Columns.Add("CreatedAtFmt", typeof(string));
            foreach (DataRow row in dt.Rows)
            {
                row["RoleClass"] = (row["RoleName"].ToString() == "Admin") ? "admin" : "member";
                row["StatusClass"] = (row["AccountStatus"].ToString() == "Active") ? "active" : "suspended";
                row["CreatedAtFmt"] = Convert.ToDateTime(row["CreatedAt"]).ToString("dd MMM yyyy");
            }

            rptUsers.DataSource = dt;
            rptUsers.DataBind();

            pnlEmpty.Visible = (dt.Rows.Count == 0);
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadUsers();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlFilterRole.SelectedValue = "";
            ddlFilterStatus.SelectedValue = "";
            LoadUsers();
        }

        protected void rptUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int userId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditUser")
            {
                LoadUserIntoForm(userId);
            }
            else if (e.CommandName == "DeleteUser")
            {
                DeleteUser(userId);
            }
        }

        private void LoadUserIntoForm(int userId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(
                    @"SELECT FullName, Email, RoleID, AccountStatus, CreatedAt, LastLogin
                      FROM [User] WHERE UserID = @UserID", conn);
                cmd.Parameters.AddWithValue("@UserID", userId);
                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    if (!rd.Read())
                    {
                        ShowError("User not found.");
                        return;
                    }
                    txtFullName.Text = rd["FullName"].ToString();
                    txtEmail.Text = rd["Email"].ToString();
                    ddlRole.SelectedValue = rd["RoleID"].ToString();
                    ddlStatus.SelectedValue = rd["AccountStatus"].ToString();
                    litEditHeader.Text = "Editing " + Server.HtmlEncode(rd["FullName"].ToString());
                    litDetailJoined.Text = Convert.ToDateTime(rd["CreatedAt"]).ToString("dd MMM yyyy");
                    litDetailLastLogin.Text = (rd["LastLogin"] == DBNull.Value)
                        ? "Never"
                        : Convert.ToDateTime(rd["LastLogin"]).ToString("dd MMM yyyy");
                }

                SqlCommand c1 = new SqlCommand(
                    "SELECT COUNT(*) FROM Enrollment WHERE UserID = @UserID", conn);
                c1.Parameters.AddWithValue("@UserID", userId);
                litDetailEnrols.Text = c1.ExecuteScalar().ToString();

                SqlCommand c2 = new SqlCommand(
                    "SELECT COUNT(*) FROM UserProgress WHERE UserID = @UserID AND IsCompleted = 1", conn);
                c2.Parameters.AddWithValue("@UserID", userId);
                litDetailModules.Text = c2.ExecuteScalar().ToString();

                SqlCommand c3 = new SqlCommand(
                    "SELECT COUNT(*) FROM Quiz_Attempt WHERE UserID = @UserID", conn);
                c3.Parameters.AddWithValue("@UserID", userId);
                litDetailAttempts.Text = c3.ExecuteScalar().ToString();

                SqlCommand c4 = new SqlCommand(
                    @"SELECT AVG(CAST(Score AS FLOAT) * 100.0 / NULLIF(TotalQuestions, 0))
                      FROM Quiz_Attempt WHERE UserID = @UserID", conn);
                c4.Parameters.AddWithValue("@UserID", userId);
                object avg = c4.ExecuteScalar();
                litDetailAvg.Text = (avg == null || avg == DBNull.Value) ? "0" : Convert.ToInt32(avg).ToString();
            }

            ViewState["EditingUserID"] = userId;
            pnlEditForm.Visible = true;
            pnlSuccess.Visible = false;
            pnlError.Visible = false;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            if (ViewState["EditingUserID"] == null) return;

            int userId = Convert.ToInt32(ViewState["EditingUserID"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand cmdDup = new SqlCommand(
                    "SELECT COUNT(*) FROM [User] WHERE Email = @Email AND UserID <> @UserID", conn);
                cmdDup.Parameters.AddWithValue("@Email", txtEmail.Text.Trim().ToLower());
                cmdDup.Parameters.AddWithValue("@UserID", userId);
                int dup = Convert.ToInt32(cmdDup.ExecuteScalar());
                if (dup > 0)
                {
                    ShowError("Another user already uses that email.");
                    return;
                }

                SqlCommand upd = new SqlCommand(
                    @"UPDATE [User]
                      SET FullName = @FullName, Email = @Email,
                          RoleID = @RoleID, AccountStatus = @Status
                      WHERE UserID = @UserID", conn);
                upd.Parameters.AddWithValue("@FullName", txtFullName.Text.Trim());
                upd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim().ToLower());
                upd.Parameters.AddWithValue("@RoleID", ddlRole.SelectedValue);
                upd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
                upd.Parameters.AddWithValue("@UserID", userId);
                upd.ExecuteNonQuery();
            }

            pnlEditForm.Visible = false;
            ViewState["EditingUserID"] = null;
            ShowSuccess("User updated successfully.");
            LoadUsers();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            pnlEditForm.Visible = false;
            ViewState["EditingUserID"] = null;
        }

        private void DeleteUser(int userId)
        {
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
                    ShowError("Could not delete user.");
                    return;
                }
            }

            ShowSuccess("User deleted successfully.");
            LoadUsers();
        }

        private void ShowSuccess(string msg)
        {
            pnlSuccess.Visible = true;
            pnlError.Visible = false;
            litSuccess.Text = Server.HtmlEncode(msg);
        }

        private void ShowError(string msg)
        {
            pnlError.Visible = true;
            pnlSuccess.Visible = false;
            litError.Text = Server.HtmlEncode(msg);
        }
    }
}
