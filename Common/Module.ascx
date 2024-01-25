<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Module.ascx.cs" Inherits="FSC.Common.Module" %>
<%@ Register TagPrefix="Common" TagName="QuizView" Src="~/Common/QuizView.ascx" %>

<%if(Q["quiz"] == "1"){ %>
    <Common:QuizView runat="server" />
    <%}else{ %>

<asp:Panel ID="pnl_Youtube" runat="server" Visible="false">
    <br /><br />
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
    <iframe src='https://view.officeapps.live.com/op/embed.aspx?src=http://lms.bdfoodsafety.com<%=_embed %>' width='100%' height='100%' frameborder='0' />
</asp:Panel>


<asp:Panel ID="pnl_List" runat="server" Visible="false">
    <h3>Training modules<asp:Literal ID="lt_ExtraTitle" runat="server"></asp:Literal></h3>
    <asp:Repeater ID="rpt_List" runat="server">
        <HeaderTemplate>
            <table class="border" width="100%">
                <tr>
                    <th></th>
                    <th>Module name</th>
                    <th>Type</th>
                    <th>Visibility</th>
                    <%if (!_direct_check_only) { %>
                    <th>Quiz</th>
                    <th>Direct<br />observation</th>
                    <%} %>
                    <th></th>
                </tr>
        </HeaderTemplate>
        <ItemTemplate>
                <tr>
                    <td><a href="<%=Request.Path %>?preview=<%#DataBinder.Eval(Container.DataItem, "IdModule") %>" target="_blank" class="btn btn-primary">Preview &raquo;</a></td>
                    <td><%#DataBinder.Eval(Container.DataItem, "ModuleName") %></td>
                    <td><%#DataBinder.Eval(Container.DataItem, "Type") %></td>
                    <td>
                        <%#DataBinder.Eval(Container.DataItem, "IdClient", "{0}") == "" ? "system" : "local" %>
                    </td>
                    <%if (!_direct_check_only) { %>
                    <td>
                        <%#DataBinder.Eval(Container.DataItem, "QuizSessions", "{0}") == "1" ? "yes" : ""%>
                    </td>
                    <td>
                        <%#DataBinder.Eval(Container.DataItem, "DirectCheck", "{0}") == "1" ? "yes" : "" %>
                    </td>
                    <%} %>
                    <td><a href="<%=Request.Path %>?module=<%#DataBinder.Eval(Container.DataItem, "IdModule") %>" 
                        class="btn btn-primary"><%=(_direct_check_only?"Direct observation":"Details") %> &raquo;</a></td>
                </tr>
        </ItemTemplate>
        <FooterTemplate>
            </table>
        </FooterTemplate>
    </asp:Repeater>
    <br />
    <asp:Button id="btn_AddNew" runat="server" CssClass="btn btn-primary" Text="Add new individual session" OnClick="btn_AddNew_Click" />

</asp:Panel>

<asp:Panel ID="pnl_NewModule"  runat="server" Visible="false">

    <div class="jumbotron">
    
    <h2>New module</h2>
    <br /><br />

    Description: <asp:TextBox ID="tb_LinkDescription" runat="server"  Width="600px"></asp:TextBox>
    
    </div>
    <div class="jumbotron">
                <p>Please choose a file to upload (.doc, .pdf, .zip)</p>
                File to upload: <asp:FileUpload ID="fu_File" runat="server" /> 
                <br />
                <br />
        <asp:Button ID="btn_Upload" CssClass="btn btn-primary" runat="server" Text="Upload" OnClick="btn_Upload_Click" />
        <asp:Button ID="btn_CancelUpload" CssClass="btn" runat="server" Text="Cancel" OnClick="btn_CancelUpload_Click" /> 
    </div>
    <div class="jumbotron">
        <span style="float: right;">
            <input type="button" value="?" class="btn btn-primary" onclick="javascript: ShowHelp('youtube-share');" />
        </span>
                <p>or set an embedded code for youtube video</p>
                Embed code: &nbsp;&nbsp;<br />
                <asp:TextBox ID="tb_YoutubeLink" runat="server" Width="400" Height="150" TextMode="MultiLine"></asp:TextBox>
                <br />
                    <asp:Button ID="btn_SaveYoutubeLink" CssClass="btn btn-primary" runat="server" Text="Save" OnClick="btn_SaveYoutubeLink_Click" />
                <asp:Button ID="btn_CancelSaveYoutubeLink" CssClass="btn" runat="server" Text="Cancel" OnClick="btn_CancelUpload_Click" /> 
    </div>



   <script type="text/javascript">
       function ShowHelp(id) {
           window.open('/Help.aspx?help=' + id, "_blank");
       }
   </script>
    <br /><br />
</asp:Panel>

<asp:Panel ID="pnl_Details" runat="server" Visible="false">
    <asp:Panel ID="pnl_DetailsInner" CssClass="jumbotron" runat="server" Visible="false">
        <%if (_direct_check_only)
            { %>
        <div style="float: right;">
            <asp:Button ID="btn_Cancel2" runat="server" Text="Back" CssClass="btn btn-primary" OnClick="btn_Cancel_Click"  />
        </div>
        <%} %>
        <table class="details" align="center">
            <tr>
                <td>Module name:</td>
                <td><asp:TextBox ID="tb_ModuleName" runat="server" Width="600"></asp:TextBox>
                    <asp:Label ID="lb_ModuleName" runat="server"></asp:Label>
                </td>
            </tr>
            <%if (!_direct_check_only)
            { %>
            <tr>
                <td>Type:</td>
                <td><asp:TextBox ID="tb_Type" runat="server" ReadOnly="true"  Width="100"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Resource:</td>
                <td><asp:TextBox ID="tb_Path" runat="server" Width="600" TextMode="MultiLine" Rows="4"></asp:TextBox>
                    <asp:Button ID="btn_ChooseFile" Text="..." runat="server" Visible="false" OnClick="btn_ChooseFile_Click" />
                </td>
            </tr>
            <tr>
                <td>Quiz sessions:</td>
                <td><asp:CheckBox ID="cb_QuizSessions" runat="server" /></td>
            </tr>
            <tr>
                <td>Direct observation:</td>
                <td><asp:CheckBox ID="cb_DirectCheck" runat="server" /></td>
            </tr>
            <tr>
                <td>Delay in seconds(for self-paced courses only):</td>
                <td><asp:TextBox ID="tb_Delay" runat="server" type="number" min="0" Width="100"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="2" class="buttons">
                    <asp:Button ID="btn_Save" CssClass="btn btn-primary" runat="server" Text="Save" OnClick="btn_Save_Click" />
                    <asp:Button ID="btn_Cancel" CssClass="btn btn-primary" runat="server" Text="Cancel" OnClick="btn_Cancel_Click" />
                    <asp:Button ID="btn_Delete" CssClass="btn btn-primary" runat="server" Text="Delete" OnClientClick="return window.confirm('Are you sureyou want to delete this module?');" OnClick="btn_Delete_Click" />
                
                            &nbsp;&nbsp;&nbsp;
                            <a href="<%=Request.Path %>?module=<%=_module %>&quiz=1" target="_blank" class="btn btn-primary">Preview quiz</a>
                </td>
            </tr>
            <%} %>
        </table>
    </asp:Panel>
    <asp:Panel ID="pnl_ChooseFile" runat="server" Visible="false">
                <br /><br />
            <p>Choose the starting file of the module or press <asp:Button ID="btn_CancelChoose" runat="server" Text="Cancel" /></p>
        <asp:Repeater ID="rpt_FilesList" runat="server">
            <HeaderTemplate>
                <table width="100%" class="border"> 
                        
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><img src="/Resources/<%#DataBinder.Eval(Container.DataItem, "Type") %>.png" /></td>
                    <td><a href="<%=Request.Path %>?module=<%=_module %>&<%#DataBinder.Eval(Container.DataItem, "Type") %>=<%#DataBinder.Eval(Container.DataItem, "Filename") %>&choose=1"><%#DataBinder.Eval(Container.DataItem, "Name") %></a></td>
                </tr>

            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </asp:Panel>

    <asp:Panel ID="pnl_DirectObservation" CssClass="jumbotron" runat="server" Visible="false">
        <asp:Panel ID="pnl_DirectObservation_Select" runat="server" Visible="false">
            <h3>Please choose the employee you want to observe</h3>
            Name: <input type="text" onkeyup="javascript:ChooseEmployee_OnKeyUp(this);" />
        
            <asp:Button ID="btn_CancelDirectCheck" CssClass="btn btn-default" Text="Cancel" runat="server" OnClick="btn_Cancel_Click" />
            <br /><br />
            <input type="button" class="btn btn-primary" value="Choose" onclick="javascript: SelectEmployee();" /> selected employee
            <table id="select-employees" class="border" width="100%">
       
            </table>
            <script type="text/javascript">
                var added = 0;
                function SelectEmployee() {
                    var checks = document.getElementsByTagName('input');
                    added = 0;
                    for (var i = 0; i < checks.length; i++) {
                        if (checks[i].type == 'radio') {
                            if (checks[i].checked) {
                                var par = checks[i].id.substr(4) + '&module=<%=_module%>&adm=<%=(string)S["Client.IdAdministrator"]%>';
                                AjaxCall('select', par, OnAddedResponse);
                                console.log(checks[i].id.substr(4));
                                break;
                            }
                        }
                    }

                //setTimeout(function () { window.location = '<%=Request.Path + '?' + Request.QueryString.ToString() %>'; }, 500);
                }

                function OnAddedResponse(data) {
                    window.location = '<%=Request.Path + '?' + Request.QueryString.ToString() %>';
                }
                function ChooseEmployee_OnKeyUp(txt) {
                    var name = txt.value;
                    var table = document.getElementById('select-employees');
                    table.innerHTML = '';
                    //console.log(txt.value);
                    if (name != '')
                        AjaxCall('search', name, OnEmployeeList);
                }
                function OnEmployeeList(list) {
                    //console.log(JSON.stringify(list));
                    var table = document.getElementById('select-employees');
                    table.innerHTML = '';
                    for (var i = 0; i < list.employees.length; i++) {
                        var tr = document.createElement('tr');

                        var tdcheck = document.createElement('td');
                        tdcheck.width = '20px';
                        var check = document.createElement('input');
                        check.id = 'emp_' + list.employees[i].id;
                        check.type = 'radio';
                        check.name = 'em';
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
                    var url = "<%=((Outpost.Utils.BaseWebPage)Page).BASE_ADDRESS%>/Common/ModuleAjax.aspx?client=<%=_client%>&method="
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

            </script>
        </asp:Panel>
        <asp:Panel ID="pnl_DirectObservation_Start" runat="server" Visible="false">
            <a href="<%=Request.Path %>?preview=<%=_module %>" target="_blank" class="btn btn-primary">Start &raquo;</a>
            presentation module in another browser's tab or 
            <asp:Button ID="btn_ChooseAnother" class="btn btn-default" runat="server" Text="Choose" OnClick="btn_ChooseAnother_Click" /> 
            another employee
            <hr style="border: 1px solid #337ab7;" />
            
            <h3>Employee: <%=_selected_employee %></h3>
            
            <br />
            <!--Date: <b><%=DateTime.Today.ToString("MM/dd/yyyy") %></b>&nbsp;&nbsp;&nbsp;
            Time:--> <b><span id="time"></span></b>
            <h4>Result of direct observation
            <asp:Button ID="btn_ObservationPassed" runat="server" Text="Acceptable" class="btn btn-green" 
                OnClientClick="return ConfirmPassed();" OnClick="btn_ObservationPassed_Click" />
            <asp:Button ID="btn_ObservationNotPassed" runat="server" Text="Unacceptable" class="btn btn-red" 
                OnClientClick="return ConfirmNotPassed();" OnClick="btn_ObservationNotPassed_Click" />
            </h4>
            
            Person conducting Direct Observation: <b><%=(string)S["Client.AdministratorName"] %></b>
            
            <script type="text/javascript">
                function DisplayTime() {
                    var dt = new Date(<%= DateTime.UtcNow
                                .Subtract(new DateTime(1970,1,1,0,0,0,DateTimeKind.Utc))
                                    .TotalMilliseconds %>);
                    

                    $("#time").text(dt);
                    
                }
                function ConfirmPassed() {
                    return window.confirm('Do you confirm that <%=_selected_employee %> passed this test?');
                }
                function ConfirmNotPassed() {
                    return window.confirm('Do you confirm that <%=_selected_employee %> did not passed this test?');
                }
                DisplayTime();
            </script>
        </asp:Panel>
    </asp:Panel>

    <asp:Panel ID="pnl_Questions" runat="server" Visible="false">
        <asp:Button id="btn_AddNewQuestion" runat="server" CssClass="btn btn-primary" Text="Add new question" OnClientClick="javascript: window.location = '<%=Request.Path %>?<%=Request.QueryString %>&question=0';" OnClick="btn_AddNewQuestion_Click" />
        <br /><br />
        <asp:Repeater ID="rpt_Questions" runat="server">
            <HeaderTemplate>
                <table class="border" width="100%">
                    <tr>
                        <th>Question</th>
                        <th></th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><%#DataBinder.Eval(Container.DataItem, "Question") %></td>
                    <td><a  class="btn btn-primary" href="<%=Request.Path %>?<%=Request.QueryString %>&question=<%#DataBinder.Eval(Container.DataItem, "IdQuizQuestion") %>">Edit</a></td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </asp:Panel>
    <asp:Panel ID="pnl_QuestionDetails" runat="server" Visible="false">
        <div class="jumbotron">
            <h3>Question details</h3>

            <table class="details">
                <tr>
                    <td>Question:</td>
                    <td><asp:TextBox ID="tb_Question" runat="server" TextMode="MultiLine" Rows="3" Columns="80"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Answers:</td>
                    <td>
                        
                        <asp:Repeater ID="rpt_Options" runat="server">
                            <HeaderTemplate>
                                <table class="border" width="100%">
                                    <tr>
                                        <td style="width:80px;">Correct</td>
                                        <td>Answer</td>
                                    </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr class="tr" id="tr_<%# DataBinder.Eval(Container.DataItem, "Position") %>">
                                    <td>
                                        <!--<div id="od_<%# DataBinder.Eval(Container.DataItem, "Position") %>_correct" contenteditable 
                                        onkeyup="OnLineEdited(this);"
                                        onfocus="OnFocusDiv(this);" ><%# DataBinder.Eval(Container.DataItem, "Correct") %></div>-->
                                        <input type="checkbox" name="hd_<%# DataBinder.Eval(Container.DataItem, "Position") %>_correct" 
                                            id="hd_<%# DataBinder.Eval(Container.DataItem, "Position") %>_correct" 
                                            <%# DataBinder.Eval(Container.DataItem, "Correct", "{0}") == "1" ? "checked='checked'" : "" %> />
                                    </td>
                                    <td><input type="text" id="od_<%# DataBinder.Eval(Container.DataItem, "Position") %>_answer" 
                                        onkeyup="OnLineEdited(this);" style="width: 500px;"
                                        onfocus="OnFocusDiv(this);" value="<%# DataBinder.Eval(Container.DataItem, "Answer") %>" ></input>
                                        <input type="hidden" name="hd_<%# DataBinder.Eval(Container.DataItem, "Position") %>_answer" id="hd_<%# DataBinder.Eval(Container.DataItem, "Position") %>_answer" value="<%# DataBinder.Eval(Container.DataItem, "Answer") %>" />
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>
                            
<script type="text/javascript">
                            function OnLineEdited(div) {

                                if (div.id.indexOf('od__') == 0) {
                                    return;
                                }

                                var id_hd = div.id.replace('od_', 'hd_');
                                //console.log(id_hd + ' -> ' + div.innerHTML);
                                var hd = document.getElementById(id_hd);
                                hd.value = div.value;


                            }
                            function AddCell(type, pos) {
                                var td = document.createElement('td');
                                var div = document.createElement('input');
                                div.type = 'text';
                                div.style.width = '500px';
                                div.id = 'od_' + pos + '_' + type;
                                //div.setAttribute("contentEditable", true);
                                div.onkeyup = function () { OnLineEdited(div); }
                                td.appendChild(div);
                                var input = document.createElement('input');
                                input.type = 'hidden';
                                input.id = 'hd_' + pos + '_' + type;
                                input.name = 'hd_' + pos + '_' + type;
                                td.appendChild(input);
                                return td;
                            }
                            function AddCheckbox(type, pos) {
                                var td = document.createElement('td');
                                var input = document.createElement('input');
                                input.type = 'checkbox';
                                input.id = 'hd_' + pos + '_' + type;
                                input.name = 'hd_' + pos + '_' + type;
                                td.appendChild(input);
                                return td;
                            }
                            function OnFocusDiv(div) {
                                if (div.id.indexOf('od__') == 0) {
                                    // first line
                                    var trs = document.getElementsByClassName('tr');
                                    console.log(trs.length);

                                    var tr = document.createElement('tr');
                                    tr.className = 'tr';
                                    var pos = trs.length - 1;
                                    tr.id = 'tr_' + pos;
                                    var this_tr = document.getElementById('tr_');
                                    //console.log(tr.tagName + ' - ' + this_tr.tagName + ' - ' + div.parentNode.parentNode.parentNode.tagName);
                                    div.parentNode.parentNode.parentNode.insertBefore(tr, this_tr);

                                    tr.appendChild(AddCheckbox('correct', pos));
                                    tr.appendChild(AddCell('answer', pos));

                                    var focus = null;
                                    // change focus to new added line
                                    if (div.id.indexOf('_correct') > 0)
                                        focus = document.getElementById('od_' + pos + '_correct');
                                    if (div.id.indexOf('_answer') > 0)
                                        focus = document.getElementById('od_' + pos + '_answer');

                                    if (focus != null) {
                                        focus.focus();
                                    }
                                }

                            }
                        </script>
                    </td>
                </tr>

                <tr>
                    <td colspan="2" class="buttons">
                        <asp:Button ID="btn_SaveQuestion" runat="server" Text="Save" OnClick="btn_SaveQuestion_Click" />
                        <asp:Button ID="btn_SaveAndNewQuestion" runat="server" Text="Save and new" OnClick="btn_SaveAndNewQuestion_Click" />
                        <asp:Button ID="btn_CancelQuestion" runat="server" Text="Cancel" OnClick="btn_CancelQuestion_Click" />
                        <asp:Button ID="btn_DeleteQuestion" runat="server" Text="Delete" OnClientClick="return window.confirm('Are you sure you want to delete this question?');" OnClick="btn_DeleteQuestion_Click" />
                    </td>
                </tr>

            </table>
        </div>
    </asp:Panel>

</asp:Panel>

<%} %>