using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Common
{
    public partial class QuizView : Outpost.Utils.BaseUserControl   // System.Web.UI.UserControl
    {
        string _module;
        protected int _index = -1;
        protected int _no_of_questions = 0;
        DataSet client_answers = null;
        protected string _points = "0";

        protected void Page_Load(object sender, EventArgs e)
        {
            _module = Q["module"];
            try
            {
                string index = Q["index"];
                _index = int.Parse(index);
            }
            catch
            {
                _index = -1;
            }

            if (_index < 0)
            {
                if (!IsPostBack)
                {
                    pnl_Start.Visible = true;
                    if (S["Client.IdEmployee"] != null)
                    {
                        DB.AddParam("id_module", _module);
                        DB.AddParam("id_employee", S["Client.IdEmployee"]);
                        DB.RunSP("EmployeeQuiz_Start");
                    }
                }
            }
            else
            {
                DB.AddParam("id_module", _module);
                DataSet ds = DB.RunSPReturnDS("QuizQuestion_List");
                btn_Previous.Enabled = _index != 0;
                _no_of_questions = ds.Tables[0].Rows.Count;
                if (ds.Tables[0].Rows.Count > _index)
                {
                    pnl_Question.Visible = true;
                    string question = ds.Tables[0].Rows[_index]["IdQuizQuestion"].ToString();
                    lb_Question.Text = ds.Tables[0].Rows[_index]["Question"].ToString();
                    IdQuizQuestion.Value = question;

                    if (S["Client.IdEmployee"] != null)
                    {
                        DB.AddParam("id_module", _module);
                        DB.AddParam("id_employee", S["Client.IdEmployee"]);
                        client_answers = DB.RunSPReturnDS("EmployeeQuizAnswer_List");
                    }

                    DB.AddParam("id_quiz_question", question);
                    DataSet dsA = DB.RunSPReturnDS("QuizQuestion_Details");

                    rpt_Answers.DataSource = dsA.Tables[1];
                    rpt_Answers.DataBind();
                }
                else
                {
                    pnl_Stop.Visible = true;
                    DB.AddParam("id_module", _module);
                    DB.AddParam("id_client_session", null);
                    DB.AddParam("id_employee", S["Client.IdEmployee"]);
                    DataSet dsScore = DB.RunSPReturnDS("EmployeeQuiz_CalculateScore");

                    if (dsScore.Tables[0].Rows.Count > 0)
                        _points = dsScore.Tables[0].Rows[0]["Points"].ToString();
                }
            }
        }

        protected string GetCheckedAnswer(object container)
        {
            string ret = "";

            if (client_answers != null)
            {
                DataRowView drv = (DataRowView)container;
                string id_quiz_question = drv["IdQuizQuestion"].ToString();
                string id_answer = drv["IdQuizAnswer"].ToString();

                DataView dv = new DataView(client_answers.Tables[0]);
                dv.RowFilter = "idQuizQuestion = " + id_quiz_question;
                string answer = "";
                if (dv.Count > 0)
                {
                    DataRowView drvAnswer = dv[0];
                    answer = drvAnswer["Answer"].ToString();
                    string full = "," + answer + ",";
                    if (full.IndexOf("," + id_answer + ",") >= 0)
                        ret = "checked='checked'";
                }
            }
            return ret;
        }

        protected void btn_Start_Click(object sender, EventArgs e)
        {
            _index = 0;
            Response.Redirect(Request.Path + "?" + Q.ReplaceKey("index", "0"));
        }

        protected void btn_Previous_Click(object sender, EventArgs e)
        {
            SaveAnswer();

            _index--;
            Response.Redirect(Request.Path + "?" + Q.ReplaceKey("index", _index.ToString()));
        }

        protected void btn_Next_Click(object sender, EventArgs e)
        {
            SaveAnswer();

            _index++;
            Response.Redirect(Request.Path + "?" + Q.ReplaceKey("index", _index.ToString()));
        }

        private void SaveAnswer()
        {
            string id_employee = (string)S["Client.IdEmployee"];
            if (id_employee == null)
                return;

            string answer = "";
            foreach(string key in F)
            {
                if(key.StartsWith("answer_") && F[key] == "on")
                {
                    string id = key.Substring("answer_".Length);
                    if (answer != "")
                        answer += ",";
                    answer += id;
                }
            }

            DB.AddParam("id_module", _module);
            DB.AddParam("id_client_session", null);
            DB.AddParam("id_employee", id_employee);
            DB.AddParam("id_quiz_question", IdQuizQuestion.Value);
            DB.AddParam("answer", answer);
            DB.RunSP("EmployeeQuizAnswer_Save");
        }
    }
}