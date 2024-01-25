
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Module_Details]
	@id_module AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM Module WHERE IdModule = @id_module
END
