

CREATE PROCEDURE dbo.MailQueue_Processed
	@id AS INT,
	@error AS VARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE MailQueue SET ExecutedAt = GETDATE(), Error = @error WHERE Id = @id

END
