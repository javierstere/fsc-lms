-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ClientSession_Stop]
	@id_client_session AS INT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE ClientSession SET Status = 0, CurrentStep = 0 WHERE IdClientSession = @id_client_session
END
