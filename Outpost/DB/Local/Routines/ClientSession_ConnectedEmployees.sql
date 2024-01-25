
CREATE PROCEDURE [dbo].[ClientSession_ConnectedEmployees]
	@id_client_session AS INT
AS
BEGIN
	SET NOCOUNT ON;


	DECLARE @id_step AS INT
	SELECT @id_step = CurrentStep FROM ClientSession WHERE IdClientSession = @id_client_session

	-- ClientSession_ConnectedEmployees 2

	SELECT 
		E.EmployeeName, 
		CASE WHEN ISNULL(ANS.Answer, '') = '' THEN 0 ELSE 1 END AS Answered,
		CASE WHEN CSE.Timestamp > DATEADD(ss, -45, GETDATE()) THEN 1 ELSE 0 END AS Connected
		FROM ClientSessionEmployee CSE
		INNER JOIN Employee E ON E.IdEmployee = CSE.IdEmployee
		LEFT JOIN (
			SELECT DISTINCT EQ.IdEmployee, CASE WHEN ISNULL(EQA.Answer, '') = '' THEN '' ELSE '1' END AS Answer FROM EmployeeQuizAnswer EQA
				INNER JOIN EmployeeQuiz EQ ON EQ.IdEmployeeQuiz = EQA.IdEmployeeQuiz
				INNER JOIN QuizQuestion QQ ON EQA.IdQuizQuestion = QQ.IdQuizQuestion
				WHERE QQ.IdStep = @id_step AND EQ.IdClientSession = @id_client_session
		) ANS ON ANS.IdEmployee = E.IdEmployee
	WHERE CSE.IdClientSession = @id_client_session
		--AND CSE.Timestamp > DATEADD(ss, -45, GETDATE())
	ORDER BY E.EmployeeName
END


