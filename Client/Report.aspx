<%@ Page Title="Reports" Language="C#" AutoEventWireup="true" MasterPageFile="~/Client/Client.Master" CodeBehind="Report.aspx.cs" Inherits="FSC.Client.Report" %>
<%@ Register TagPrefix="Common" TagName="Report" Src="~/Common/Report.ascx" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <Common:Report runat="server" />
</asp:Content>