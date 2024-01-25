using System;
using System.Web;
using System.Data;


namespace Outpost.Utils
{
    public class SessionWrapper
    {
        private System.Web.SessionState.HttpSessionState _session;
        private HttpResponse _response;
        private HttpRequest _request;
        //private DB _db;

        private string _sessionId;

        public SessionWrapper(System.Web.SessionState.HttpSessionState session, HttpRequest request, HttpResponse response, DB db)
        {
            _session = session;
            _response = response;
            _request = request;
            _session.Timeout = 60;
            //_db = db;

            HttpCookie cookieSession = _request.Cookies["SessionId"];

            if (cookieSession != null)
            {
                _sessionId = cookieSession.Value;
                cookieSession.Expires = DateTime.Now.AddMinutes(20);
                _response.Cookies.Set(cookieSession);
            }

            if(_sessionId == null)
            {
                _sessionId = _session.SessionID;
                HttpCookie myCookie = new HttpCookie("SessionId", _sessionId);
                myCookie.Expires = DateTime.Now.AddMinutes(20);
                response.Cookies.Add(myCookie);
            }


        }

        public object this[int i]
        {
            get { return _session[i]; }
            set { _session[i] = value; }
        }

        public object this[string key]
        {
            get
            {
                GetSessionValueFromDB(key);
                return _session[key];
            }
            set
            {
                SetSessionValueIntoDB(key, value);
                _session[key] = value;
            }
        }

        public void Kill()
        {
            RemoveSessionFromDB();
            HttpCookie mycookie = new HttpCookie("ASP.NET_SessionId");
            mycookie.Expires = DateTime.Now.AddDays(-1);
            _response.Cookies.Add(mycookie);
            HttpCookie mycookie1 = new HttpCookie("SessionId");
            mycookie1.Expires = DateTime.Now.AddDays(-1);
            _response.Cookies.Add(mycookie1);
        }

        private void RemoveSessionFromDB()
        {
            DB db = new DB();
            db.AddParam("session_id", _sessionId);
            db.RunSP("Outpost_SessionStorage_Remove");
            db.Close();
        }

        private void GetSessionValueFromDB(string key)
        {
            if (_session[key] == null)
            {
                // check database
                DB db = new DB();
                db.AddParam("session_id", _sessionId);
                db.AddParam("key", key);
                DataSet ds = db.RunSPReturnDS("Outpost_SessionStorage_GetValue");
                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    _session[key] = ds.Tables[0].Rows[0]["Value"].ToString();
                db.Close();
            }
        }
        private void SetSessionValueIntoDB(string key, object value)
        {
            bool dbwrite = false;

            if ((_session[key] == null && value != null) || (_session[key] != null && value == null))
                dbwrite = true;
            if ((_session[key] != null && value != null) && (_session[key].ToString() != value.ToString()))
                dbwrite = true;

            if (dbwrite)
            {
                DB db = new DB();
                db.AddParam("session_id", _sessionId);
                db.AddParam("key", key);
                db.AddParam("value", value);
                db.RunSP("Outpost_SessionStorage_SetValue");
                db.Close();
            }
        }
    }
}
/*
CREATE TABLE[dbo].[Outpost_SessionStorage]
(

   [Id][int] IDENTITY(1,1) NOT NULL,

  [SessionId] [varchar] (50) NULL,
	[ExpireAt] [datetime] NULL,
 CONSTRAINT[PK_Outpost_SessionStorage] PRIMARY KEY CLUSTERED
(
   [Id] ASC
)WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON[PRIMARY]
) ON[PRIMARY]

GO



CREATE TABLE [dbo].[Outpost_SessionStorageValues](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdSessionStorage] [int] NULL,
	[Key] [varchar](100) NULL,
	[Value] [varchar](MAX) NULL,
 CONSTRAINT [PK_Outpost_SessionStorageValues] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO




CREATE PROCEDURE [dbo].[Outpost_SessionStorage_GetValue]
	@session_id AS VARCHAR(50),
	@key AS VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (SELECT * FROM Outpost_SessionStorage WHERE SessionId = @session_id AND ExpireAt > GETDATE()) BEGIN

		UPDATE Outpost_SessionStorage SET ExpireAt = DATEADD(mi, 20, GETDATE()) WHERE SessionId = @session_id

		SELECT SSV.* FROM Outpost_SessionStorageValues SSV
			INNER JOIN Outpost_SessionStorage SS ON SS.Id = SSV.IdSessionStorage
			WHERE SS.SessionId = @session_id AND [Key] = @key
	END 
END

GO


CREATE PROCEDURE [dbo].[Outpost_SessionStorage_SetValue]
	@session_id AS varchar(50),
	@key AS varchar(100),
	@value AS varchar(1000)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ssid AS INT

	IF NOT EXISTS (SELECT * FROM Outpost_SessionStorage WHERE SessionId = @session_id) BEGIN
		INSERT INTO Outpost_SessionStorage (SessionId, ExpireAt) 
			VALUES (@session_id, DATEADD(mi, 20, GETDATE()))
		SET @ssid = @@IDENTITY

		DELETE FROM Outpost_SessionStorageValues WHERE IdSessionStorage IN 
			(SELECT Id FROM Outpost_SessionStorage WHERE ExpireAt < GETDATE())
		DELETE FROM Outpost_SessionStorage WHERE ExpireAt < GETDATE()
	END ELSE BEGIN
		SELECT @ssid = Id FROM Outpost_SessionStorage WHERE SessionId = @session_id
	END
	
	UPDATE Outpost_SessionStorage SET ExpireAt = DATEADD(mi, 20, GETDATE()) WHERE Id = @ssid
	
	IF @value IS NULL BEGIN
		DELETE FROM Outpost_SessionStorageValues WHERE [Key] = @key AND IdSessionStorage = @ssid
	END ELSE BEGIN
		IF NOT EXISTS (SELECT * FROM Outpost_SessionStorageValues WHERE [Key] = @key AND IdSessionStorage = @ssid) BEGIN
			INSERT INTO Outpost_SessionStorageValues (IdSessionStorage, [Key])
				VALUES (@ssid, @key)
		END
		UPDATE Outpost_SessionStorageValues SET Value = @value WHERE [Key] = @key AND IdSessionStorage = @ssid
	END
END
GO


CREATE PROCEDURE [dbo].[Outpost_SessionStorage_Remove]
	@session_id AS varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM Outpost_SessionStorageValues WHERE IdSessionStorage IN (SELECT Id FROM Outpost_SessionStorage WHERE SessionId = @session_id)
	DELETE FROM Outpost_SessionStorage WHERE SessionId = @session_id


END
GO


*/


