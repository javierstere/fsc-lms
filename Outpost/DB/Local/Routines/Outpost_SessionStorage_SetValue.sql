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