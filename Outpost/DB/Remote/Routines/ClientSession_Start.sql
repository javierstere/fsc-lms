-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ClientSession_Start]
	@id_client_session AS INT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE ClientSession SET Status = 1, CurrentStep = 0 WHERE IdClientSession = @id_client_session
END
