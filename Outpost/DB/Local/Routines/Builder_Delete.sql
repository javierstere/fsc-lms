
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Builder_Delete]
	@id_builder AS INT
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM Builder WHERE IdBuilder = @id_builder
END
