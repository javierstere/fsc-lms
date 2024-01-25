
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Administrator_Delete]
	@id_client AS INT,
	@id_administrator AS INT
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM Administrator 
		WHERE IdClient = @id_client 
			AND IdAdministrator = @id_administrator
END
