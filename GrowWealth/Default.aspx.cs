using System;
using System.Web.UI;

namespace GrowWealth
{
    public partial class Default : Page
    {
        protected void Page_PreInit(object sender, EventArgs e)
        {
            if (Request.IsAuthenticated)
            {
                this.MasterPageFile = "~/Master/after_landing.Master";
            }
            else
            {
                this.MasterPageFile = "~/Master/before_landing.Master";
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.IsAuthenticated)
            {
                phAnonymous.Visible = false;
                phDashboard.Visible = true;
                litUserName.Text = Context.User.Identity.Name;
            }
            else
            {
                phAnonymous.Visible = true;
                phDashboard.Visible = false;
            }
        }
    }
}
