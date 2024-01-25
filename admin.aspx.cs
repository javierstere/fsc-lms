using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC
{
    public partial class admin : Outpost.Utils.BaseWebPage  //System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            PopulateList();

            if(Q["buil"] != null)
            {
                S["Builder.Id"] = Q["buil"];
                string type = Q["type"];
                if (type == "B")
                    type = "builder";
                if (type == "C")
                    type = "cobuilder";
                S["Builder.Type"] = type;
                Response.Redirect("/Builder/Default.aspx");
            }
            if(Q["clie"] != null)
            {
                S["Client.Link"] = Q["link"];
                if (Q["empl"] != null)
                {
                    S["Client.Auth"] = "employee";
                    S["Client.Id"] = Q["clie"];
                    S["Client.IdEmployee"] = Q["empl"];
                    S["Client.EmployeeName"] = Q["name"];

                    Response.Redirect("/Employee/Default.aspx");
                }

                if (Q["admi"] != null)
                {
                    S["Client.Auth"] = "administrator";
                    S["Client.Id"] = Q["clie"];
                    S["Client.IdAdministrator"] = Q["admi"];
                    S["Client.AdministratorName"] = Q["name"];
                    Response.Redirect("/Client/Default.aspx");
                }

                if (Q["cli"] != null)
                {
                    S["Client.Auth"] = "client";
                    S["Client.Id"] = Q["clie"];
                    Response.Redirect("/Client/Default.aspx");
                }
            }
        }

        DataSet _ds;

        private void PopulateList()
        {
            _ds = DB.RunSPReturnDS("Admin_List");
            rpt_Builder.DataSource = _ds.Tables[0];
            rpt_Builder.DataBind();

            rpt_Client.ItemDataBound += Rpt_Client_ItemDataBound;
            rpt_Client.DataSource = _ds.Tables[1];
            rpt_Client.DataBind();
        }

        private void Rpt_Client_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            DataView dvu = new DataView(_ds.Tables[2]);
            dvu.RowFilter = "IdClient=" + ((DataRowView)e.Item.DataItem)["IdClient"].ToString();
            Repeater ru = (Repeater)e.Item.FindControl("rpt_University");
            ru.DataSource = dvu;
            ru.DataBind();

            DataView dva = new DataView(_ds.Tables[3]);
            dva.RowFilter = "IdClient=" + ((DataRowView)e.Item.DataItem)["IdClient"].ToString();
            Repeater ra = (Repeater)e.Item.FindControl("rpt_Administrator");
            ra.DataSource = dva;
            ra.DataBind();

            DataView dve = new DataView(_ds.Tables[4]);
            dve.RowFilter = "IdClient=" + ((DataRowView)e.Item.DataItem)["IdClient"].ToString();
            Repeater re = (Repeater)e.Item.FindControl("rpt_Employee");
            re.DataSource = dve;
            re.DataBind();
        }

        public override bool IsAuthenticated()
        {
            if (_Development_ && (string)S["sa"] == null)
                S["sa"] = "!";
                
            return (string)S["sa"] == "!";
        }

    }
}