using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Client
{
    public partial class DirectCheck : ClientBasePage   //System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            module.DireckCheckOnly = true;
            module.ExtraTitle = "direct observation";
        }
    }
}