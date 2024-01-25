-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[QuizQuestion_Save]
	@id_quiz_question AS INT,
	@id_module AS INT,
	@id_step AS INT,
	@question AS VARCHAR(1000)
AS
BEGIN
	SET NOCOUNT ON;

	IF @id_quiz_question = 0 BEGIN
		INSERT INTO QuizQuestion (IdModule, IdStep) VALUES (@id_module, @id_step)
		SET @id_quiz_question = @@IDENTITY
	END

	UPDATE QuizQuestion 
		SET Question = @question
	WHERE IdQuizQuestion = @id_quiz_question

	SELECT @id_quiz_question AS Id
END
