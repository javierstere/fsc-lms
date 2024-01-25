using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FSC.Builder
{
    public partial class Client : BaseBuilderPage   //System.Web.UI.Page
    {
        protected string _client;
        protected string _admin;

        protected string _client_name;

        protected string _tab = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            _client = Q["client"];
            _admin = Q["admin"];
            _tab = Q["tab"];
            _univ = Q["univ"];

            if (_client != null)
            {
                if (!IsPostBack)
                    PopulateDetails();
            }
            else
            {
                if (!IsPostBack) {
                    if (S["Client.SearchFilter"] != null)
                        tb_SearchClient.Text = (string)S["Client.SearchFilter"];
                    btn_SearchClient_Click(null, null);
                }
            }
        }

        DataSet dsClients;

        protected void btn_SearchClient_Click(object sender, EventArgs e)
        {
            pnl_List.Visible = true;

            S["Client.SearchFilter"] = tb_SearchClient.Text;

            DB.AddParam("id_builder", S["Builder.Id"]);
            DB.AddParam("filter", tb_SearchClient.Text);
            dsClients = DB.RunSPReturnDS("Client_List");

            rpt_List.DataSource = dsClients.Tables[0];
            rpt_List.DataBind();
        }


        
        protected string GetAdministrators(object container)
        {
            string ret = "";
            DataRowView drv = (DataRowView)container;
            DataView dv = new DataView(dsClients.Tables[1]);
            dv.RowFilter = "IdClient=" + drv["IdClient"].ToString();
            foreach(DataRowView row in dv)
            {
                ret += "<div>" + row["AdministratorName"].ToString() + "</div>";
            }
            return ret;
        }
        protected string GetAssignedBuilders(object container)
        {
            string ret = "";
            DataRowView drv = (DataRowView)container;
            DataView dv = new DataView(dsClients.Tables[2]);
            dv.RowFilter = "IdClient=" + drv["IdClient"].ToString();
            foreach (DataRowView row in dv)
            {
                ret += "<div>" + row["BuilderName"].ToString() + "</div>";
            }
            return ret;
        }

        protected void btn_AddNew_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?client=0");
        }

        private void PopulateDetails()
        {
            pnl_Search.Visible = false;
            pnl_Details.Visible = true;

            DB.AddParam("id_client", _client);
            DataSet ds = DB.RunSPReturnDS("Client_Details");

            DataRow row;
            if(ds.Tables[0].Rows.Count == 0)
            {
                row = ds.Tables[0].NewRow();
            }
            else
            {
                row = ds.Tables[0].Rows[0];
            }

            _client_name = row["ClientName"].ToString();

            if (_tab == null)
            {
                pnl_Details1.Visible = true;
                tb_ClientName.Text = row["ClientName"].ToString();
                tb_State.Text = row["State"].ToString();
                tb_City.Text = row["City"].ToString();
                tb_Address.Text = row["Address"].ToString();
                tb_Phone.Text = row["Phone"].ToString();
                tb_Email.Text = row["Email"].ToString();

                if(System.IO.File.Exists(MapPath("/Client/Logo/" + _client + ".png")))
                {
                    img_Logo.Visible = true;
                    img_Logo.ImageUrl = "/Client/Logo/" + _client + ".png";
                    fu_Logo.Visible = false;
                    btn_Remove.Visible = true;
                }
            }

            if (_tab == "administrator")
            {
                pnl_Details_Admin.Visible = true;
            }

            if (_tab == "access")
            {
                pnl_Details_Access.Visible = true;

                tb_ContactPerson.Text = row["ContactPerson"].ToString();
                tb_TitleRole.Text = row["TitleRole"].ToString();
                tb_AccessEmail.Text = row["AccessEmail"].ToString();

                tb_MaxAdmins.Text = row["MaxAdmins"].ToString();
                tb_MaxUniversities.Text = row["MaxUniversities"].ToString();
                tb_MaxEmployees.Text = row["MaxEmployees"].ToString();
                tb_MaxActiveEmployees.Text = row["MaxActiveEmployees"].ToString();
                tb_MaxModules.Text = row["MaxModules"].ToString();
                tb_MaxProjects.Text = row["MaxProjects"].ToString();
            }

            if (_tab == "university")
            {
                pnl_Details_University.Visible = true;
                PopulateUniversity();
            }
            if (_tab == "project")
            {
                pnl_Details_Project.Visible = true;
            }
            if (_tab == "employee")
            {
                pnl_Details_Employee.Visible = true;
            }
            if(_tab == "builder")
            {
                pnl_Details_Builder.Visible = true;
                PopulateBuilders();
            }
            if(_tab == "report")
            {
                pnl_Details_Report.Visible = true;
            }
            if (_tab == "training")
            {
                pnl_Details_Training.Visible = true;
                PopulateVisibleModules();
            }
            //PopulateAdmin();
        }

        protected void PopulateVisibleModules()
        {
            DB.AddParam("id_client", _client);
            DataSet ds = DB.RunSPReturnDS("ModuleClient_List");
            rpt_Modules.DataSource = ds;
            rpt_Modules.DataBind();
        }

        protected string GetModuleCheckbox(object container)
        {
            DataRowView drv = (DataRowView)container;
            string ret = "";
            ret += "<input type='hidden' value='" + (drv["Selected"].ToString() != "" ? "1" : "0") + "' "
                + " name='module_h_" + drv["IdModule"].ToString() + "' />";

            ret += "<input type='checkbox'";

            ret += " name='module_" + drv["IdModule"].ToString() + "' ";

            if (drv["Selected"].ToString() == "1" )
                ret += " checked='checked' ";

            ret += " />";

            return ret;
        }

        protected void btn_SaveModules_Click(object sender, EventArgs e)
        {
            foreach (string key in F)
            {
                if (key.StartsWith("module_h_"))
                {
                    string id_module = key.Substring("module_h_".Length);
                    DB.AddParam("id_client", _client);
                    DB.AddParam("id_module", id_module);
                    DB.AddParam("active", F[key.Replace("module_h_", "module_")] == "on" ? "1" : "0");

                    DB.RunSP("ModuleClient_Save");
                }
            }

            Response.Redirect(Request.Path + "?" + Request.QueryString);
        }

        protected void PopulateBuilders()
        {
            DB.AddParam("id_client", _client);
            DataSet ds = DB.RunSPReturnDS("ClientBuilder_List");
            rpt_Builders.DataSource = ds;
            rpt_Builders.DataBind();
        }

        protected string GetBuilderCheckbox(object container)
        {
            DataRowView drv = (DataRowView)container;
            string ret = "";
            ret += "<input type='hidden' value='" + (drv["IdClientBuilder"].ToString() != "" ? "1" : "0") + "' " 
                + " name='builder_h_" + drv["IdBuilder"].ToString() + "' />";

            ret += "<input type='checkbox'";

            ret += " name='builder_" + drv["IdBuilder"].ToString() + "' ";
            //ret += "id='builder_" + drv["IdBuilder"].ToString() + "' ";

            if (drv["Type"].ToString() == "B" || drv["IdClientBuilder"].ToString() != "")
                ret += " checked='checked' ";

            ret += " />"; 
            
            return ret;
        }

        protected void btn_SaveBuilders_Click(object sender, EventArgs e)
        {
            foreach(string key in F)
            {
                if (key.StartsWith("builder_h_"))
                {
                    string id_builder = key.Substring("builder_h_".Length);
                    DB.AddParam("id_client", _client);
                    DB.AddParam("id_builder", id_builder);
                    DB.AddParam("active", F[key.Replace("builder_h_", "builder_")] == "on" ? "1" : "0");

                    DB.RunSP("ClientBuilder_Save");
                }
            }

            Response.Redirect(Request.Path + "?" + Request.QueryString);
        }

        protected void btn_Save_Click(object sender, EventArgs e)
        {
            if (tb_ClientName.Text.Trim() == "")
                return;

            DB.AddParam("id_client", _client);
            DB.AddParam("id_builder", S["Builder.Id"]);
            DB.AddParam("client_name", tb_ClientName.Text);
            DB.AddParam("state", tb_State.Text);
            DB.AddParam("city", tb_City.Text);
            DB.AddParam("address", tb_Address.Text);
            DB.AddParam("phone", tb_Phone.Text);
            DB.AddParam("email", tb_Email.Text);
            DataSet ds = DB.RunSPReturnDS("Client_Save");

            _client = ds.Tables[0].Rows[0]["Id"].ToString();

            if (fu_Logo.HasFile)
            {
                // upload a logo file
                string logo = MapPath("/Client/Logo/");
                logo = System.IO.Path.Combine(logo, _client + System.IO.Path.GetExtension(fu_Logo.FileName));
                fu_Logo.SaveAs(logo);
                if(System.IO.Path.GetExtension(logo).ToLower() != ".png")
                {
                    // convert to PNG
                    using (System.Drawing.Image img = System.Drawing.Image.FromFile(logo))
                        img.Save(MapPath("/Client/Logo/") + System.IO.Path.GetFileNameWithoutExtension(logo) + ".png", System.Drawing.Imaging.ImageFormat.Png);
                    System.IO.File.Delete(logo);
                }
            }

            Response.Redirect(Request.Path + "?client=" + _client);
        }

        protected void btn_Cancel_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path);
        }

        protected void btn_Delete_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_client", _client);
            DB.RunSP("Client_Delete");
            Response.Redirect(Request.Path);
        }

        protected void btn_SaveAccess_Click(object sender, EventArgs e)
        {
            string pass = null;
            if (tb_Password1.Text.Trim() != "" && tb_Password2.Text == tb_Password1.Text)
            {
                pass = tb_Password1.Text.Trim();
            }
            DB.AddParam("id_client", _client);
            DB.AddParam("contact_person", tb_ContactPerson.Text);
            DB.AddParam("title_role", tb_TitleRole.Text);
            DB.AddParam("access_email", tb_AccessEmail.Text);

            DB.AddParam("max_admins", tb_MaxAdmins.Text);
            DB.AddParam("max_universities", tb_MaxUniversities.Text);
            DB.AddParam("max_employees", tb_MaxEmployees.Text);
            DB.AddParam("max_active_employees", tb_MaxActiveEmployees.Text);
            DB.AddParam("max_modules", tb_MaxModules.Text);
            DB.AddParam("max_projects", tb_MaxProjects.Text);

            DB.AddParam("password", pass);
            DB.RunSP("Client_Save_Access");
            Response.Redirect(Request.Path + "?" + Request.QueryString);
        }

        protected string _univ;
        private void PopulateUniversity()
        {
            if(_univ == null)
            {
                pnl_ListUniversity.Visible = true;
                DB.AddParam("id_client", _client);
                DataSet ds = DB.RunSPReturnDS("University_List");
                if (ds.Tables[0].Rows.Count > 0)
                {
                    rpt_ListUniversity.DataSource = ds;
                    rpt_ListUniversity.DataBind();

                    btn_UniversityAdd.Enabled = ((int)ds.Tables[1].Rows[0]["MaxUniversities"] > ds.Tables[0].Rows.Count);
                }
                else
                {
                    pnl_NoUniversity.Visible = true;
                }
            }
            else
            {
                if (!IsPostBack)
                {
                    pnl_DetailsUniversity.Visible = true;
                    DB.AddParam("id_university", _univ);
                    DB.AddParam("id_client", _client);
                    DataSet ds = DB.RunSPReturnDS("University_Details");

                    DataRow row = null;
                    if (ds.Tables[0].Rows.Count == 0)
                    {
                        row = ds.Tables[0].NewRow();
                    }
                    else
                    {
                        row = ds.Tables[0].Rows[0];
                    }
                    tb_UniversityDescription.Text = row["Description"].ToString();
                    tb_UniversityLink.Text = row["Link"].ToString();
                    cb_UniversityEnabled.Checked = row["Enabled"].ToString() == "1";
                    lb_UniversityLink.Text = BASE_ADDRESS + "/" + row["Link"].ToString();
                }
            }
        }

        protected void btn_UniversityAdd_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?" + Request.QueryString + "&univ=0");
        }

        protected void btn_SaveUniversity_Click(object sender, EventArgs e)
        {
            string link = tb_UniversityLink.Text;

            if (link.Trim() == "")
                link = tb_ClientName.Text.Trim();

            char[] chars_link = link.ToCharArray();

            for (int i = 0; i < chars_link.Length; i++)
            {
                bool valid = false;
                if (chars_link[i] >= '0' && chars_link[i] <= '9')
                    valid = true;
                if (chars_link[i] >= 'a' && chars_link[i] <= 'z')
                    valid = true;
                if (chars_link[i] >= 'A' && chars_link[i] <= 'Z')
                    valid = true;

                if (!valid)
                    chars_link[i] = '-';
            }

            link = new string(chars_link);

            DB.AddParam("id_university", _univ);
            DB.AddParam("id_client", _client);
            DB.AddParam("enabled", cb_UniversityEnabled.Checked ? "1" : "0");
            DB.AddParam("description", tb_UniversityDescription.Text);
            DB.AddParam("link", link);
            DataSet ds = DB.RunSPReturnDS("University_Save");
            string prev = _univ;
            _univ = ds.Tables[0].Rows[0]["Id"].ToString();
            string query = Request.QueryString.ToString();
            if(prev != _univ)
                query = query.Replace("&univ=" + prev, "&univ=" + _univ);

            RestartApp();

            Response.Redirect(Request.Path + "?" + query);
        }

        protected void btn_CancelUniversity_Click(object sender, EventArgs e)
        {
            string query = Request.QueryString.ToString();
            query = query.Replace("&univ=" + _univ, "");
            Response.Redirect(Request.Path + "?" + query);
        }

        protected void btn_DeleteUniversity_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_university", _univ);
            DB.AddParam("id_client", _client);
            DB.RunSP("University_Delete");

            btn_CancelUniversity_Click(null, null);
        }

        protected void btn_Remove_Click(object sender, EventArgs e)
        {
            System.IO.File.Delete(MapPath("/Client/Logo/" + _client + ".png"));
            Response.Redirect(Request.Path + "?" + Request.QueryString);
        }
    }
}