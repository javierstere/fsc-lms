using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC
{
    public partial class Status : Outpost.Utils.BaseWebPage // System.Web.UI.Page
    {
        private static object syncRoot = new Object();

        protected void Page_Load(object sender, EventArgs e)
        {
            ProcessMailQueue();

            OneYearReminder();

            SendEmails();
        }

        private void SendEmails()
        {
            DataSet ds = DB.RunSPReturnDS("Mail_List");

            foreach(DataRow row in ds.Tables[0].Rows)
            {
                string id = row["id"].ToString();
                string to = row["to"].ToString();
                string cc = row["cc"].ToString();
                string bcc = row["bcc"].ToString();
                string subject = row["subject"].ToString();
                string message = row["message"].ToString();

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

                DB.AddParam("id", id);
                DB.AddParam("status", ok ? "1" : "0");
                DB.AddParam("error", error);
                DB.RunSP("Mail_Sent");
            }
        }

        private void OneYearReminder()
        {
            string bcc = null;
            //string debug_email = "bartdobek@bdfoodsafety.com";
            string debug_email = "ileasori.n@gmail.com";
            bcc = "reminderslms@gmail.com;ilea.sorin@gmail.com;dan.vladea@merlin-x.ro";
            //bcc = "ilea.sorin@gmail.com;dan.vladea@merlin-x.ro";



            DataSet ds = DB.RunSPReturnDS("Report_OneYearReminder");

            foreach(DataRow adm in ds.Tables[0].Rows)
            {
                string email = adm["Email"].ToString();
                string name = adm["AdministratorName"].ToString();

                if(bcc != null)email = debug_email;

                string idclient = adm["IdClient"].ToString();

                StringBuilder sb = new StringBuilder();

                int rows = 0;
                sb.Append("Hi " + name + ",<br/><br/>");
                sb.Append("Here is the list of employees with past due training.<br/><br/><br/>");

                sb.Append("<table border='1' style='border-collapse: separate;'>");
                sb.Append("<tr>");
                sb.Append("<th style='padding: 5px;'>Name</th>");
                sb.Append("<th style='padding: 5px;'>User</th>");
                sb.Append("<th style='padding: 5px;'>Last Training Date</th>");
                sb.Append("<th style='padding: 5px;'>Module Name</th>");
                sb.Append("<th style='padding: 5px;'>Verification Type</th>");
                sb.Append("<th style='padding: 5px;'>Result</th>");
                sb.Append("</tr>");

                foreach (DataRow row in ds.Tables[1].Rows)
                {
                    if(row["IdClient"].ToString() == idclient)
                    {
                        rows++;

                        sb.Append("<tr>");
                        sb.Append("<td style='padding: 5px;'>" + row["EmployeeName"].ToString() + "</td>");
                        sb.Append("<td style='padding: 5px;'>" + row["EmployeeUser"].ToString() + "</td>");
                        sb.Append("<td style='padding: 5px;'>" + row["LastCheck"].ToString() + "</td>");
                        sb.Append("<td style='padding: 5px;'>" + row["ModuleName"].ToString() +  "</td>");
                        sb.Append("<td style='padding: 5px;'>" + row["Type"].ToString() + "</td>");
                        sb.Append("<td style='padding: 5px;'>" + row["Score"].ToString() + "</td>");
                        sb.Append("</tr>");

                        string email_employee = row["Email"].ToString();
                        try
                        {
                            if (email_employee != "" && row["sent"].ToString() == "")
                            {
                                // send email to employee
                                if(bcc != null)email_employee = debug_email;

                                StringBuilder sbe = new StringBuilder();
                                sbe.Append("Hi " + row["EmployeeName"].ToString() + ",<br/><br/>");
                                sbe.Append("Your training course for <b>" + row["ModuleName"].ToString() + "(" + row["Type"].ToString() + ")</b>");
                                sbe.Append(", with the last training date of <b>" + row["LastCheck"].ToString() + "</b>");
                                sbe.Append(" and score/status of <b>" + row["Score"].ToString() + "</b> is now past due<br/><br/>");
                                sbe.Append("Please login to your account and take refresher training at https://lms.bdfoodsafety.com/" + row["Link"].ToString() + "<br><br>Thank You!");


                                DB.AddParam("to", email_employee);
                                DB.AddParam("bcc", bcc);
                                DB.AddParam("subject", "Past Due Training");
                                DB.AddParam("message", sbe.ToString());
                                DB.RunSP("Mail_Add");

                                //utils.Smtp mail = new utils.Smtp();
                                //mail.SendMail(email_employee, bcc, "Past Due Training", sbe.ToString(), null);
                                //DB.RunStatement("insert into _log_ (timestamp, message) values (getdate(), 'employee msg sent" + row["Email"].ToString() + "');");

                                row["sent"] = "y";
                            }
                        }
                        catch(Exception ex)
                        {
                            Global.Log(ex);
                        }
                    }
                }
                sb.Append("</table>");

                if(rows > 0)
                {



                    try
                    {
                        DB.AddParam("to", email);
                        DB.AddParam("bcc", bcc);
                        DB.AddParam("subject", "List of employees with past due training");
                        DB.AddParam("message", sb.ToString());
                        DB.RunSP("Mail_Add");



                        //Global.Log("sending list msg");
                        //utils.Smtp mail = new utils.Smtp();
                        //mail.SendMail(email, bcc, "List of employees with past due training", sb.ToString(), null);
                        //Global.Log("list msg sent");
                    }catch(Exception ex)
                    {
                        Global.Log(ex);

                    }
                }
            }
        }

        public override bool MustBeAuthenticated()
        {
            return false;
        }

        private void ProcessMailQueue()
        {
            lock (syncRoot)
            {
                if (Application["ProcessMailQueue"] != null)
                    return;
                Application["ProcessMailQueue"] = "1";
            }

            try
            {
                DataSet ds = DB.RunSPReturnDS("MaiQueue_List");
                DateTime start = DateTime.Now;
                foreach(DataRow row in ds.Tables[0].Rows)
                {
                    MaiQueueProcessOneEntry(row);
                    DateTime current = DateTime.Now;
                    if (current.Subtract(start).TotalSeconds > 30)
                        break;
                }
            }
            finally
            {
                Application["ProcessMailQueue"] = null;
            }
        }

        private void MaiQueueProcessOneEntry(DataRow row)
        {
            string id = row["Id"].ToString();
            try
            {
                string template = row["template"].ToString();
                string message = row["Message"].ToString();
                string subject = "";

                if (message == "")
                {
                    // get template
                    string template_file = MapPath("/Emails/" + template + ".txt");
                    message = System.IO.File.ReadAllText(template_file);
                }


                // get process data
                string sp = "MailQueue_Template_" + template.Replace("-", "_");
                string parameters = row["Params"].ToString();
                string[] parts = parameters.Split('|');

                foreach (string part in parts)
                {
                    DB.AddParam(part);
                }
                DataSet ds = DB.RunSPReturnDS(sp);

                string email = "";
                if(ds.Tables.Count > 0)
                {
                    if(ds.Tables[0].Rows.Count > 0)
                    {
                        if (ds.Tables[0].Columns["Email"] != null)
                            email = ds.Tables[0].Rows[0]["Email"].ToString();
                    }
                }
                
                if(email == "")
                {
                    DB.AddParam("id", id);
                    DB.AddParam("error", "(missing email)");
                    DB.RunSP("MailQueue_Processed");
                    return;
                }


                //email = "ilea.sorin@gmail.com";



                // preprocess message
                foreach (DataTable tbl in ds.Tables)
                {
                    if (tbl.Rows.Count > 0)
                    {
                        DataRow data = tbl.Rows[0];
                        foreach (DataColumn col in tbl.Columns)
                        {
                            string value = data[col].ToString();

                            var r = new Regex(@"(?<=[A-Z])(?=[A-Z][a-z]) |
                                 (?<=[^A-Z])(?=[A-Z]) |
                                 (?<=[A-Za-z])(?=[^A-Za-z])", RegexOptions.IgnorePatternWhitespace);

                            string tag = "#" + r.Replace(col.ColumnName, "-").ToUpper() + "#";

                            if (tag == "#SESSION-DATE#")
                            {
                                try
                                {
                                    DateTime dt = (DateTime)data[col];
                                    int tz = (int)data["TimeZone"];
                                    dt = dt.AddHours(tz);
                                    value = dt.ToString("MM/dd/yyyy hh:mm tt");
                                    value += " " + Global.TimeZone(tz);
                                }
                                catch { }
                            }

                            message = message.Replace(tag, value);
                        }
                    }
                }

                // send email
                int first_new_line = message.IndexOf(Environment.NewLine);
                if (first_new_line > -1)
                {
                    subject = message.Substring(0, first_new_line);
                    message = message.Substring(first_new_line + 1);
                }


                message = message.Replace("\r\n", "\n");
                message = message.Replace("\n", "<br/>");


                //utils.Smtp mail = new utils.Smtp();
                //mail.SendMail(email, subject, message);

                DB.AddParam("to", email);
                DB.AddParam("subject", subject);
                DB.AddParam("message", message);
                DB.RunSP("Mail_Add");


                DB.AddParam("id", id);
                DB.AddParam("error", null);
                DB.RunSP("MailQueue_Processed");
            }
            catch (Exception ex)
            {
                DB.AddParam("id", id);
                DB.AddParam("error", ex.Message);
                DB.RunSP("MailQueue_Processed");
            }
        }
    }
}