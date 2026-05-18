using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace GrowWealth.Pages.Admin
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboardNumbers();
                LoadRecentUsers();
                LoadRecentSimulations();
            }
        }

        private void LoadDashboardNumbers()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    lblUsers.Text = GetCount(conn, "SELECT COUNT(*) FROM [User]").ToString();
                    lblRoles.Text = GetCount(conn, "SELECT COUNT(*) FROM [Role]").ToString();
                    lblSimulations.Text = GetCount(conn, "SELECT COUNT(*) FROM InvestmentSimulation").ToString();

                    lblAdmins.Text = GetCount(conn,
                        "SELECT COUNT(*) " +
                        "FROM [User] U " +
                        "INNER JOIN [Role] R ON U.RoleID = R.RoleID " +
                        "WHERE R.RoleName = 'Admin'").ToString();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Dashboard data cannot be loaded. " + ex.Message;
            }
        }

        private int GetCount(SqlConnection conn, string sql)
        {
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                object result = cmd.ExecuteScalar();

                if (result == null || result == DBNull.Value)
                {
                    return 0;
                }

                return Convert.ToInt32(result);
            }
        }

        private void LoadRecentUsers()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql =
                        "SELECT TOP 5 " +
                        "U.UserID AS [User ID], " +
                        "U.FullName AS [Full Name], " +
                        "U.Email AS [Email], " +
                        "R.RoleName AS [Role] " +
                        "FROM [User] U " +
                        "LEFT JOIN [Role] R ON U.RoleID = R.RoleID " +
                        "ORDER BY U.UserID DESC";

                    SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvUsers.DataSource = dt;
                    gvUsers.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Recent users cannot be loaded. " + ex.Message;
            }
        }

        private void LoadRecentSimulations()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql =
                        "SELECT TOP 5 * " +
                        "FROM InvestmentSimulation " +
                        "ORDER BY 1 DESC";

                    SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvSimulations.DataSource = dt;
                    gvSimulations.DataBind();
                }
            }
            catch
            {
                gvSimulations.DataSource = null;
                gvSimulations.DataBind();
            }
        }
    }
}