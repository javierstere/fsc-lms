using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Ionic.Zip;

namespace FSC.Builder
{
    public partial class Session : BaseBuilderPage  //System.Web.UI.Page
    {
        protected string _session;
        protected string _step;

        protected void Page_Load(object sender, EventArgs e)
        {
            _session = Q["session"];
            _step = Q["step"];

            if(_session == null)
            {
                PopulateList();
            }
            else
            {
                if (Q["dir"] != null)
                {
                    MoveStep();
                    return;
                }
                if(!IsPostBack)
                    PopulateDetails();
            }
        }

        private void MoveStep()
        {
            DB.AddParam("id_session", _session);
            DB.AddParam("id_step", _step);
            DB.AddParam("direction", Q["dir"] == "1" ? 1 : -1);
            DB.RunSP("TrainingSessionStep_Move");
            Response.Redirect(Request.Path + "?session=" + _session);
        }
        protected void btn_AddNew_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?session=0");
        }

        protected void btn_AddNewStep_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?session=" + _session + "&step=0");
        }

        private void PopulateList()
        {
            pnl_List.Visible = true;

            DataSet ds = DB.RunSPReturnDS("TrainingSession_List");

            rpt_List.DataSource = ds;
            rpt_List.DataBind();
        }

        private void PopulateDetails()
        {
            pnl_SessionDetails.Visible = true;

            DB.AddParam("id_training_session", _session);
            DataSet ds = DB.RunSPReturnDS("TrainingSession_Details");

            bool existing = false;
            DataRow row = null;
            if(ds.Tables[0].Rows.Count == 0)
            {
                row = ds.Tables[0].NewRow();
            }
            else
            {
                existing = true;
                row = ds.Tables[0].Rows[0];
            }
            tb_SessionName.Text = row["SessionName"].ToString();
            lb_SessionName.Text = row["SessionName"].ToString();

            pnl_SessionDetails_Edit.Visible = true;
            if (existing)
            {
                if(_step == null)
                {
                    pnl_StepsList.Visible = true;

                    DB.AddParam("id_training_session", _session);
                    DataSet dsSteps = DB.RunSPReturnDS("TrainingSessionStep_List");

                    rpt_StepsList.DataSource = dsSteps;
                    rpt_StepsList.DataBind();
                }
                else
                {
                    pnl_SessionDetails_Edit.Visible = false;
                    pnl_StepDetails.Visible = true;
                    pnl_SessionDetails_View.Visible = true;
                    cmb_ResourceType.Attributes.Add("onchange", "javascript:OnResourceTypeChange();");

                    DB.AddParam("id_step", _step);
                    DataSet dsDet = DB.RunSPReturnDS("TrainingSessionStep_Details");
                    DataRow rowDet;
                    if (dsDet.Tables[0].Rows.Count == 0)
                    {
                        rowDet = dsDet.Tables[0].NewRow();
                        rowDet["PresentationDuration"] = "10";
                        rowDet["TimeToAnswer"] = "20";
                    }
                    else
                        rowDet = dsDet.Tables[0].Rows[0];

                    tb_StepName.Text = rowDet["StepName"].ToString();
                    tb_Duration.Text = rowDet["PresentationDuration"].ToString();
                    tb_Time2Answer.Text = rowDet["TimeToAnswer"].ToString();
                    tb_ResourceYoutube.Text = rowDet["Resource"].ToString();
                    hl_ResourceZip.Visible = false;

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

                    if (dsDet.Tables[1].Rows.Count > 0)
                    {
                        hd_IdQuizQuestion.Value = dsDet.Tables[1].Rows[0]["IdQuizQuestion"].ToString();
                        tb_Question.Text = dsDet.Tables[1].Rows[0]["Question"].ToString();
                    }

                    DataRow last = dsDet.Tables[2].NewRow();
                    dsDet.Tables[2].Rows.Add(last);

                    rpt_Options.DataSource = dsDet.Tables[2];
                    rpt_Options.DataBind();
                }
            }
        }

        protected void btn_SessionSave_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_training_session", _session);
            DB.AddParam("session_name", tb_SessionName.Text);

            DataSet ds = DB.RunSPReturnDS("TrainingSession_Save");

            _session = ds.Tables[0].Rows[0]["Id"].ToString();

            Response.Redirect(Request.Path + "?session=" + _session);
        }

        protected void btn_SessionCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path);
        }

        protected void btn_SessionDelete_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_training_session", _session);
            DB.RunSP("TrainingSession_Delete");
            Response.Redirect(Request.Path);
        }

        protected void btn_StepSave_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_training_session", _session);
            DB.AddParam("id_step", _step);
            DB.AddParam("step_name", tb_StepName.Text);
            DB.AddParam("resource_type", cmb_ResourceType.SelectedValue);

            if (cmb_ResourceType.SelectedValue == "Z")
                DB.AddParam("resource", DBNull.Value);

            if (cmb_ResourceType.SelectedValue == "Y")
                DB.AddParam("resource", tb_ResourceYoutube.Text);

            DB.AddParam("presentation_duration", tb_Duration.Text);
            DB.AddParam("time_to_answer", tb_Time2Answer.Text);
            DataSet ds = DB.RunSPReturnDS("TrainingSessionStep_Save");

            _step = ds.Tables[0].Rows[0]["Id"].ToString();

            if (cmb_ResourceType.SelectedValue == "Z" && fu_ResourceZip.HasFile)
            {
                // replace existing file, if any

                string filename = fu_ResourceZip.FileName;
                string type = System.IO.Path.GetExtension(filename).ToUpper();
                string name = System.IO.Path.GetFileNameWithoutExtension(filename);

                string path = MapPath("/Module/TS/");
                string path_base = System.IO.Path.Combine(path, _session);
                path_base = System.IO.Path.Combine(path_base, _step);

                string path_db = filename.Replace(" ", "-");
                path = System.IO.Path.Combine(path_base, path_db);

                if (System.IO.Directory.Exists(path_base))
                    System.IO.Directory.Delete(path_base, true);
                if (!System.IO.Directory.Exists(path_base))
                    System.IO.Directory.CreateDirectory(path_base);

                fu_ResourceZip.SaveAs(path);

                bool found = false;

                if (type == ".ZIP")
                {
                    using (ZipFile zf = ZipFile.Read(path))
                    {
                        foreach (ZipEntry entry in zf)
                        {
                            entry.Extract(path_base, ExtractExistingFileAction.OverwriteSilently);
                            if (!found && (entry.FileName.ToLower().EndsWith("story_html5.html") || entry.FileName.ToLower().EndsWith("story.html")))
                            {
                                found = true;
                                path_db = entry.FileName;
                            }
                        }
                    }
                }

                DB.AddParam("id_step", _step);
                DB.AddParam("resource", path_db);
                DB.RunSPReturnDS("TrainingSessionStep_SaveResourcePath");

            }




            DB.AddParam("id_quiz_question", hd_IdQuizQuestion.Value);
            DB.AddParam("id_module", null);
            DB.AddParam("id_step", _step);
            DB.AddParam("question", tb_Question.Text);
            DataSet dsQ = DB.RunSPReturnDS("QuizQuestion_Save");

            hd_IdQuizQuestion.Value = dsQ.Tables[0].Rows[0]["Id"].ToString();


            DataSet dsValues = new DataSet();
            DB.FillTable(dsValues, "QuizAnswer", "IdQuizQuestion=" + hd_IdQuizQuestion.Value);
            int index = 0;
            foreach (string key in Request.Form)
            {
                if (key.StartsWith("hd_") && key.EndsWith("_answer") && Request.Form[key].Trim() != "")
                {
                    string pos = key.Replace("hd_", "").Replace("_answer", "");
                    DataRow row = null;
                    if (dsValues.Tables[0].Rows.Count > index)
                    {
                        row = dsValues.Tables[0].Rows[index];
                    }
                    else
                    {
                        row = dsValues.Tables[0].NewRow();
                        row["IdQuizQuestion"] = hd_IdQuizQuestion.Value;
                        row["Position"] = index;
                        dsValues.Tables[0].Rows.Add(row);
                    }

                    row["Answer"] = Request.Form["hd_" + pos + "_answer"];
                    row["Correct"] = Request.Form["hd_" + pos + "_correct"] != null ? "1" : "0";

                    index++;
                }
            }
            DB.UpdateTable(dsValues, "QuizAnswer");

            while (dsValues.Tables[0].Rows.Count > index)
            {
                DB.DeleteTable("QuizAnswer", "IdQuizAnswer="
                    + dsValues.Tables[0].Rows[dsValues.Tables[0].Rows.Count - 1]["IdQuizAnswer"].ToString());
                dsValues.Tables[0].Rows.RemoveAt(dsValues.Tables[0].Rows.Count - 1);
            }


            Response.Redirect(Request.Path + "?session=" + _session + "&step=" + _step);
        }

        protected void btn_StepCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?session=" + _session);
        }

        protected void btn_StepDelete_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_step", _step);
            DB.RunSP("TrainingSessionStep_Delete");
            Response.Redirect(Request.Path + "?session=" + _session);
        }
    }
}