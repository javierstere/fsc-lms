using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Common
{
    public partial class Report : Outpost.Utils.BaseUserControl    //System.Web.UI.UserControl
    {
        protected string _client;
        protected string _employee;
        protected string _module;
        protected string _cs;

        protected string _extra;

        protected void Page_Load(object sender, EventArgs e)
        {
            //if(Q["s"] == null)
            //{
            //    Response.Redirect(Request.Path + "?s=i");
            //    return;
            //}

            _client = (string)S["Client.Id"];
            if (Q["client"] != null)
                _client = Q["client"];

            _extra = Q["tab"];
            if (_extra != null)
                _extra = "&tab=" + _extra;

            _employee = Q["employee"];
            _module = Q["module"];
            _cs = Q["cs"];

            if (_employee != null && (_module != null || _cs != null))
            {
                if (Q["do"] == "1")
                    PopulateDetailsDO();
                else
                    PopulateDetails();
            }
            else
            {
                if (!IsPostBack)
                {
                    tb_Search.Text = (string)S["Report.Search"];
                    btn_Search_Click(null, null);
                }
                pnl_Search.Visible = true;
            }
        }

        protected void btn_Search_Click(object sender, EventArgs e)
        {
            string report_type = Q["s"];
            if (report_type == null)
                report_type = "i";
            S["Report.Search"] = tb_Search.Text.Trim();
            pnl_List.Visible = true;
            if (report_type == "i" || report_type == "g")
            {
                DB.AddParam("id_client", _client);
                DB.AddParam("type", report_type);
                DB.AddParam("filter", tb_Search.Text.Trim());
                DataSet ds = DB.RunSPReturnDS("Employee_Find");

                rpt_List.DataSource = ds;
                rpt_List.DataBind();
                rpt_List.Visible = true;
            }
            else
            {
                DB.AddParam("id_client", _client);
                DB.AddParam("filter", tb_Search.Text.Trim());
                DataSet ds = DB.RunSPReturnDS("Report_DirectCheck");

                rpt_ListDO.DataSource = ds;
                rpt_ListDO.DataBind();
                rpt_ListDO.Visible = true;
            }
        }

        protected void btn_Export_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_client", _client);
            DB.AddParam("type", Q["s"] == "g" ? "g" : "i");
            DB.AddParam("filter", tb_Search.Text.Trim());
            DataSet ds = DB.RunSPReturnDS("Employee_Report");

            ds.Tables[0].TableName = "Scores";
            string excel_file = "scores_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".xls";

            excel_file = MapPath("/Temp/" + excel_file);

            ExcelLibrary.DataSetHelper.CreateWorkbook(excel_file, ds);

            Response.Clear();
            Response.ClearContent();
            Response.ClearHeaders();

            Response.ContentType = "application/octet-stream";
            Response.AddHeader("Content-Disposition", "attachment; filename=Scores.xls");

            Response.TransmitFile(excel_file);

            Response.Flush();


            System.Threading.Thread.Sleep(500);

            try
            {
                System.IO.File.Delete(excel_file);
            }
            catch (Exception ex)
            {
                string er = ex.Message;
            }

            Response.End();
        }

        protected string GetDetailsLink(object container)
        {
            string ret = "";
            DataRowView drv = (DataRowView)container;
            if (drv["Passed"].ToString() != "")
            {
                if (drv["Passed"].ToString() == ".")
                    return "";
                string query = "";
                if (Q["tab"] != null)
                    query += "&tab=" + Q["tab"];
                if (Q["client"] != null)
                    query += "&client=" + Q["client"];
                ret = "<a href=\"" + Request.Path + "?employee=" + drv["IdEmployee"].ToString();
                if (drv["IdModule"].ToString() != "")
                    ret += "&module=" + drv["IdModule"].ToString();
                ret += "&do=1";
                if (Q["s"] == "g")
                    ret += "&s=g";
                ret += query + "\">Details</a>";
            }
            else if (drv["IdModule"].ToString() != "" || drv["IdClientSession"].ToString() != "")
            {
                string query = "";
                if (Q["tab"] != null)
                    query += "&tab=" + Q["tab"];
                if (Q["client"] != null)
                    query += "&client=" + Q["client"];
                ret = "<a href=\"" + Request.Path + "?employee=" + drv["IdEmployee"].ToString();
                if (drv["IdModule"].ToString() != "")
                    ret += "&module=" + drv["IdModule"].ToString();
                if (drv["IdClientSession"].ToString() != "")
                    ret += "&cs=" + drv["IdClientSession"].ToString();
                if (Q["s"] == "g")
                    ret += "&s=g";
                ret += query + "\">Details</a>";
            }
            
            return ret;
        }

        protected string _time = "";
        
        private void PopulateDetailsDO()
        {
            pnl_Details_DC.Visible = true;

            DB.AddParam("id_client", _client);
            DB.AddParam("id_module", _module);
            DB.AddParam("id_employee", _employee);
            DataSet ds  = DB.RunSPReturnDS("Report_DirectCheckDetails");

            if (ds.Tables[0].Rows.Count == 0)
                return;

            lb_Admin.Text = ds.Tables[0].Rows[0]["AdministratorName"].ToString();
            lb_Employee.Text = ds.Tables[0].Rows[0]["EmployeeName"].ToString();
            lb_Module.Text = ds.Tables[0].Rows[0]["ModuleName"].ToString();
            lb_Result.Text = ds.Tables[0].Rows[0]["Passed"].ToString() == "1" ? "Acceptable" : "Unacceptable";

            _time = ((DateTime)ds.Tables[0].Rows[0]["Date"])
                                .Subtract(new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc))
                                    .TotalMilliseconds.ToString();
        }

        DataSet employee_answers = null;
        private void PopulateDetails()
        {
            pnl_Details.Visible = true;

            DB.AddParam("id_client", _client);
            DB.AddParam("id_project", null);
            DB.AddParam("id_module", _module);
            DB.AddParam("id_client_session", _cs);
            DB.AddParam("id_employee", _employee);
            employee_answers = DB.RunSPReturnDS("Report_ProjectModuleEmployee");

            DataRow row = employee_answers.Tables[0].Rows[0];
            lb_EmployeeName.Text = row["EmployeeName"].ToString();
            lb_EmployeeModule.Text = row["ModuleName"].ToString();
            lb_EmployeePoints.Text = row["Points"].ToString();
            if(row["Timestamp"].ToString() != "")
                lb_Timestamp.Text = ((DateTime)row["Timestamp"]).ToString("MM/dd/yyyy");

            rpt_EmployeeAnswers.DataSource = employee_answers.Tables[1];
            rpt_EmployeeAnswers.DataBind();
        }


        protected string GetAnswers(object container)
        {
            string ret = "";
            DataRowView drv = (DataRowView)container;

            string answer = drv["Answer"].ToString();
            string[] answers = answer.Split(',');
            foreach (string ans in answers)
            {
                if (ans != "")
                {
                    ret += "<div>";
                    DataView dv = new DataView(employee_answers.Tables[2]);
                    dv.RowFilter = "IdQuizAnswer=" + ans;
                    if (dv.Count == 1)
                        ret += dv[0]["Answer"].ToString();

                    ret += "</div>";
                }
            }

            return ret;
        }
    }
}