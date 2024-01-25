using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Common
{
    public partial class EmployeeAjax : Outpost.Utils.BaseWebPage    //System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Clear();

            string method = Q["method"];
            //_client = Q["client"];
            //_params = Q["params"];

            if (method == "activate")
                ActivateEmployee();

            Response.End();
        }

        public override bool MustBeAuthenticated()
        {
            return false;
        }

        private void ActivateEmployee()
        {
            DB.AddParam("id_client", Q["client"]);
            DB.AddParam("id_employee", Q["employee"]);
            DB.AddParam("active", Q["active"].ToLower() == "true" ? "1" : "0");

            DataSet ds = DB.RunSPReturnDS("Employee_Activate");
            string idemployee = ds.Tables[0].Rows[0]["IdEmployee"].ToString();

            Response.Write("{ \"idemployee\": \"" + idemployee + "\" }");
        }
    }
}