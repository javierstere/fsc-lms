using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.IO;
using System.Text;
using System.Runtime.Serialization.Json;



namespace FSC.Common
{
    // Reference / System.Runtime.Serialization

    [System.Runtime.Serialization.DataContract]
    public class JsonBase
    {
        public static object FromString(string str, Type clazz)
        {
            object obj = null;
            using (var ms = new MemoryStream(Encoding.Unicode.GetBytes(str)))
            {
                // Deserialization from JSON  
                DataContractJsonSerializer deserializer = new DataContractJsonSerializer(clazz);
                obj = deserializer.ReadObject(ms);
            }
            return obj;
        }

        public override string ToString()
        {
            DataContractJsonSerializer js = new DataContractJsonSerializer(GetType());
            MemoryStream msObj = new MemoryStream();
            js.WriteObject(msObj, this);
            msObj.Position = 0;
            StreamReader sr = new StreamReader(msObj);

            string json = sr.ReadToEnd();

            sr.Close();
            msObj.Close();

            return json;
        }
    }


    [System.Runtime.Serialization.DataContract]
    public class JsonResponseSessionRun : JsonBase
    {
        [System.Runtime.Serialization.DataMember]
        public List<JsonEmployee> employees = new List<JsonEmployee>();
    }


    [System.Runtime.Serialization.DataContract]
    public class JsonResponseSessionClient : JsonBase
    {
        [System.Runtime.Serialization.DataMember]
        public string status;

        [System.Runtime.Serialization.DataMember]
        public string step;
    }

    [System.Runtime.Serialization.DataContract]
    public class JsonResponseSessionEmployeeAjax : JsonBase
    {
        [System.Runtime.Serialization.DataMember]
        public List<JsonEmployeeCandidate> employees = new List<JsonEmployeeCandidate>();
    }

    [System.Runtime.Serialization.DataContract]
    public class JsonEmployee
    {
        [System.Runtime.Serialization.DataMember]
        public string name;
        [System.Runtime.Serialization.DataMember]
        public bool answered;
        [System.Runtime.Serialization.DataMember]
        public bool connected;
    }

    [System.Runtime.Serialization.DataContract]
    public class JsonEmployeeCandidate
    {
        [System.Runtime.Serialization.DataMember]
        public string name;
        [System.Runtime.Serialization.DataMember]
        public string id;
    }


}