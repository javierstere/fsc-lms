
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[EmployeeQuiz_CalculateScore]
	@id_module AS INT,
	@id_client_session AS INT,
	@id_employee AS INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @eq AS INT
	SELECT @eq = IdEmployeeQuiz FROM EmployeeQuiz WHERE IdEmployee = @id_employee AND (IdModule = @id_module OR IdClientSession = @id_client_session)

	DECLARE @questions AS INT

	IF @id_module IS NOT NULL
		SELECT @questions = COUNT(*) FROM QuizQuestion WHERE IdModule = @id_module
	IF @id_client_session IS NOT NULL
		SELECT @questions = COUNT(*) FROM ClientSession CS
			INNER JOIN TrainingSession TS ON TS.IdTrainingSession = CS.IdTrainingSession
			INNER JOIN TrainingSessionStep TSs ON TSS.IdTrainingSession = TS.IdTrainingSession
			WHERE IdClientSession = @id_client_session


	IF @questions > 0 BEGIN
		DECLARE @total AS DECIMAL(18, 2)
		SELECT @total = SUM(Points) FROM EmployeeQuizAnswer WHERE IdEmployeeQuiz = @eq

		UPDATE EmployeeQuiz SET Points = @total / @questions WHERE IdEmployeeQuiz = @eq
	END

	SELECT * FROM EmployeeQuiz WHERE IdEmployeeQuiz = @eq
END
