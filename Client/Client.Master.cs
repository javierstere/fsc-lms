using Outpost.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Client
{
    public partial class Client : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected SessionWrapper S
        {
            get
            {
                if (Page is BaseWebPage)
                {
                    return ((BaseWebPage)Page).S;
                }
                return null;
            }
        }

        protected bool IsAuthenticated()
        {
            if (Page is BaseWebPage)
            {
                return ((BaseWebPage)Page).IsAuthenticated();
            }
            return false;
        }
    }
}