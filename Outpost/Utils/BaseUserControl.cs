using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Outpost.Utils
{
    public class BaseUserControl : System.Web.UI.UserControl
    {
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

        protected Outpost.Utils.DB DB
        {
            get
            {
                if (Page is BaseWebPage)
                {
                    return ((BaseWebPage)Page).DB;
                }
                return null;
            }
        }

        protected QueryStringWrapper Q
        {
            get
            {
                if (Page is BaseWebPage)
                {
                    return ((BaseWebPage)Page).Q;
                }
                return null;
            }
        }
        protected System.Collections.Specialized.NameValueCollection F
        {
            get { return Request.Form; }
        }
    }
}