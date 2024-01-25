<%@ Page Title="Login" MasterPageFile="~/Client/Client.Master" Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="FSC.Client.Login" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
    <style>
    
    table.center {
    margin-left:auto; 
    margin-right:auto;
  }
        </style>
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">


    <div class="jumbotron" style="text-align:center;">
         
        <h3><%=S["Client.Description"] %></h3>
        <table class="center" >
            <tr>
                <td>Username:</td>
                <td><asp:TextBox ID="tb_Username" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
            <tr>
                 <td>Password:</td>
                 <td><asp:TextBox ID="tb_Password" runat="server" TextMode="Password"></asp:TextBox> </td>

            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
        <asp:Panel ID="pnl_WrongUserPass" runat="server" Visible="false">
             User or password incorrect
         </asp:Panel>

         <asp:Button id="btn_Login" runat="server" CssClass="btn btn-primary" Text="Login" OnClick="btn_Login_Click" />
         <!--<asp:Button id="btn_LostPassword" runat="server" CssClass="btn btn-primary" Text="Lost your password?" OnClick="btn_LostPassword_Click" />-->
         <br /><br />
             
    </div>
</asp:Content>