using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Outpost.Utils
{
    public class QueryStringWrapper
    {
        HttpRequest _request;
        public QueryStringWrapper(HttpRequest request)
        {
            _request = request;
        }

        public string this[string i]
        {
            get { return _request[i]; }
        }

        public string WithoutKey(string key)
        {
            System.Text.StringBuilder ret = new System.Text.StringBuilder();

            bool first = true;
            foreach (string qkey in _request.QueryString)
            {
                if (qkey == key)
                    continue;
                if (!first) ret.Append("&");
                ret.Append(qkey + "=" + _request.QueryString[qkey]);
                first = false;
            }

            return ret.ToString();
        }
        public string ReplaceKey(string key, string newval)
        {
            return ReplaceKey(key, newval, false);
        }

        public string ReplaceKey(string key, string newval, bool add)
        {
            System.Text.StringBuilder ret = new System.Text.StringBuilder();

            bool first = true;
            bool processed = false;
            foreach (string qkey in _request.QueryString)
            {
                string append = qkey + "=" + _request.QueryString[qkey];
                if (qkey == key)
                {
                    append = qkey + "=" + newval;
                    processed = true;
                }
                if (!first) ret.Append("&");
                ret.Append(append);
                first = false;
            }
            if (!processed)
            {
                if (!first) ret.Append("&");
                ret.Append(key + "=" + newval);
            }

            return ret.ToString();
        }
    }
}