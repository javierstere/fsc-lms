
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[QuizQuestion_Delete]
	@id_quiz_question AS INT
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM QuizQuestion WHERE IdQuizQuestion = @id_quiz_question
END
