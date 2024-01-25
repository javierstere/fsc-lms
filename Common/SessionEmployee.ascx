<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SessionEmployee.ascx.cs" Inherits="FSC.Common.SessionEmployee" %>


<asp:Panel ID="pnl_Select" runat="server" Visible="false">
    <br />
    Please search and add the employees for this session group<br /><br />
    Name: <input type="text" onkeyup="javascript:SessionEmployee_OnKeyUp(this);" />
    <input type="button" class="btn btn-primary" value="Add selected employees" onclick="javascript:SessionEmployee_OnAdd();" />
    <asp:Button ID="btn_Cancel" CssClass="btn btn-default" Text="Cancel" runat="server" OnClick="btn_Cancel_Click" />
    <br /><br />
    <table id="session-employees-add" class="border" width="100%">
       
    </table>
    <br /><br /><br />
    <script type="text/javascript">
        var added = 0;
        function SessionEmployee_OnAdd() {
            var checks = document.getElementsByTagName('input');
            added = 0;
            for (var i = 0; i < checks.length; i++) {
                if (checks[i].type == 'checkbox') {
                    if (checks[i].checked) {
                        //console.log(checks[i].id);
                        added++;
                        AjaxCall('add', checks[i].id.substr(4), OnAddedResponse);
                    }
                }
            }
            
            //setTimeout(function () { window.location = '<%=Request.Path + '?' + Request.QueryString.ToString() %>'; }, 500);
        }

        function OnAddedResponse(data) {
            added--;
            if (added <= 0)
                window.location = '<%=Request.Path + '?' + Request.QueryString.ToString() %>';
        }
        function SessionEmployee_OnKeyUp(txt) {
            var name = txt.value;
            var table = document.getElementById('session-employees-add');
            table.innerHTML = '';
            //console.log(txt.value);
            if (name != '')
                AjaxCall('list', name, OnEmployeeCandidatesList);
        }
        function OnEmployeeCandidatesList(list) {
            //console.log(JSON.stringify(list));
            var table = document.getElementById('session-employees-add');
            table.innerHTML = '';
            for (var i = 0; i < list.employees.length; i++) {
                var tr = document.createElement('tr');

                var tdcheck = document.createElement('td');
                tdcheck.width = '20px';
                var check = document.createElement('input');
                check.id = 'emp_' + list.employees[i].id;
                check.type = 'checkbox';
                tdcheck.appendChild(check);

                var tdname = document.createElement('td');
                var text = document.createTextNode(list.employees[i].name);
                tdname.appendChild(text);

                tr.appendChild(tdcheck);
                tr.appendChild(tdname);
                table.appendChild(tr);
            }
        }
        function AjaxCall(method, params, callback) {
            var xmlhttp = new XMLHttpRequest();
            var url = "<%=((Outpost.Utils.BaseWebPage)Page).BASE_ADDRESS%>/Common/SessionEmployeeAjax.aspx?cs=<%=_cs%>&method=" 
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
            //CONSOLE_INF('AjaxCall: ' + method + ' - ' + url);
            xmlhttp.open("GET", url, true);
            xmlhttp.send();
        }

    </script>
</asp:Panel>

<asp:Panel ID="pnl_List" runat="server">
    <script type="text/javascript">
        function OnCheckAll(cbx) {
            
            var checks = document.getElementsByTagName('input');
            for (var i = 0; i < checks.length; i++) {
                if (checks[i].type === 'checkbox') {
                    checks[i].checked = cbx.checked;
                }
            }
        }
    </script>
   
    <br /><br />
    <asp:Button ID="btn_Add" CssClass="btn btn-primary" runat="server" Text="Add" OnClick="btn_Add_Click" />
    employees for this session
    <br /><br />
    <asp:Panel ID="pnl_EmployeesList" runat="server" Visible="false">
        <asp:Repeater ID="rpt_EmployeesList" runat="server">
            <HeaderTemplate>
                <table width="100%" class="border">
                    <colgroup>
                        <col width="20px" />
                    </colgroup>
                    <tr>
                        <th><input type="checkbox" onclick="javascript: OnCheckAll(this);" /></th>
                        <th>Employee name</th>
                        <th>Invited on</th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td width="20px" ><input type="checkbox" name="emp_<%#DataBinder.Eval(Container.DataItem, "IdEmployee") %>" /></td>
                    <td><%#DataBinder.Eval(Container.DataItem, "EmployeeName") %></td>
                    <td><%#GetInvitedAtStr(Container.DataItem) %>
                        <!--<%#DataBinder.Eval(Container.DataItem, "InvitedAt") %>--></td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
        <br />
        <asp:Button ID="btn_DeleteEmployees" CssClass="btn" runat="server" Text="Remove" 
            OnClick="btn_DeleteEmployees_Click" 
            OnClientClick="return window.confirm('Are you sure you want remove selected employees from this session?');" /> 
        selected employees
        <br /><br />
    </asp:Panel>
    <asp:Panel ID="pnl_NoEmployees" runat="server" Visible="false">
        No employees added for this session yet.
        <br />
        Press "Add" button to add some.
    </asp:Panel>
    <asp:Panel ID="pnl_SendInvitations" runat="server" Visible="false">

        <asp:Button ID="btn_SendInvitation" CssClass="btn btn-default" runat="server" Text="Send" OnClick="btn_SendInvitation_Click"
            
            OnClientClick="return window.confirm('Are you sure you want send invitation emails to selected employees?');" /> 
        invitation to selected employees<br /><br />
        <asp:TextBox ID="tb_Invitation" runat="server" TextMode="MultiLine" Rows="15" Columns="70"></asp:TextBox><br />

    </asp:Panel>
</asp:Panel>
