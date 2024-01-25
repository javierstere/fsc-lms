using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

using System.Text;

using System.Data.SqlClient;
using System.Runtime.InteropServices;

namespace Outpost.Utils
{
    /// <summary>
    /// Handle the Database access. read, write to/from database.
    /// If this module will become bigger it will be moved in a different assembly.
    /// </summary>
    [Serializable]
    public class DB
    {
        public const string CONTEXT = "Outpost.DB";
        [NonSerialized]
        private SqlConnection sqlCon = null;

        [NonSerialized]
        private SqlCommand sqlCmd;
        [NonSerialized]
        private SqlDataAdapter sqlDA;
        private string _connection_string = null;
        private int commandTimeout = -1;
        // TRANSACTION Start

        Log _log = null;

        public DB()
        {
            _created_at = DateTime.Now;
        }

        public DB(Log log)
        {
            _created_at = DateTime.Now;
            _log = log;
        }

        public static DB GetInstance(HttpContext context)
        {
            DB db = null;
            if (context != null)
                db = (DB)context.Items[CONTEXT];
            if (db == null)
            {
                db = new DB();
                if (context != null)
                    context.Items[CONTEXT] = db;
            }
            return db;
        }

        public static DB GetInstance(HttpContext context, Log log)
        {
            DB db = null;
            if (context != null)
                db = (DB)context.Items[CONTEXT];
            if (db == null)
            {
                db = new DB(log);
                if (context != null)
                    context.Items[CONTEXT] = db;
            }
            return db;
        }

        DateTime _created_at;
        public string SessionId;

        public string LogActivity(string app, HttpContext context, string message)
        {
            string id = "";
            // log connection time and some messages
            try
            {
                TimeSpan ts = DateTime.Now.Subtract(_created_at);

                string browser =
                    //context.Request.Browser.Type + ";" +
                    //context.Request.Browser.Browser + ";" +
                    //context.Request.Browser.Version + ";" +
                    (context.Request.Browser.IsMobileDevice ? "mobile" : "desktop") + ";" +
                    //context.Request.Browser.Platform + ";" + 
                    "[" + context.Request.UserAgent + "]"
                    ;



                AddParam("start_time", _created_at);
                AddParam("duration", ts.TotalMilliseconds);
                AddParam("application", app);
                AddParam("browser", browser);
                AddParam("page", context.Request.Path);
                AddParam("query", context.Request.QueryString.ToString());
                AddParam("session_id", SessionId);
                AddParam("message", message);

                DataSet ds = RunSPReturnDS("Outpost_Log_Add");
                id = ds.Tables[0].Rows[0][0].ToString();
            }
            catch
            {

            }
            return id;
        }


        private string _tag = "";
        public string Tag
        {
            get { return _tag; }
            set { _tag = value; }
        }
        /*
        Logger.Log _log = null;
        public Logger.Log Log
        {
            set { _log = value; }
            get
            {
                if (_log == null)
                {
                    _log = new Logger.Log("", "DB");
                }
                return _log;
            }
        }
        */
        private void InitConnection()
        {
            try
            {
                if (sqlCon == null)
                {
                    sqlCon = new SqlConnection(ConnectionString);
                }
                if (sqlCon.State != ConnectionState.Open)
                {
                    sqlCon.Open();
                }
            }
            catch (Exception)
            {
                //Log.Exception(ex);
                throw;
            }
        }

        #region HOW TO USE TRANSACTION
        /*
            try
            {
                db.BeginTransaction();
                db.RunSp("procedura");
                db.FillTable(ds, "tabela");
                db.UpdateTable(ds, "tabela");
                db.Commit();
            }
            catch(Exception ex)
            {
                db.RollBack();
            }
            finally
            {
                // optional
                db.Close();
            }
        
         */
        #endregion
        [NonSerialized]
        private SqlTransaction sqlTrans = null;



        public void BeginTransaction()
        {
            if (sqlTrans != null) return;
            if (sqlCon == null)
                InitConnection();
            sqlTrans = sqlCon.BeginTransaction();
        }

        public void Commit()
        {
            if (sqlTrans == null) return;
            sqlTrans.Commit();
            sqlTrans = null;
        }

        public void Rollback()
        {
            if (sqlTrans == null) return;
            sqlTrans.Rollback();
            sqlTrans = null;
        }
        //TRANSACTION End

        public virtual DataSet RunSPReturnDS(string SPName)
        {
            return RunSPReturnDS(SPName, true);
        }

