
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Module_Delete]
	@id_module AS INT
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (SELECT * FROM EmployeeQuiz WHERE IdModule = @id_module) BEGIN
		UPDATE Module SET Deleted='1' WHERE IdModule = @id_module
	END ELSE BEGIN
		DELETE FROM Module WHERE IdModule = @id_module
	END

END
