using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Client
{
    public partial class Module : ClientBasePage// System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Q["content"] == null && S["Module.Content"] == null)
                S["Module.Content"] = "system";

            if (Q["content"] != null)
                S["Module.Content"] = Q["content"];

            module.ContentType = (string)S["Module.Content"];
            module.ExtraTitle = (string)S["Module.Content"];
        }
    }
}