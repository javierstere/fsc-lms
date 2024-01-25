<%@ Page Language="C#" Title="Training" MasterPageFile="~/Employee/Employee.Master" AutoEventWireup="true" CodeBehind="Training.aspx.cs" Inherits="FSC.Employee.Training" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">


    <asp:Panel ID="pnl_List" runat="server" Visible="false">

        <div class="jumbotron">
        <h3>Available training modules</h3>
        </div>

        <asp:Repeater ID="rpt_List" runat="server">
            <HeaderTemplate>
                <table class="border" width="100%">
                    <tr>
                        <th>Module</th>
                        <th>Type</th>
                        <th></th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                    <tr>
                        <td><%#DataBinder.Eval(Container.DataItem, "ModuleName") %></td>
                        <td><%#DataBinder.Eval(Container.DataItem, "Type") %></td>
                        <td><a target="_blank" href="<%=Request.Path %>?module=<%#DataBinder.Eval(Container.DataItem, "IdModule") %>">View</a></td>
                    </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>

    </asp:Panel>

    <asp:Panel ID="pnl_Details" runat="server" Visible="false">

        <asp:Panel ID="pnl_Youtube" runat="server" Visible="false">
            <br /><br />
            <input type="button" value="Back" onclick="window.location='<%=Request.Path%>';" /> to training modules
            <table width="100%">
                <tr>
                    <td align="center">
                        <%=_embed %>    
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <asp:Panel ID="pnl_PPT" CssClass="full-height" runat="server" Visible="false">
            <br /><br />
            <input type="button" value="Back" onclick="window.location = '<%=Request.Path%>';" /> to training modules
            <iframe src='https://view.officeapps.live.com/op/embed.aspx?src=http://lms.bdfoodsafety.com<%=_embed %>' width='100%' height='100%' frameborder='0'/>
        </asp:Panel>
    </asp:Panel>
</asp:Content>