using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Common
{
    public partial class Employee : Outpost.Utils.BaseUserControl //System.Web.UI.UserControl
    {
        protected string _client;
        protected string _employee;
        protected string _extra;
        protected bool _jobs = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            _employee = Q["employee"];
            _client = (string)S["Client.Id"];
            if (Q["client"] != null)
                _client = Q["client"];
            _extra = Q["tab"];
            if (_extra != null)
                _extra = "&tab=" + _extra;

            if (_employee == null)
            {
                PopulateList();
            }
            else
            {
                if (!IsPostBack)
                    PopulateDetails();
            }
        }

        private void PopulateList()
        {
            pnl_List.Visible = true;
            DB.AddParam("id_client", _client);
            DataSet ds = DB.RunSPReturnDS("Employee_List");

            rpt_List.DataSource = ds;
            rpt_List.DataBind();

            btn_EmployeeAdd.Enabled = ((int)ds.Tables[1].Rows[0]["MaxEmployees"] > ds.Tables[0].Rows.Count);
        }

        protected void btn_EmployeeAdd_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?client=" + _client + "&employee=0" + _extra);
        }

        private void PopulateDetails()
        {
            pnl_Details.Visible = true;
            DB.AddParam("id_client", _client);
            DB.AddParam("id_employee", _employee);
            DataSet ds = DB.RunSPReturnDS("Employee_Details");
            DataRow row = null;
            if(ds.Tables[0].Rows.Count == 0)
            {
                row = ds.Tables[0].NewRow();
                //if (ds.Tables[1].Rows.Count > 0)
                //{
                //    row["Job"] = ds.Tables[1].Rows[0]["Job"].ToString();
                //}
            }
            else
            {
                row = ds.Tables[0].Rows[0];
            }

            tb_EmployeeName.Text = row["EmployeeName"].ToString();
            tb_EmployeeUser.Text = row["EmployeeUser"].ToString();
            tb_Email.Text = row["Email"].ToString();

            tb_Job.Text = row["Job"].ToString();
            
            if(ds.Tables[1].Rows.Count > 0)
            {
                _jobs = true;
                cmb_Job.DataSource = ds.Tables[1];
                cmb_Job.DataTextField = "Job";
                cmb_Job.DataBind();
                cmb_Job.Attributes["onchange"] = "javascript:CopyJob();";
                cmb_Job.Attributes["onblur"] = "javascript:CopyJobIfEmpty();";
                cmb_Job.Attributes["onfocus"] = "javascript:CopyJobIfEmpty();";
                ListItem item = cmb_Job.Items.FindByText(row["Job"].ToString());
                if (item != null)
                    item.Selected = true;

            }
            
            if ((string)S["Saved"] == "1")
            {
                S["Saved"] = null;
                pnl_SavedMessage.Visible = true;
            }
            if ((string)S["Password"] == "1")
            {
                S["Password"] = null;
                pnl_PasswordSent.Visible = true;
            }
        }

        protected void btn_Save_Click(object sender, EventArgs e)
        {
            string pass = null;
            if (tb_Password1.Text.Trim() != "")
            {
                if (tb_Password2.Text == tb_Password1.Text)
                {
                    pass = tb_Password1.Text.Trim();
                }
                else
                {
                    pnl_PassMistmatch.Visible = true;
                    return;
                }
            }
            if (tb_EmployeeUser.Text.Trim() == "")
                tb_EmployeeUser.Text = tb_EmployeeName.Text;
            DB.AddParam("id_employee", _employee);
            DB.AddParam("id_client", _client);
            DB.AddParam("employee_name", tb_EmployeeName.Text);
            DB.AddParam("employee_user", tb_EmployeeUser.Text);
            DB.AddParam("job", tb_Job.Text);
            DB.AddParam("email", tb_Email.Text);
            DB.AddParam("password", pass);
            DataSet ds = DB.RunSPReturnDS("Employee_Save");

            _employee= ds.Tables[0].Rows[0]["Id"].ToString();
            //S["Saved"] = "1";
            //Response.Redirect(Request.Path + "?client=" + _client + "&employee=" + _employee + _extra);
            Response.Redirect(Request.Path + "?client=" + _client + _extra);
        }

        protected void btn_Cancel_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?client=" + _client + _extra);
        }

        protected void btn_Delete_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_employee", _employee);
            DB.AddParam("id_client", _client);
            DB.RunSP("Employee_Delete");

            Response.Redirect(Request.Path + "?client=" + _client + _extra);
        }
        protected void btn_SendPass_Click(object sender, EventArgs e)
        {
            DB.AddParam("template", "password");
            DB.AddParam("scheduled_at", DateTime.Now);
            DB.AddParam("params", _employee);
            DB.AddParam("message", null);
            DB.RunSP("MailQueue_Add");
            S["Password"] = "1";

            Response.Redirect(Request.Path + "?client=" + _client + "&employee=" + _employee + _extra);
            //Response.Redirect(Request.Path + "?client=" + _client + _extra);
        }
    }
}