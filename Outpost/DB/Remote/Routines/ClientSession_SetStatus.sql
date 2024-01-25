-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE dbo.ClientSession_SetStatus
	@id_client_session AS INT,
	@status AS CHAR(1)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE ClientSession SET Status = @status WHERE IdClientSession = @id_client_session
END
