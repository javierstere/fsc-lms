using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Outpost.Utils
{
    public class BaseWebPage : System.Web.UI.Page
    {
        private SessionWrapper _session;
        private QueryStringWrapper _querystring;
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

           
            if(MustBeAuthenticated() && !IsAuthenticated())
            {
                Response.Redirect(LoginLink());
            }
        }

        protected void RestartApp()
        {
            //System.Web.HttpRuntime.UnloadAppDomain();
            //System.Web.Hosting.HostingEnvironment.InitiateShutdown();

            // touch web.config
            System.IO.File.SetLastWriteTimeUtc(MapPath("/web.config"), DateTime.UtcNow);
        }

        public virtual string LoginLink()
        {
            return "/Login.aspx";
        }

        public virtual bool MustBeAuthenticated()
        {
            return true;
        }

        public virtual bool IsAuthenticated()
        {
            return false;
        }
        
        public SessionWrapper S
        {
            get {
                if (_session == null)
                    _session = new SessionWrapper(Session, Request, Response, DB);
                return _session;
            }
        }
        
        public QueryStringWrapper Q
        {
            get {
                if (_querystring == null)
                    _querystring = new QueryStringWrapper(Request);
                return _querystring;
            }
        }
        protected System.Collections.Specialized.NameValueCollection F
        {
            get { return Request.Form; }
        }

        public Outpost.Utils.DB DB
        {

            get
            {
                return Outpost.Utils.DB.GetInstance(Context);
            }
        }

        public Outpost.Utils.Log Log
        {

            get
            {
                return Outpost.Utils.Log.GetInstance(Context);
            }
        }

        public string BASE_ADDRESS
        {
            get
            {
                string addr = Request.Url.AbsoluteUri;
                int pos = addr.IndexOf("//");
                pos = addr.IndexOf("/", pos + 2);
                //addr = addr.Substring(0, addr.Length - Request.Url.AbsolutePath.Length);
                addr = addr.Substring(0, pos);
                return addr;
            }
        }

        public virtual bool _Development_
        {
            get { return System.Configuration.ConfigurationManager.AppSettings["Development"] == "true";  }
        }

    }
}