        /// <summary>
        /// Run a stored procedure that returns a DataSet
        /// </summary>
        /// <param name="SPName">Name of the stored proecure</param>
        /// <returns>DataSet to be returned</returns>
        public virtual DataSet RunSPReturnDS(string SPName, bool clear)
        {
            if (_log != null)
                _log.Info("RunSPReturnDS: " + SPName);

            DataSet ds = null;
            try
            {
                InitConnection();

                ds = new DataSet();
                if (sqlCmd == null)
                {
                    sqlCmd = new SqlCommand();
                }
                sqlCmd.CommandTimeout = CommandTimeout;
                sqlCmd.Transaction = sqlTrans;
                sqlCmd.Connection = sqlCon;
                sqlCmd.CommandText = SPName;
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlDA = new SqlDataAdapter(sqlCmd);

                if (_log != null)
                {
                    foreach (SqlParameter par in sqlCmd.Parameters)
                    {
                        _log.Info("Param: " + par.ParameterName + ":" + par.Value);
                    }
                }

                sqlDA.Fill(ds, SPName);

                if (clear)
                    ClearParams();

            }
            catch
            {
                ClearParams();
                throw;
            }
            finally
            {
                if (clear)
                {
                    ClearParams();
                }
            }

            if (_log != null)
                _log.Info("RunSPReturnDS: " + SPName + " returned: " + ds.GetXml());

            return ds;
        }

        public virtual string RunSPReturnParamValue(string SPName, string ParamName)
        {
            return RunSPReturnParamValue(SPName, ParamName, true);
        }

        /// <summary>
        /// Run a stored procedure that returns an output parameter
        /// </summary>
        /// <param name="SPName">Name of the stored procedure</param>
        /// <param name="ParamName">Name of the output parameter</param>
        /// <returns>value returned by stored procedure</returns>
        public virtual string RunSPReturnParamValue(string SPName, string ParamName, bool clear)
        {
            string s = null;

            try
            {
                InitConnection();

                if (sqlCmd == null)
                {
                    sqlCmd = new SqlCommand();
                }
                sqlCmd.CommandTimeout = CommandTimeout;
                sqlCmd.Connection = sqlCon;
                sqlCmd.Transaction = sqlTrans;
                sqlCmd.CommandText = SPName;
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.ExecuteNonQuery();
                s = sqlCmd.Parameters["@" + ParamName].Value.ToString();
            }
            catch
            {
                ClearParams();
                throw;
            }
            finally
            {
                if (clear)
                    ClearParams();
            }

            return s;
        }

        public virtual void RunSP(string SPName)
        {
            RunSP(SPName, true);
        }

        /// <summary>
        /// Run a stored procedure that doesn't return anything
        /// </summary>
        /// <param name="SPName">Name of the stored proecure</param>
        public virtual void RunSP(string SPName, bool clear)
        {
            try
            {
                InitConnection();


                if (sqlCmd == null)
                {
                    sqlCmd = new SqlCommand();
                }
                sqlCmd.CommandTimeout = CommandTimeout;
                sqlCmd.Transaction = sqlTrans;
                sqlCmd.Connection = sqlCon;
                sqlCmd.CommandText = SPName;
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.ExecuteNonQuery();

            }
            catch (Exception)
            {
                //Log.Exception(ex);
                throw;
            }
            finally
            {
                if (clear)
                    ClearParams();
            }
        }

        public virtual DataSet RunStatementReturnDS(string sql)
        {
            return RunStatementReturnDS(sql, true);
        }

        /// <summary>
        /// Run an sql statement that returns a DataSet
        /// </summary>
        /// <param name="sql">Sql statement to be run</param>
        /// <returns>DataSet to be returned</returns>
        public virtual DataSet RunStatementReturnDS(string sql, bool clear)
        {
            DataSet ds = null;

            InitConnection();

            ds = new DataSet();
            if (sqlCmd == null)
            {
                sqlCmd = new SqlCommand();
            }
            sqlCmd.CommandTimeout = CommandTimeout;
            sqlCmd.Transaction = sqlTrans;
            sqlCmd.Connection = sqlCon;
            sqlCmd.CommandText = sql;
            sqlCmd.CommandType = CommandType.Text;
            sqlDA = new SqlDataAdapter(sqlCmd);

            sqlDA.Fill(ds, "result");

            return ds;
        }

        public virtual bool DeleteTable(string table, string where)
        {
            bool deleted;

            try
            {
                string sql = "DELETE FROM [" + table + "]";
                if (where != "")
                    sql += " WHERE " + where;
                deleted = RunStatement(sql, true);
            }
            finally
            {
            }

            return deleted;
        }


