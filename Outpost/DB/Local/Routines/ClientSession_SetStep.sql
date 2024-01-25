-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE dbo.ClientSession_SetStep
	@id_client_session AS INT,
	@step AS INT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE ClientSession SET Status = 1, CurrentStep = @step WHERE IdClientSession = @id_client_session
END
