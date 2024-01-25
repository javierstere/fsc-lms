<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Report.ascx.cs" Inherits="FSC.Common.Report" %>

<style>
    .tab-label {
        padding: 10px;
        display: inline-block;
        border: solid 1px #000;
        margin: 5px;
    }

    .selected {
        background-color: #ddd;
    }
</style>

<asp:Panel ID="pnl_Search" runat="server" CssClass="jumbotron" style="text-align:center;" Visible="false">
         
        <h3>Employee's report</h3>
        Name: <asp:TextBox ID="tb_Search" runat="server"></asp:TextBox>
         <asp:Button id="btn_Search" runat="server" CssClass="btn btn-primary" Text="Search" OnClick="btn_Search_Click"/>
</asp:Panel>

<asp:Panel ID="pnl_List" runat="server" Visible="false">

    <div class="tab-label <%=Q["s"]=="i"?"selected" : "" %>">
        <a href="<%=Request.Path %>?client=<%=_client %>&s=i<%=_extra %>">Individual sessions</a>
    </div>
    <div class="tab-label <%=Q["s"]=="g"?"selected" : "" %>">
        <a href="<%=Request.Path %>?client=<%=_client %>&s=g<%=_extra %>">Group sessions</a>
    </div>
    <!--
    <div class="tab-label <%=Q["s"]=="o"?"selected" : "" %>">
        <a href="<%=Request.Path %>?s=o">Direct observation</a>
    </div>
    -->
    <asp:Repeater ID="rpt_List" runat="server" Visible="false">
        <HeaderTemplate>
            <table class="border" width="100%">
                <tr>
                    <th style="text-align:center;">Name</th>
                    <th style="text-align:center;">Username</th>
                    <th style="text-align:center;"><%=Q["s"]=="g"?"Group session" : "Individual session" %></th>
                    <th style="text-align:center;">Date</th>
                    <th style="text-align:center;">Score</th>
                    <%if (Q["s"] == "i" || Q["s"] == null)
                        { %>
                    <th style="text-align:center;">Direct<br />observation<br />result</th>
                    <%} %>
                    <th style="text-align:center;"></th>
                </tr>
        </HeaderTemplate>
        <ItemTemplate>
                <tr>
                    <td><%#DataBinder.Eval(Container.DataItem, "EmployeeName") %></td>
                    <td><%#DataBinder.Eval(Container.DataItem, "EmployeeUser") %></td>
                    <td><%#DataBinder.Eval(Container.DataItem, "ModuleName") %></td>
                    <td><%#DataBinder.Eval(Container.DataItem, "Timestamp", "{0: MM/dd/yyyy}") %></td>
                    <td><%#DataBinder.Eval(Container.DataItem, "Points") %></td>
                    <%if (Q["s"] == "i" || Q["s"] == null)
                        { %>
                    <td>
                        <%#DataBinder.Eval(Container.DataItem, "Passed", "{0}") == "1" ? "Acceptable" : "" %>
                        <%#DataBinder.Eval(Container.DataItem, "Passed", "{0}") == "0" ? "Unacceptable" : "" %>
                        <%#DataBinder.Eval(Container.DataItem, "Passed", "{0}") == "." ? "(under observation)" : "" %>
                    </td>
                    <%} %>
                    <td>
                        <%#GetDetailsLink(Container.DataItem) %>    
                    </td>
                </tr>
        </ItemTemplate>
        <FooterTemplate>
            </table>
        </FooterTemplate>
    </asp:Repeater>
    <asp:Repeater ID="rpt_ListDO" runat="server" Visible="false">
        <HeaderTemplate>
            <table class="border" width="100%">
                <tr>
                    <th>Employee name</th>
                    <th>Observer</th>
                    <th>Module</th>
                    <th>Date</th>
                    <th>Passed</th>
                </tr>
        </HeaderTemplate>
        <ItemTemplate>
                <tr>
                    <td><%#DataBinder.Eval(Container.DataItem, "EmployeeName") %></td>
                    <td><%#DataBinder.Eval(Container.DataItem, "AdministratorName") %></td>
                    <td><%#DataBinder.Eval(Container.DataItem, "ModuleName") %></td>
                    <td><%#DataBinder.Eval(Container.DataItem, "Date", "{0: MM/dd/yyyy}") %></td>
                    <td>
                        <%#DataBinder.Eval(Container.DataItem, "Passed", "{0}") == "1" ? "Passed" : "" %>
                        <%#DataBinder.Eval(Container.DataItem, "Passed", "{0}") == "0" ? "Not passed" : "" %>
                    </td>
                </tr>
        </ItemTemplate>
        <FooterTemplate>
            </table>
        </FooterTemplate>
    </asp:Repeater>
    <br />
    <asp:Button id="btn_Export" runat="server" CssClass="btn btn-primary" Text="Export" OnClick="btn_Export_Click"/> this into XLS file.
</asp:Panel>

<asp:Panel ID="pnl_Details_DC" runat="server" Visible="false">
    <div class="jumbotron">
        <span style="float: right;"><input type="button" class="btn btn-primary" value="Back" onclick="window.location = '<%=Request.Path + "?" + Q.WithoutKey("module")%>';" /></span>
        
        <h3>Employee: <asp:Label ID="lb_Employee" runat="server"></asp:Label></h3>
            
        <br />
        <span id="time"></span>
        <br />
        <h4>Module: <b><asp:Label ID="lb_Module" runat="server"></asp:Label></b></h4>
        <b><span id="time"></span></b>
        <h4>Result of direct observation: <b><asp:Label ID="lb_Result" runat="server"></asp:Label></b>
        </h4>
            
        Person conducting Direct Observation: <b><asp:Label ID="lb_Admin" runat="server"></asp:Label></b>

<script type="text/javascript">
    function DisplayTime() {
        var dt = new Date(<%=_time %>);
        $("#time").text(dt);
    }

    DisplayTime();
</script>
    </div>
</asp:Panel>

<asp:Panel ID="pnl_Details" runat="server" Visible="false">

    <div class="jumbotron">
            <%if (Q["module"] != null)
                { %>
            <span style="float: right;"><input type="button" class="btn btn-primary" value="Back" onclick="window.location='<%=Request.Path + "?" + Q.WithoutKey("module")%>';" /></span>
            <% }
            else
            { %>
            <span style="float: right;"><input type="button" class="btn" value="Back" onclick="window.location='<%=Request.Path + "?" + Q.WithoutKey("cs")%>';" /></span>
            <%} %>
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
                    <td>Date:</td>
                    <td><asp:Label ID="lb_Timestamp" runat="server"></asp:Label></td>
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