<%@ Page Title="Clients" MasterPageFile="~/Builder/Builder.Master" Language="C#" AutoEventWireup="true" CodeBehind="Client.aspx.cs" Inherits="FSC.Builder.Client" %>
<%@ Register TagPrefix="Common" TagName="Administrator" Src="~/Common/Administrator.ascx" %>
<%@ Register TagPrefix="Common" TagName="Employee" Src="~/Common/Employee.ascx" %>
<%@ Register TagPrefix="Common" TagName="Project" Src="~/Common/Project.ascx" %>
<%@ Register TagPrefix="Common" TagName="Report" Src="~/Common/Report.ascx" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="pnl_Search" runat="server" CssClass="jumbotron" style="text-align:center;">
         
        <h3>Manage clients</h3>
        <p>You can change an existing client or you can add a new client</p>

        <asp:TextBox ID="tb_SearchClient" runat="server"></asp:TextBox>
         <asp:Button id="btn_SearchClient" runat="server" CssClass="btn btn-primary" Text="Search" OnClick="btn_SearchClient_Click"/>
        &nbsp;&nbsp;or&nbsp;&nbsp;
         <asp:Button id="btn_AddNew" runat="server" CssClass="btn btn-default" Text="Add new" OnClick="btn_AddNew_Click" />
         <br />
    </asp:Panel>

    <asp:Panel ID="pnl_NoClients" runat="server" Visible="false" CssClass="jumbotron">
        <h4 class="red">No clients found</h4>
    </asp:Panel>

    <asp:Panel ID="pnl_List" runat="server" Visible="false">
        <asp:Repeater ID="rpt_List" runat="server">
            <HeaderTemplate>
                <table class="border" width="100%"">
                    <tr>
                        <th>Client name</th>
                        <th>State</th>
                        <th>City</th>
                        <th>Administrator</th>
                        <th>Assigned builder</th>
                        <th></th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                    <tr>
                        <td><%#DataBinder.Eval(Container.DataItem, "ClientName") %></td>
                        <td><%#DataBinder.Eval(Container.DataItem, "State") %></td>
                        <td><%#DataBinder.Eval(Container.DataItem, "City") %></td>
                        <td><%#GetAdministrators(Container.DataItem) %></td>
                        <td><%#GetAssignedBuilders(Container.DataItem) %></td>
                        <td><a href="<%=Request.Path %>?client=<%#DataBinder.Eval(Container.DataItem, "IdClient") %>" class="btn btn-primary">Edit &raquo;</a></td>
                    </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </asp:Panel>
             
    <asp:Panel ID="pnl_Details" runat="server" Visible="false">
        <%if(_client != "0"){ %>
        <div class="jumbotron">
            <span style="float: right;"><input type="button" value="Back" class="btn" onclick="window.location='<%=Request.Path%>';" /></span>
            <h3><%=_client_name %></h3>
            <ul class="nav navbar-nav">
                <li><a href="<%=Request.Path %>?client=<%=_client %>">Details</a></li>
                <li><a href="<%=Request.Path %>?client=<%=_client %>&tab=access">Access</a></li>
                <li><a href="<%=Request.Path %>?client=<%=_client %>&tab=administrator">Administrators</a></li>
                <li><a href="<%=Request.Path %>?client=<%=_client %>&tab=university">University</a></li>
                <li><a href="<%=Request.Path %>?client=<%=_client %>&tab=training">Visible modules</a></li>
                <li><a href="<%=Request.Path %>?client=<%=_client %>&tab=project">Training projects</a></li>
                <li><a href="<%=Request.Path %>?client=<%=_client %>&tab=employee">Employees</a></li>
                <li><a href="<%=Request.Path %>?client=<%=_client %>&tab=builder">Cobuilders</a></li>
                <li><a href="<%=Request.Path %>?client=<%=_client %>&tab=report">Reports</a></li>
            </ul>
        </div>
        <%} %>
        <asp:Panel ID="pnl_Details1" runat="server" CssClass="jumbotron" style="text-align:center;" Visible="false">
            <%if (_client != "0") { %>
                <h4>Client's details</h4>
            <%} else { %>
                <h4>New client</h4>
            <% } %>
            <table class="details"  style="margin: 0 auto;">
                <tr>
                    <td>Client name:</td>
                    <td><asp:TextBox ID="tb_ClientName" runat="server" Width="250"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Phone:</td>
                    <td><asp:TextBox ID="tb_Phone" runat="server" Width="250"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Email:</td>
                    <td><asp:TextBox ID="tb_Email" runat="server" Width="250"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Address:</td>
                    <td><asp:TextBox ID="tb_Address" runat="server" Width="250"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>State:</td>
                    <td><asp:TextBox ID="tb_State" runat="server" Width="250"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>City:</td>
                    <td><asp:TextBox ID="tb_City" runat="server" Width="250"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Logo:</td>
                    <td>
                        <asp:FileUpload ID="fu_Logo" runat="server" />
                        <asp:Image runat="server" ID="img_Logo"  Height="100" Visible="false" />
                        <asp:Button ID="btn_Remove" Visible="false" runat="server" Text="Remove" CssClass="btn btn-danger" OnClick="btn_Remove_Click" />
                    </td>
                </tr>
                
                <tr>
                    <td colspan="2" class="buttons">

                        <asp:Button ID="btn_Save" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btn_Save_Click" />
                        <asp:Button ID="btn_Cancel" runat="server" Text="Cancel" CssClass="btn btn-default" OnClick="btn_Cancel_Click" />
                        <asp:Button ID="btn_Delete" runat="server" Text="Delete" OnClientClick="return window.confirm('Are you sure you want to delete this client?');" CssClass="btn" OnClick="btn_Delete_Click" />
                    </td>

                </tr>

            </table>
        </asp:Panel>

        <asp:Panel ID="pnl_Details_Access" CssClass="jumbotron"  runat="server" style="text-align:center;" Visible="false">
            <div class="row">
                <div class="col-md-6">

            <table class="details"  style="margin: 0 auto;">
                <tr>
                    <td>Contact person:</td>
                    <td><asp:TextBox ID="tb_ContactPerson" runat="server" Width="250"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Title/role:</td>
                    <td><asp:TextBox ID="tb_TitleRole" runat="server" Width="250"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Access email:</td>
                    <td><asp:TextBox ID="tb_AccessEmail" runat="server" Width="250"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Password:</td>
                    <td>
                        <asp:TextBox ID="tb_Password1" runat="server" TextMode="Password"></asp:TextBox>                        
                    </td>
                </tr>
                <tr>
                    <td>Retype password:</td>
                    <td><asp:TextBox ID="tb_Password2" runat="server" TextMode="Password"></asp:TextBox></td>
                </tr>
            </table>
            </div>
            <div class="col-md-6">
                <table class="details"  style="margin: 0 auto;">
                    <tr>
                        <td>Max administrators:</td>
                        <td><asp:TextBox ID="tb_MaxAdmins" runat="server" Width="50"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Max universities:</td>
                        <td><asp:TextBox ID="tb_MaxUniversities" runat="server" Width="50"> </asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Max employees:</td>
                        <td><asp:TextBox ID="tb_MaxEmployees" runat="server" Width="50"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Max active employees:</td>
                        <td><asp:TextBox ID="tb_MaxActiveEmployees" runat="server" Width="50"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Max local modules:</td>
                        <td><asp:TextBox ID="tb_MaxModules" runat="server" Width="50"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Max training projects:</td>
                        <td><asp:TextBox ID="tb_MaxProjects" runat="server" Width="50"></asp:TextBox></td>
                    </tr>
                </table>

            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <asp:Button ID="btn_SaveAccess" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btn_SaveAccess_Click" />
            </div>
        </div>


        </asp:Panel>


        <asp:Panel ID="pnl_Details_Training" runat="server" Visible="false">
             <h3>Visible modules</h3>

            Select visible modules and press <asp:Button ID="btn_SaveModules" runat="server" Text="Save" OnClick="btn_SaveModules_Click" /><br /><br />
            <asp:Repeater ID="rpt_Modules" runat="server">
                <HeaderTemplate>
                    <table class="border">
                        <tr>
                            <th></th>
                            <th>Module name</th>
                            <th>Quiz</th>
                            <th>Direct<br />observation</th>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td><%#GetModuleCheckbox(Container.DataItem) %></td>
                        <td><%#DataBinder.Eval(Container.DataItem, "ModuleName") %></td>
                        <td><%#DataBinder.Eval(Container.DataItem, "QuizSessions", "{0}") == "1" ? "yes" : "" %></td>
                        <td><%#DataBinder.Eval(Container.DataItem, "DirectCheck", "{0}") == "1" ? "yes" : "" %></td>                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </asp:Panel>

        <asp:Panel ID="pnl_Details_Admin" runat="server" Visible="false">
            <Common:Administrator runat="server" />
        </asp:Panel>

        <asp:Panel ID="pnl_Details_University" runat="server" Visible="false">
            <asp:Panel ID="pnl_ListUniversity" runat="server" Visible="false">
                <asp:Repeater ID="rpt_ListUniversity" runat="server">
                    <HeaderTemplate>
                        <table class="border" width="100%">
                            <tr>
                                <th>Enabled</th>
                                <th>Description</th>
                                <th>Link</th>
                                <th></th>
                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                            <tr>
                                <td><input type="checkbox" disabled="disabled" <%#DataBinder.Eval(Container.DataItem, "Enabled", "{0}") == "1" ? "checked='checked'" : ""%>/></td>
                                <td><%#DataBinder.Eval(Container.DataItem, "Description") %></td>
                                <td><%#DataBinder.Eval(Container.DataItem, "Link") %></td>
                                <td><a href="<%=Request.Path %>?<%=Request.QueryString %>&univ=<%#DataBinder.Eval(Container.DataItem, "IdUniversity") %>" class="btn btn-primary">Edit &raquo;</a></td>
                            </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
                <asp:Panel ID="pnl_NoUniversity" Visible="false" runat="server">
                    No universities for this client, yet.
                </asp:Panel>
                <br />
                <asp:Button ID="btn_UniversityAdd" CssClass="btn btn-primary" runat="server" Text="Add university &raquo;" OnClick="btn_UniversityAdd_Click" />
            </asp:Panel>
            <asp:Panel ID="pnl_DetailsUniversity" CssClass="jumbotron" runat="server" Visible="false">
                <table class="details"  style="margin: 0 auto;">
                    <tr>
                        <td>Enabled:</td>
                        <td><asp:CheckBox ID="cb_UniversityEnabled" runat="server" /> </td>
                    </tr>
                    <tr>
                        <td>Description:</td>
                        <td><asp:TextBox ID="tb_UniversityDescription" runat="server"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Link:</td>
                        <td>
                            <asp:TextBox ID="tb_UniversityLink" runat="server"></asp:TextBox><br />
                            
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Label ID="lb_UniversityLink" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="buttons">
                            <asp:Button ID="btn_SaveUniversity" CssClass="btn btn-primary" Text="Save" runat="server" OnClick="btn_SaveUniversity_Click" />
                            <asp:Button ID="btn_CancelUniversity" CssClass="btn btn-default" Text="Cancel" runat="server" OnClick="btn_CancelUniversity_Click" />
                            <asp:Button ID="btn_DeleteUniversity" cssclass="btn" OnClientClick="return window.confirm('Delete this university?');" Text="Delete" runat="server" OnClick="btn_DeleteUniversity_Click" />
                        </td>
                    </tr>
                </table>

            </asp:Panel>
        </asp:Panel>

        <asp:Panel ID="pnl_Details_Project" runat="server" Visible="false">
            <Common:Project runat="server" />

        </asp:Panel>

        <asp:Panel ID="pnl_Details_Employee" runat="server" Visible="false">
            <Common:Employee runat="server" />

        </asp:Panel>

        <asp:Panel ID="pnl_Details_Builder" runat="server" Visible="false">
            <h3>Assigned cobuilders</h3>
            Select one or more cobuilders and press <asp:Button ID="btn_SaveBuilders" runat="server" Text="Save" OnClick="btn_SaveBuilders_Click" /><br /><br />
            <asp:Repeater ID="rpt_Builders" runat="server">
                <HeaderTemplate>
                    <table class="border">
                        <tr>
                            <th></th>
                            <th>(Co)builder</th>
                            <th>Type</th>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td><%#GetBuilderCheckbox(Container.DataItem) %></td>
                        <td><%#DataBinder.Eval(Container.DataItem, "BuilderName") %></td>
                        <td>
                            <%#DataBinder.Eval(Container.DataItem, "Type", "{0}") == "C" ? "Co-builder" : "" %>
                            <%#DataBinder.Eval(Container.DataItem, "Type", "{0}") == "B" ? "Builder" : "" %>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </asp:Panel>
    </asp:Panel>
             
    <asp:Panel ID="pnl_Details_Report" runat="server" Visible="false">
        <Common:Report runat="server" />
    </asp:Panel>

</asp:Content>