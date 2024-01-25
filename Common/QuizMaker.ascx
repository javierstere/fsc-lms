<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="QuizMaker.ascx.cs" Inherits="FSC.Common.QuizMaker" %>
<asp:Panel ID="pnl_ListQuiz" runat="server" Visible="false">
    <h2>Quizzes</h2>
    <asp:Repeater ID="rpt_ListQuiz" runat="server">
        <HeaderTemplate>
            <table class="border" width="100%">
                <tr>
                    <th>Quiz name</th>
                    <th></th>
                </tr>
        </HeaderTemplate>
        <ItemTemplate>
                <tr>
                    <td><%#DataBinder.Eval(Container.DataItem, "QuizName") %></td>
                    <td><a class="btn btn-primary" href="<%=Request.Path %>?<%=Request.QueryString %>&quiz=<%#DataBinder.Eval(Container.DataItem, "IdQuiz") %>">Edit &raquo;</a></td>
                </tr>
        </ItemTemplate>
        <FooterTemplate>
            </table>
        </FooterTemplate>
    </asp:Repeater>
    <br />
    <input type="button" class="btn btn-primary" value="Add new quiz" onclick="javascript: window.location = '<%=Request.Path %>?<%=Request.QueryString %>&quiz=0';" />
</asp:Panel>

<asp:Panel ID="pnl_DetailsQuiz" runat="server" Visible="false">

    <div class="jumbotron" style="text-align: center;">
    <h3>Quiz details</h3>

    <table class="details" style="margin: 0 auto;">
        <tr>
            <td>Quiz name:</td>
            <td><asp:TextBox ID="tb_QuizName" runat="server"></asp:TextBox></td>
        </tr>

        <tr>
            <td colspan="2" class="buttons">
                <asp:Button ID="btn_SaveQuiz" runat="server" Text="Save" OnClick="btn_SaveQuiz_Click" />
                <asp:Button ID="btn_CancelQuiz" runat="server" Text="Cancel" OnClick="btn_CancelQuiz_Click" />
                <asp:Button ID="btn_DeleteQuiz" runat="server" Text="Delete" OnClientClick="return window.confirm('Are you sure you want to delete this quiz?');" OnClick="btn_DeleteQuiz_Click" />
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a href="<%=Request.Path %>?quiz=<%=_quiz %>&preview=1" target="_blank" class="btn btn-primary">Preview</a>
            </td>
        </tr>
    </table>
    </div>
    <br />
    <hr />

    <asp:Panel ID="pnl_Questions" runat="server" Visible="false">
        <input type="button" value="Add new question" onclick="javascript: window.location = '<%=Request.Path %>?<%=Request.QueryString %>&question=0';" />

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
                    <td><a href="<%=Request.Path %>?<%=Request.QueryString %>&question=<%#DataBinder.Eval(Container.DataItem, "IdQuestion") %>">Edit</a></td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </asp:Panel>
    <asp:Panel ID="pnl_QuestionDetails" runat="server" Visible="false">

        <h3>Question details</h3>

        <table class="details">
            <tr>
                <td>Question:</td>
                <td><asp:TextBox ID="tb_Question" runat="server" TextMode="MultiLine" Rows="3" Columns="100"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Answers:</td>
                <td>
                    <script type="text/javascript">
                        function OnLineEdited(div) {

                            if (div.id.indexOf('od__') == 0) {
                                return;
                            }

                            var id_hd = div.id.replace('od_', 'hd_');
                            console.log(id_hd + ' -> ' + div.innerHTML);
                            var hd = document.getElementById(id_hd);
                            hd.value = div.innerHTML;


                        }
                        function AddCell(type, pos) {
                            var td = document.createElement('td');
                            var div = document.createElement('div');
                            div.id = 'od_' + pos + '_' + type;
                            div.setAttribute("contentEditable", true);
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
                                <td><div id="od_<%# DataBinder.Eval(Container.DataItem, "Position") %>_answer" contenteditable 
                                    onkeyup="OnLineEdited(this);"
                                    onfocus="OnFocusDiv(this);" ><%# DataBinder.Eval(Container.DataItem, "Answer") %></div>
                                    <input type="hidden" name="hd_<%# DataBinder.Eval(Container.DataItem, "Position") %>_answer" id="hd_<%# DataBinder.Eval(Container.DataItem, "Position") %>_answer" value="<%# DataBinder.Eval(Container.DataItem, "Answer") %>" />
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                            
                </td>
            </tr>

            <tr>
                <td colspan="2" class="buttons">
                    <asp:Button ID="btn_SaveQuestion" runat="server" Text="Save" OnClick="btn_SaveQuestion_Click" />
                    <asp:Button ID="btn_CancelQuestion" runat="server" Text="Cancel" OnClick="btn_CancelQuestion_Click" />
                    <asp:Button ID="btn_DeleteQuestion" runat="server" Text="Delete" OnClientClick="return window.confirm('Are you sure you want to delete this question?');" OnClick="btn_DeleteQuestion_Click" />
                </td>
            </tr>

        </table>

    </asp:Panel>
</asp:Panel>