using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace GrowWealth.Pages.Public
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // Dummy authentication for demonstration
                string email = txtEmail.Text;
                string password = txtPassword.Text;

                if (email == "ahmad@email.com" && password == "password123")
                {
                    // Successful login
                    pnlError.Visible = false;
                    // Usually we would redirect to a dashboard or set auth cookie
                    // For now, let's just go back to Default
                    Response.Redirect("~/Default.aspx");
                }
                else
                {
                    // Failed login
                    pnlError.Visible = true;
                    litErrorMsg.Text = "Invalid email or password.";
                }
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
