
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Project_Delete]
	@id_project AS INT
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM Project WHERE IdProject = @id_project
END
