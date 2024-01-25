using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            /*
            HttpCookie cookieSession = Request.Cookies["Client.Link"];

            if (cookieSession != null)
            {
                if (Session["Client.Link"] == null)
                {
                    Session["Client.Link"] = cookieSession.Value;
                    cookieSession.Expires = DateTime.Now.AddYears(20);
                    Response.Cookies.Set(cookieSession);
                }
                Response.Redirect("/" + cookieSession.Value);
            }
            */

        }
    }
}