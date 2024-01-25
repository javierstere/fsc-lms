using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Client
{
    public partial class Frame : ClientBasePage// Outpost.Utils.BaseWebPage    //System.Web.UI.Page
    {
        protected string _link;
        protected void Page_Load(object sender, EventArgs e) 
        {
            _link = HttpContext.Current.Request.RawUrl;
            if (_link.StartsWith("/"))
                _link = _link.Substring(1);
            if (_link.EndsWith("/"))
                _link = _link.Substring(0, _link.Length - 1);

            S["Client.Link"] = _link;
            HttpCookie myCookie = new HttpCookie("Client.Link", _link);
            myCookie.Expires = DateTime.Now.AddYears(20);
            Response.Cookies.Add(myCookie);

            Response.Redirect("/Client/Default.aspx");

            //if (Q["link"] != null)
            //    _link = Q["link"];

            //if(S["Client.Description"] != null)
            //    Title = (string)S["Client.Description"];
        }

        protected override void OnInit(EventArgs e)
        {
            if (_Development_)
            {
                if ((Q["link"] == null || Q["link"] == "") && (S["Client.Link"] == null))
                {
                    Response.Redirect(Request.Path + "?link=testroteam"); 
                    return;
                }
            }

            base.OnInit(e);
        }

        public override bool MustBeAuthenticated()
        {
            return false;
        }
    }
}