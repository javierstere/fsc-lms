
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[EmployeeQuiz_Training]
	@id_module AS INT,
	@id_employee AS INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @eq AS INT

	SELECT @eq = IdEmployeeQuiz FROM EmployeeQuiz WHERE IdEmployee = @id_employee AND IdModule = @id_module

	IF @eq IS NULL BEGIN
		INSERT INTO EmployeeQuiz (IdEmployee, IdModule, StartCount) VALUES (@id_employee, @id_module, 0)

		SET @eq = @@IDENTITY
	END

END
