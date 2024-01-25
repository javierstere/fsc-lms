using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Builder
{
    public partial class BuilderMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        public bool _Development_
        {
            get { return System.Configuration.ConfigurationManager.AppSettings["Development"] == "true"; }
        }

    }
}