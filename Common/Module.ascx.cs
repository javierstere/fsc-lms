using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Ionic.Zip;

namespace FSC.Common
{
    public partial class Module : Outpost.Utils.BaseUserControl   //System.Web.UI.UserControl
    {
        protected string _client;
        protected string _module;
        protected string _preview;
        protected string _embed;
        protected string _question;

        protected string _selected_employee;

        string _content_type = null;
        protected bool _direct_check_only = false;
        string _extra_title = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            //if(Q["content"] != null)
            //{
            //    S["Module.Content"] = Q["content"];
            //    Response.Redirect(Request.Path);
            //    return;
            //}

            _module = Q["module"];
            _preview = Q["preview"];
            _question = Q["question"];

            if (_preview != null)
            {
                Preview();
                return;
            }

            _client = (string)S["Client.Id"];
            if (Q["client"] != null)
                _client = Q["client"];

            if (_module == null)
            {
                PopulateList();
            }
            else
            {
                if (!IsPostBack)
                    PopulateDetails();
            }

            if (_extra_title != null)
                lt_ExtraTitle.Text = " - " + _extra_title;
        }

        public string ContentType
        {
            set { _content_type = value; }
        }
        public bool DireckCheckOnly
        {
            set { _direct_check_only = value; }
        }

        public string ExtraTitle
        {
            set { _extra_title = value;  }
        }
        private void Preview()
        {
            DB.AddParam("id_module", _preview);
            DataSet ds = DB.RunSPReturnDS("Module_Details");
            string path = ds.Tables[0].Rows[0]["Path"].ToString();

            string type = ds.Tables[0].Rows[0]["Type"].ToString().ToLower();
            if (type == "video")
            {
                pnl_Youtube.Visible = true;
                _embed = ds.Tables[0].Rows[0]["Path"].ToString();
            }
            else if (type == ".pptx" || type == ".ppsx")
            {
                pnl_PPT.Visible = true;
                _embed = ds.Tables[0].Rows[0]["Path"].ToString();
                _embed = "/Module/" + HttpUtility.UrlEncode(_embed).Replace("%5c", "/");
                //_embed = _embed.Replace("\\", "/");

            }
            else
            {

                path = path.Replace("\\", "/");

                path = HttpUtility.UrlPathEncode(path);

                Response.Redirect("/Module/" + path);
            }
        }

