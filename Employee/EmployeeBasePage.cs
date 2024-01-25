using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FSC.Employee
{
    public class EmployeeBasePage : Outpost.Utils.BaseWebPage
    {
        protected string _client;
        protected string _user;

        protected override void OnInit(EventArgs e)
        {
            if (_Development_)
            {
                if (S["Client.Link"] == null)
                    S["Client.Link"] = "ediblecuts";

                if (S["Client.Id"] == null)
                {
                    S["Client.Auth"] = "employee(debug)";
                    S["Client.Id"] = "3";
                    S["Client.IdEmployee"] = "48";
                }

                if (S["Client.IdEmployee"] == null)
                {
                    S["Client.IdEmployee"] = "48";
                }

            }

            _client = (string)S["Client.Id"];

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

            base.OnInit(e);

        }
        public override bool IsAuthenticated()
        {
            return S["Client.Auth"] != null;
        }

        public override string LoginLink()
        {
            return "/Client/Login.aspx";
        }

    }
}