
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CourseModule_List]
	@id_course AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM CourseModule PM
		INNER JOIN Module M ON PM.IdModule = M.IdModule
		WHERE PM.IdCourse = @id_course
		ORDER BY M.ModuleName
END
