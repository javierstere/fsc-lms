-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ClientSession_GetStatus]
	@id_client_session AS INT,
	@id_client AS INT
AS
BEGIN
	SET NOCOUNT ON;


	-- ClientSession_GetStatus 1, 1

	SELECT CS.*, TS.SessionName FROM ClientSession CS
		INNER JOIN TrainingSession TS ON TS.IdTrainingSession = CS.IdTrainingSession
		 WHERE IdClientSession = @id_client_session

	SELECT * FROM TrainingSessionStep TSS
		INNER JOIN ClientSession CS ON CS.IdTrainingSession = TSS.IdTrainingSession
		INNER JOIN QuizQuestion QQ ON QQ.IdStep = TSS.IdStep
		WHERE IdClientSession = @id_client_session
		ORDER BY TSS.Position
			

	SELECT QA.* FROM TrainingSessionStep TSS
		INNER JOIN ClientSession CS ON CS.IdTrainingSession = TSS.IdTrainingSession
		INNER JOIN QuizQuestion QQ ON QQ.IdStep = TSS.IdStep
		INNER JOIN QuizAnswer QA ON QA.IdQuizQuestion = QQ.IdQuizQuestion
		WHERE IdClientSession = @id_client_session
			AND TSS.IdStep = CS.CurrentStep

END
