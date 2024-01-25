using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC
{
    public partial class _404 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // check url in client.link
            // if found, restart app pool
            // and redirect

            //Response.Write(HttpContext.Current.Request.RawUrl);


            // HttpRuntime.UnloadAppDomain();
        }
    }
}