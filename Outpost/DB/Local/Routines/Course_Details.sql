
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Course_Details]
	@id_course AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM Course WHERE IdCourse = @id_course


	DECLARE @id_client AS INT
	SELECT @id_client = IdClient FROM Course WHERE IdCourse = @id_course

	SELECT DISTINCT Job FROM Employee WHERE IdClient = @id_client AND Job <> ''
		UNION 
	SELECT DISTINCT Job FROM Course WHERE IdClient = @id_client AND Job <> ''
	ORDER BY Job
END
