

CREATE PROCEDURE [dbo].[Course_Save]
	@id_course AS INT,
	@id_client AS INT,
	@course_name AS VARCHAR(2000),
	@job AS VARCHAR(250),
	@months AS INT
AS
BEGIN
	SET NOCOUNT ON;

	IF @id_course = 0 BEGIN
		INSERT INTO [Course] (IdClient) VALUES (@id_client)
		SET @id_course = @@IDENTITY
	END

	UPDATE [Course]
		SET CourseName = @course_name,
			Job = @job,
			months = @months
		WHERE 
			IdCourse = @id_course

	SELECT @id_course AS Id
END
