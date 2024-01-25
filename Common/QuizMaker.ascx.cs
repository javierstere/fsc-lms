using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Common
{
    public partial class QuizMaker : Outpost.Utils.BaseUserControl // System.Web.UI.UserControl
    {
        protected string _client;
        protected string _quiz;
        protected string _question;
        protected void Page_Load(object sender, EventArgs e)
        {
            _quiz = Q["quiz"];
            _question = Q["question"];

            _client = (string)S["Client.Id"];
            if (Q["client"] != null)
                _client = Q["client"];

            if (_quiz == null)
            {
                PopulateQuizList();
            }
            else
            {
                if(!IsPostBack)
                    PopulateQuizDetails();
            }
        }

        private void PopulateQuizList()
        {
            pnl_ListQuiz.Visible = true;
            DB.AddParam("id_client", _client);
            DataSet ds = DB.RunSPReturnDS("Quiz_List");

            rpt_ListQuiz.DataSource = ds;
            rpt_ListQuiz.DataBind();
        }

        private void PopulateQuizDetails()
        {
            pnl_DetailsQuiz.Visible = true;

            DB.AddParam("id_client", _client);
            DB.AddParam("id_quiz", _quiz);
            DataSet ds = DB.RunSPReturnDS("Quiz_Details");

            DataRow row;
            if (ds.Tables[0].Rows.Count == 0)
                row = ds.Tables[0].NewRow();
            else
                row = ds.Tables[0].Rows[0];

            tb_QuizName.Text = row["QuizName"].ToString();

            if (row["IdQuiz"].ToString() != "")
                PopulateQuestion();
        }

        private void PopulateQuestion()
        {
            if (_question == null)
            {
                pnl_Questions.Visible = true;
                DB.AddParam("id_client", _client);
                DB.AddParam("id_quiz", _quiz);
                DataSet ds = DB.RunSPReturnDS("QuizQuestion_List");
                rpt_Questions.DataSource = ds;
                rpt_Questions.DataBind();
            }
            else
            {
                pnl_QuestionDetails.Visible = true;

                DB.AddParam("id_question", _question);
                DataSet ds = DB.RunSPReturnDS("QuizQuestion_Details");
                DataRow row;
                if (ds.Tables[0].Rows.Count == 0)
                    row = ds.Tables[0].NewRow();
                else
                    row = ds.Tables[0].Rows[0];

                tb_Question.Text = row["Question"].ToString();


                DataRow last = ds.Tables[1].NewRow();
                ds.Tables[1].Rows.Add(last);

                rpt_Options.DataSource = ds.Tables[1];
                rpt_Options.DataBind();

            }
        }

        protected void btn_SaveQuiz_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_quiz", _quiz);
            DB.AddParam("id_client", _client);
            DB.AddParam("quiz_name", tb_QuizName.Text);
            DataSet ds = DB.RunSPReturnDS("Quiz_Save");

            _quiz = ds.Tables[0].Rows[0]["Id"].ToString();

            Response.Redirect(Request.Path + "?" + Q.ReplaceKey("quiz", _quiz));
        }

        protected void btn_CancelQuiz_Click(object sender, EventArgs e)
        {
            //string query = Request.QueryString.ToString();
            //query = query.Replace("&quiz=" + _quiz, "");
            Response.Redirect(Request.Path + "?" + Q.WithoutKey("quiz"));
        }

        protected void btn_DeleteQuiz_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_quiz", _quiz);
            DB.AddParam("id_client", _client);
            DB.RunSP("Quiz_Delete");

            btn_CancelQuiz_Click(null, null);
        }

        protected void btn_SaveQuestion_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_quiz", _quiz);
            DB.AddParam("id_question", _question);
            DB.AddParam("question", tb_Question.Text);
            DataSet ds = DB.RunSPReturnDS("QuizQuestion_Save");             // ?????????????????????????????????????

            _question = ds.Tables[0].Rows[0]["Id"].ToString();



            DataSet dsValues = new DataSet();
            DB.FillTable(dsValues, "QuizAnswer", "IdQuizQuestion=" + _question);
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
                        row["IdQuizQuestion"] = _question;
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

            Response.Redirect(Request.Path + "?" + Q.ReplaceKey("question", _question));
        }

        protected void btn_CancelQuestion_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?" + Q.WithoutKey("question"));
        }

        protected void btn_DeleteQuestion_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_question", _question);
            DB.RunSP("QuizQuestion_Delete");

            Response.Redirect(Request.Path + "?" + Q.WithoutKey("question"));
        }
    }
}