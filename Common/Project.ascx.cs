using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Common
{
    public partial class Project : Outpost.Utils.BaseUserControl  //System.Web.UI.UserControl
    {
        protected string _project;
        protected string _client;
        protected bool _jobs = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            _project = Q["project"];
            _client = (string)S["Client.Id"];
            if (Q["client"] != null)
                _client = Q["client"];
            if (_project == null)
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
            if (_client == null)
                return;

            pnl_List.Visible = true;

            DB.AddParam("id_client", _client);
            DataSet ds = DB.RunSPReturnDS("Project_List");

            rpt_List.DataSource = ds;
            rpt_List.DataBind();

            btn_ProjectAdd.Enabled = ((int)ds.Tables[1].Rows[0]["MaxProjects"] > ds.Tables[0].Rows.Count);
        }

        protected void btn_ProjectAdd_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?project=0" + GetClientLink()  + GetTabLink());
        }

        private void PopulateDetails()
        {
            pnl_Details.Visible = true;

            DB.AddParam("id_project", _project);
            DataSet ds = DB.RunSPReturnDS("Project_Details");

            DataRow row = null;
            if (ds.Tables[0].Rows.Count == 0)
                row = ds.Tables[0].NewRow();
            else
                row = ds.Tables[0].Rows[0];

            tb_ProjectName.Text = row["ProjectName"].ToString();
            tb_Job.Text = row["Job"].ToString();
            tb_Reminder.Text = row["months"].ToString();
            if (ds.Tables[1].Rows.Count > 0)
            {
                _jobs = true;
                cmb_Job.DataSource = ds.Tables[1];
                cmb_Job.DataTextField = "Job";
                cmb_Job.DataBind();
                cmb_Job.Attributes["onchange"] = "javascript:CopyJob();";
                ListItem item = cmb_Job.Items.FindByText(row["Job"].ToString());
                if (item != null)
                    item.Selected = true;
            }

            if (_project != "0")
            {
                pnl_Modules.Visible = true;
                DB.AddParam("id_project", _project);
                DataSet dsM = DB.RunSPReturnDS("ProjectModule_List");
                rpt_Modules.DataSource = dsM;
                rpt_Modules.DataBind();
            }

            if (Q["module"] != null)
            {
                if (Q["module"] == "0")
                {
                    pnl_AddModule.Visible = true;
                    DB.AddParam("id_client", _client);
                    DataSet dsM = DB.RunSPReturnDS("ModuleClient_List");

                    DataView dv = new DataView(dsM.Tables[0]);


                    cmb_Modules.DataSource = dv;
                    cmb_Modules.DataTextField = "ModuleName";
                    cmb_Modules.DataValueField = "IdModule";
                    cmb_Modules.DataBind();
                    cmb_Modules.Items.Insert(0, new ListItem());
                    btn_AddModule.Visible = false;
                }
                else
                {
                    DB.AddParam("id_project", _project);
                    DB.AddParam("id_module", Q["module"]);
                    DB.RunSP("ProjectModule_Delete");

                    Response.Redirect(Request.Path + "?" + Q.WithoutKey("module"));
                }
            }
        }

        protected void btn_SaveProject_Click(object sender, EventArgs e)
        {
            int months = -1;
            try
            {
                months = int.Parse(tb_Reminder.Text);
            }
            catch { }

            DB.AddParam("id_project", _project);
            DB.AddParam("id_client", _client);
            DB.AddParam("project_name", tb_ProjectName.Text);
            DB.AddParam("job", tb_Job.Text);
            DB.AddParam("months", months > 0 ? (object)months : DBNull.Value);
            DataSet ds = DB.RunSPReturnDS("Project_Save");
            _project = ds.Tables[0].Rows[0]["Id"].ToString();
            Response.Redirect(Request.Path + "?" + Q.ReplaceKey("project", _project));
        }

        protected void btn_CancelProject_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?" + Q.WithoutKey("project"));
        }

        protected void btn_DeleteProject_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_project", _project);
            DB.RunSP("Project_Delete");
            Response.Redirect(Request.Path + "?" + GetClientLink() + GetTabLink());
        }

        protected void btn_AddModule_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?" + Request.QueryString + "&module=0");
        }

        protected void btn_SaveAddModule_Click(object sender, EventArgs e)
        {
            if (cmb_Modules.SelectedValue != "")
            {
                DB.AddParam("id_project", _project);
                DB.AddParam("id_module", cmb_Modules.SelectedValue);
                DB.RunSP("ProjectModule_Add");
            }
            Response.Redirect(Request.Path + "?" + Q.WithoutKey("module"));
        }

        protected void btn_CancelAddModule_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?" + Q.WithoutKey("module"));
        }

        protected string GetClientLink()
        {
            if (Q["client"] != null)
                return "&client=" + Q["client"];
            return "";
        }
        protected string GetTabLink()
        {
            if (Q["tab"] != null)
                return "&tab=" + Q["tab"];
            return "";
        }
    }
}