<%@ Page Language="C#" Title="Module" MasterPageFile="~/Builder/Builder.Master" AutoEventWireup="true" ValidateRequest="false" CodeBehind="Module.aspx.cs" Inherits="FSC.Builder.Module" %>
<%@ Register TagPrefix="Common" TagName="Module" Src="~/Common/Module.ascx" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <Common:Module runat="server" />
    
</asp:Content>