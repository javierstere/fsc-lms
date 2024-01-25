
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProjectModule_List]
	@id_project AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM ProjectModule PM
		INNER JOIN Module M ON PM.IdModule = M.IdModule
		WHERE PM.IdProject = @id_project
		ORDER BY M.ModuleName
END
