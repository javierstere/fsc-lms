using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Builder
{
    public partial class Builder : BaseBuilderPage // System.Web.UI.Page
    {
        protected string _builder;
        protected void Page_Load(object sender, EventArgs e)
        {
            _builder = Q["builder"];
            if (_builder == null)
            {
                PopulateList();
            }
            else
            {
                if (!IsPostBack)
                    PopulateDetails();
            }
        }

        private void PopulateList()
        {
            pnl_List.Visible = true;

            btn_AddNew.Visible = ((string)S["Builder.Type"] == "builder");

            DataSet ds = DB.RunSPReturnDS("Builder_List");

            if (ds.Tables[0].Rows.Count == 0)
            {
                pnl_NoBuilders.Visible = true;
            }
            else
            {
                rpt_List.DataSource = ds;
                rpt_List.DataBind();
            }

            if(S["Builder.Saved"] != null && (bool)S["Builder.Saved"]){
                S["Builder.Saved"] = null;
                pnl_BuilderSaved.Visible = true;
            }
        }

        private void PopulateDetails()
        {
            pnl_Details.Visible = true;

            bool enabled = ((string)S["Builder.Type"] == "builder");
            btn_Save.Enabled = enabled;
            btn_Delete.Enabled = enabled;

            DB.AddParam("id_builder", _builder);
            DataSet ds = DB.RunSPReturnDS("Builder_Details");

            DataRow row;
            if (ds.Tables[0].Rows.Count == 0)
            {
                row = ds.Tables[0].NewRow();
                row["InitiationDate"] = DateTime.Today;
            }
            else
            {
                row = ds.Tables[0].Rows[0];
            }

            tb_BuilderName.Text = row["BuilderName"].ToString();
            tb_Email.Text = row["Email"].ToString();
            tb_Phone.Text = row["Phone"].ToString();
            if(row["InitiationDate"].ToString() != "")
                tb_InitiationDate.Text = ((DateTime)row["InitiationDate"]).ToString("MM/dd/yyyy");
            ListItem item = cmb_Type.Items.FindByValue(row["Type"].ToString());
            if (item != null)
                item.Selected = true;
        }

        protected void btn_AddNew_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?builder=0");
        }


        protected void btn_Save_Click(object sender, EventArgs e)
        {
            string pass = null;
            if (tb_Password1.Text.Trim() != "" && tb_Password2.Text == tb_Password1.Text)
            {
                pass = tb_Password1.Text.Trim();
            }

            DB.AddParam("id_builder", _builder);
            DB.AddParam("builder_name", tb_BuilderName.Text);
            DB.AddParam("phone", tb_Phone.Text);
            DB.AddParam("email", tb_Email.Text);
            if (tb_InitiationDate.Text.Trim() == "")
            {
                DB.AddParam("initiation_date", null);
            }
            else
            {
                try
                {
                    DateTime date = DateTime.ParseExact(tb_InitiationDate.Text, "MM/dd/yyyy", null);
                    DB.AddParam("initiation_date", date);
                }
                catch
                {
                    DB.AddParam("initiation_date", null);
                }

            }
            DB.AddParam("type", cmb_Type.SelectedValue);
            DB.AddParam("password", pass);
            DataSet ds = DB.RunSPReturnDS("Builder_Save");

            _builder = ds.Tables[0].Rows[0]["Id"].ToString();
            //Response.Redirect(Request.Path + "?builder=" + _builder);
            S["Builder.Saved"] = true;
            Response.Redirect(Request.Path);
        }

        protected void btn_Cancel_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path);
        }

        protected void btn_Delete_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_builder", _builder);
            DB.RunSP("Builder_Delete");
            Response.Redirect(Request.Path);
        }
    }
}