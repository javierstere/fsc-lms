
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProjectModule_Delete]
	@id_project AS INT,
	@id_module AS INT
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM ProjectModule WHERE IdProject = @id_project AND IdModule = @id_module
END