        public virtual bool RunStatement(string sql)
        {
            return RunStatement(sql, true);
        }

        /// <summary>
        /// Run an sql statement
        /// </summary>
        /// <param name="sql">Sql statement to be run</param>
        /// <returns>Boolean values if operation succeeded</returns>
        public virtual bool RunStatement(string sql, bool clear)
        {
            bool bc = false;
            int count = 0;
            try
            {
                InitConnection();

                if (sqlCmd == null)
                {
                    sqlCmd = new SqlCommand();
                }
                sqlCmd.CommandTimeout = CommandTimeout;
                sqlCmd.Transaction = sqlTrans;
                sqlCmd.Connection = sqlCon;
                sqlCmd.CommandText = sql;
                sqlCmd.CommandType = CommandType.Text;
                count = sqlCmd.ExecuteNonQuery();
                bc = (count >= 0);
            }
            catch (Exception)
            {
                //Log.Exception(ex);
                throw;
            }
            finally
            {
                if (clear)
                    ClearParams();
            }
            return bc;
        }

        /// <summary>
        /// Clear params that where used on a previous call of the RunSPReturnDS
        /// </summary>
        public virtual void ClearParams()
        {
            if (sqlCmd == null) return;
            sqlCmd.Parameters.Clear();
        }

        public virtual void AddParam(object value)
        {
            SqlParameter par = null;
            if (value == null)
                value = DBNull.Value;
            par = new SqlParameter("@a", value);
            par.Direction = ParameterDirection.Input;
            if (sqlCmd == null)
            {
                sqlCmd = new SqlCommand();
            }
            sqlCmd.CommandTimeout = CommandTimeout;
            sqlCmd.Transaction = sqlTrans;
            sqlCmd.Parameters.Add(par);
            par.ParameterName = null;
        }

        /// <summary>
        /// Add an input parameter for calling the stored procedure
        /// </summary>
        /// <param name="param">Parameter name</param>
        /// <param name="value">Parameter value</param>
        public virtual void AddParam(string param, object value)
        {
            SqlParameter par = null;
            if (value == null)
                value = DBNull.Value;
            par = new SqlParameter("@" + param, value);
            par.Direction = ParameterDirection.Input;
            if (sqlCmd == null)
            {
                sqlCmd = new SqlCommand();
            }
            sqlCmd.CommandTimeout = CommandTimeout;
            sqlCmd.Transaction = sqlTrans;
            sqlCmd.Parameters.Add(par);
        }

        /// <summary>
        /// Add an output parameter for calling the stored procedure
        /// </summary>
        /// <param name="param">Parameter name</param>
        public virtual void AddOutputParam(string param)
        {
            SqlParameter par = new SqlParameter("@" + param, SqlDbType.VarChar);
            par.Direction = ParameterDirection.Output;
            par.Size = 255;
            if (sqlCmd == null)
            {
                sqlCmd = new SqlCommand();
            }
            sqlCmd.CommandTimeout = CommandTimeout;
            sqlCmd.Transaction = sqlTrans;
            sqlCmd.Parameters.Add(par);
        }

        /// <summary>
        /// Close the connection to the database
        /// </summary>
        public virtual void Close()
        {
            if (sqlCon != null)
            {
                sqlCon.Close();
                sqlCon = null;
            }
        }

        public string ConnectionString
        {
            get
            {
                if (_connection_string == null)
                {
                    // original						_connection_string = Common.Cryptography.Decrypt(Config.Key("Database.ConnectionString"));
                    _connection_string = WebConfig.ConfigKey("Database.ConnectionString");
                }
                return _connection_string;
            }
            set
            {
                _connection_string = value;
            }
        }

        public int CommandTimeout
        {
            get
            {
                if (commandTimeout < 0)
                {
                    commandTimeout = 15;

                    try
                    {
                        // commentted for now commandTimeout = int.Parse(Config.Key("Database.CommandTimeout"));
                    }
                    catch
                    {
                    }
                }

                return commandTimeout;
            }
            set
            {
                commandTimeout = value;
            }
        }
        /// <summary>
        /// Fill the given DataSet object with rows from the given table
        /// </summary>
        /// <param name="ds">DataSet to be filled</param>
        /// <param name="table">Table name from database</param>
        public virtual void FillTable(DataSet ds, string table)
        {
            FillTable(ds, table, "");
        }

        public virtual void FillTable(DataSet ds, string table, bool schema)
        {
            FillTable(ds, table, "", schema);
        }

