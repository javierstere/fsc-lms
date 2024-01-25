using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Common
{
    public partial class ModuleAjax : Outpost.Utils.BaseWebPage    //System.Web.UI.Page
    {
        protected string _params;
        protected string _client;

        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Clear();

            string method = Q["method"];
            _client = Q["client"];
            _params = Q["params"];

            if (method == "search")
                GetEmployeesList();
            if (method == "select")
                SelectEmployee();

            Response.End();
        }

        public override bool MustBeAuthenticated()
        {
            return false;
        }

        protected void SelectEmployee()
        {
            DB.AddParam("id_client", _client);
            DB.AddParam("id_administrator", Q["adm"]);
            DB.AddParam("id_module", Q["module"]);
            DB.AddParam("id_employee", _params);
            DB.RunSP("DirectCheck_Select");
        }

        protected void GetEmployeesList()
        {
            DB.AddParam("id_client", _client);
            DB.AddParam("filter", _params);
            DataSet ds = DB.RunSPReturnDS("Employee_Search");


            Common.JsonResponseSessionEmployeeAjax sr = new Common.JsonResponseSessionEmployeeAjax();
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                Common.JsonEmployeeCandidate e = new Common.JsonEmployeeCandidate();

                e.name = row["EmployeeName"].ToString();
                e.id = row["IdEmployee"].ToString();

                sr.employees.Add(e);
            }

            Response.Write(sr);

        }
    }
}