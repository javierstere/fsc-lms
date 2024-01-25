using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Employee
{
    public partial class Session : EmployeeBasePage //System.Web.UI.Page
    {
        protected string _session;
        protected string _employee;
        protected string _training_session;
        protected string _question;
        protected string _percent;

        protected void Page_Load(object sender, EventArgs e)
        {
            _session = Q["session"];
            _employee = (string)S["Client.IdEmployee"];

            if (_Development_)
            {
                if (_session == null)
                    _session = "1";
            }

            if(Q["ajax"] != null)
            {
                ProcessAjax();
                return;
            }

            if(_session != null)
                PopulateDetails();
        }

        private void ProcessAjax()
        {
            Response.Clear();

            DB.AddParam("id_client_session", Q["session"]);
            DB.AddParam("id_client", Q["client"]);
            DB.AddParam("id_employee", Q["employee"]);
            DataSet ds = DB.RunSPReturnDS("ClientSession_GetDetails");

            string status = ds.Tables[0].Rows[0]["Status"].ToString();
            string step = ds.Tables[0].Rows[0]["CurrentStep"].ToString();

            Common.JsonResponseSessionClient sc = new Common.JsonResponseSessionClient();
            sc.status = status;
            sc.step = step;

            Response.Write(sc);

            Response.End();
        }

        private void PopulateDetails()
        {
            string id_client = (string)S["Client.Id"];
            string id_employee = (string)S["Client.IdEmployee"];

            DB.AddParam("id_client_session", _session);
            DB.AddParam("id_client", id_client);
            DB.AddParam("id_employee", id_employee);
            DataSet ds = DB.RunSPReturnDS("ClientSession_GetDetails");

            string status = ds.Tables[0].Rows[0]["Status"].ToString();

            if (status == "0")
            {
                pnl_NotActive.Visible = true;
                return;
            }

            if (status == "3")
            {
                pnl_Ended.Visible = true;
                _percent = ds.Tables[1].Rows[0]["Points"].ToString();
                return;
            }

            pnl_Details.Visible = true;

            _training_session = ds.Tables[0].Rows[0]["SessionName"].ToString();

            if (status == "1")
            {
                pnl_WaitForQuestion.Visible = true;
            }
            else 
            {
                pnl_Question.Visible = true;

                if (ds.Tables[1].Rows.Count > 0)
                {
                    _question = ds.Tables[1].Rows[0]["Question"].ToString();
                    hd_IdQuizQuestion.Value = ds.Tables[1].Rows[0]["IdQuizQuestion"].ToString();
                }

                rpt_Answers.DataSource = ds.Tables[2];
                rpt_Answers.DataBind();
            }

        }
        protected bool _answer_saved = false;
        protected string GetCheckedAnswer(object container)
        {
            DataRowView drv = (DataRowView)container;
            string answer = "," + drv["EmployeeAnswer"].ToString() + ",";
            if(answer.IndexOf("," + drv["IdQuizAnswer"].ToString()  +",") > -1)
            {
                _answer_saved = true;
                return " checked='checked' ";
            }
            return "";
        }

        protected void btn_SaveAnswer_Click(object sender, EventArgs e)
        {
            if (S["Client.IdEmployee"] == null)
                return;

            string answer = "";
            foreach (string key in F)
            {
                if (key.StartsWith("answer_") && F[key] == "on")
                {
                    string id = key.Substring("answer_".Length);
                    if (answer != "")
                        answer += ",";
                    answer += id;
                }
            }

            string id_employee = (string)S["Client.IdEmployee"];


            DB.AddParam("id_module", null);
            DB.AddParam("id_client_session", _session);
            DB.AddParam("id_employee", id_employee);
            DB.AddParam("id_quiz_question", hd_IdQuizQuestion.Value);
            //DB.AddParam("id_step", hd_IdStep.Value);
            DB.AddParam("answer", answer);
            DB.RunSP("EmployeeQuizAnswer_Save");


            DB.AddParam("id_module", null);
            DB.AddParam("id_client_session", _session);
            DB.AddParam("id_employee", id_employee);
            DataSet dsScore = DB.RunSPReturnDS("EmployeeQuiz_CalculateScore");


            Response.Redirect(Request.Path + "?" + Request.QueryString);
        }
    }
}