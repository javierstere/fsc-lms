<%@ Page Title="Module" MasterPageFile="~/Client/Client.Master" Language="C#" AutoEventWireup="true" ValidateRequest="false" CodeBehind="Module.aspx.cs" Inherits="FSC.Client.Module" %>
<%@ Register TagPrefix="Common" TagName="Module" Src="~/Common/Module.ascx" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

<Common:Module runat="server" ID="module" />


</asp:Content>