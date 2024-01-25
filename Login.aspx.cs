using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC
{
    public partial class Login : Outpost.Utils.BaseWebPage    //System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Q["sa"] == "!") S["sa"] = null;
            if (Q["logout"] == "!")
            {
                bool sa = (string)S["sa"] == "!";
                S.Kill();
                if (sa)
                {
                    S["sa"] = "!";
                    Response.Redirect("/admin.aspx");
                }
                else
                {
                    Response.Redirect(Request.Path);
                }
            }
        }

        protected void btn_Login_Click(object sender, EventArgs e)
        {
            DB.AddParam("email", tb_Username.Text);
            DB.AddParam("password", tb_Password.Text);
            DataSet ds = DB.RunSPReturnDS("Builder_Authenticate");

            if(ds.Tables[0].Rows.Count > 0)
            {
                S["Builder.Id"] = ds.Tables[0].Rows[0]["IdBuilder"].ToString();
                string type = ds.Tables[0].Rows[0]["Type"].ToString();
                if (type == "B")
                    type = "builder";
                if (type == "C")
                    type = "cobuilder";
                S["Builder.Type"] = type;
                Response.Redirect("/Builder/Default.aspx");
            }
            else
            {
                pnl_WrongUserPass.Visible = true;
            }
        }

        public override bool MustBeAuthenticated()
        {
            return false;
        }

        protected void btn_CreateAccount_Click(object sender, EventArgs e)
        {

        }

        protected void btn_LostPassword_Click(object sender, EventArgs e)
        {

        }
    }
}