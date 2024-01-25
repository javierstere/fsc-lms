<%@ Page Language="C#" Title="Quiz" MasterPageFile="~/Employee/Employee.Master" AutoEventWireup="true" CodeBehind="Quiz.aspx.cs" Inherits="FSC.Employee.Quiz" %>
<%@ Register TagPrefix="Common" TagName="QuizView" Src="~/Common/QuizView.ascx" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="pnl_List" runat="server" Visible="false">
        <div class="jumbotron">
            <h3>Available quizzes</h3>
        </div>

        <asp:Repeater ID="rpt_List" runat="server">
            <HeaderTemplate>
                <table class="border" width="100%">
                    <tr>
                        <th>Module</th>
                        <th>Status</th>
                        <th>Points</th>
                        <th></th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                    <tr>
                        <td><%#DataBinder.Eval(Container.DataItem, "ModuleName") %></td>
                        <td><%#DataBinder.Eval(Container.DataItem, "Type") %></td>
                        <td><%#DataBinder.Eval(Container.DataItem, "Points") %></td>
                        <td><a target="_blank" href="<%=Request.Path %>?module=<%#DataBinder.Eval(Container.DataItem, "IdModule") %>">Quiz</a></td>
                    </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </asp:Panel>

    <asp:Panel ID="pnl_Details" runat="server" Visible="false">

        <Common:QuizView runat="server" />

    </asp:Panel>

</asp:Content>