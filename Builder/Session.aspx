<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Builder/Builder.Master"  CodeBehind="Session.aspx.cs" Inherits="FSC.Builder.Session" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="pnl_List" runat="server" Visible="false">

        <h3>Training session templates</h3>

        <asp:Repeater ID="rpt_List" runat="server">
            <HeaderTemplate>
                <table class="border" width="100%">
                    <tr>
                        <th>Session name</th>
                        <th></th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                    <tr>
                        <td><%#DataBinder.Eval(Container.DataItem, "SessionName") %></td>
                        <td><a href="<%=Request.Path %>?session=<%#DataBinder.Eval(Container.DataItem, "IdTrainingSession") %>" class="btn btn-primary">Details &raquo;</a></td>
                    </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>

        </asp:Repeater>

        <asp:Button id="btn_AddNew" runat="server" CssClass="btn btn-primary" Text="Add new group session" OnClick="btn_AddNew_Click" />

    </asp:Panel>

    
    <asp:Panel ID="pnl_SessionDetails" runat="server" Visible="false">
        <asp:Panel ID="pnl_SessionDetails_Edit" runat="server" Visible="false">
        <div class="jumbotron">
            <table class="details">
                <tr>
                    <td>Session name:</td>
                    <td><asp:TextBox ID="tb_SessionName" runat="server" Width="600"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Button ID="btn_SessionSave" runat="server" Text="Save" OnClick="btn_SessionSave_Click" />
                        <asp:Button ID="btn_SessionCancel" runat="server" Text="Cancel" OnClick="btn_SessionCancel_Click" />
                        <asp:Button ID="btn_SessionDelete" runat="server" Text="Delete" OnClick="btn_SessionDelete_Click" />
                    </td>
                </tr>
            </table>
        </div>
        </asp:Panel>
        <asp:Panel ID="pnl_SessionDetails_View" runat="server" Visible="false">
            <div class="jumbotron">
                <center>
                    Session name: <asp:Label id="lb_SessionName" runat="server"></asp:Label>
                </center>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnl_StepsList" runat="server" Visible="false">
            <asp:Repeater ID="rpt_StepsList" runat="server">
                <HeaderTemplate>
                    <table class="border" width="100%">
                        <colgroup>
                            <col />
                            <col width="10%" />
                            <col width="5%" />
                            <col width="5%" />
                        </colgroup>
                        <tr>
                            <th>Step name</th>
                            <th></th>
                            <th></th>
                            <th></th>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                        <tr>
                            <td><%#DataBinder.Eval(Container.DataItem, "StepName") %></td>
                            <td><a href="<%=Request.Path %>?session=<%=_session %>&step=<%#DataBinder.Eval(Container.DataItem, "IdStep") %>" class="btn btn-primary">Details &raquo;</a></td>
                            <td><a href="<%=Request.Path %>?session=<%=_session %>&step=<%#DataBinder.Eval(Container.DataItem, "IdStep") %>&dir=1" class="btn">down</a></td>
                            <td><a href="<%=Request.Path %>?session=<%=_session %>&step=<%#DataBinder.Eval(Container.DataItem, "IdStep") %>&dir=-1" class="btn">up</a></td>
                        </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
            <asp:Button id="btn_AddNewStep" runat="server" CssClass="btn btn-primary" Text="Add new step" OnClick="btn_AddNewStep_Click" />
        </asp:Panel>
        <asp:Panel ID="pnl_StepDetails" runat="server" Visible="false">
            <table class="details">
                <tr>
                    <td>Step name:</td>
                    <td><asp:TextBox ID="tb_StepName" runat="server" Width="600"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Resource type:</td>
                    <td>    
                        <asp:DropDownList ID="cmb_ResourceType" runat="server">
                            <asp:ListItem Text="(zip)" Value="Z"></asp:ListItem>
                            <asp:ListItem Text="(youtube)" Value="Y"></asp:ListItem>
                        </asp:DropDownList>
                        
                    </td>
                </tr>
                <tr>
                    <td>Resource:</td>

                    <td>
                        <div id="resource-Z" class="item-resource">
                            <asp:FileUpload ID="fu_ResourceZip" runat="server"></asp:FileUpload>
                            <asp:HyperLink ID="hl_ResourceZip" runat="server" Text="(preview)" Target="_blank"></asp:HyperLink>
                        </div>
                        <div id="resource-Y" class="item-resource">
                            <asp:TextBox ID="tb_ResourceYoutube" runat="server" TextMode="MultiLine" Rows="5" Columns="75"></asp:TextBox>
                        </div>

                        <script type="text/javascript">
                            function OnResourceTypeChange() {

                                var items = document.getElementsByClassName('item-resource');
                                for (var i = 0; i < items.length; i++)
                                    items[i].style.display = 'none';

                                var cmb = document.getElementById('<%=cmb_ResourceType.ClientID%>');

                                var selected = cmb.options[cmb.selectedIndex].value;
                                var visible = document.getElementById('resource-' + selected);
                                if (visible != null) {
                                    visible.style.display = '';
                                }
                            }

                            OnResourceTypeChange();
                        </script>
                    </td>
                </tr>
                <tr>
                    <td>Presentation duration:</td>
                    <td><asp:TextBox ID="tb_Duration" runat="server"></asp:TextBox>(seconds)</td>
                </tr>
                <tr>
                    <td>Time to answer:</td>
                    <td><asp:TextBox ID="tb_Time2Answer" runat="server"></asp:TextBox>(seconds)</td>
                </tr>
                <tr>
                    <td>Question:</td>
                    <td>
                        <asp:HiddenField ID="hd_IdQuizQuestion" runat="server" />
                        <asp:TextBox ID="tb_Question" runat="server" TextMode="MultiLine" Rows="3" Columns="75"></asp:TextBox>
                    </td>
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
                    <td colspan="2">
                        <asp:Button ID="btn_StepSave" runat="server" Text="Save" OnClick="btn_StepSave_Click" />
                        <asp:Button ID="btn_StepCancel" runat="server" Text="Cancel" OnClick="btn_StepCancel_Click" />
                        <asp:Button ID="btn_StepDelete" runat="server" Text="Delete" OnClientClick="return window.confirm('Are you sure you want to delete this step?');" OnClick="btn_StepDelete_Click" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </asp:Panel>
    
</asp:Content>