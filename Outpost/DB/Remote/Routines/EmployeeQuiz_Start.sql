
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[EmployeeQuiz_Start]
	@id_module AS INT,
	@id_employee AS INT
AS
BEGIN
	SET NOCOUNT ON;


	UPDATE EmployeeQuiz 
		SET StartCount = StartCount + 1
	WHERE IdEmployee = @id_employee AND IdModule = @id_module

END
