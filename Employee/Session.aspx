<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Employee/Employee.Master" CodeBehind="Session.aspx.cs" Inherits="FSC.Employee.Session" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="pnl_NotActive" runat="server" Visible="false">
        <div class="jumbotron">
            This session training is no longer active.
        </div>
    </asp:Panel>

    <asp:Panel ID="pnl_Ended" runat="server" Visible="false">
        <div class="jumbotron">
            Thank you for your time! You've finished the group session and you've achived <%=_percent %>% accuracy.
        </div>
    </asp:Panel>


    <asp:Panel id="pnl_Details" runat="server" Visible="false">
        <asp:Panel ID="pnl_WaitForQuestion" runat="server" Visible="false">
            <div class="jumbotron">

            Please watch the presentation on the main screen and wait for the question

            </div>

        </asp:Panel>

        <asp:Panel ID="pnl_Question" runat="server" Visible="false">
            <div class="jumbotron">
                <h3>Question</h3>
                <p>
                    <%=_question %>
                </p>
                <h3>Answer</h3>
                <p>
                    <asp:Repeater ID="rpt_Answers" runat="server">
                        <HeaderTemplate>
                            <ul>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <li>
                                <input type="checkbox" 
                                    <%# GetCheckedAnswer(Container.DataItem) %>
                                    name="answer_<%#DataBinder.Eval(Container.DataItem, "IdQuizAnswer")%>" />
                                    <%#DataBinder.Eval(Container.DataItem, "Answer") %>

                            </li>
                        </ItemTemplate>
                        <FooterTemplate>
                            </ul>
                        </FooterTemplate>
                    </asp:Repeater>
                    <p>
                        <%if(_answer_saved){ %>
                        Your answer is saved. You can still change your option and submit again, if you want.
                        <%} %>
                    </p>
                    <asp:Button ID="btn_SaveAnswer" runat="server" OnClick="btn_SaveAnswer_Click" Text="Submit" />
                    your answer
                    <asp:HiddenField ID="hd_IdQuizQuestion" runat="server" />
                </p>

            </div>
        </asp:Panel>

        <h4><%=_training_session %></h4>

        
    </asp:Panel>


    <script type="text/javascript">

        function AjaxCall(method, params, callback) {
            var xmlhttp = new XMLHttpRequest();
            var url = "<%=Request.Path%>?ajax=1&client=<%=_client%>&session=<%=_session%>&employee=<%=_employee%>";// + method + params;
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

        var _previous_status = null;
        var _previous_step = null;

        function OnCheckChanges(data) {
            //console.log(JSON.stringify(data));

            var reload = false;

            if (_previous_status != null) {
                if (_previous_status != data.status)
                    reload = true;
            }
            _previous_status = data.status;

            if (_previous_step != null) {
                if (_previous_step != data.step)
                    reload = true;
            }
            _previous_step = data.step;

            if (reload)
                location.reload(true);
        }

        function CheckChanges() {
            AjaxCall(null, null, OnCheckChanges);
        }
        setInterval(CheckChanges, 5 * 1000);

        CheckChanges();
        </script>


</asp:Content>