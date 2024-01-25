<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="admin.aspx.cs" Inherits="FSC.admin" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <table width="100%">
        <tr>
            <td valign="top">
                <h3>Builders</h3>
                <asp:Repeater ID="rpt_Builder" runat="server">
                    <ItemTemplate>
                        <div style="border: solid 1px #ddd; padding: 2px; margin: 2px;">
                            <a href="<%=Request.Path %>?buil=<%#DataBinder.Eval(Container.DataItem, "IdBuilder") %>&type=<%#DataBinder.Eval(Container.DataItem, "type") %>"><%#DataBinder.Eval(Container.DataItem, "BuilderName") %></a> 
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </td>
            <td valign="top">
                <h3>Clients</h3>
                <asp:Repeater ID="rpt_Client" runat="server">
                    <ItemTemplate>
                        <div style="border: solid 1px #ddd; padding: 2px; margin: 2px; height: 110px;">
                            <div style="float: right; overflow: auto; height: 100px; width: 300px;">
                                <asp:Repeater ID="rpt_Employee" runat="server">
                                    <ItemTemplate>
                                        <div><a href="<%=Request.Path %>?link=<%#DataBinder.Eval(Container.DataItem, "Link") %>&name=<%#DataBinder.Eval(Container.DataItem, "EmployeeName") %>&empl=<%#DataBinder.Eval(Container.DataItem, "IdEmployee") %>&clie=<%#DataBinder.Eval(Container.DataItem, "IdClient") %>"><%#DataBinder.Eval(Container.DataItem, "EmployeeName") %></a></div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                            Client: <a href="<%=Request.Path %>?link=<%#DataBinder.Eval(Container.DataItem, "Link") %>&clie=<%#DataBinder.Eval(Container.DataItem, "IdClient") %>&cli=!"><%#DataBinder.Eval(Container.DataItem, "ClientName") %></a>
                            <asp:Repeater ID="rpt_University" runat="server">
                                <ItemTemplate>
                                    <div>University: <%#DataBinder.Eval(Container.DataItem, "Link") %></div>
                                </ItemTemplate>
                            </asp:Repeater>
                            <asp:Repeater ID="rpt_Administrator" runat="server">
                                <ItemTemplate>
                                    <div>Admin: <a href="<%=Request.Path %>?link=<%#DataBinder.Eval(Container.DataItem, "Link") %>&name=<%#DataBinder.Eval(Container.DataItem, "AdministratorName") %>&admi=<%#DataBinder.Eval(Container.DataItem, "IdAdministrator") %>&clie=<%#DataBinder.Eval(Container.DataItem, "IdClient") %>"> <%#DataBinder.Eval(Container.DataItem, "AdministratorName") %></a></div>
                                </ItemTemplate>
                            </asp:Repeater>                                
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </td>
        </tr>
    </table>
</asp:Content>