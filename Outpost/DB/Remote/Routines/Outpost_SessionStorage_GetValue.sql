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