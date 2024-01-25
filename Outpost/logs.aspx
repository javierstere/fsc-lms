<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Repeater ID="rpt_Files" runat="server">
                <ItemTemplate>
                    <div>
                        <a href="<%=Request.Path%>?path=<%=DateTime.Today.ToString("yyyy-MM-dd") %>&file=<%#Container.DataItem %>" target="_blank"><%#Container.DataItem %></a>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </form>
</body>
 <script runat="server">

     protected void Page_Load(object sender, EventArgs e)
     {
         if(Request.QueryString["path"] != null && Request.QueryString["file"] != null)
         {
             Outpost.Utils.Log log = Outpost.Utils.Log.GetInstance(Context);
             Response.Clear();

             Response.ContentType = "text/plain";
             Response.TransmitFile(log.GetTodayLogFolder() + "\\" + Request.QueryString["file"]);

             Response.Flush();
             Response.End();
             return;
         }
         if (!IsPostBack)
         {
             PopulateLogsFromToday();
         }
     }

     private void PopulateLogsFromToday()
     {
         Outpost.Utils.Log log = Outpost.Utils.Log.GetInstance(Context);

         string[] files = System.IO.Directory.GetFiles(log.GetTodayLogFolder(), "*.log");
         for(int i = 0; i < files.Length; i++)
         {
             files[i] = System.IO.Path.GetFileName(files[i]);
         }
         rpt_Files.DataSource = files;
         rpt_Files.DataBind();
     }
     /*
          protected void btn_SaveLogLevel_Click(object sender, EventArgs e)
          {
              Outpost.Utils.Log.Level = int.Parse(tb_LogLevel.Text);
              Response.Redirect(Request.Path);
          }
     */
    </script>
</html>
