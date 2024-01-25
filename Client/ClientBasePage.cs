using System;
using System.Collections.Generic;
using System.Data;
using System.Web;

namespace FSC.Client
{
    public class ClientBasePage : Outpost.Utils.BaseWebPage
    {
        protected string _client;
        protected string _user;
        
        protected override void OnInit(EventArgs e)
        {
            if (_Development_)
            {
                if ((Q["link"] == null || Q["link"] == "") && (S["Client.Link"] == null))
                {
                    Response.Redirect(Request.Path + "?link=testroteam");
                }
            }


            HttpCookie cookieSession = Request.Cookies["Client.Link"];

            if (cookieSession != null)
            {
                S["Client.Link"] = cookieSession.Value;
                cookieSession.Expires = DateTime.Now.AddYears(20);
                Response.Cookies.Set(cookieSession);
            }
            if (Q["link"] != null)
            {
                S["Client.Link"] = Q["link"];
            }

            LoadClientDescription();

            base.OnInit(e);

            _client = (string)S["Client.Id"];
        }

        public override string LoginLink()
        {
            //return Context.Items["Client.Link"] + "/Client/Login.aspx"; //?link=" + (string)S["Client.Link"];
            return "/Client/Login.aspx"; //?link=" + (string)S["Client.Link"];
        }

        public override bool IsAuthenticated()
        {
            return S["Client.Auth"] != null;
        }

        protected void LoadClientDescription()
        {    
            //if (S["Client.Description"] == null)
            //{
                DB.AddParam("link", S["Client.Link"]);
                DataSet ds = DB.RunSPReturnDS("University_GetDescription");
                if (ds.Tables[0].Rows.Count > 0)
                    S["Client.Description"] = ds.Tables[0].Rows[0]["Description"].ToString();
            //}
        }
    }
}