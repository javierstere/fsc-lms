<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Frame.aspx.cs" Inherits="FSC.Client.Frame" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title><%=S["Client.Description"]%></title>
    <style>
        html, body{
            width: 100%;
            height: 100%;
            margin: 0;
        }
        iframe{
            width: 100%;
            height: 100%;
            margin: 0;

            position:fixed; 
            top:0px; 
            left:0px; 
            bottom:0px; 
            right:0px; 
            width:100%; 
            height:100%; 
            border:none; 
            margin:0; 
            padding:0; 
            overflow:hidden; 
            z-index:999999;"
        }
    </style>
</head>
<body>
    <!--<iframe src="/Client/Default.aspx" frameborder="0"></iframe>-->
    <div>
        <iframe src="/Client/Default.aspx?link=<%=_link %>" width="100%" height="100%" >
    </div>
    Your browser doesn't support iframes
</iframe>
</body>
</html>
