CREATE PROCEDURE [dbo].[Outpost_SessionStorage_Remove]
@session_id AS varchar(50)
AS
BEGIN
SET NOCOUNT ON;
DELETE FROM Outpost_SessionStorageValues WHERE IdSessionStorage IN (SELECT Id FROM Outpost_SessionStorage WHERE SessionId = @session_id)
DELETE FROM Outpost_SessionStorage WHERE SessionId = @session_id
END