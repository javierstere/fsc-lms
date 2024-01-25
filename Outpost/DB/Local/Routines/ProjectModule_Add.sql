
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProjectModule_Add]
	@id_project AS INT,
	@id_module AS INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF NOT EXISTS (SELECT * FROM ProjectModule WHERE IdProject = @id_project AND IdModule = @id_module)
		INSERT INTO ProjectModule (IdProject, IdModule) VALUES (@id_project, @id_module)
END
