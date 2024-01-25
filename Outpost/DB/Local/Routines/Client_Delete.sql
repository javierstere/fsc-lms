
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Client_Delete]
	@id_client AS INT
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM Client WHERE IdClient = @id_client
END
