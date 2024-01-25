
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Report_ModulesList]
	@id_client AS INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT P.ProjectName, M.ModuleName, P.Job, M.IdModule, P.IdProject FROM Project P
		INNER JOIN ProjectModule PM ON PM.IdProject = P.IdProject
		INNER JOIN Module M ON M.IdModule = PM.IdModule
		WHERE P.IdClient = @id_client
	ORDER BY P.ProjectName, M.ModuleName
END
