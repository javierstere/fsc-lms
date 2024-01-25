
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Employee_GetQuizzes]
	@id_client AS INT,
	@id_employee AS INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @job AS VARCHAR(250)
	SELECT @job = Job FROM Employee WHERE IdClient = @id_client AND IdEmployee = @id_employee

	SELECT * FROM Module M
		LEFT JOIN (SELECT * FROM EmployeeQuiz WHERE IdEmployee = @id_employee) EQ ON EQ.IdModule = M.IdModule
	WHERE (IdClient IS NULL OR IdClient = @id_client)
		AND M.IdModule IN (
			SELECT IdModule FROM ProjectModule PM 
				INNER JOIN Project P ON P.IdProject = PM.IdProject 
				WHERE P.Job = @job AND IdClient = @id_client)
		AND ISNULL(Deleted, 0) = 0
END
