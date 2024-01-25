using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Util;
using FSC.utils;

namespace FSC.Employee
{
    public partial class Default : EmployeeBasePage //System.Web.UI.Page
    {
        protected string _module;
        protected string _view;
        protected string _embed;

        protected void Page_Load(object sender, EventArgs e)
        {
            _module = Q["module"];
            _view = Q["view"];
            if (_module == null && _view == null)
            {
                PopulateList();
                PopulateActiveTrainings();
            }
            else if (_view != null)
            {
                ViewTraining();
            }
            else if (_module != null)
            {
                pnl_Quiz.Visible = true;
            }
        }

        private void PopulateActiveTrainings()
        {
            string id_client = (string)S["Client.Id"];
            string id_employee = (string)S["Client.IdEmployee"];

            DB.AddParam("id_client", id_client);
            DB.AddParam("id_employee", id_employee);
            DataSet ds = DB.RunSPReturnDS("ClientSession_ForEmployee");

            if (ds.Tables[0].Rows.Count > 0)
            {
                pnl_ClientSession.Visible = true;
                rpt_ClientSession.DataSource = ds;
                rpt_ClientSession.DataBind();
            }
        }

        private void PopulateList()
        {
            pnl_List.Visible = true;

            string id_client = (string)S["Client.Id"];
            string id_employee = (string)S["Client.IdEmployee"];
            DB.AddParam("id_client", id_client);
            DB.AddParam("id_employee", id_employee);
            DataSet dsQ = DB.RunSPReturnDS("Employee_GetQuizzes");

            if (dsQ.Tables[0].Rows.Count > 0)
            {
                rpt_ListQuiz.DataSource = dsQ;
                rpt_ListQuiz.DataBind();
            }

            DB.AddParam("id_client", id_client);
            DB.AddParam("id_employee", id_employee);
            DataSet dsDC = DB.RunSPReturnDS("Employee_GetDirectCheck");

            if (dsDC.Tables[0].Rows.Count > 0)
            {
                rpt_ListDC.DataSource = dsDC;
                rpt_ListDC.DataBind();
            }

            DB.AddParam("id_client", id_client);
            DB.AddParam("id_employee", id_employee);
            DataSet dsCourse = DB.RunSPReturnDS("Employee_GetCourses");

            Boolean fl = true;
            if (dsCourse.Tables[0].Rows.Count > 0)
            {
                DataSet ds = new DataSet();
                foreach (DataTable origDt in dsCourse.Tables)
                {
                    origDt.Columns.Add("Completed", typeof(System.Int32));
                    DataTable encodedDt = origDt.Clone();
                    for (int i = 0; i < origDt.Rows.Count; i++)
                    {
                        DataRow dr = origDt.Rows[i];
                        
                        if (dr["StartCount"].ToString() == "0" || dr["StartCount"].ToString() == "")
                        {
                            fl = false;
                        }

                        if (dr["StartCount"].ToString() == "0" || dr["StartCount"].ToString() == "")
                        {
                            if (i > 0)
                            {
                                DataRow pdr = origDt.Rows[i - 1];
                                if (pdr["StartCount"].ToString() == "0" || pdr["StartCount"].ToString() == "")
                                    dr["Completed"] = 3; // Empty
                                else
                                    dr["Completed"] = 1; // To Start
                            } else
                                dr["Completed"] = 1; // To start
                        } else
                        {
                            dr["Completed"] = 2; // Completed
                        }
                        encodedDt.ImportRow(dr);
                    }
                    ds.Tables.Add(encodedDt);
                }

                if (fl)
                {
                    DB.AddParam("id_client", id_client);
                    DB.AddParam("id_employee", id_employee);
                    DataSet dsCourseNotification = DB.RunSPReturnDS("CourseNotification_Add");
                    if (dsCourseNotification.Tables[0].Rows.Count == 0)
                    {
                        string to = "lms@doceosystem.com";
                        string cc = "";
                        string bcc = "";
                        string subject = "Training Completed";
                        string message = "Dear LMS Administrator, <br> User (" + (string)S["Client.EmployeeName"] + ") has successfully completed the training";

                        bool ok = false;
                        string error = null;
                        try
                        {
                            utils.Smtp mail = new utils.Smtp();
                            mail.SendMail(to, bcc, subject, message, null);
                            ok = true;
                        }
                        catch (Exception ex)
                        {
                            error = ex.Message;
                            if (ex.InnerException != null) error += "\r\n" + ex.InnerException.Message;
                        }
                    }
                }
                rpt_ListCourse.DataSource = ds;
                rpt_ListCourse.DataBind();
            }
        }

