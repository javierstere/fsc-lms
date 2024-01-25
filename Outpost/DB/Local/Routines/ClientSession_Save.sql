CREATE PROCEDURE [dbo].[ClientSession_Save]
	@id_client_session AS INT,
	@location AS VARCHAR(100),
	@session_date AS DATETIME,
	@time_zone AS INT
	
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE ClientSession 
		SET Location = @location, 
			SessionDate = @session_date,
			TimeZone = @time_zone
	WHERE IdClientSession = @id_client_session
END
