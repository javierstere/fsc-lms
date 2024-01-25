
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Administrator_List]
	@id_client AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM Administrator WHERE IdClient = @id_client ORDER BY AdministratorName

	SELECT MaxAdmins FROM Client WHERE IdClient = @id_client
END
