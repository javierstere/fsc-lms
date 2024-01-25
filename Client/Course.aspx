<%@ Page Language="C#" Title="Course" MasterPageFile="~/Client/Client.Master" AutoEventWireup="true" CodeBehind="Course.aspx.cs" Inherits="FSC.Client.Course" %>
<%@ Register TagPrefix="Common" TagName="Course" Src="~/Common/Course.ascx" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <Common:Course runat="server" />   
</asp:Content>