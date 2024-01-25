<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="Test.aspx.cs" Inherits="FSC.Test" %>


<asp:Content ContentPlaceHolderID="head" runat="server">
    <!--<script type="text/javascript" src="https://gdio.ro/programari/load.aspx?account=11592001173731&version=Programari/v030/Load.aspx?clinica=finas.medical"></script>-->
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
       <div class="jumbotron">
        <h1>Schedule</h1>
        <div id="programari">
            
        </div>
            Time: <b><span id="time"></span></b>
    </div>

    <script type="text/javascript">
                function DisplayTime() {
                    var dt = new Date(<%= DateTime.UtcNow
                                .Subtract(new DateTime(1970,1,1,0,0,0,DateTimeKind.Utc))
                                    .TotalMilliseconds %>);
                    

                    document.getElementById("time").innerHTML = dt;
                    
        }
        DisplayTime();
        </script>

</asp:Content>
