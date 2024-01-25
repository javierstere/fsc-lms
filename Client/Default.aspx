<%@ Page Title="Default" MasterPageFile="~/Client/Client.Master" Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="FSC.Client.Default" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="jumbotron">
        <%if (System.IO.File.Exists(MapPath("/Client/Logo/") + _client + ".png")){ %>
        <img style="float: right; margin-top: -20px; " src="/Client/Logo/<%=_client %>.png"  height="100" />
        <%} else { %>
        <!--<img style="float: right; margin-top: -20px; " src="/Resources/logo-bd.png"  height="100" />-->
        <img style="float: right; margin-top: -20px; " src="/Resources/doceo.png"  height="100" />
        <%} %>
        <h3><%=S["Client.Description"] %></h3><br />
    </div>
    <div class="row">
        <div class="col-md-12" style="align-content:center; text-align:center;">
            <img src="/Resources/i1.jpg" class="img-responsive" style="display: inline-block;" />
            <img src="/Resources/i2.jpg" class="img-responsive" style="display: inline-block;" />
            <img src="/Resources/i3.jpg" class="img-responsive" style="display: inline-block;" /> <!--  width="347" height="231"  -->
        </div>
    </div>
</asp:Content>