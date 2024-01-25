
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Module_List]
	@id_client AS INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM Module 
		WHERE 
			ISNULL(Deleted, '0') = '0' AND
			((@id_client IS NOT NULL AND (IdClient = @id_client OR IdClient IS NULL))
			OR
			(@id_client IS NULL AND IdClient IS NULL))
	ORDER BY ISNULL(IdClient, 0) DESC, ModuleName

	IF @id_client IS NOT NULL BEGIN
		SELECT MaxModules FROM Client WHERE IdClient = @id_client

		SELECT COUNT(*) AS LocalModules FROM Module WHERE IdClient = @id_client AND ISNULL(Deleted, '0') = '0'
	END
END
