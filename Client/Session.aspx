<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Client/Client.Master"  CodeBehind="Session.aspx.cs" Inherits="FSC.Client.Session" %>
<%@ Register TagPrefix="Common" TagName="SessionEmployee" Src="~/Common/SessionEmployee.ascx" %>

<asp:Content ContentPlaceHolderID="head" runat="server">

    
<style>
.header{
    position:fixed;
    width:100%;
    top:0;
    left:0;
    height:80px;
    background:#eee;
}
.entry-menu{
    position:fixed;
    top:80px;
    width:200px;
    height: 100%;
    background: #EEF;
}
.entry-content-right{
    width:99%;
    margin: 0px;
    padding: 0px;
}
.entry-content{
    padding: 0px;
    margin-top: 80px;
}
.entry-content-right-padding{
    padding-left: 220px;
}
</style>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel ID="pnl_List" runat="server" Visible="false">
         <h3>Group sessions</h3>
        <asp:Repeater ID="rpt_List" runat="server">
            <HeaderTemplate>
                <table class="border" width="100%">
                    <tr>
                        <th>Session name</th>
                        <th>Training template</th>
                        <th>Session date/time</th>
                        <th></th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                    <tr>
                        <td><%#DataBinder.Eval(Container.DataItem, "SessionName") %></td>
                        <td><%#DataBinder.Eval(Container.DataItem, "TemplateName") %></td>
                        <td><%#GetSessionDateStr(Container.DataItem) %></td>
                        <td><a href="<%=Request.Path %>?cs=<%#DataBinder.Eval(Container.DataItem, "IdClientSession") %>" class="btn btn-primary">Details &raquo;</a></td>
                    </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
        <asp:Button id="btn_AddNew" runat="server" CssClass="btn btn-primary" Text="Add new group session" OnClick="btn_AddNew_Click" />
    </asp:Panel>

    <asp:Panel ID="pnl_Add" runat="server" Visible="false">
        Choose one training template or press <asp:Button ID="btn_Cancel" runat="server" CssClass="btn btn-default" Text="Cancel" OnClick="btn_Cancel_Click" />
        <br /><br />
        <table class="border">
            <tr>
                <td>Training template: </td>
                <td><asp:DropDownList ID="cmb_TrainingSession" runat="server"></asp:DropDownList></td>
            </tr>
            <tr>
                <td>Session name:</td>
                <td><asp:TextBox ID="tb_SessionName" runat="server"></asp:TextBox></td>
            </tr>
        </table>
        <br /><br />
        <asp:Button ID="btn_Add" runat="server" CssClass="btn btn-default" Text="Save" OnClick="btn_Add_Click" />
            
    </asp:Panel>

    <asp:Panel ID="pnl_Details" runat="server" Visible="false">
        <table width="100%">
            <colgroup>
                <col width="50%" valign="top" />
                <col width="50%" valign="top" />
            </colgroup>
            <tr>
                <td width="50%" valign="top">
                    <br /><br />
                    <table class="details">
                        <tr>
                            <td colspan="2">
                                <asp:button ID="btn_StartSession" runat="server" CssClass="btn btn-primary" Text="Start" OnClick="btn_StartSession_Click" />
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:button ID="btn_Cancel2" runat="server" CssClass="btn btn-default" Text="Cancel" OnClick="btn_Cancel_Click" />
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:button ID="btn_DeleteSession" runat="server" CssClass="btn" Text="Delete" OnClick="btn_DeleteSession_Click" OnClientClick="return window.confirm('Are you sure you want to delete this Group session?');" />
                            </td>
                        </tr>
                        <tr>
                            <td>Session name:</td>
                            <td><b><asp:Label ID="lb_SessionName" runat="server"></asp:Label></b></td>
                        </tr>    
                        <tr>
                            <td>Training template:</td>
                            <td><asp:Label ID="lb_Template" runat="server"></asp:Label></td>
                        </tr>    
                        <!--tr>
                            <td>For position:</td>
                            <td><asp:DropDownList ID="cmb_Job" runat="server"></asp:DropDownList></td>
                        </tr-->
                        <tr>
                            <td>Location:</td>
                            <td><asp:TextBox id="tb_Location" runat="server"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td>Date:</td>
                            <td><asp:TextBox ID="tb_SessionDate" runat="server" Width="100"></asp:TextBox> mm/dd/yyyy</td>
                        </tr>
                        <tr>
                            <td>Time:</td>
                            <td>
                                <asp:TextBox ID="tb_SessionTime" runat="server" Width="50"></asp:TextBox> hh:mm
                                <asp:DropDownList ID="cmb_AMPM" runat="server">
                                    <asp:ListItem Text="AM"></asp:ListItem>
                                    <asp:ListItem Text="PM"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:DropDownList ID="cmb_TimeZone" runat="server">
                                    <asp:ListItem Text="Eastern" Value="-5"></asp:ListItem>
                                    <asp:ListItem Text="Central" Value="-6"></asp:ListItem>
                                    <asp:ListItem Text="Mountain" Value="-7"></asp:ListItem>
                                    <asp:ListItem Text="Pacific" Value="-8"></asp:ListItem>
                                    <asp:ListItem Text="Alaska" Value="-9"></asp:ListItem>
                                    <asp:ListItem Text="Hawaii" Value="-10"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>Reminder before session:</td>
                            <td>
                                <asp:DropDownList ID="cmb_ReminderOffset" runat="server"></asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <center>
                                <asp:Button ID="btn_Save" runat="server" CssClass="btn btn-primary" Text="Save"  OnClick="btn_Save_Click" />
                                    </center>
                            </td>
                        </tr>
                    </table>
                    <br /><br />
                </td>
                <td width="50%" valign="top">
                    <Common:SessionEmployee runat="server" />
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>