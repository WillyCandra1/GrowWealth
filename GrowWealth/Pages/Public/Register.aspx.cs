using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GrowWealth.Pages.Public
{
    public partial class Register : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void cvTerms_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = chkTerms.Checked;
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // Dummy logic for demonstration
                string email = txtEmail.Text;
                
                if (email == "ahmad@email.com") // Simulate existing user
                {
                    pnlError.Visible = true;
                    litErrorMsg.Text = "Email address is already registered.";
                }
                else
                {
                    // Success, would typically create user here and redirect
                    pnlError.Visible = false;
                    Response.Redirect("~/Pages/Public/Login.aspx");
                }
            }
        }
    }
}
