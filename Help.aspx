<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Help.aspx.cs" Inherits="FSC.Help" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Help</title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="text-align: center;">
            <%if (Request.QueryString["help"] == "youtube-share"){ %>
               
                Please click on “share” below the youtube video and choose “embedded” from the proposed list of sharing options. 
                    <br />From the pop-up window of sharing video, please copy al text starting with “&lt;iframe …” till (including) “…/iframe&gt;”
                    <br /><br />
                    <img src="/Resources/youtube-share.png" />

            <%} %>
        </div>
    </form>
</body>
</html>
