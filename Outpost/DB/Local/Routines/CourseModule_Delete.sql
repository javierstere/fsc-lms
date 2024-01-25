
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CourseModule_Delete]
	@id_course AS INT,
	@id_module AS INT
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM CourseModule WHERE IdCourse = @id_course AND IdModule = @id_module
END
