<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="QuizView.ascx.cs" Inherits="FSC.Common.QuizView" %>
<asp:Panel ID="pnl_Start" runat="server" Visible="false">

    <div class="jumbotron" style="text-align: center;">
        <h2>Welcome to the quiz</h2>
        <h3>Good luck !</h3>

        <br /><br />
        <asp:Button ID="btn_Start" CssClass="btn btn-primary" runat="server" Text="Start" OnClick="btn_Start_Click" />
    </div>
</asp:Panel>




<asp:Panel ID="pnl_Stop" runat="server" Visible="false">

    <div class="jumbotron" style="text-align: center;">
        <h3>You completed the quiz. If you want to return to your list of trainings and quizzes please close this tab.</h3>
        <h2>Your score is <span style="color: red;"><%=_points %></span>/100</h2>
        <h3>Have a nice day !</h3>
        <br />
        <br />
        <br />
        <a href="javascript:window.close();">Back to training modules.</a>
    </div>

</asp:Panel>

<asp:Panel ID="pnl_Question" runat="server" Visible="false">
    <asp:HiddenField ID="hd_QuestionIndex" runat="server" />

    <div class="jumbotron"  >
        Question <%=_index+1 %> of <%=_no_of_questions %>
        <h3><asp:Label ID="lb_Question" runat="server"></asp:Label></h3>
        <asp:HiddenField ID="IdQuizQuestion" runat="server" />
        <br /><br />
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

        <br /><br />

        <div>
            <asp:Button ID="btn_Previous" CssClass="btn btn-primary"  runat="server" Text=" <<< " OnClick="btn_Previous_Click" />
            <asp:Button ID="btn_Next" CssClass="btn btn-primary"  runat="server" Text=" >>> " OnClick="btn_Next_Click" />
        </div>
    </div>

</asp:Panel>