        protected string StartButton(object container)
        {
            string ret = "";

            DataRowView drv = (DataRowView)container;

            if (drv["IdEmployeeQuiz"].ToString() != "")
            {
                int count = (int)drv["StartCount"];
                DateTime dt = DateTime.Now;
                if (drv["timestamp"] != DBNull.Value)
                {
                    dt = (DateTime)drv["timestamp"];
                    if (dt.CompareTo(DateTime.Today) < 0)
                        count = 0;
                }
                if (count < 3)
                {
                    TimeSpan ts = ((DateTime)drv["NOW"]).Subtract(dt);
                    if (ts.TotalMinutes > 3 && ts.TotalDays < 1)
                        ret = "<a href=\"javascript: Start(" + drv["IdModule"].ToString() + ")\">Start</a>";
                }
                else
                {
                    ret = "<a href=\"javascript: Closed();\">Closed</a>";
                }
            }

            return ret;
        }

        protected string CourseStatusText(object container)
        {
            string ret = "";

            DataRowView drv = (DataRowView)container;

            if (drv["Completed"].ToString() == "1")
            {
                ret = "Not yet";
            }
            else if (drv["Completed"].ToString() == "2")
            {
                ret = "Completed";
            }
            else
            {
                ret = "Not yet";
            }

            return ret;
        }

        protected string CourseAction(object container)
        {
            string ret = "";

            DataRowView drv = (DataRowView)container;

            if (drv["Completed"].ToString() == "1")
            {
                if (drv["IdEmployeeQuiz"].ToString() == "")
                {
                    ret = "";
                }
                else
                {
                    DateTime dt = DateTime.Now;
                    if (drv["timestamp"] != DBNull.Value)
                    {
                        dt = (DateTime)drv["timestamp"];
                    }
                    TimeSpan ts = ((DateTime)drv["NOW"]).Subtract(dt);
                    if (ts.TotalSeconds > (int)(drv["Delay"] != DBNull.Value ? drv["Delay"] : 0))
                        ret = "<a href=\"javascript: Start(" + drv["IdModule"].ToString() + ")\">Start</a>";
                    else
                        ret = "";
                }
            }
            else if (drv["Completed"].ToString() == "2")
            {
                ret = "<a href=\"javascript: Start(" + drv["IdModule"].ToString() + ")\">Review</a>";
            }
            else
            {
                ret = "";
            }

            return ret;
        }

        private void ViewTraining()
        {
            DB.AddParam("id_module", _view);
            DB.AddParam("id_employee", (string)S["Client.IdEmployee"]);
            DB.RunSP("EmployeeQuiz_Training");

            pnl_View.Visible = true;
            DB.AddParam("id_module", _view);
            DataSet ds = DB.RunSPReturnDS("Module_Details");

            string path = ds.Tables[0].Rows[0]["Path"].ToString();

            string type = ds.Tables[0].Rows[0]["Type"].ToString().ToLower();
            if (type == "video")
            {
                pnl_Youtube.Visible = true;
                _embed = ds.Tables[0].Rows[0]["Path"].ToString();
            }
            else if (type == ".pptx" || type == ".ppsx")
            {
                pnl_PPT.Visible = true;
                _embed = ds.Tables[0].Rows[0]["Path"].ToString();
                //_embed = _embed.Replace("\\", "/");
                _embed = "/Module/" + HttpUtility.UrlEncode(_embed).Replace("%5c", "/");
            }
            else
            {

                path = path.Replace("\\", "/");

                path = HttpUtility.UrlPathEncode(path);

                Response.Redirect("/Module/" + path);
            }
        }
    }
}