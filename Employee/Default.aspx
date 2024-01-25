<%@ Page Title="Employee's page" Language="C#" MasterPageFile="~/Employee/Employee.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="FSC.Employee.Default" %>

<%@ Register TagPrefix="Common" TagName="QuizView" Src="~/Common/QuizView.ascx" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel ID="pnl_List" runat="server" Visible="false">

        <div class="row">
            <div class="col-md-12" style="align-content: center; text-align: center;">
                <br />
                <img src="/Resources/i1.jpg" class="img-responsive" style="display: inline-block;" />
                <img src="/Resources/i2.jpg" class="img-responsive" style="display: inline-block;" />
                <img src="/Resources/i3.jpg" class="img-responsive" style="display: inline-block;" />
                <!--  width="347" height="231"  -->
            </div>
        </div>

        <div class="jumbotron">

            <%if (System.IO.File.Exists(MapPath("/Client/Logo/") + _client + ".png"))
                { %>
            <img style="float: right; margin-top: -20px;" src="/Client/Logo/<%=_client %>.png" height="100" />
            <%}
                else
                { %>
            <img style="float: right; margin-top: -20px;" src="/Resources/doceo.png" height="100" />
            <%} %>



            <h3>Hi, <%=(string)S["Client.EmployeeName"] %></h3>
            <p>Welcome to your training/quiz page</p>

        </div>

        <asp:Panel ID="pnl_ClientSession" runat="server" Visible="false">
            <div class="jumbotron">
                <h3>Please connect to the active training session from bellow</h3>

                <asp:Repeater ID="rpt_ClientSession" runat="server">
                    <HeaderTemplate>
                        <table class="border" width="100%">
                            <tr>
                                <th>Session</th>
                                <th></th>
                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><%#DataBinder.Eval(Container.DataItem, "SessionName") %></td>
                            <td><a href="Session.aspx?session=<%#DataBinder.Eval(Container.DataItem, "IdClientSession") %>">Join</a></td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </asp:Panel>



        <asp:Repeater ID="rpt_ListQuiz" runat="server">
            <HeaderTemplate>
                <div class="jumbotron">
                    <h3>INSTRUCTIONS for individual trainings</h3>
                    <p>1. Click on “View” link to start the training</p>
                    <p>2. After completing the module the “start” link will activate in Quiz column</p>
                    <p>3. Click on “start” link to take the quiz, if your score is less than 75 please retake the quiz</p>
                    <table class="border" width="100%">
                        <tr>
                            <th>Module</th>
                            <th>Training</th>
                            <th>Quiz</th>
                            <th>Score</th>
                            <th>Date</th>
                        </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><%#DataBinder.Eval(Container.DataItem, "ModuleName") %></td>
                    <td><a href="javascript:View(<%#DataBinder.Eval(Container.DataItem, "IdModule") %>)">View</a></td>
                    <td>
                        <%#StartButton(Container.DataItem) %>
                        <span <%#DataBinder.Eval(Container.DataItem, "IdEmployeeQuiz", "{0}") == "" ? "style='display: none;'" : "" %>></span>
                    </td>
                    <td><span id="points_<%#DataBinder.Eval(Container.DataItem, "IdModule") %>"><%#DataBinder.Eval(Container.DataItem, "Points") %></span></td>
                    <td><%#DataBinder.Eval(Container.DataItem, "timestamp", "{0:MM/dd/yyyy}") %></td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
                </div>
            </FooterTemplate>
        </asp:Repeater>

        <asp:Repeater ID="rpt_ListDC" runat="server">
            <HeaderTemplate>
                <div class="jumbotron">
                    <h3>INSTRUCTIONS for direct observation trainings</h3>
                    <p>1. Click on “View” link to start the training</p>
                    <p>2. After completing the module a person will observe you how you complete some tasks</p>
                    <p>3. You will receive an acceptable or unacceptable score</p>
                    <table class="border" width="100%">
                        <tr>
                            <th>Module</th>
                            <th>Training</th>
                            <th>Direct observation</th>
                            <th>Date</th>
                        </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <tr>
                        <td><%#DataBinder.Eval(Container.DataItem, "ModuleName") %></td>
                        <td><a href="javascript:View(<%#DataBinder.Eval(Container.DataItem, "IdModule") %>)">View</a></td>
                        <td>
                            <%#DataBinder.Eval(Container.DataItem, "Passed", "{0}") == "1" ? "Acceptable" : "" %>
                            <%#DataBinder.Eval(Container.DataItem, "Passed", "{0}") == "0" ? "Unacceptable" : "" %>
                            <%#DataBinder.Eval(Container.DataItem, "Passed", "{0}") == "." ? "(under observation)" : "" %>
                        </td>
                        <td><%#DataBinder.Eval(Container.DataItem, "Date", "{0:MM/dd/yyyy}") %></td>
                    </tr>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
                </div>
            </FooterTemplate>
        </asp:Repeater>

        <asp:Repeater ID="rpt_ListCourse" runat="server">
            <HeaderTemplate>
                <div class="jumbotron">
                    <h3>INSTRUCTIONS for Self-paced Courses</h3>
                    <p>1. Click on “View” link to start the training</p>
                    <p>2. After completing the module the “start” link will activate in Quiz column</p>
                    <p>3. Click on “start” link to take the quiz, if your score is less than 75 please retake the quiz</p>
                    <table class="border" width="100%">
                        <tr>
                            <th>Module</th>
                            <th>Status</th>
                            <th>Training</th>
                            <th>Quiz</th>
                        </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><%#DataBinder.Eval(Container.DataItem, "ModuleName") %></td>
                    <td><%#CourseStatusText(Container.DataItem) %></td>
                    <td>
                        <a href="javascript:View(<%#DataBinder.Eval(Container.DataItem, "IdModule") %>)">View</a>
                    </td>
                    <td>
                        <%#CourseAction(Container.DataItem) %>
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
                </div>
            </FooterTemplate>
        </asp:Repeater>

        <script type="text/javascript">
            function Closed() {
                alert('This quiz is closed. You can start a quiz only 3 times.');
            }
            function View(id) {
                //ChangeToRefresh(id);
                setTimeout(function () {
                    window.location.reload(false);
                }, 60 * 1000);
                window.open('<%=Request.Path %>?view=' + id, '_blank');
            }
            function Start(id) {
                //ChangeToRefresh(id);
                window.open('<%=Request.Path %>?module=' + id, '_blank');
            }
            function ChangeToRefresh(id) {
                var span = document.getElementById('points_' + id);
                if (span != null)
                    span.innerHTML = "<a href='javascript:window.location.reload(false);'>reload</a>";
            }
        </script>
    </asp:Panel>

    <asp:Panel ID="pnl_Quiz" runat="server" Visible="false">
        <Common:QuizView runat="server" />
    </asp:Panel>


    <asp:Panel ID="pnl_View" CssClass="full-height" runat="server" Visible="false">

        <asp:Panel ID="pnl_Youtube" runat="server" Visible="false">
            <br />
            <br />
            <input type="button" value="Back" onclick="window.location = '<%=Request.Path%>';" />
            to training modules
            <table width="100%">
                <tr>
                    <td align="center">
                        <%=_embed %>    
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <asp:Panel ID="pnl_PPT" CssClass="full-height" runat="server" Visible="false">
            <br />
            <br />
            <input type="button" value="Back" onclick="window.location = '<%=Request.Path%>';" />
            to training modules
            <iframe src='https://view.officeapps.live.com/op/embed.aspx?src=http://lms.bdfoodsafety.com<%=_embed %>' width='100%' height='100%' frameborder='0' />
        </asp:Panel>
    </asp:Panel>

</asp:Content>
