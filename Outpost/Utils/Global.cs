using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Outpost.Utils
{
    public class Global : HttpApplication
    {
        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            Log log = Log.GetInstance(Context);
            log.GlobalPerformanceStart();
            log.WebLog(Context);

            Outpost.Utils.DB.GetInstance(Context, log);

            LogMessage("[" + Context.Request.UserHostAddress + "]" + Context.Request.Path + "?" + Request.QueryString.ToString(), Context);
          

            OnBeginRequest();
        }

        protected void Application_EndRequest(object sender, EventArgs e)
        {
            OnEndRequest();

            Outpost.Utils.DB db = (Outpost.Utils.DB)Context.Items[Outpost.Utils.DB.CONTEXT];
            if (db != null)
            {
                db.Close();
                Context.Items[Outpost.Utils.DB.CONTEXT] = null;
            }
            Log.GetInstance(Context).GlobalPerformanceEnd();
        }

        protected void Application_Error(object sender, EventArgs e)
        {
            Exception exc = Server.GetLastError();

            LogMessage(Request.Path + "?" + Request.QueryString.ToString(), Context);
            LogMessage(Request.UserAgent, Context);
            LogException(exc, Context);

            OnError();

            Outpost.Utils.DB db = (Outpost.Utils.DB)Context.Items[Outpost.Utils.DB.CONTEXT];
            if (db != null)
            {
                db.Close();
                Context.Items[Outpost.Utils.DB.CONTEXT] = null;
            }
            Log.GetInstance(Context).GlobalPerformanceEnd();
        }

        protected void Session_Start(object sender, EventArgs e)
        {
        }

        protected virtual void OnBeginRequest()
        {

        }

        protected virtual void OnEndRequest()
        {

        }

        protected virtual void OnError()
        {

        }


        public static void LogMessage(string message, HttpContext context)
        {
            List<string> lst = new List<string>();
            lst.Add(message);

            LogMessages(lst, context);
        }

        public static void LogMessages(List<String> lst, HttpContext context)
        {
            string message = "\r\n-----------------------------------------------------\r\n" +
                DateTime.Now.ToString() + "\r\n";

            if (lst == null)
                lst = new List<string>();
            lst.Insert(0, message);

            if (!System.IO.Directory.Exists(System.Web.Hosting.HostingEnvironment.MapPath("/temp/")))
                System.IO.Directory.CreateDirectory(System.Web.Hosting.HostingEnvironment.MapPath("/temp/"));
            string filename = System.IO.Path.Combine(System.Web.Hosting.HostingEnvironment.MapPath("/temp/"), "error-" + DateTime.Today.ToString("yyyy-MM-dd") + ".txt");
            //System.Threading.ReaderWriterLockSlim _lock = new System.Threading.ReaderWriterLockSlim();
            //_lock.EnterWriteLock();
            try
            {
                System.IO.File.AppendAllLines(filename, lst);
            }
            catch { }
            finally
            {
                //_lock.ExitWriteLock();
            }
        }

        public static void LogException(Exception ex, HttpContext context)
        {
            List<String> lst = null;
            //Outpost.Utils.DB db = (Outpost.Utils.DB)context.Items[Outpost.Utils.DB.CONTEXT];
            //if (db != null)
            //    lst = db._dbcalls;
            //else
            //    lst = new List<string>();

            lst = new List<string>();
            lst.Insert(0, ex.Message + "\r\n" + ex.InnerException.ToString() + "\r\n");

            LogMessages(lst, context);
        }
    }
}