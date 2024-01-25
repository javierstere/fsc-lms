-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CourseModule_Add]
	@id_course AS INT,
	@id_module AS INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF NOT EXISTS (SELECT * FROM CourseModule WHERE IdCourse = @id_course AND IdModule = @id_module)
		INSERT INTO CourseModule (IdCourse, IdModule) VALUES (@id_course, @id_module)
END
