<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Employee.ascx.cs" Inherits="FSC.Common.Employee" %>

<asp:Panel ID="pnl_List" runat="server" Visible="false">
      <h3>Employees</h3>
    <asp:Repeater ID="rpt_List" runat="server">
        <HeaderTemplate>
        <br />
            <table class="border" style="width: 100%;">
                <tr>
                    <th>Name</th>
                    <th>User name</th>
                    <th>Email</th>
                    <th>Position</th>
                    <th>Active<br /><input type="checkbox" onclick="javascript: CheckAll(this);" title="Check/uncheck all" /></th>
                    <th></th>
                </tr>
        </HeaderTemplate>
        <ItemTemplate>
                <tr>
                    <td><%#DataBinder.Eval(Container.DataItem, "EmployeeName") %></td>
                    <td><%#DataBinder.Eval(Container.DataItem, "EmployeeUser") %></td>
                    <td><%#DataBinder.Eval(Container.DataItem, "Email") %></td>
                    <td><%#DataBinder.Eval(Container.DataItem, "Job") %></td>
                    <td><input type="checkbox" onchange="javascript:Activate(this);" id="active_<%#DataBinder.Eval(Container.DataItem, "IdEmployee") %>" <%#DataBinder.Eval(Container.DataItem, "Active", "{0}") != "" ? "checked='checked'" : "" %></td>
                    <td><a href="<%=Request.Path %>?client=<%=_client %>&employee=<%#DataBinder.Eval(Container.DataItem, "IdEmployee") %><%=_extra %>" class="btn btn-primary">Edit &raquo;</a></td>
                </tr>
        </ItemTemplate>
        <FooterTemplate>
            </table>
        </FooterTemplate>
    </asp:Repeater>
    <br />
    <asp:Button ID="btn_EmployeeAdd" CssClass="btn btn-primary" runat="server" Text="Add employee &raquo;" OnClick="btn_EmployeeAdd_Click" />
    <script type="text/javascript">
        function CheckAll(cbx) {
            var cbxs = document.getElementsByTagName('input');
            for (var i = 0; i < cbxs.length; i++) {
                if (cbxs[i].type == 'checkbox' && cbxs[i].id.substr(0, 7) == 'active_') {
                    if (cbx.checked != cbxs[i].checked) {
                        console.log(cbxs[i].id);
                        cbxs[i].checked = !cbxs[i].checked;
                        Activate(cbxs[i]);
                    }
                }
            }
        }
        function AjaxCall(method, params, callback) {
            var xmlhttp = new XMLHttpRequest();
            var url = "<%=((Outpost.Utils.BaseWebPage)Page).BASE_ADDRESS%>/Common/EmployeeAjax.aspx?client=<%=_client%>&method="
                + method + "&params=" + params;// + method + params;

            xmlhttp.onreadystatechange = function () {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    if (callback != null) {
                        try {
                            if (xmlhttp.responseText != '') {
                                var data = JSON.parse(xmlhttp.responseText);
                                callback(data);
                            } else
                                callback(null);
                        } catch (err) {
                            console.log('AjaxCall: ' + method + ' - ' + url);
                            console.log(err.stack);
                            console.log(url + ' --- ' + err);
                            console.log('AjaxResponse: ' + xmlhttp.responseText);
                        }
                    }
                }
            }
            //console.log('AjaxCall: ' + method + ' - ' + url);
            xmlhttp.open("GET", url, true);
            xmlhttp.send();
        }
        function Activate(cbx) {
            var par = '!&employee=' + cbx.id.substr(7) + '&active=' + cbx.checked;
            AjaxCall('activate', par, OnActiveResponse);
        }
        function OnActiveResponse(response) {
            var cbx = document.getElementById('active_' + response.idemployee);
            if (cbx != null) cbx.checked = false;
            //alert(JSON.stringify(response));
        }
    </script>
</asp:Panel>

<asp:Panel ID="pnl_Details" CssClass="jumbotron" runat="server" Visible="false">
    <h3>Employee's details</h3>
    <table class="details" style="margin: 0 auto;" >
        <tr>
            <td>Employee name:</td>
            <td><asp:TextBox ID="tb_EmployeeName" runat="server" Width="400"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Employee user:</td>
            <td>
                <asp:TextBox ID="tb_EmployeeUser" runat="server" Width="400"></asp:TextBox>
                <br /><span style="font-size: smaller;">(fill if there are other employees with the same name)</span>
            </td>
        </tr>
        <tr>
            <td>Position:</td>
            <td><asp:TextBox ID="tb_Job" runat="server"></asp:TextBox>
                <%if(_jobs){ %>
                <asp:DropDownList ID="cmb_Job" runat="server"></asp:DropDownList>
                <br /><span style="font-size: smaller;">(add new or choose existing)</span>
                <script type="text/javascript">
                    function CopyJob(){
                        cmb = document.getElementById('<%=cmb_Job.ClientID%>');
                        tb = document.getElementById('<%=tb_Job.ClientID%>');

                        tb.value = cmb.options[cmb.selectedIndex].text;
                    }
                    function CopyJobIfEmpty(){
                        tb = document.getElementById('<%=tb_Job.ClientID%>');
                        if (tb.value == '')
                            CopyJob();
                    }
                </script>
                <%} %>
                </td>
        </tr>
        <tr>
            <td>Email:</td>
            <td>
                <asp:TextBox ID="tb_Email" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>Password:</td>
            <td><asp:TextBox ID="tb_Password1" runat="server" TextMode="Password"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Retype password:</td>
            <td><asp:TextBox ID="tb_Password2" runat="server" TextMode="Password"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="2" class="buttons">
                <asp:Button ID="btn_Save" runat="server" Text="Save" class="btn btn-primary" OnClick="btn_Save_Click" />
                <asp:Button ID="btn_Cancel" runat="server" Text="Cancel" class="btn btn-default" OnClick="btn_Cancel_Click" />
                <asp:Button ID="btn_Delete" runat="server" Text="Delete" class="btn" OnClientClick="return window.confirm('Are you sure you want to delete this Employee?');" OnClick="btn_Delete_Click" />

                <asp:Button ID="btn_SendPass" runat="server" Text="Send password" CssClass="btn" 
                    OnClientClick="return window.confirm('Are you sure you send the password to this Employee?');" 
                    OnClick="btn_SendPass_Click"  />
            </td>
        </tr>
    </table>
        <asp:Panel ID="pnl_SavedMessage" runat="server" Visible="false">
            Saved successfully
        </asp:Panel>
        <asp:Panel ID="pnl_PasswordSent" runat="server" Visible="false">
            Password sent to employee
        </asp:Panel>
    <asp:Panel ID="pnl_PassMistmatch" runat="server" Visible="false">
        Retype of password doesn’t match password field.
    </asp:Panel>
</asp:Panel>