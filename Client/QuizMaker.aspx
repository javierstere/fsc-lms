<%@ Page Language="C#" Title="Quiz maker" MasterPageFile="~/Client/Client.Master" AutoEventWireup="true" ValidateRequest="false" CodeBehind="QuizMaker.aspx.cs" Inherits="FSC.Client.QuizMaker" %>
<%@ Register TagPrefix="Common" TagName="QuizMaker" Src="~/Common/QuizMaker.ascx" %>
<%@ Register TagPrefix="Common" TagName="QuizView" Src="~/Common/QuizView.ascx" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <%if(Q["preview"] == "1"){ %>
    <Common:QuizView runat="server" />
    <%}else{ %>
    <Common:QuizMaker runat="server" />
    <%} %>

</asp:Content>