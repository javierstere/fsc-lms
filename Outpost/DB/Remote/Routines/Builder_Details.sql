
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Builder_Details]
	@id_builder AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM Builder WHERE IdBuilder = @id_builder
END
