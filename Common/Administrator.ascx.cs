using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Common
{
    public partial class Administrator : Outpost.Utils.BaseUserControl    //System.Web.UI.UserControl
    {
        protected string _admin;
        protected string _client;
        protected string _extra;

        protected void Page_Load(object sender, EventArgs e)
        {
            _admin = Q["admin"];
            _extra = Q["tab"];
            if (_extra != null)
                _extra = "&tab=" + _extra;            

            _client = (string)S["Client.Id"];
            if (Q["client"] != null)
                _client = Q["client"];

            if(!IsPostBack)
                PopulateAdmin();
        }

        private void PopulateAdmin()
        {
            if (_admin == null)
            {
                DB.AddParam("id_client", _client);
                DataSet ds = DB.RunSPReturnDS("Administrator_List");

                pnl_ListAdministrator.Visible = true;

                if (ds.Tables[0].Rows.Count == 0)
                {
                    pnl_NoAdminstrator.Visible = true;
                }
                else
                {
                    rpt_Administrators.DataSource = ds;
                    rpt_Administrators.DataBind();

                    btn_AdministratorAdd.Enabled = ((int)ds.Tables[1].Rows[0]["MaxAdmins"] > ds.Tables[0].Rows.Count);
                }
            }
            else
            {
                pnl_DetailsAdministrator.Visible = true;
                DB.AddParam("id_client", _client);
                DB.AddParam("id_administrator", _admin);
                DataSet ds = DB.RunSPReturnDS("Administrator_Details");

                DataRow row;
                if (ds.Tables[0].Rows.Count == 0)
                {
                    row = ds.Tables[0].NewRow();
                }
                else
                {
                    row = ds.Tables[0].Rows[0];
                }

                tb_AdministratorName.Text = row["AdministratorName"].ToString();
                tb_AdministratorJobTitle.Text = row["JobTitle"].ToString();
                tb_AdministratorEmail.Text = row["Email"].ToString();
                tb_AdministratorPhone.Text = row["Phone"].ToString();
            }
        }

        protected void btn_SaveAdministrator_Click(object sender, EventArgs e)
        {
            string pass = null;
            if (tb_Password1.Text.Trim() != "" && tb_Password2.Text == tb_Password1.Text)
            {
                pass = tb_Password1.Text.Trim();
            }

            DB.AddParam("id_client", _client);
            DB.AddParam("id_administrator", _admin);
            DB.AddParam("administrator_name", tb_AdministratorName.Text);
            DB.AddParam("job_title", tb_AdministratorJobTitle.Text);
            DB.AddParam("email", tb_AdministratorEmail.Text);
            DB.AddParam("phone", tb_AdministratorPhone.Text);
            DB.AddParam("password", pass);
            DataSet ds = DB.RunSPReturnDS("Administrator_Save");

            _admin = ds.Tables[0].Rows[0]["Id"].ToString();
            //Response.Redirect(Request.Path + "?client=" + _client + "&admin=" + _admin);
            Response.Redirect(Request.Path + "?client=" + _client  +_extra);
        }

        protected void btn_CancelAdministrator_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?client=" + _client + _extra);
        }

        protected void btn_DeleteAdministrator_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_client", _client);
            DB.AddParam("id_administrator", _admin);
            DB.RunSP("Administrator_Delete");
            Response.Redirect(Request.Path + "?client=" + _client + _extra);
        }

        protected void btn_AdministratorAdd_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?client=" + _client + "&admin=0" + _extra);
        }
    }
}