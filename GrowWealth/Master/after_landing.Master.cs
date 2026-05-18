using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GrowWealth
{
    public partial class after_landing : MasterPage
    {
        protected Panel pnlAdminLinks;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.IsAuthenticated)
            {
                try
                {
                    string connStr = ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        SqlCommand cmd = new SqlCommand("SELECT RoleID FROM [User] WHERE FullName = @Name AND AccountStatus = 'Active'", conn);
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
        }
    }
}