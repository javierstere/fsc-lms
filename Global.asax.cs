using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;

namespace FSC
{
    public class Global : Outpost.Utils.Global  // HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            RegisterRoutes(RouteTable.Routes);
        }
        /*
        private void GetRoutes()
        {
            Outpost.Utils.DB db = new Outpost.Utils.DB();
            try
            {
                db.AddParam("id_client", null);
                DataSet routes = db.RunSPReturnDS("University_List");
            }
            catch
            {
            }
            finally
            {
                if (db != null)
                    db.Close();
            }

            //Application["routes"] = routes;
        }

        protected override void OnBeginRequest()
        {
            DataSet routes = (DataSet)Application["routes"];
            

            string fullOrigionalpath = Request.Path;

            foreach(DataRow row in routes.Tables[0].Rows)
            {
                if (fullOrigionalpath.Contains("/" + row["Link"].ToString() + "/"))
                {
                    Context.Items["Client.Link"] = row["Link"].ToString();
                    string path = fullOrigionalpath.Replace("/" + row["Link"].ToString() + "/", "/");
                    if (path == "/") path = "/Client/Default.aspx";
                    Context.RewritePath(path, false);
                }
            }
        }

            */
        // http://www.4guysfromrolla.com/articles/012710-1.aspx

        void RegisterRoutes(RouteCollection routes)
        {
            /*
            // Register a route for Categories/All
            routes.MapPageRoute(
               "Panda",      // Route name
               "Panda",      // Route URL
               "~/Client/Default.aspx" // Web page to handle route
            );
            */
            /*
            // Route to handle Categories/{CategoryName}. 
            // The {*CategoryName} instructs the route to match all content after the first slash, which is needed b/c some category names contain a slash, as in the category "Meat/Produce"
            // See http://forums.asp.net/p/1417546/3131024.aspx for more information
            routes.MapPageRoute(
               "View Category",               // Route name
               "Categories/{*CategoryName}",  // Route URL
               "~/CategoryProducts.aspx"      // Web page to handle route
            );

            // Register a route for Products/{ProductName}
            routes.MapPageRoute(
               "View Product",           // Route name
               "Products/{ProductName}", // Route URL
               "~/ViewProduct.aspx"      // Web page to handle route
            ); 
            */


            Outpost.Utils.DB db = new Outpost.Utils.DB();
            try
            {
                db.AddParam("id_client", null);
                DataSet ds = db.RunSPReturnDS("University_List");
                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    string link = row["Link"].ToString();
                    if (link.Trim() != "")
                    {
                        routes.MapPageRoute(
                            link,      // Route name
                            link,      // Route URL
                            "~/Client/Frame.aspx" // Web page to handle route
                        );
                        routes.MapPageRoute(
                            link + "2",      // Route name
                            link + "/{*Path}",      // Route URL
                            "~/Client/Frame.aspx" // Web page to handle route
                        );
                    }
                }
            }
            catch
            {
            }
            finally
            {
                if(db != null)
                    db.Close();
            }
        }

        public static string TimeZone(int offset)
        {
            if (offset == -5)
                return "Eastern";
            if (offset == -6)
                return "Central";
            if (offset == -7)
                return "Mountain";
            if (offset == -8)
                return "Pacific";
            if (offset == -9)
                return "Alaska";
            if (offset == -10)
                return "Hawaii";
            return "";
        }


        public static void Log(Exception ex)
        {
            string msg = ex.Message;
            if (ex.InnerException != null)
                msg += "\r\n" + ex.InnerException.Message;
            Log(msg);
        }

        public static void Log(string message)
        {
            Outpost.Utils.DB db = new Outpost.Utils.DB();

            try
            {
                db.AddParam("message", message);
                db.RunStatement("insert into _log_ (timestamp, message) values (getdate(), @message);");
            }
            catch { }
            finally
            {
                if (db != null)
                    db.Close();
            }

            
        }
        
    }
}


