CREATE PROCEDURE dbo.MaiQueue_List
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM MailQueue
		WHERE ExecutedAt IS NULL
			AND ScheduledAt < GETDATE()

END
