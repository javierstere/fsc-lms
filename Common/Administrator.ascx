<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Administrator.ascx.cs" Inherits="FSC.Common.Administrator" %>



<asp:Panel ID="pnl_ListAdministrator" runat="server" Visible="false">
    <h3 style="text-align: center;">Administrators</h3>

    <asp:Panel ID="pnl_NoAdminstrator" runat="server" Visible="false">
        There is no administrator for this client.
    </asp:Panel>
            <asp:Repeater ID="rpt_Administrators" runat="server">
                <HeaderTemplate>
                    <table class="border" width="100%">
                        <tr>
                            <th>Name</th>
                            <th>Job title</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th></th>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td><%#DataBinder.Eval(Container.DataItem, "AdministratorName") %></td>
                        <td><%#DataBinder.Eval(Container.DataItem, "JobTitle") %></td>
                        <td><%#DataBinder.Eval(Container.DataItem, "Email") %></td>
                        <td><%#DataBinder.Eval(Container.DataItem, "Phone") %></td>
                        <td><a href="<%=Request.Path %>?client=<%=_client %>&admin=<%#DataBinder.Eval(Container.DataItem, "IdAdministrator") %><%=_extra %>" class="btn btn-primary">Edit &raquo;</a></td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
                    <br />
            <asp:Button ID="btn_AdministratorAdd" CssClass="btn btn-primary" runat="server" Text="Add administrator &raquo;" OnClick="btn_AdministratorAdd_Click" />
        </asp:Panel>
        <asp:Panel ID="pnl_DetailsAdministrator" CssClass="jumbotron" runat="server" Visible="false" style="text-align: center;">
            
            <h4>Administrator's details</h4>

            <table class="details"  style="margin: 0 auto;">
                <tr>
                    <td>Administrator name:</td>
                    <td><asp:TextBox ID="tb_AdministratorName" runat="server" Width="250"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Job title:</td>
                    <td><asp:TextBox ID="tb_AdministratorJobTitle" runat="server" Width="250"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Phone:</td>
                    <td><asp:TextBox ID="tb_AdministratorPhone" runat="server" Width="250"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Email:</td>
                    <td><asp:TextBox ID="tb_AdministratorEmail" runat="server" Width="250"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Password:</td>
                    <td>
                        <asp:TextBox ID="tb_Password1" runat="server" TextMode="Password"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>Retype password:</td>
                    <td><asp:TextBox ID="tb_Password2" runat="server" TextMode="Password"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="2" class="buttons">

                        <asp:Button ID="btn_SaveAdministrato" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btn_SaveAdministrator_Click" />
                        <asp:Button ID="btn_CancelAdministrator" runat="server" Text="Cancel" CssClass="btn btn-default" OnClick="btn_CancelAdministrator_Click" />
                        <asp:Button ID="btn_DeleteAdministrator" runat="server" Text="Delete" OnClientClick="return window.confirm('Are you sure you want to delete this administrator?');" 
                            CssClass="btn" OnClick="btn_DeleteAdministrator_Click" />
                    </td>

                </tr>

            </table>


        </asp:Panel>