        protected void btn_AddNew_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?module=0");
        }

        private void PopulateList()
        {
            pnl_List.Visible = true;

            DB.AddParam("id_client", _client);
            //DB.AddParam("content", (string)S["Module.Content"]);
            DB.AddParam("content", _content_type);
            if(_direct_check_only)
                DB.AddParam("direct_check", "1");
            DataSet ds = DB.RunSPReturnDS("Module_List");
            rpt_List.DataSource = ds;
            rpt_List.DataBind();

            if (_content_type != null)
                btn_AddNew.Visible = (_content_type == "local");
            if (_direct_check_only)
                btn_AddNew.Visible = false;
            if (ds.Tables.Count > 1)
                btn_AddNew.Enabled = (int)ds.Tables[1].Rows[0]["MaxModules"] > (int)ds.Tables[2].Rows[0]["LocalModules"];
        }

        private void PopulateDetails()
        {
            if (_module == "0")
            {
                pnl_NewModule.Visible = true;
                return;
            }
            pnl_Details.Visible = true;

            DB.AddParam("id_module", _module);
            DataSet ds = DB.RunSPReturnDS("Module_Details");
            DataRow row = ds.Tables[0].Rows[0];

            if(_client != null && row["IdClient"].ToString() == "")
            {
                btn_Save.Enabled = false;
                btn_Delete.Enabled = false;
                btn_AddNewQuestion.Enabled = false;

                btn_SaveAndNewQuestion.Enabled = false;
                btn_SaveQuestion.Enabled = false;
                btn_DeleteQuestion.Enabled = false;
            }

            string choose_file = Q["choose"];
            if (choose_file != null)
            {
                string current = HttpUtility.UrlDecode(Q["folder"]);
                if (current == null)
                    current = row["Path"].ToString();
                

                if (Q["file"] != null)
                {
                    // file choosen
                    DB.AddParam("id_module", _module);
                    DB.AddParam("id_client", _client);
                    DB.AddParam("module_name", null);
                    DB.AddParam("type", null);
                    DB.AddParam("path", Q["file"]);

                    DB.RunSPReturnDS("Module_Save");
                    Response.Redirect(Request.Path + "?module=" + _module);
                }
                else
                {
                    pnl_ChooseFile.Visible = true;

                    string start = MapPath("/Module/");
                    //string current = HttpUtility.UrlDecode(row["Path"].ToString());

                    string path = System.IO.Path.Combine(start, current);
                    string folder = path;
                    if(Q["folder"] == null)
                        folder = System.IO.Path.GetDirectoryName(path);

                    DataSet dsFiles = new DataSet();
                    DataTable tbl = dsFiles.Tables.Add();
                    tbl.Columns.Add("Type");
                    tbl.Columns.Add("Name");
                    tbl.Columns.Add("Filename");

                    string[] folders = System.IO.Directory.GetDirectories(folder, "*.*", System.IO.SearchOption.TopDirectoryOnly);

                    //string top_folder = System.IO.Path.GetDirectoryName(folder + "\\").Replace(start, "");
                    if (folder != (start + _module))
                    {
                        DataRow rowUp = tbl.NewRow();
                        rowUp["Type"] = "folder";
                        rowUp["Name"] = "..";
                        rowUp["Filename"] = System.IO.Path.GetDirectoryName(folder).Replace(start, "");
                        tbl.Rows.Add(rowUp);
                    }


                    foreach (string dir in folders)
                    {
                        DataRow rowFile = tbl.NewRow();
                        rowFile["Type"] = "folder";
                        rowFile["Name"] = dir.Replace(start + _module + "\\", "");
                        rowFile["Filename"] = HttpUtility.UrlEncode(dir.Replace(start, ""));
                        tbl.Rows.Add(rowFile);
                    }

                    string[] files = System.IO.Directory.GetFiles(folder, "*.*", System.IO.SearchOption.TopDirectoryOnly);
                    foreach (string file in files)
                    {
                        DataRow rowFile = tbl.NewRow();
                        rowFile["Type"] = "file";
                        rowFile["Name"] = file.Replace(start + _module + "\\", "");
                        rowFile["Filename"] = HttpUtility.UrlEncode(file.Replace(start, ""));
                        tbl.Rows.Add(rowFile);
                    }

                    rpt_FilesList.DataSource = dsFiles;
                    rpt_FilesList.DataBind();

                    return;
                }
            }
            pnl_DetailsInner.Visible = true;

            tb_ModuleName.Text = row["ModuleName"].ToString();
            tb_Type.Text = row["Type"].ToString();
            if (tb_Type.Text == ".ZIP")
            {
                tb_Path.ReadOnly = true;
                btn_ChooseFile.Visible = true;
            }
            tb_Path.Text = row["Path"].ToString();
            if(tb_Type.Text != "video")
                tb_Path.Text = tb_Path.Text.Substring(_module.Length + 1);

            cb_QuizSessions.Checked = row["QuizSessions"].ToString() == "1";
            cb_DirectCheck.Checked = row["DirectCheck"].ToString() == "1";
            tb_Delay.Text = row["Delay"].ToString();
            if(!_direct_check_only)
                PopulateQuestion();
            else
            {
                btn_Save.Visible = false;
                btn_Delete.Visible = false;
                if((string)S["Client.Auth"] == "administrator")
                {
                    PopulateDirectCheck();
                }
            }
        }

        private void PopulateDirectCheck()
        {
            pnl_DirectObservation.Visible = true;

            DB.AddParam("id_client", _client);
            DB.AddParam("id_administrator", (string)S["Client.IdAdministrator"]);
            DB.AddParam("id_module", _module);
            DataSet ds = DB.RunSPReturnDS("DirectCheck_GetSelected");

            if(ds.Tables[0].Rows.Count > 0)
            {
                pnl_DirectObservation_Start.Visible = true;

                _selected_employee = ds.Tables[0].Rows[0]["EmployeeName"].ToString();
            }
            else
            {
                pnl_DirectObservation_Select.Visible = true;
            }
        }

        protected void btn_CancelUpload_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path);
        }

        protected void btn_SaveYoutubeLink_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_module", "0");
            DB.AddParam("id_client", _client);
            DB.AddParam("module_name", tb_LinkDescription.Text);
            DB.AddParam("type", "video");
            DB.AddParam("path", tb_YoutubeLink.Text);

            DataSet ds = DB.RunSPReturnDS("Module_Save");
            _module = ds.Tables[0].Rows[0]["Id"].ToString();

            Response.Redirect(Request.Path + "?" + Q.ReplaceKey("module", _module));
        }

        protected void btn_Upload_Click(object sender, EventArgs e)
        {
            if (fu_File.HasFile)
            {
                string filename = fu_File.FileName;
                string type = System.IO.Path.GetExtension(filename).ToUpper();
                string name = System.IO.Path.GetFileNameWithoutExtension(filename);

                DB.AddParam("id_module", "0");
                DB.AddParam("id_client", _client);
                DB.AddParam("module_name", name);
                DB.AddParam("type", type);
                DB.AddParam("path", null);

                DataSet ds = DB.RunSPReturnDS("Module_Save");
                _module = ds.Tables[0].Rows[0]["Id"].ToString();

                string path = MapPath("/Module/");
                filename = filename.Replace(" ", "-");
                string path_base = System.IO.Path.Combine(path, _module);
                if (!System.IO.Directory.Exists(path_base))
                    System.IO.Directory.CreateDirectory(path_base);

                string path_db = System.IO.Path.Combine(_module, filename);
                path = System.IO.Path.Combine(path, path_db);

                fu_File.SaveAs(path);

                DB.AddParam("id_module", _module);
                DB.AddParam("id_client", _client);
                DB.AddParam("module_name", name);
                DB.AddParam("type", type);
                DB.AddParam("path", path_db);

                DB.RunSPReturnDS("Module_Save");

                if (type == ".ZIP")
                {
                    using (ZipFile zf = ZipFile.Read(path))
                    {
                        foreach (ZipEntry entry in zf)
                        {
                            entry.Extract(path_base, ExtractExistingFileAction.OverwriteSilently);
                        }
                    }

                }

                Response.Redirect(Request.Path + "?" + Q.ReplaceKey("module", _module));
            }
        }

        protected void btn_ChooseFile_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?module=" + _module + "&choose=1");   // + HttpUtility.UrlEncode(tb_Path.Text));
        }

        protected void btn_Save_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_module", _module);
            DB.AddParam("id_client", _client);
            DB.AddParam("module_name", tb_ModuleName.Text);
            DB.AddParam("type", null);
            if(tb_Type.Text == "video")
                DB.AddParam("path", tb_Path.Text);
            else
                DB.AddParam("path", null);
            DB.AddParam("quiz_sessions", cb_QuizSessions.Checked ? "1" : "0");
            DB.AddParam("direct_check", cb_DirectCheck.Checked ? "1": "0");
            DB.AddParam("delay", tb_Delay.Text);
            DB.RunSPReturnDS("Module_Save");

            //Response.Redirect(Request.Path + "?" + Q.ReplaceKey("module", _module));
            Response.Redirect(Request.Path + "?" + Q.WithoutKey("module"));
        }

        protected void btn_Cancel_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path);
        }

        protected void btn_Delete_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_module", _module);
            DataSet ds = DB.RunSPReturnDS("Module_Details");
            if(ds.Tables[0].Rows[0]["Type"].ToString() != "video")
            {
                try
                {
                    string path = MapPath("/Module/");
                    path = System.IO.Path.Combine(path, _module);
                    System.IO.Directory.Delete(path, true);
                }
                catch
                {

                }
            }

            DB.AddParam("id_module", _module);
            DB.RunSPReturnDS("Module_Delete");
            Response.Redirect(Request.Path + "?" + Q.WithoutKey("module"));
        }



        //--------------------------------------------------------------------
        private void PopulateQuestion()
        {
            if (_question == null)
            {
                pnl_Questions.Visible = true;
                DB.AddParam("id_module", _module);
                DataSet ds = DB.RunSPReturnDS("QuizQuestion_List");
                rpt_Questions.DataSource = ds;
                rpt_Questions.DataBind();
            }
            else
            {
                pnl_QuestionDetails.Visible = true;

                DB.AddParam("id_quiz_question", _question);
                DataSet ds = DB.RunSPReturnDS("QuizQuestion_Details");
                DataRow row;
                if (ds.Tables[0].Rows.Count == 0)
                    row = ds.Tables[0].NewRow();
                else
                    row = ds.Tables[0].Rows[0];

                tb_Question.Text = row["Question"].ToString();


                DataRow last = ds.Tables[1].NewRow();
                ds.Tables[1].Rows.Add(last);

                rpt_Options.DataSource = ds.Tables[1];
                rpt_Options.DataBind();

            }
        }

        protected void btn_AddNewQuestion_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path +"?" + Request.QueryString + "&question=0");
        }

        private string SaveQuestion()
        {
            DB.AddParam("id_module", _module);
            DB.AddParam("id_step", null);
            DB.AddParam("id_quiz_question", _question);
            DB.AddParam("question", tb_Question.Text);
            DataSet ds = DB.RunSPReturnDS("QuizQuestion_Save");

            _question = ds.Tables[0].Rows[0]["Id"].ToString();



            DataSet dsValues = new DataSet();
            DB.FillTable(dsValues, "QuizAnswer", "IdQuizQuestion=" + _question);
            int index = 0;
            foreach (string key in Request.Form)
            {
                if (key.StartsWith("hd_") && key.EndsWith("_answer") && Request.Form[key].Trim() != "")
                {
                    string pos = key.Replace("hd_", "").Replace("_answer", "");
                    DataRow row = null;
                    if (dsValues.Tables[0].Rows.Count > index)
                    {
                        row = dsValues.Tables[0].Rows[index];
                    }
                    else
                    {
                        row = dsValues.Tables[0].NewRow();
                        row["IdQuizQuestion"] = _question;
                        row["Position"] = index;
                        dsValues.Tables[0].Rows.Add(row);
                    }

                    row["Answer"] = Request.Form["hd_" + pos + "_answer"];
                    row["Correct"] = Request.Form["hd_" + pos + "_correct"] != null ? "1" : "0";

                    index++;
                }
            }
            DB.UpdateTable(dsValues, "QuizAnswer");

            while (dsValues.Tables[0].Rows.Count > index)
            {
                DB.DeleteTable("QuizAnswer", "IdQuizAnswer="
                    + dsValues.Tables[0].Rows[dsValues.Tables[0].Rows.Count - 1]["IdQuizAnswer"].ToString());
                dsValues.Tables[0].Rows.RemoveAt(dsValues.Tables[0].Rows.Count - 1);
            }
            return _question;
        }

        protected void btn_SaveAndNewQuestion_Click(object sender, EventArgs e)
        {
            SaveQuestion();
            Response.Redirect(Request.Path + "?" + Q.ReplaceKey("question", "0"));
        }

        protected void btn_SaveQuestion_Click(object sender, EventArgs e)
        {
            _question = SaveQuestion();

            //Response.Redirect(Request.Path + "?" + Q.ReplaceKey("question", _question));
            Response.Redirect(Request.Path + "?" + Q.WithoutKey("question"));
        }

        protected void btn_CancelQuestion_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?" + Q.WithoutKey("question"));
        }

        protected void btn_DeleteQuestion_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_quiz_question", _question);
            DB.RunSP("QuizQuestion_Delete");

            Response.Redirect(Request.Path + "?" + Q.WithoutKey("question"));
        }

        protected void btn_ChooseAnother_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_client", _client);
            DB.AddParam("id_administrator", (string)S["Client.IdAdministrator"]);
            DB.AddParam("id_module", _module);
            //DB.AddParam("id_employee", _params);
            DB.RunSP("DirectCheck_Unselect");
            Response.Redirect(Request.Path + "?" + Request.QueryString);
        }

        protected void btn_ObservationPassed_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_client", _client);
            DB.AddParam("id_administrator", (string)S["Client.IdAdministrator"]);
            DB.AddParam("id_module", _module);
            DB.AddParam("status", "1");
            DB.RunSP("DirectCheck_EndTest");
            Response.Redirect(Request.Path + "?" + Request.QueryString);
        }

        protected void btn_ObservationNotPassed_Click(object sender, EventArgs e)
        {
            DB.AddParam("id_client", _client);
            DB.AddParam("id_administrator", (string)S["Client.IdAdministrator"]);
            DB.AddParam("id_module", _module);
            DB.AddParam("status", "0");
            DB.RunSP("DirectCheck_EndTest");
            Response.Redirect(Request.Path + "?" + Request.QueryString);
        }
    }
}