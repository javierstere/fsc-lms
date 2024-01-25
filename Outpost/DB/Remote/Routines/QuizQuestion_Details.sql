
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[QuizQuestion_Details]
	@id_quiz_question AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM QuizQuestion WHERE IdQuizQuestion = @id_quiz_question

	SELECT * FROM QuizAnswer WHERE IdQuizQuestion = @id_quiz_question
END
