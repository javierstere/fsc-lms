
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Project_List]
	@id_client AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM Project WHERE IdClient = @id_client ORDER BY ProjectName

	IF @id_client IS NOT NULL AND @id_client <> 0 BEGIN
		SELECT MaxProjects FROM Client WHERE IdClient = @id_client
	END ELSE BEGIN
		SELECT 1000 AS MaxProjects
	END


END
