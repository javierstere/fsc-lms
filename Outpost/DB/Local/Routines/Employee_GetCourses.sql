-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Employee_GetCourses]
	@id_client AS INT,
	@id_employee AS INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @job AS VARCHAR(250)
	SELECT @job = Job FROM Employee WHERE IdClient = @id_client AND IdEmployee = @id_employee

	SELECT *, GETUTCDATE() AS NOW FROM Module M
		LEFT JOIN (
			SELECT EQ.* FROM EmployeeQuiz EQ
				inner join (SELECT IdEmployee, IdModule, MAX(timestamp) AS LastTimestamp FROM EmployeeQuiz
				GROUP BY IdEmployee, IdModule) EQM ON EQ.IdEmployee = EQM.IdEmployee
				AND EQ.IdModule = EQM.IdModule AND EQ.timestamp = EQM.LastTimestamp
			
			--SELECT * FROM EmployeeQuiz 
			
			WHERE EQ.IdEmployee = @id_employee
		) EQ ON EQ.IdModule = M.IdModule
	WHERE (IdClient IS NULL OR IdClient = @id_client)
		AND M.IdModule IN (
			SELECT IdModule FROM CourseModule PM 
				INNER JOIN Course P ON P.IdCourse = PM.IdCourse 
				WHERE (P.Job = @job OR LOWER(P.Job) = 'all'  OR ISNULL(P.Job, '') = '') AND IdClient = @id_client)
		AND ISNULL(Deleted, 0) = 0
	ORDER BY M.ModuleName
END
