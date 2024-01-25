CREATE PROCEDURE [dbo].[ClientSession_Add]
	@id_client AS INT,
	@id_training_session AS INT,
	@session_name AS VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO ClientSession (CreatedAt, IdTrainingSession, IdClient, Status, SessionName)
		VALUES (GETDATE(), @id_training_session, @id_client, 0, @session_name)

	SELECT @@IDENTITY AS Id
END

