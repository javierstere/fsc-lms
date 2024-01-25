CREATE PROCEDURE [dbo].[Course_Delete]
	@id_course AS INT
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM Course WHERE IdCourse = @id_course
END
