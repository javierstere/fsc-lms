-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE dbo.TrainingSessionStep_Details
	@id_step AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM TrainingSessionStep WHERE IdStep = @id_step

	SELECT * FROM QuizQuestion WHERE IdStep = @id_step

	SELECT * FROM QuizAnswer QA
		INNER JOIN QuizQuestion QQ ON QQ.IdQuizQuestion = QA.IdQuizQuestion
		WHERE IdStep = @id_step
END
