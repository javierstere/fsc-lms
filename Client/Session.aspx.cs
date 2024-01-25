using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Client
{
    public partial class Session : ClientBasePage   //System.Web.UI.Page
    {
        protected string _cs;
        protected void Page_Load(object sender, EventArgs e)
        {
            _cs = Q["cs"];
            
            if(_cs == null)
            {
                PopulateList();
            }
            else
            {
                if (!IsPostBack)
                {
                    if (_cs == "0")
                    {
                        pnl_Add.Visible = true;

                        DataSet ds = DB.RunSPReturnDS("TrainingSession_List");
                        cmb_TrainingSession.DataSource = ds;
                        cmb_TrainingSession.DataTextField = "SessionName";
                        cmb_TrainingSession.DataValueField = "IdTrainingSession";
                        cmb_TrainingSession.DataBind();
                    }
                    else
                    {
                        PopulateDetails();
                    }
                }
            }
        }

        private void PopulateList()
        {
            pnl_List.Visible = true;
            DB.AddParam("id_client", _client);
            DataSet ds = DB.RunSPReturnDS("ClientSession_List");

            rpt_List.DataSource = ds;
            rpt_List.DataBind();
        }

        private void PopulateDetails()
        {
            pnl_Details.Visible = true;
            DB.AddParam("id_client_session", _cs);
            DataSet ds = DB.RunSPReturnDS("ClientSession_Details");


            string status = ds.Tables[0].Rows[0]["Status"].ToString();
            lb_Template.Text = ds.Tables[0].Rows[0]["TemplateName"].ToString();
            lb_SessionName.Text = ds.Tables[0].Rows[0]["SessionName"].ToString();
            ListItem item;

            tb_Location.Text = ds.Tables[0].Rows[0]["Location"].ToString();
            try
            {
                DateTime dt = (DateTime)ds.Tables[0].Rows[0]["SessionDate"];
                dt = dt.AddHours((int)ds.Tables[0].Rows[0]["TimeZone"]);
                tb_SessionDate.Text = dt.ToString("MM/dd/yyyy");
                string hour = dt.ToString("hh:mm tt");
                tb_SessionTime.Text = hour.Substring(0, 5);
                item = cmb_AMPM.Items.FindByText(hour.Substring(6));
                if (item != null)
                    item.Selected = true;
            }
            catch { }

            item = cmb_TimeZone.Items.FindByValue(ds.Tables[0].Rows[0]["TimeZone"].ToString());
            if (item != null)
                item.Selected = true;

            cmb_ReminderOffset.Items.Clear();
            cmb_ReminderOffset.Items.Add(new ListItem("(none)", "0"));
            for(int i = 1; i <= 24; i++)
            {
                string txt = i + " hours";
                if (i == 1)
                    txt = "1 hour";
                cmb_ReminderOffset.Items.Add(new ListItem(txt, i.ToString()));
            }
            item = cmb_ReminderOffset.Items.FindByValue(ds.Tables[0].Rows[0]["ReminderOffset"].ToString());
            if (item != null)
                item.Selected = true;

            /*
            DB.AddParam("id_client", _client);
            DataSet jobs = DB.RunSPReturnDS("Client_JobsList");

            cmb_Job.DataSource = jobs.Tables[0];
            cmb_Job.DataTextField = "Job";
            cmb_Job.DataBind();

            cmb_Job.Items.Insert(0, new ListItem());

            ListItem item = cmb_Job.Items.FindByText(ds.Tables[0].Rows[0]["Job"].ToString());
            if (item != null)
                item.Selected = true;
            */
        }

        protected void btn_AddNew_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?cs=0");
        }

        protected void btn_Cancel_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path);
        }

        protected void btn_Add_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_client", _client);
            DB.AddParam("id_training_session", cmb_TrainingSession.SelectedValue);
            DB.AddParam("session_name", tb_SessionName.Text);
            DataSet ds = DB.RunSPReturnDS("ClientSession_Add");

            _cs = ds.Tables[0].Rows[0]["Id"].ToString();
            Response.Redirect(Request.Path + "?cs=" + _cs);
        }

        protected void btn_StartSession_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_client_session", _cs);
            DB.RunSPReturnDS("ClientSession_Start");

            Response.Redirect("SessionRun.aspx?cs=" + _cs);
        }

        protected void btn_DeleteSession_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_client_session", _cs);
            DB.RunSPReturnDS("ClientSession_Delete");

            Response.Redirect(Request.Path);
        }

        protected string GetSessionDateStr(object container)
        {
            string ret = "";
            try
            {
                DataRowView drv = (DataRowView)container;
                DateTime dt = (DateTime)drv["SessionDate"];

                int tz = (int)drv["TimeZone"];

                dt = dt.AddHours(tz);

                ret = dt.ToString("MM/dd/yyyy hh:mm tt");
                ret += " " + Global.TimeZone(tz);
            }
            catch { }
            return ret;
        }
        protected void btn_Save_Click(object sender, EventArgs e)
        {
            string time = "12:00";
            DateTime dt1 = DateTime.Today;
            DateTime dt2 = DateTime.Parse("12:00 PM");
            try
            {
                dt1 = DateTime.ParseExact(tb_SessionDate.Text, "MM/dd/yyyy", null );
            }
            catch { }
            try
            {
                dt2 = DateTime.Parse(tb_SessionTime.Text + " " + cmb_AMPM.SelectedValue);
                //time = dt2.ToString("HH:mm");
            }
            catch { }
            dt1 = dt1.AddHours(dt2.Hour);
            dt1 = dt1.AddMinutes(dt2.Minute);
            dt1 = dt1.AddHours(-int.Parse(cmb_TimeZone.SelectedValue));

            DB.AddParam("id_client_session", _cs);
            DB.AddParam("location", tb_Location.Text);
            DB.AddParam("session_date", dt1);
            DB.AddParam("time_zone", cmb_TimeZone.SelectedValue);
            if(cmb_ReminderOffset.SelectedValue == "0")
                DB.AddParam("reminder_offset", DBNull.Value);
            else
                DB.AddParam("reminder_offset", cmb_ReminderOffset.SelectedValue);
            DB.RunSPReturnDS("ClientSession_Save");
            
            Response.Redirect(Request.Path + "?cs=" + _cs);
        }

    }
}