
 CREATE PROCEDURE [dbo].[Report_ProjectModuleEmployee]
 	@id_client AS INT,
 	@id_project AS INT,
 	@id_module AS INT,
	@id_client_session AS INT,
 	@id_employee AS INT
 AS
 BEGIN
 	-- SET NOCOUNT ON added to prevent extra result sets from
 	-- interfering with SELECT statements.
 	SET NOCOUNT ON;
 
 	-- Report_ProjectModuleEmployee 1, 4, 10, 2

	IF @id_module IS NOT NULL BEGIN

 		SELECT EQ.Points, M.ModuleName, E.EmployeeName, EQ.Timestamp FROM EmployeeQuiz EQ
 			INNER JOIN Module M ON M.IdModule = EQ.IdModule
 			INNER JOIN Employee E ON E.IdEmployee = EQ.IdEmployee
 		WHERE EQ.IdModule = @id_module AND EQ.IdEmployee = @id_employee
 
 		SELECT EQA.*, QQ.Question FROM EmployeeQuizAnswer EQA
 			INNER JOIN QuizQuestion QQ ON QQ.IdQuizQuestion = EQA.IdQuizQuestion
 			INNER JOIN EmployeeQuiz EQ ON EQ.IdEmployeeQuiz = EQA.IdEmployeeQuiz
 			WHERE IdEmployee = @id_employee AND QQ.IdModule = @id_module
	
	 	SELECT * FROM QuizAnswer WHERE IdQuizQuestion IN (SELECT IdQuizQuestion FROM QuizQuestion WHERE IdModule = @id_module)

	END ELSE BEGIN
 		SELECT EQ.Points, CS.SessionName AS ModuleName, E.EmployeeName, EQ.Timestamp FROM EmployeeQuiz EQ
 			INNER JOIN ClientSession CS ON CS.IdClientSession = EQ.IdClientSession
 			INNER JOIN Employee E ON E.IdEmployee = EQ.IdEmployee
 		WHERE EQ.IdClientSession = @id_client_session AND EQ.IdEmployee = @id_employee
 
 		SELECT EQA.*, QQ.Question FROM EmployeeQuizAnswer EQA
 			INNER JOIN QuizQuestion QQ ON QQ.IdQuizQuestion = EQA.IdQuizQuestion
 			INNER JOIN EmployeeQuiz EQ ON EQ.IdEmployeeQuiz = EQA.IdEmployeeQuiz
 			WHERE IdEmployee = @id_employee AND EQ.IdClientSession = @id_client_session

	 	SELECT * FROM QuizAnswer WHERE IdQuizQuestion IN (
			SELECT IdQuizQuestion FROM QuizQuestion WHERE IdStep IN (SELECT IdStep FROM TrainingSessionStep TSS 
				INNER JOIN ClientSession CS ON CS.IdTrainingSession = TSS.IdTrainingSession
				WHERE CS.IdClientSession = @id_client_session)
		)
	END
 
 
 END