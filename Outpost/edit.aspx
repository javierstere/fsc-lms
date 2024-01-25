<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Xml" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>

<table>
<tr>
	<td>
		<asp:repeater id="rpt_Folders" runat="server">
			<ItemTemplate>
				<div><%# Container.DataItem %></div>
			</ItemTemplate>
		</asp:repeater>
		<asp:repeater id="rpt_Files" runat="server">
			<ItemTemplate>
				<div><%# Container.DataItem %></div>
			</ItemTemplate>
		</asp:repeater>
	</td>
</tr>
<tr>
	<td>
	</td>
</tr>
</table>

</body>
<!-- ------------------------------------------------------------------------------------------------ -->



<script runat="server">
	

	protected void Page_Load(object sender, EventArgs e)
    	{
		string offset = "";

		string root = MapPath("/");
		
		string start = System.IO.Path.Combine(root, offset);

		ShowFolders(start);
		ShowFiles(start);
	}
	
	private void ShowFolders(string start)
	{
		string[]folders = System.IO.Directory.GetDirectories(start, "*", SearchOption.TopDirectoryOnly);
		for(int i=0;i<folders.Length;i++){
			folders[i] = folders[i].Substring(start.Length);
		}
		rpt_Folders.DataSource = folders;
		rpt_Folders.DataBind();
	}

	private void ShowFiles(string start)
	{
		
		string[]files = System.IO.Directory.GetFiles(start, "*", SearchOption.TopDirectoryOnly);
		for(int i=0;i<files.Length;i++){
			files[i] = files[i].Substring(start.Length);
		}
		rpt_Files.DataSource = files;
		rpt_Files.DataBind();
	}



</script>
</html>
