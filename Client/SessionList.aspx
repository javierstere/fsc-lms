<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Client/Client.Master"   CodeBehind="SessionList.aspx.cs" Inherits="FSC.Client.SessionList" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="pnl_List" CssClass="jumbotron" runat="server" Visible="false">
        <h3>System content</h3>
        <asp:Repeater runat="server" ID="rpt_List" >
            <HeaderTemplate>
                <table class="border" width="100%">
                    <colgroup>
                        <col />
                        <col width="100px" />
                    </colgroup>
                    <tr>
                        <th>Module</th>
                        <th></th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><%#DataBinder.Eval(Container.DataItem, "SessionName") %></td>
                    <td><a href="<%=Request.Path %>?id=<%#DataBinder.Eval(Container.DataItem, "IdTrainingSession") %>" class="btn btn-primary">Details</a></td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </asp:Panel>

    <asp:Panel ID="pnl_Details" runat="server" Visible="false">
        <div class="jumbotron">
            <div style="float: right">
                <asp:Button ID="btn_CancelDetails" runat="server" CssClass="btn btn-primary" Text="Back" OnClick="btn_CancelDetails_Click" />
            </div>
        <h3><asp:Label ID="lb_SessionName" runat="server" ></asp:Label></h3>

        </div>

        <asp:Panel ID="pnl_DetailsStep" CssClass="jumbotron" runat="server" Visible="false">
            <div style="float: right">
                <asp:Button ID="btn_CancelStep" runat="server" CssClass="btn btn-primary" Text="Cancel" OnClick="btn_CancelStep_Click" />
            </div>
            <h3><asp:Label ID="lb_StepName" runat="server"></asp:Label></h3>
            <table class="details">
                <tr>
                    <td>Resource type:</td>
                    <td>  <asp:Label ID="lb_ResourceType" runat="server"></asp:Label> </td>
                </tr>
                <!--
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

                        
                    </td>
                </tr>
                -->
                <tr>
                    <td>Presentation duration:</td>
                    <td><asp:Label ID="lb_Duration" runat="server"></asp:Label> (seconds)</td>
                </tr>
                <tr>
                    <td>Time to answer:</td>
                    <td><asp:Label ID="lb_Time2Answer" runat="server"></asp:Label> (seconds)</td>
                </tr>
                <tr>
                    <td>Question:</td>
                    <td>
                        <asp:Label ID="lb_Question" runat="server"></asp:Label>
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
                                <tr class="tr">
                                    <td>
                                        <input type="checkbox" disabled="disabled"
                                            <%# DataBinder.Eval(Container.DataItem, "Correct", "{0}") == "1" ? "checked='checked'" : "" %> />
                                    </td>
                                    <td><%# DataBinder.Eval(Container.DataItem, "Answer") %>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>
                    </td>
                </tr>
            </table>
        </asp:Panel>

        <asp:Repeater ID="rpt_StepsList" runat="server">
            <HeaderTemplate>
                <table class="border" width="100%">
                    <colgroup>
                        <col />
                        <col width="10%" />
                    </colgroup>
                    <tr>
                        <th>Step name</th>
                        <th></th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                    <tr>
                        <td><%#DataBinder.Eval(Container.DataItem, "StepName") %></td>
                        <td><a href="<%=Request.Path %>?id=<%=_id %>&step=<%#DataBinder.Eval(Container.DataItem, "IdStep") %>" class="btn btn-primary">Details &raquo;</a></td>
                    </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </asp:Panel>
</asp:Content>