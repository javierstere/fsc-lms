-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ClientSession_GetDetails]
	@id_client_session AS INT,
	@id_client AS INT,
	@id_employee AS INT
AS
BEGIN
	SET NOCOUNT ON;


	-- ClientSession_GetDetails 5, 3, 48

	DECLARE @job AS VARCHAR(250)
	SELECT @job = Job FROM Employee WHERE IdClient = @id_client AND IdEmployee = @id_employee

	SELECT CS.*, TS.SessionName FROM ClientSession CS
		INNER JOIN TrainingSession TS ON TS.IdTrainingSession = CS.IdTrainingSession
		 WHERE IdClientSession = @id_client_session

	IF NOT EXISTS (SELECT * FROM ClientSessionEmployee WHERE IdClientSession = @id_client_session AND IdEmployee = @id_employee)
		INSERT INTO ClientSessionEmployee (IdClientSession, IdEmployee) VALUES (@id_client_session, @id_employee)

	UPDATE ClientSessionEmployee
		SET Timestamp = GETDATE()
		WHERE IdClientSession = @id_client_session AND IdEmployee = @id_employee

	IF EXISTS(SELECT * FROM ClientSession WHERE IdClientSession = @id_client_session AND Status = 2) BEGIN
		SELECT QQ.* FROM TrainingSessionStep TSS
			INNER JOIN ClientSession CS ON CS.IdTrainingSession = TSS.IdTrainingSession
			INNER JOIN QuizQuestion QQ ON QQ.IdStep = TSS.IdStep
			WHERE IdClientSession = @id_client_session
				AND TSS.IdStep = CS.CurrentStep

		SELECT QA.*, EQA.Answer AS EmployeeAnswer FROM TrainingSessionStep TSS
			INNER JOIN ClientSession CS ON CS.IdTrainingSession = TSS.IdTrainingSession
			INNER JOIN QuizQuestion QQ ON QQ.IdStep = TSS.IdStep
			INNER JOIN QuizAnswer QA ON QA.IdQuizQuestion = QQ.IdQuizQuestion
			LEFT JOIN (SELECT EQA.Answer, EQA.IdQuizQuestion FROM EmployeeQuizAnswer EQA
				INNER JOIN EmployeeQuiz EQ ON EQ.IdEmployeeQuiz = EQA.IdEmployeeQuiz 
					WHERE EQ.IdEmployee = @id_employee AND EQ.IdClientSession = @id_client_session) EQA ON EQA.IdQuizQuestion = QQ.IdQuizQuestion
			WHERE IdClientSession = @id_client_session
				AND TSS.IdStep = CS.CurrentStep

		-- ClientSession_GetDetails 5, 3, 48
	END

	IF EXISTS(SELECT * FROM ClientSession WHERE IdClientSession = @id_client_session AND Status = 3) BEGIN
		SELECT * FROM EmployeeQuiz WHERE IdEmployee = @id_employee AND IdClientSession = @id_client_session
	END

END
