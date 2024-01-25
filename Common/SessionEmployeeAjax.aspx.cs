using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Common
{
    public partial class SessionEmployeeAjax : Outpost.Utils.BaseWebPage    //System.Web.UI.Page
    {
        protected string _params;
        protected string _cs;

        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Clear();

            string method = Q["method"];
            _cs = Q["cs"];
            _params = Q["params"];

            if (method == "list")
                GetEmployeesList();
            if (method == "add")
                AddEmployee();

            Response.End();
        }

        public override bool MustBeAuthenticated()
        {
            return false;
        }

        protected void AddEmployee()
        {
            DB.AddParam("id_client_session", _cs);
            DB.AddParam("id_employee", _params);
            DB.RunSP("ClientSessionEmployee_Add");
        }

        protected void GetEmployeesList()
        {
            DB.AddParam("id_client_session", _cs);
            DB.AddParam("name", _params);
            DataSet ds = DB.RunSPReturnDS("ClientSessionEmployee_Candidates");

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