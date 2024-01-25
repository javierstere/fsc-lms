-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE dbo.Client_JobsList
	@id_client AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT Job FROM Employee WHERE IdClient = @id_client AND Job <> ''
		UNION 
	SELECT DISTINCT Job FROM Project WHERE IdClient = @id_client AND Job <> ''
END
