<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SessionRun.aspx.cs" Inherits="FSC.Client.SessionRun" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

<style>
body{
	margin: 0px;
	padding: 0px;
}
.header{
    position:fixed;
    width:100%;
    top:0;
    left:0;
    height:25px;
    background:#eee;
}
.entry-menu{
    position:fixed;
    top:25px;
    width:200px;
    height: 100%;
    background: #EEF;
}
.entry-content-right{
    position:fixed;
    top:25px;

    width:99%;
    height:99%;
    margin: 0px;
    padding: 0px;
}
.entry-content{
    padding: 0px;
    margin-top: 25px;
}
.entry-content-right-padding{
    padding-left: 220px;
    height:99%;
}

.text-center{
    height: 100%;
    width: 100%;
    display: table;
}

.text-center-child{
    display: table-cell;
    vertical-align: middle;
    text-align: center;
}

.employee{
    padding: 3px;
}

.red {
    color: red;
}
.green {
    color: green;
}
.blue {
    color: blue;
}

#pnl_Z{
    height: 100%;
}

</style>
</head>
<body>
    <form id="form1" runat="server">
        <div>

            <div class="header" id="buttons">
                <div style="float: left;">
                    <asp:Button ID="btn_Close" runat="server" Text="Close" OnClick="btn_Close_Click" />
                </div>
                <center>
                    <b><asp:Label id="lb_StepName" runat="server"></asp:Label></b>
                    <asp:Button ID="btn_Prev" runat="server" Text="Prev" OnClick="btn_Prev_Click" />
                    <asp:Button ID="btn_Next" runat="server" Text="Next" OnClick="btn_Next_Click" />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="btn_Question" runat="server" Text="Question" OnClick="btn_Question_Click" />
                    <script type="text/javascript">
                        var btnq = document.getElementById('<%=btn_Question.ClientID%>');
                        btnq.disabled = true;

                        <%if (_enable_question) { %>
                        setTimeout(function () {
                            var btnq = document.getElementById('<%=btn_Question.ClientID%>');
                            btnq.disabled = false;
                        }, <%=_presentation_duration%> * 1000);
                        <%}%>

                        <%if (_enable_next) { %>
                        setTimeout(function () {
                            var btnn = document.getElementById('<%=btn_Next.ClientID%>');
                            btnn.disabled = false;
                        }, <%=_time_to_answer%> * 1000);
                        <%}%>

                    </script>
                </center>
            </div>
            <div class="entry-content">
                <div id="employees" class="entry-menu">
                    

                </div>
                <script type="text/javascript">
                    function AjaxCall(method, params, callback){
                            var xmlhttp = new XMLHttpRequest();
                            var url = "<%=Request.Path%>?ajax=1&cs=<%=_cs%>";// + method + params;
                        xmlhttp.onreadystatechange = function () {
                            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                                if (callback != null) {
                                    try {
                                        var data = JSON.parse(xmlhttp.responseText);
                                        callback(data);
                                    } catch (err) {
                                        console.log(err.stack);
                                        console.log(url + ' --- ' + err);
                                        console.log('AjaxCall: ' + method + ' - ' + url);
                                        console.log('AjaxResponse: ' + xmlhttp.responseText);
                                    }
                                }
                            }
                        }
                        //CONSOLE_INF('AjaxCall: ' + method + ' - ' + url);
                        xmlhttp.open("GET", url, true);
                        xmlhttp.send();
                    }


                    setInterval(GetEmployees, 3 * 1000);
                    function GetEmployees() {
                        AjaxCall(null, null, OnGetEmployeesResponse)
                    }
                    function OnGetEmployeesResponse(data) {
                        console.log(JSON.stringify(data));
                        var container = document.getElementById('employees');
                        while (container.firstChild) {
                            container.removeChild(container.firstChild);
                        }

                        for (var i = 0; i < data.employees.length; i++) {
                            var employee = document.createElement('div');
                            employee.className = 'employee';
                            employee.innerHTML = data.employees[i].name;
                            if (data.employees[i].answered)
                                employee.className += ' green';
                            else if (data.employees[i].connected)
                                employee.className += ' blue';
                            else
                                employee.className += ' red';
                            container.appendChild(employee);
                        }
                    }
                    GetEmployees();
                </script>
                <div id="presentation" class="entry-content-right">
                    <div class="entry-content-right-padding">
                    <asp:Panel ID="pnl_Question" runat="server" CssClass="text-center" Visible="false">
                        <div class="text-center-child">
                        <h1><asp:Literal ID="lt_Question" runat="server"></asp:Literal></h1>
                        </div>
                    </asp:Panel>
                    <asp:Panel id="pnl_Done" runat="server" CssClass="text-center" Visible="false">
                        <div class="text-center-child">
                        <h1>Done</h1>
                        </div>
                    </asp:Panel>
                    <asp:Panel ID="pnl_PleaseConnect" runat="server" CssClass="text-center" Visible="false">
                        <div class="text-center-child">
                            <h1>Please connect to session using your username and password at</h1>
                            <br />
                            <h1 style="color: red;"><asp:Literal ID="lt_URL" runat="server"></asp:Literal></h1>
                        </div>
                    </asp:Panel>
                    <asp:Panel ID="pnl_NoResource" runat="server" Visible="false">
                        <div class="text-center-child">
                            <h1>Please answer the next question</h1>
                        </div>                        
                    </asp:Panel>
                    <asp:Panel ID="pnl_Z" runat="server" Visible="false">
                        <iframe src="<%=_resource_url %>" width="100%" height="93%" frameborder="0" ></iframe>
                    </asp:Panel>
                    <asp:Panel ID="pnl_Y" runat="server" Visible="false">
                        <%=_embed_youtube %>
                    </asp:Panel>
                    </div>
                </div>
            </div>

        </div>
    </form>
</body>
</html>
