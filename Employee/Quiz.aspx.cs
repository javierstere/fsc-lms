using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Employee
{
    public partial class Quiz : EmployeeBasePage //System.Web.UI.Page
    {
        protected string _module;
        protected void Page_Load(object sender, EventArgs e)
        {
            _module = Q["module"];

            if(_module == null)
            {
                PopulateList();
            }
            else
            {
                pnl_Details.Visible = true;
            }
        }

        private void PopulateList()
        {
            pnl_List.Visible = true;

            DB.AddParam("id_client", (string)S["Client.Id"]);
            DB.AddParam("id_employee", (string)S["Client.IdEmployee"]);
            DataSet ds = DB.RunSPReturnDS("Employee_GetQuizzes");

            rpt_List.DataSource = ds;
            rpt_List.DataBind();
        }
    }
}