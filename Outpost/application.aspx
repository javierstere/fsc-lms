<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="Outpost.Utils" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%=System.Web.Hosting.HostingEnvironment.MapPath("/") %>
            <table>
                <tr>
                    <td>Application.Log.Level</td>
                    <td><asp:TextBox ID="tb_LogLevel" runat="server"></asp:TextBox></td>
                    <td><asp:Button ID="btn_SaveLogLevel" runat="server" Text="Save" OnClick="btn_SaveLogLevel_Click" /></td>
                </tr>
            </table>
        </div>
    </form>
</body>



<!-- ------------------------------------------------------------------------------------------------ -->



    <script runat="server">

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                tb_LogLevel.Text = Outpost.Utils.Log.Level.ToString();
            }
        }

        protected void btn_SaveLogLevel_Click(object sender, EventArgs e)
        {
            Outpost.Utils.Log.Level = int.Parse(tb_LogLevel.Text);
            Response.Redirect(Request.Path);
        }

    </script>
</html>
