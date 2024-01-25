using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Client
{
    public partial class Default : ClientBasePage  //System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if((string)S["Client.Auth"] == "employee")
            {
                Response.Redirect("/Employee/Default.aspx");
            }
        }

    }
}