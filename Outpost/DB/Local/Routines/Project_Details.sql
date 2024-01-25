
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Project_Details]
	@id_project AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM Project WHERE IdProject = @id_project


	DECLARE @id_client AS INT
	SELECT @id_client = IdClient FROM Project WHERE IdProject = @id_project

	SELECT DISTINCT Job FROM Employee WHERE IdClient = @id_client AND Job <> ''
		UNION 
	SELECT DISTINCT Job FROM Project WHERE IdClient = @id_client AND Job <> ''
	ORDER BY Job
END
