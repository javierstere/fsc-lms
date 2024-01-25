using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace FSC.Client
{
    public partial class SessionRun : ClientBasePage    //System.Web.UI.Page
    {
        protected string _cs;
        protected string _resource_url;
        protected string _embed_youtube;

        protected bool _enable_question = false;
        protected bool _enable_next = false;
        protected string _presentation_duration = "0";
        protected string _time_to_answer = "0";

        protected void Page_Load(object sender, EventArgs e)
        {
            _cs = Q["cs"];
            if (_Development_)
            {
                if (_cs == null)
                    _cs = "1";
            }

            if(Q["ajax"] != null)
            {
                ProcessAjax();
                return;
            }

            if(!IsPostBack)
                PopulateDetails();
        }

        private void ProcessAjax()
        {
            Response.Clear();

            DB.AddParam("id_client_session", _cs);
            DataSet ds = DB.RunSPReturnDS("ClientSession_ConnectedEmployees");

            Common.JsonResponseSessionRun sr = new Common.JsonResponseSessionRun();
            foreach(DataRow row in ds.Tables[0].Rows)
            {
                Common.JsonEmployee e = new Common.JsonEmployee();

                e.name = row["EmployeeName"].ToString();
                e.answered = row["Answered"].ToString() == "1";
                e.connected= row["Connected"].ToString() == "1";

                sr.employees.Add(e);
            }

            Response.Write(sr);

            Response.End();
        }

        private void PopulateDetails()
        {
            btn_Prev.Enabled = false;
            btn_Next.Enabled = false;

            DB.AddParam("id_client_session", _cs);
            DB.AddParam("id_client", _client);
            DataSet ds = DB.RunSPReturnDS("ClientSession_GetStatus");

            string current_step = ds.Tables[0].Rows[0]["CurrentStep"].ToString();
            string status = ds.Tables[0].Rows[0]["Status"].ToString();

            if (status == "3")
            {
                pnl_Done.Visible = true;
                return;
            }

            DataRow step = GetCurrentStep(ds);
            if (step == null)
            {
                pnl_PleaseConnect.Visible = true;

                lt_URL.Text = BASE_ADDRESS + "/" + (string)S["Client.Link"];
                btn_Next.Enabled = true;
                return;
            }

            if (status == "0")
            {
                pnl_PleaseConnect.Visible = true;
                return;
            }
            if (status == "1")
            {
                btn_Prev.Enabled = true;
                _enable_question = true;
                _presentation_duration = step["PresentationDuration"].ToString();
                lb_StepName.Text = step["StepName"].ToString() 
                    + "(" + step["PresentationDuration"].ToString() + "-" + step["TimeToAnswer"].ToString() + ")"; 
                pnl_Z.Visible = false;
                pnl_Y.Visible = false;
                pnl_NoResource.Visible = false;
                if (step["Resource"].ToString() != "")
                {
                    if (step["ResourceType"].ToString() == "Z")
                    {
                        pnl_Z.Visible = true;
                        _resource_url = "/Module/TS/" + step["IdTrainingSession"].ToString() + "/" + step["IdStep"].ToString() + "/" + step["Resource"].ToString();
                    }
                    if (step["ResourceType"].ToString() == "Y")
                    {
                        pnl_Y.Visible = true;
                        _embed_youtube = step["Resource"].ToString();
                    }
                }
                else
                {
                    pnl_NoResource.Visible = true;
                }
            }
            if (status == "2")
            {
                btn_Prev.Enabled = true;
                //btn_Next.Enabled = true;
                _enable_next = true;

                // display question
                pnl_Question.Visible = true;

                lt_Question.Text = step["Question"].ToString();
                _time_to_answer = step["TimeToAnswer"].ToString();
            }
        }

        private DataRow GetCurrentStep(DataSet ds)
        {
            string current_step = ds.Tables[0].Rows[0]["CurrentStep"].ToString();
            foreach (DataRow row in ds.Tables[1].Rows)
            {
                if (row["IdStep"].ToString() == current_step)
                    return row;
            }
            return null;
        }

        private DataRow GetPreviousStep(DataSet ds)
        {
            string current_step = ds.Tables[0].Rows[0]["CurrentStep"].ToString();
            DataRow prev = null;
            foreach (DataRow row in ds.Tables[1].Rows)
            {
                if (row["IdStep"].ToString() == current_step)
                    return prev;
                prev = row;
            }
            return null;
        }

        private DataRow GetNextStep(DataSet ds)
        {
            string current_step = ds.Tables[0].Rows[0]["CurrentStep"].ToString();
            bool next = false;
            foreach (DataRow row in ds.Tables[1].Rows)
            {
                if (next)
                    return row;
                if (row["IdStep"].ToString() == current_step)
                    next = true;
            }
            return null;
        }
        private DataRow GetFirstStep(DataSet ds)
        {
            if(ds.Tables[1].Rows.Count > 0)
                return ds.Tables[1].Rows[0];
            return null;
        }
        protected void btn_Close_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_client_session", _cs);
            DB.RunSPReturnDS("ClientSession_Stop");

            Response.Redirect("Session.aspx?" + Request.QueryString);
        }
        protected void btn_Prev_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_client_session", _cs);
            DB.AddParam("id_client", _client);
            DataSet ds = DB.RunSPReturnDS("ClientSession_GetStatus");

            string current_step = ds.Tables[0].Rows[0]["CurrentStep"].ToString();

            DataRow step = GetPreviousStep(ds);
            if (step != null) {

                DB.AddParam("id_client_session", _cs);
                DB.AddParam("step", step["IdStep"].ToString());
                DB.RunSP("ClientSession_SetStep");
            }
            else
            {
                DB.AddParam("id_client_session", _cs);
                DB.AddParam("step", 0);
                DB.RunSP("ClientSession_SetStep");
            }
            Response.Redirect(Request.Path + "?" + Request.QueryString);
        }

        protected void btn_Next_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_client_session", _cs);
            DB.AddParam("id_client", _client);
            DataSet ds = DB.RunSPReturnDS("ClientSession_GetStatus");

            string current_step = ds.Tables[0].Rows[0]["CurrentStep"].ToString();

            DataRow step = GetNextStep(ds);
            if (step == null && current_step == "0")
                step = GetFirstStep(ds);
            
            if (step != null)
            {
                DB.AddParam("id_client_session", _cs);
                DB.AddParam("step", step["IdStep"].ToString());
                DB.RunSP("ClientSession_SetStep");
            }
            else
            {
                DB.AddParam("id_client_session", _cs);
                DB.RunSPReturnDS("ClientSession_End");
            }
            Response.Redirect(Request.Path + "?" + Request.QueryString);
        }

        protected void btn_Question_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_client_session", _cs);
            DB.AddParam("status", "2");
            DB.RunSP("ClientSession_SetStatus");

            Response.Redirect(Request.Path + "?" + Request.QueryString);
        }
    }


    

}