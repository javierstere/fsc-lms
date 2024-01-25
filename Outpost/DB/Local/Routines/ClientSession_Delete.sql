-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE dbo.ClientSession_Delete
	@id_client_session AS INT
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM ClientSession WHERE IdClientSession = @id_client_session
END
