<%@ Page Title="Employee" MasterPageFile="~/Client/Client.Master" Language="C#" AutoEventWireup="true" CodeBehind="Employee.aspx.cs" Inherits="FSC.Client.Employee" %>
<%@ Register TagPrefix="Common" TagName="Employee" Src="~/Common/Employee.ascx" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<Common:Employee runat="server" />


</asp:Content>