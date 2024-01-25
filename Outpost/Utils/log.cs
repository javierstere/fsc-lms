using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Outpost.Utils
{
    public class Log
    {
        public const string CONTEXT = "Outpost.Log";

        private string _filename = null;
        private string _flag = "I";
        private static string[] _flags = { "I", "W", "E", "X" };

        private static int _level = 0;

        private DateTime _start;

        HttpContext _context = null;


        public static Log GetInstance(HttpContext context)
        {
            Log log = null;
            if (context != null)
                log = (Log)context.Items[CONTEXT];
            if (log == null)
            {
                log = new Log();
                log._context = context;

                if (context != null)
                {
                    if (context.Request.QueryString["Application.Log.Level"] != null)
                    {
                        try
                        {
                            _level = int.Parse(context.Request.QueryString["Application.Log.Level"]);
                        }
                        catch { }
                    }
                    context.Items[CONTEXT] = log;
                }
            }
            return log;
        }

        public static int Level
        {
            get
            {
                return _level;
            }
            set
            {
                _level = value;
            }
        }


        public void WebLog(HttpContext context)
        {
            // 
            // TODO - log stuff about web request
            //
            // - path/page name
            // - query string
            // - form 
            // - session
            //
            // - rename log file with page name ( ----- )
            //
            Info(context.Request.Path + "?" + context.Request.QueryString);
        }

        public void GlobalPerformanceStart()
        {
            _start = DateTime.Now;
        }

        public void GlobalPerformanceEnd()
        {
            TimeSpan ts = DateTime.Now.Subtract(_start);
            Info("Global performance: " + ts.TotalMilliseconds);
        }

        public void Info(string message)
        {
            if (Level >= 2)
                LogInternal(message);
        }

        public void Warning(string message)
        {
            RenameLogFile("W");
            // level 1
            if (Level >= 1)
                LogInternal(message);
        }

        public void Error(string message)
        {
            RenameLogFile("E");
            // level 0
            LogInternal(message);
        }

        public void Exception(Exception e)
        {
            RenameLogFile("X");
            // level 0
            LogInternal(e.Message);
        }

        private void RenameLogFile(string flag)
        {
            if (flag == _flag)
                return;

            int index_new = 0;
            int index_old = 0;
            for(int i=0;i<_flags.Length;i++)
            {
                if (flag == _flags[i])
                    index_new = i;
                if (_flag == _flags[i])
                    index_old = i;
            }

            if (index_old > index_new)
                return;

            try
            {
                string newname = _filename.Replace("-" + _flag + ".log", "-" + flag + ".log");
                System.IO.File.Move(_filename, newname);

                _filename = newname;
            }
            catch
            {

            }
        }

        public string GetTodayLogFolder()
        {
            string folder = System.Web.Hosting.HostingEnvironment.MapPath("/log/");
            folder += DateTime.Now.ToString("yyyy-MM-dd");
            System.IO.Directory.CreateDirectory(folder);
            return folder;
        }

        private void LogInternal(string message)
        {
            try
            {
                if (_filename == null)
                {
                    string file = DateTime.Now.ToString("HH-mm-ss-fff") + "-----" + _flag + ".log";
                    _filename = System.IO.Path.Combine(GetTodayLogFolder(), file);
                    System.IO.File.AppendAllLines(_filename, new string[0]);
                }

                List<string> lines = new List<string>();
                lines.Add(DateTime.Now.ToString("HH:mm:ss.fff"));
                lines.Add(message);

                System.IO.File.AppendAllLines(_filename, lines);
            }
            catch
            {

            }
        }
    }
}