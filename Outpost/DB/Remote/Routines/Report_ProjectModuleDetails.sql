
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Report_ProjectModuleDetails]
	@id_client AS INT,
	@id_project AS INT,
	@id_module AS INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @job AS VARCHAR(250)
	SELECT @job = Job FROM Project WHERE IdProject = @id_project

	-- Report_ProjectModuleDetails 4, 11
	-- Report_ProjectModuleDetails 4, 10
	-- Report_ProjectModuleDetails 5, 12
	-- Report_ProjectModuleDetails 5, 11
	-- Report_ProjectModuleDetails 5, 10

	SELECT P.ProjectName, P.Job, M.ModuleName FROM Project P
		INNER JOIN ProjectModule PM ON PM.IdProject = P.IdProject
		INNER JOIN Module M ON PM.IdModule = M.IdModule
		WHERE P.IdProject = @id_project AND M.IdModule = @id_module

	SELECT E.IdEmployee, E.EmployeeName, EQ.Points FROM Employee E
		LEFT JOIN (SELECT * FROM EmployeeQuiz WHERE IdModule = @id_module) EQ ON EQ.IdEmployee = E.IdEmployee
		WHERE
			IdClient = @id_client AND
			Job = @job
		ORdER BY EmployeeName

END
