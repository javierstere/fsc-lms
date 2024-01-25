using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Employee
{
    public partial class Training : EmployeeBasePage //System.Web.UI.Page
    {
        protected string _module;
        protected string _embed;
        protected void Page_Load(object sender, EventArgs e)
        {
            _module = Q["module"];
            if(_module == null)
            {
                PopulateList();
            }
            else
            {
                ViewTraining();
            }
        }

        private void PopulateList()
        {
            pnl_List.Visible = true;

            DB.AddParam("id_client", (string)S["Client.Id"]);
            DB.AddParam("id_employee", (string)S["Client.IdEmployee"]);
            DataSet ds = DB.RunSPReturnDS("Employee_GetModules");

            rpt_List.DataSource = ds;
            rpt_List.DataBind();
        }

        private void ViewTraining()
        {
            pnl_Details.Visible = true;
            DB.AddParam("id_module", _module);
            DataSet ds = DB.RunSPReturnDS("Module_Details");
            string path = ds.Tables[0].Rows[0]["Path"].ToString();

            string type = ds.Tables[0].Rows[0]["Type"].ToString().ToLower();
            if (type == "video")
            {
                pnl_Youtube.Visible = true;
                _embed = ds.Tables[0].Rows[0]["Path"].ToString();
            }
            else if (type == ".pptx" || type == ".ppsx")
            {
                pnl_PPT.Visible = true;
                _embed = ds.Tables[0].Rows[0]["Path"].ToString();
                //_embed = _embed.Replace("\\", "/");
                _embed = "/Module/" + HttpUtility.UrlEncode(_embed).Replace("%5c", "/");
            }
            else
            {

                path = path.Replace("\\", "/");

                path = HttpUtility.UrlPathEncode(path);

                Response.Redirect("/Module/" + path);
            }
        }
    }
}