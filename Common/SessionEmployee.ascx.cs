using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Common
{
    public partial class SessionEmployee : Outpost.Utils.BaseUserControl    //System.Web.UI.UserControl
    {
        protected string _cs;
        protected void Page_Load(object sender, EventArgs e)
        {
            _cs = Q["cs"];
            if (_cs == null || _cs == "0")
                return;
            PopulateList();
        }

        private void PopulateList()
        {
            DB.AddParam("id_client_session", _cs);
            DataSet ds = DB.RunSPReturnDS("ClientSessionEmployee_List");
            if (ds.Tables[0].Rows.Count > 0)
            {
                pnl_EmployeesList.Visible = true;
                rpt_EmployeesList.DataSource = ds;
                rpt_EmployeesList.DataBind();

                pnl_SendInvitations.Visible = true;
                tb_Invitation.Text = System.IO.File.ReadAllText(MapPath("/Emails/group-session.txt"));
            }
            else
            {
                pnl_NoEmployees.Visible = true;
            }
        }
        protected string GetInvitedAtStr(object container)
        {
            string ret = "";
            try
            {
                DataRowView drv = (DataRowView)container;
                DateTime dt = (DateTime)drv["InvitedAt"];

                int tz = (int)drv["TimeZone"];

                dt = dt.AddHours(tz);

                ret = dt.ToString("MM/dd/yyyy hh:mm tt");
                ret += " " + Global.TimeZone(tz);
            }
            catch { }
            return ret;
        }

        protected void btn_Add_Click(object sender, EventArgs e)
        {
            pnl_Select.Visible = true;
            pnl_List.Visible = false;
            //Response.Redirect(Request.Path + "?" + Q.ToString() + "&add=1");
        }

        protected void btn_Cancel_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?" + Request.QueryString.ToString());
        }

        protected void btn_DeleteEmployees_Click(object sender, EventArgs e)
        {
            foreach(string key in Request.Form)
            {
                if (key.StartsWith("emp_"))
                {
                    string id = key.Substring(4);
                    DB.AddParam("id_client_session", _cs);
                    DB.AddParam("id_employee", id);
                    DB.RunSP("ClientSessionEmployee_Delete");
                }
            }
            Response.Redirect(Request.Path + "?" + Request.QueryString.ToString());
        }

        protected void btn_SendInvitation_Click(object sender, EventArgs e)
        {
            foreach (string key in Request.Form)
            {
                if (key.StartsWith("emp_"))
                {
                    string id = key.Substring(4);
                    DB.AddParam("template", "group-session");
                    DB.AddParam("scheduled_at", DateTime.Now);
                    DB.AddParam("params", _cs + "|" + id);
                    DB.AddParam("message", tb_Invitation.Text);
                    DB.RunSP("MailQueue_Add");

                    DB.AddParam("id_client_session", _cs);
                    DB.AddParam("id_employee", id);
                    DB.RunSP("ClientSessionEmployee_Invited");
                }
                //Session["Confirmation"] = "Emails sent to " + ds.Tables[0].Rows.Count + " employees";
            }

            Response.Redirect(Request.Path + "?" + Request.QueryString.ToString());
        }

    }
}