using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Common
{
    public partial class Course : Outpost.Utils.BaseUserControl  //System.Web.UI.UserControl
    {
        protected string _course;
        protected string _client;
        protected bool _jobs = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            _course = Q["course"];
            _client = (string)S["Client.Id"];
            if (Q["client"] != null)
                _client = Q["client"];
            if (_course == null)
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
            DataSet ds = DB.RunSPReturnDS("Course_List");

            rpt_List.DataSource = ds;
            rpt_List.DataBind();
        }

        protected void btn_CourseAdd_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?course=0" + GetClientLink() + GetTabLink());
        }

        private void PopulateDetails()
        {
            pnl_Details.Visible = true;

            DB.AddParam("id_course", _course);
            DataSet ds = DB.RunSPReturnDS("Course_Details");

            DataRow row = null;
            if (ds.Tables[0].Rows.Count == 0)
                row = ds.Tables[0].NewRow();
            else
                row = ds.Tables[0].Rows[0];

            tb_CourseName.Text = row["CourseName"].ToString();
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

            if (_course != "0")
            {
                pnl_Modules.Visible = true;
                DB.AddParam("id_course", _course);
                DataSet dsM = DB.RunSPReturnDS("CourseModule_List");
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
                    DB.AddParam("id_course", _course);
                    DB.AddParam("id_module", Q["module"]);
                    DB.RunSP("CourseModule_Delete");

                    Response.Redirect(Request.Path + "?" + Q.WithoutKey("module"));
                }
            }
        }

        protected void btn_SaveCourse_Click(object sender, EventArgs e)
        {
            int months = -1;
            try
            {
                months = int.Parse(tb_Reminder.Text);
            }
            catch { }

            DB.AddParam("id_course", _course);
            DB.AddParam("id_client", _client);
            DB.AddParam("course_name", tb_CourseName.Text);
            DB.AddParam("job", tb_Job.Text);
            DB.AddParam("months", months > 0 ? (object)months : DBNull.Value);
            DataSet ds = DB.RunSPReturnDS("Course_Save");
            _course = ds.Tables[0].Rows[0]["Id"].ToString();
            Response.Redirect(Request.Path + "?" + Q.ReplaceKey("course", _course));
        }

        protected void btn_CancelCourse_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?" + Q.WithoutKey("course"));
        }

        protected void btn_DeleteCourse_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_course", _course);
            DB.RunSP("Course_Delete");
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
                DB.AddParam("id_course", _course);
                DB.AddParam("id_module", cmb_Modules.SelectedValue);
                DB.RunSP("CourseModule_Add");
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