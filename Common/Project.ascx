<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Project.ascx.cs" Inherits="FSC.Common.Project" %>

<asp:Panel ID="pnl_List" runat="server" Visible="false">
        <h2>Training projects</h2>
        <asp:Repeater ID="rpt_List" runat="server">
            <HeaderTemplate>
                <table class="border" width="100%">
                <tr>
                    <th>Project name</th>
                    <th>Job/Position</th>
                    <th></th>
                </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><%#DataBinder.Eval(Container.DataItem, "ProjectName") %></td>
                    <td><%#DataBinder.Eval(Container.DataItem, "Job") %></td>
                    <td><a class="btn btn-default" href="<%=Request.Path %>?project=<%#DataBinder.Eval(Container.DataItem, "IdProject") %><%=GetClientLink() %><%=GetTabLink() %>">Details</a></td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
        <br />
        <asp:Button ID="btn_ProjectAdd" CssClass="btn btn-primary" runat="server" Text="Add project &raquo;" OnClick="btn_ProjectAdd_Click" />
    </asp:Panel>

    <asp:Panel ID="pnl_Details" runat="server" Visible="false">
        <div class="jumbotron">
        <table class="details">
            <tr>
                <td>Project name:</td>
                <td><asp:TextBox ID="tb_ProjectName" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Job/position: &nbsp;<input type="button" value="?" onclick="alert('This project will be available to all employees that have “job/position” the one mentioned in the similar filed here');" /></td>
                <td><asp:TextBox id="tb_Job" runat="server"></asp:TextBox>
                    <%if(_jobs){ %>
                    <asp:DropDownList ID="cmb_Job" runat="server"></asp:DropDownList>
                    <br /><span style="font-size: smaller;">(add new or choose existing)</span>
                    <script type="text/javascript">
                        function CopyJob(){
                            cmb = document.getElementById('<%=cmb_Job.ClientID%>');
                            tb = document.getElementById('<%=tb_Job.ClientID%>');

                            tb.value = cmb.options[cmb.selectedIndex].text;
                        }
                    </script>
                    <%} %>
                </td>
            </tr>
            <tr>
                <td>Reminder: &nbsp;<input type="button" value="?" onclick="alert('A reminder will be sent after specified number of months (or leave it empty if you do not need any reminder)');" /></td>
                <td><asp:TextBox ID="tb_Reminder" runat="server" Width="50"></asp:TextBox>  months</td>
            </tr>
            <tr>
                <td colspan="2" class="buttons">
                    <asp:Button ID="btn_SaveProject" class="btn btn-primary" runat="server" Text="Save" OnClick="btn_SaveProject_Click" />
                    <asp:Button ID="btn_CancelProject" class="btn btn-default" runat="server" Text="Cancel" OnClick="btn_CancelProject_Click" />
                    <asp:Button ID="btn_DeleteProject" class="btn" runat="server" Text="Delete" OnClientClick="return window.confirm('Are you sure you want to delete this project?');" OnClick="btn_DeleteProject_Click" />
                </td>
            </tr>
        </table>
        </div>

        <asp:Panel CssClass="jumbotron" ID="pnl_AddModule" runat="server" Visible="false">
            <h3>Add module to project</h3>
            Module: <asp:DropDownList ID="cmb_Modules" runat="server"></asp:DropDownList> 
            <asp:Button ID="btn_SaveAddModule" runat="server" Text="Add" OnClick="btn_SaveAddModule_Click" /> or <asp:Button ID="btn_CancelAddModule" runat="server" Text="Cancel" OnClick="btn_CancelAddModule_Click" />
        </asp:Panel>
            
        <asp:Panel ID="pnl_Modules" runat="server" Visible="false">
            <h3>Modules</h3>

            <asp:Button ID="btn_AddModule" class="btn btn-primary" runat="server" Text="Add module" OnClick="btn_AddModule_Click" />
            <br /><br />

            <asp:Repeater ID="rpt_Modules" runat="server">
                <HeaderTemplate>
                    <table class="border" width="100%">
                        <colgroup>
                            <col />
                            <col />
                            <col width="150px" />
                            <col width="100px" />
                        </colgroup>
                        <tr>
                            <th>Module</th>
                            <th>Type</th>
                            <th>Quiz</th>
                            <th>Direct<br />observation</th>
                            <th></th>
                            <th></th>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                        <tr>
                            <td><%#DataBinder.Eval(Container.DataItem, "ModuleName") %></td>
                            <td><%#DataBinder.Eval(Container.DataItem, "Type") %></td>
                            <td><%#DataBinder.Eval(Container.DataItem, "QuizSessions", "{0}") == "1" ? "yes" : "" %></td>
                            <td><%#DataBinder.Eval(Container.DataItem, "DirectCheck", "{0}") == "1" ? "yes" : "" %></td>
                            <td><a href="/Client/Module.aspx?preview=<%#DataBinder.Eval(Container.DataItem, "IdModule") %>" target="_blank" class="btn btn-primary">Preview &raquo;</a></td>
                            <td><a class="btn btn-default" onclick="return window.confirm('Are you sure you want to remove this module?');" 
                                href="<% =Request.Path%>?project=<%=_project %>&module=<%#DataBinder.Eval(Container.DataItem, "IdModule") %><%=GetClientLink() %><%=GetTabLink() %>">Delete</a></td>
                        </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </asp:Panel>
    </asp:Panel>