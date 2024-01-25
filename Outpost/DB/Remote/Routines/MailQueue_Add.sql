
CREATE PROCEDURE [dbo].[MailQueue_Add]
	@template AS VARCHAR(50),
	@scheduled_at AS DATETIME,
	@params AS VARCHAR(MAX),
	@message AS VARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE MailQueue SET ExecutedAt = GETDATE(), Error = 'duplicate' WHERE ExecutedAt IS NULL AND Params = @params
	INSERT INTO MailQueue (CreatedAt, Template, ScheduledAt, Params, Message)
		VALUES (GETDATE(), @template, @scheduled_at, @params, @message)
END