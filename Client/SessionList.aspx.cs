using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Client
{
    public partial class SessionList : ClientBasePage   // System.Web.UI.Page
    {
        protected string _id;
        protected string _step;
        protected void Page_Load(object sender, EventArgs e)
        {
            _id = Q["id"];
            _step = Q["step"];
            if(_id == null)
            {
                PopulateList();
            }
            else
            {
                PopulateDetails();
            }
        }

        private void PopulateList()
        {
            DataSet ds = DB.RunSPReturnDS("TrainingSession_List");
            rpt_List.DataSource = ds;
            rpt_List.DataBind();

            pnl_List.Visible = true;
        }

        private void PopulateDetails()
        {
            pnl_Details.Visible = true;
            DB.AddParam("id_training_session", _id);
            DataSet ds = DB.RunSPReturnDS("TrainingSession_Details");
            lb_SessionName.Text = ds.Tables[0].Rows[0]["SessionName"].ToString();


            DB.AddParam("id_training_session", _id);
            DataSet dsSteps = DB.RunSPReturnDS("TrainingSessionStep_List");

            rpt_StepsList.DataSource = dsSteps;
            rpt_StepsList.DataBind();

            if(_step != null)
            {
                DB.AddParam("id_step", _step);
                DataSet dsDet = DB.RunSPReturnDS("TrainingSessionStep_Details");
                DataRow rowDet = dsDet.Tables[0].Rows[0];

                pnl_DetailsStep.Visible = true;

                lb_StepName.Text = rowDet["StepName"].ToString();
                lb_Duration.Text = rowDet["PresentationDuration"].ToString();
                lb_Time2Answer.Text = rowDet["TimeToAnswer"].ToString();
                //tb_ResourceYoutube.Text = rowDet["Resource"].ToString();

                /*
                ListItem item = cmb_ResourceType.Items.FindByValue(rowDet["ResourceType"].ToString());
                if (item != null)
                {
                    item.Selected = true;

                    if (item.Value == "Z")
                    {
                        if (rowDet["Resource"].ToString() != "")
                        {
                            hl_ResourceZip.NavigateUrl = "/Module/TS/" + _session + "/" + _step + "/" + rowDet["Resource"].ToString();
                            hl_ResourceZip.Visible = true;
                        }
                    }
                }
                */
                if (dsDet.Tables[1].Rows.Count > 0)
                {
                    lb_Question.Text = dsDet.Tables[1].Rows[0]["Question"].ToString();
                }

                rpt_Options.DataSource = dsDet.Tables[2];
                rpt_Options.DataBind();
            }
            

        }

        protected void btn_CancelDetails_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path);
        }

        protected void btn_CancelStep_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?id=" + _id);
        }
    }
}