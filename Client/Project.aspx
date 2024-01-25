<%@ Page Language="C#" Title="Projects" MasterPageFile="~/Client/Client.Master" AutoEventWireup="true" CodeBehind="Project.aspx.cs" Inherits="FSC.Client.Project" %>
<%@ Register TagPrefix="Common" TagName="Project" Src="~/Common/Project.ascx" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <Common:Project runat="server" />   
</asp:Content>