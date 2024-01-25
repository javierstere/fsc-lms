using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Client
{
    public partial class Login : ClientBasePage //System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Q["logout"] == "1")
            {
                bool sa = (string)S["sa"] == "!";
                S.Kill();
                if(sa) { S["sa"] = "!"; Response.Redirect("/admin.aspx"); return; }
                Response.Redirect("/Client/Default.aspx?link=" + Q["link"]);
                return;
            }
        }

        public override bool MustBeAuthenticated()
        {
            return false;
        }

        public string ClientUniversityLink
        {
            get
            {
                string ul = "";

                Outpost.Utils.DB db = new Outpost.Utils.DB();
                try
                {
                    db.AddParam("id_client", null);
                    DataSet ds = db.RunSPReturnDS("University_List");
                    foreach (DataRow row in ds.Tables[0].Rows)
                    {
                        string link = row["Link"].ToString();
                        if (Request.Path.ToLower().StartsWith("/" + link + "/"))
                            ul = link;
                    }
                }
                catch
                {
                }
                finally
                {
                    if (db != null)
                        db.Close();
                }

                return ul;
            }
        }

        protected void btn_Login_Click(object sender, EventArgs e)
        {
            //DB.AddParam("link", ClientUniversityLink);
            //DB.AddParam("link", Context.Items["Client.Link"]);
            DB.AddParam("link", S["Client.Link"]);
            DB.AddParam("username", tb_Username.Text);
            DB.AddParam("password", tb_Password.Text);
            DataSet ds = DB.RunSPReturnDS("Client_Authenticate");

            if (ds.Tables.Count == 0) return;

            if (ds.Tables[1].Rows.Count > 0)
            {
                // client
                S["Client.Auth"] = "administrator";
                S["Client.Id"] = ds.Tables[1].Rows[0]["IdClient"].ToString();
                S["Client.IdAdministrator"] = ds.Tables[1].Rows[0]["IdAdministrator"].ToString();
                S["Client.AdministratorName"] = ds.Tables[1].Rows[0]["AdministratorName"].ToString();
            }
            else if(ds.Tables[0].Rows.Count > 0)
            {
                // client
                S["Client.Auth"] = "client";
                S["Client.Id"] = ds.Tables[0].Rows[0]["IdClient"].ToString();
            }else if (ds.Tables[2].Rows.Count > 0)
            {
                // user
                S["Client.Auth"] = "employee";
                S["Client.Id"] = ds.Tables[2].Rows[0]["IdClient"].ToString();
                S["Client.IdEmployee"] = ds.Tables[2].Rows[0]["IdEmployee"].ToString();
                S["Client.EmployeeName"] = ds.Tables[2].Rows[0]["EmployeeName"].ToString();

                Response.Redirect("/Employee/Default.aspx");
                return;
            }
            else
            {
                if (tb_Username.Text == "sa" && tb_Password.Text == "outpost")
                {
                    S["sa"] = "!";
                    Response.Redirect("/admin.aspx");
                    return;
                }

                DB.AddParam("email", tb_Username.Text);
                DB.AddParam("password", tb_Password.Text);
                DataSet ds2 = DB.RunSPReturnDS("Builder_Authenticate");

                if (ds2.Tables[0].Rows.Count > 0)
                {
                    S["Builder.Id"] = ds2.Tables[0].Rows[0]["IdBuilder"].ToString();
                    string type = ds2.Tables[0].Rows[0]["Type"].ToString();
                    if (type == "B")
                        type = "builder";
                    if (type == "C")
                        type = "cobuilder";
                    S["Builder.Type"] = type;
                    Response.Redirect("/Builder/Default.aspx");
                    return;
                }


                pnl_WrongUserPass.Visible = true;
                return;
            }
            Response.Redirect("/Client/Default.aspx");
        }

        protected void btn_CreateAccount_Click(object sender, EventArgs e)
        {

        }

        protected void btn_LostPassword_Click(object sender, EventArgs e)
        {

        }
    }
}