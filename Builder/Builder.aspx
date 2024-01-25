<%@ Page Title="Builder" Language="C#" MasterPageFile="~/Builder/Builder.Master" AutoEventWireup="true" CodeBehind="Builder.aspx.cs" Inherits="FSC.Builder.Builder" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

<asp:Panel id="pnl_List" runat="server" Visible="false">
    <div class="jumbotron" style="text-align:center;">
         
        <h3>Manage (co)builders</h3>

         
    </div>
    
    <asp:Panel ID="pnl_NoBuilders" runat="server" Visible="false" CssClass="jumbotron">
        <h4 class="red">No (co)builders found</h4>
    </asp:Panel>

    <asp:Panel ID="pnl_BuilderSaved" runat="server" Visible="false">
        <h4 class="red">(Co)builder saved</h4>
    </asp:Panel>

    <asp:Repeater ID="rpt_List" runat="server">
        <HeaderTemplate>
            <table class="border" width="100%">
                <tr>
                    <th>Name</th>
                    <th>Phone</th>
                    <th>Email</th>
                    <th>Initiation date</th>
                    <th>Type</th>
                    <th></th>
                </tr>
        </HeaderTemplate>
        <ItemTemplate>
            <tr>
                <td><%#DataBinder.Eval(Container.DataItem, "BuilderName") %></td>
                <td><%#DataBinder.Eval(Container.DataItem, "Phone") %></td>
                <td><%#DataBinder.Eval(Container.DataItem, "Email") %></td>
                <td><%#DataBinder.Eval(Container.DataItem, "InitiationDate", "{0:MM/dd/yyyy}") %></td>
                <td>
                    <%#DataBinder.Eval(Container.DataItem, "Type", "{0}") == "C" ? "Co-builder" : "" %>
                    <%#DataBinder.Eval(Container.DataItem, "Type", "{0}") == "B" ? "Builder" : "" %>
                </td>
                <td><a href="<%=Request.Path %>?builder=<%#DataBinder.Eval(Container.DataItem, "IdBuilder") %>" class="btn btn-primary">Edit &raquo;</a></td>
            </tr>
        </ItemTemplate>
        <FooterTemplate>
            </table>
            <br />
        </FooterTemplate>
    </asp:Repeater>
    <asp:Button id="btn_AddNew" runat="server" CssClass="btn btn-primary" Text="Add new" OnClick="btn_AddNew_Click" />
    
</asp:Panel>

<asp:Panel ID="pnl_Details" runat="server" Visible="false">
    <div class="jumbotron" style="text-align:center;">
        <h4>(Co)builder's details</h4>
        <table class="details"  style="margin: 0 auto;">
            <tr>
                <td>(Co)builder name:</td>
                <td><asp:TextBox ID="tb_BuilderName" runat="server" Width="250"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Phone:</td>
                <td><asp:TextBox ID="tb_Phone" runat="server" Width="250"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Email:</td>
                <td><asp:TextBox ID="tb_Email" runat="server" Width="250"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Initiation date:</td>
                <td><asp:TextBox ID="tb_InitiationDate" runat="server" Width="250"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Type:</td>
                <td><asp:DropDownList ID="cmb_Type" runat="server">
                        <asp:ListItem Value="C" Text="Co-builder"></asp:ListItem>
                        <asp:ListItem Value="B" Text="Builder"></asp:ListItem>
                    </asp:DropDownList></td>
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

                    <asp:Button ID="btn_Save" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btn_Save_Click" />
                    <asp:Button ID="btn_Cancel" runat="server" Text="Cancel" CssClass="btn btn-default" OnClick="btn_Cancel_Click" />
                    <asp:Button ID="btn_Delete" runat="server" Text="Delete" CssClass="btn" OnClientClick="return window.confirm('Are you sure you want to delete this (co)builder?');"  OnClick="btn_Delete_Click" />
                </td>

            </tr>

        </table>
    </div>
</asp:Panel>

</asp:Content>