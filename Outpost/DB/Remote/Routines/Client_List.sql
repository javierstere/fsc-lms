
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Client_List]
	@id_builder AS INT,
	@filter AS VARCHAR(200)	
AS
BEGIN
	SET NOCOUNT ON;


	-- Client_List 1, ''

	SET @filter = REPLACE(@filter, '*', '%')

	IF EXISTS (SELECT * FROM Builder WHERE IdBuilder = @id_builder AND Type='B')
		SET @id_builder = NULL
	
	SELECT TOP 50 * INTO #TEMP FROM Client
		WHERE
			ClientName LIKE @filter + '%'
			AND (
				IdClient IN (SELECT IdClient FROM ClientBuilder WHERE IdBuilder = @id_builder)
				OR @id_builder IS NULL)

	SELECT * FROM #TEMP ORDER BY ClientName

	SELECT IdClient, AdministratorName FROM Administrator
		WHERE IdClient IN (SELECT IdClient FROM #TEMP)
		ORDER BY AdministratorName

	SELECT IdClient, B.BuilderName FROM ClientBuilder CB
		INNER JOIN Builder B ON B.IdBuilder = CB.IdBuilder
		WHERE IdClient IN (SELECT IdClient FROM #TEMP)
		ORDER BY BuilderName

END
