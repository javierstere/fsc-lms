using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Client
{
    public partial class Report : ClientBasePage    //System.Web.UI.Page
    {
        //protected string _project;
        //protected string _module;
        //protected string _employee;
        protected void Page_Load(object sender, EventArgs e)
        {
            /*
            _project = Q["project"];
            _module = Q["module"];
            _employee = Q["employee"];

            if (_module == null && _project == null && _employee == null)
            {
                PopulateList();
            }
            else if(_employee == null)
            {
                PopulateDetails();
            }
            else
            {
                PopulateForEmployee();
            }
            */
        }
        /*
        private void PopulateList()
        {
            pnl_List.Visible = true;

            DB.AddParam("id_client", _client);
            DataSet ds = DB.RunSPReturnDS("Report_ModulesList");

            rpt_List.DataSource = ds;
            rpt_List.DataBind();
        }

        private void PopulateDetails()
        {
            pnl_Details.Visible = true;

            DB.AddParam("id_client", _client);
            DB.AddParam("id_project", _project);
            DB.AddParam("id_module", _module);
            DataSet ds1 = DB.RunSPReturnDS("Report_ProjectModuleDetails");

            DataRow row = ds1.Tables[0].Rows[0];
            lb_ProjectName.Text = row["ProjectName"].ToString();
            lb_Job.Text = row["Job"].ToString();
            lb_ModuleName.Text = row["ModuleName"].ToString();

            rpt_Employees.DataSource = ds1.Tables[1];
            rpt_Employees.DataBind();
        }


        DataSet employee_answers = null;
        private void PopulateForEmployee()
        {
            pnl_Employee.Visible = true;

            DB.AddParam("id_client", _client);
            DB.AddParam("id_project", _project);
            DB.AddParam("id_module", _module);
            DB.AddParam("id_employee", _employee);
            employee_answers = DB.RunSPReturnDS("Report_ProjectModuleEmployee");

            DataRow row = employee_answers.Tables[0].Rows[0];
            lb_EmployeeName.Text = row["EmployeeName"].ToString();
            lb_EmployeeModule.Text = row["ModuleName"].ToString();
            lb_EmployeePoints.Text = row["Points"].ToString();

            rpt_EmployeeAnswers.DataSource = employee_answers.Tables[1];
            rpt_EmployeeAnswers.DataBind();
        }

        protected string GetAnswers(object container)
        {
            string ret = "";
            DataRowView drv = (DataRowView)container;

            string answer = drv["Answer"].ToString();
            string[] answers = answer.Split(',');
            foreach(string ans in answers)
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
        */
    }
}

/* 
    <asp:Panel ID="pnl_List" runat="server" Visible="false">
        <div class="jumbotron">
            <h3>Reports for training projects/modules</h3>
        </div>

        <asp:Repeater ID="rpt_List" runat="server">
            <HeaderTemplate>
                <table class="border" width="100%">
                    <tr>
                        <th>Project name</th>
                        <th>Module name</th>
                        <th></th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><%#DataBinder.Eval(Container.DataItem, "ProjectName") %></td>
                    <td><%#DataBinder.Eval(Container.DataItem, "ModuleName") %></td>
                    <td><a class="btn btn-default" href="<%=Request.Path %>?project=<%#DataBinder.Eval(Container.DataItem, "IdProject") %>&module=<%#DataBinder.Eval(Container.DataItem, "IdModule") %>">Details</a></td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </asp:Panel>

    <asp:Panel ID="pnl_Details" runat="server" Visible="false">
        <div class="jumbotron">
            <span style="float: right;"><input type="button" class="btn" value="Back" onclick="window.location='<%=Request.Path%>';" /></span>
            <table class="details">
                <tr>
                    <td>Project: </td>
                    <td><asp:Label ID="lb_ProjectName" runat="server"></asp:Label></td>
                </tr>
                <tr>
                    <td>Module:</td>
                    <td><asp:Label ID="lb_ModuleName" runat="server"></asp:Label></td>
                </tr>
                <tr>
                    <td>Job/position: </td>
                    <td><asp:Label ID="lb_Job" runat="server"></asp:Label></td>
                </tr>
            </table>
        </div>

        <asp:Repeater ID="rpt_Employees" runat="server">
            <HeaderTemplate>
                <table class="border" width="100%">
                    <tr>
                        <th>Employee name</th>
                        <th>Points</th>
                        <th></th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                    <tr>
                        <td><%#DataBinder.Eval(Container.DataItem, "EmployeeName") %></td>
                        <td><%#DataBinder.Eval(Container.DataItem, "Points") %></td>
                        <td>
                            <span <%#DataBinder.Eval(Container.DataItem, "Points", "{0}") == "" ? "style='display: none;'" : "" %>>
                            <a href="<%=Request.Path %>?<%=Request.QueryString %>&employee=<%#DataBinder.Eval(Container.DataItem, "IdEmployee") %>" class="btn btn-default">Details</a>
                            </span>
                        </td>
                    </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>

    </asp:Panel>

    <asp:Panel ID="pnl_Employee" runat="server" Visible="false">
        <div class="jumbotron">
            <span style="float: right;"><input type="button" class="btn" value="Back" onclick="window.location='<%=Request.Path + "?" + Q.WithoutKey("employee")%>';" /></span>
            <table class="details">
                <tr>
                    <td>Employee: </td>
                    <td><asp:Label ID="lb_EmployeeName" runat="server"></asp:Label></td>
                </tr>
                <tr>
                    <td>Module:</td>
                    <td><asp:Label ID="lb_EmployeeModule" runat="server"></asp:Label></td>
                </tr>
                <tr>
                    <td>Score:</td>
                    <td><asp:Label ID="lb_EmployeePoints" runat="server"></asp:Label></td>
                </tr>
            </table>
        </div>

        <asp:Repeater ID="rpt_EmployeeAnswers" runat="server">
            <HeaderTemplate>
                <table class="border" width="100%">
                    <tr>
                        <th>Question</th>
                        <th>Answers</th>
                        <th>Score</th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                    <tr>
                        <td><%#DataBinder.Eval(Container.DataItem, "Question") %></td>
                        <td><%#GetAnswers(Container.DataItem) %></td>
                        <td><%#DataBinder.Eval(Container.DataItem, "Points") %></td>
                    </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </asp:Panel>
        */
