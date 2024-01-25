
CREATE PROCEDURE [dbo].[EmployeeQuizAnswer_Save]
	@id_module AS INT,
	@id_client_session AS INT,
	@id_employee AS INT,
	@id_quiz_question AS INT,
	@answer AS VARCHAR(1000)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @eq AS INT

	SELECT @eq = IdEmployeeQuiz FROM EmployeeQuiz WHERE IdEmployee = @id_employee 
		AND (IdModule = @id_module OR IdClientSession = @id_client_session)

	IF @eq IS NULL BEGIN
		INSERT INTO EmployeeQuiz (IdEmployee, IdModule, IdClientSession, timestamp) VALUES (@id_employee, @id_module, @id_client_session, GETDATE())

		SET @eq = @@IDENTITY
	END

	DECLARE @points AS DECIMAL(18, 2)
	DECLARE @total_answers AS INT
	SELECT @total_answers = COUNT(*) FROM QuizAnswer WHERE IdQuizQuestion = @id_quiz_question

	IF @total_answers > 0 BEGIN
		DECLARE @correct_answers AS INT
		SELECT 
			@correct_answers = SUM(
				CASE 
					WHEN Answers.Selected IS NOT NULL AND Correct = 1 THEN 1
					WHEN Answers.Selected IS NULL AND Correct = 0 THEN 1
					ELSE 0
				END
			)
		
		 FROM QuizAnswer QA
			LEFT JOIN (SELECT CONVERT(INT, LTRIM(RTRIM(Split.a.value('.', 'VARCHAR(100)')))) 'Selected' FROM  
							(SELECT CAST ('<M>' + REPLACE(@answer, ',', '</M><M>') + '</M>' AS XML) AS Data) AS A 
								CROSS APPLY Data.nodes ('/M') AS Split(a)) Answers ON Answers.Selected = QA.IdQuizAnswer
			WHERE QA.IdQuizQuestion = @id_quiz_question

		SET @points = @correct_answers * 100 / @total_answers
	END 

    /*
	exec EmployeeQuizAnswer_Save 10, 2, 3, '9,18'
	exec EmployeeQuizAnswer_Save 10, 2, 3, '9,17,18,19'
	exec EmployeeQuizAnswer_Save 10, 2, 3, '9,17'
	exec EmployeeQuizAnswer_Save 10, 2, 3, '17, 19'
	exec EmployeeQuizAnswer_Save 10, 2, 3, '9, 17, 19'
	select * from EmployeeQuizAnswer
	*/

	IF NOT EXISTS (SELECT * FROM EmployeeQuizAnswer WHERE IdEmployeeQuiz = @eq AND IdQuizQuestion = @id_quiz_question) BEGIN
		INSERT INTO EmployeeQuizAnswer (IdEmployeeQuiz, IdQuizQuestion, Answer, Points) 
			VALUES (@eq, @id_quiz_question, @answer, @points)
	END ELSE BEGIN
		UPDATE EmployeeQuizAnswer
			SET Answer = @answer,
				Points = CASE WHEN @points = 100 THEN 100 ELSE 0 END
		WHERE 
			IdEmployeeQuiz = @eq AND IdQuizQuestion = @id_quiz_question
	END
END