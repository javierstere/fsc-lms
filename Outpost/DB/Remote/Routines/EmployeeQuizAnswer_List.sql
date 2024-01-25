
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[EmployeeQuizAnswer_List]
	@id_module AS INT,
	@id_employee AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM EmployeeQuizAnswer WHERE idEmployeeQuiz IN 
		(SELECT IdEmployeeQuiz FROM EmployeeQuiz WHERE IdModule = @id_module AND IdEmployee = @id_employee)
END