        /// <summary>
        /// Fill the given DataSet object with rows from the given table
        /// </summary>
        /// <param name="ds">DataSet to be filled</param>
        /// <param name="table">Table name from database</param>
        /// <param name="where">Filter to restrict rows that are read</param>
        public virtual void FillTable(DataSet ds, string table, string where)
        {
            // set schema to TRUE manualy if needed
            FillTable(ds, table, where, false);
        }

        public virtual void FillTable(DataSet ds, string table, string where, bool schema)
        {

            InitConnection();

            string sql = "SELECT * FROM [" + table + "]";
            if (where != "")
                sql += " WHERE " + where;
            sqlCmd = new SqlCommand(sql, sqlCon);
            sqlCmd.Transaction = sqlTrans;
            sqlCmd.CommandTimeout = CommandTimeout;
            sqlCmd.CommandType = CommandType.Text;
            sqlDA = new SqlDataAdapter(sqlCmd);

            if ((ds.Tables.Count == 0) && schema)
                sqlDA.FillSchema(ds, SchemaType.Mapped);
            sqlDA.Fill(ds, table);

        }

        /// <summary>
        /// Save in the database the changes in DataSet
        /// </summary>
        /// <param name="ds">DataSet with changes</param>
        /// <param name="table">Table name to save from DataSet</param>
        public virtual void UpdateTable(DataSet ds, string table)
        {
            try
            {
                InitConnection();

                // reuse command and dataadapter
                string command = "SELECT * FROM [" + table + "]";
                if ((sqlCmd == null) || (sqlCmd.CommandText != command))
                {
                    sqlCmd = new SqlCommand(command, sqlCon);
                    sqlCmd.Transaction = sqlTrans;
                    sqlCmd.CommandTimeout = CommandTimeout;
                    sqlCmd.CommandType = CommandType.Text;
                    sqlDA = new SqlDataAdapter(sqlCmd);
                }
                SqlCommandBuilder sqlBui = new SqlCommandBuilder(sqlDA);
                sqlBui.DataAdapter.Update(ds, table);
                //sqlDA.Update(ds, table);
            }
            catch (Exception)
            {
                //Log.Exception(e);
                throw;
            }
            finally
            {
            }
        }


        /*
         public virtual string RunSPReturnValue(string SPName) 
         {
             return RunSPReturnValue(SPName, true);
         }

         /// <summary>
         /// Run a stored procedure that returns a value
         /// </summary>
         /// <param name="SPName">Name of the stored procedure</param>
         /// <returns>value returned by stored procedure</returns>
         public virtual string RunSPReturnValue(string SPName, bool clear) 
         {
             string s = null;
             try
             {
                 InitConnection();

                 s = "";
                 if(sqlCmd == null)
                 {
                     sqlCmd = new SqlCommand();
                 }
                 sqlCmd.CommandTimeout = CommandTimeout;
                 sqlCmd.Connection = sqlCon;
                 sqlCmd.Transaction = sqlTrans;
                 sqlCmd.CommandText = SPName;
                 sqlCmd.CommandType = CommandType.StoredProcedure;
                 SqlParameter par = new SqlParameter("@Result", SqlDbType.Int);
                 par.Direction = ParameterDirection.ReturnValue;
                 sqlCmd.Parameters.Add(par);
                 sqlCmd.ExecuteNonQuery();
                 s = sqlCmd.Parameters["@Result"].Value.ToString();
             }
             catch(Exception ex)
             {
                 throw new Exception(ex.Message + " - " + SPName);
             }
             finally
             {
                 if(clear)
                 {
                     ClearParams();
                 }
             }
             return s;
         }
         */
    }

    public static class WebConfig
    {
        [DllImport("kernel32.dll", CharSet = CharSet.Auto)]
        private static extern int GetComputerName(StringBuilder buffer, ref uint size);


        /// <summary>
        /// gets the computer name by calling a WinAPI function
        /// </summary>
        /// <returns></returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1806")]
        public static string ComputerName()
        {
            string result = "N/A";

            StringBuilder sbBuf = new StringBuilder(128);
            UInt32 intLen = (uint)sbBuf.Capacity;

            WebConfig.GetComputerName(sbBuf, ref intLen);
            result = sbBuf.ToString();

            return result;
        }

        public static string ConfigKey(string key)
        {
            string comp_name = ComputerName();

            // first, check if there is a comp_name + "." + key 

            string val = System.Configuration.ConfigurationManager.AppSettings[comp_name + "." + key];
            if (val == null)
                val = System.Configuration.ConfigurationManager.AppSettings[key];
            return val;
        }
    }
}
