CREATE PROCEDURE [dbo].[ClientSession_Save]
	@id_client_session AS INT,
	@location AS VARCHAR(100),
	@session_date AS DATETIME,
	@time_zone AS INT,
	@reminder_offset AS INT
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE ClientSession
		SET Location = @location,
		SessionDate = @session_date,
		TimeZone = @time_zone,
		ReminderOffset = @reminder_offset
	WHERE IdClientSession = @id_client_session
END