
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ClientBuilder_List]
	@id_client AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM Builder B
		LEFT JOIN (SELECT * FROM ClientBuilder WHERE IdClient = @id_client) CB ON CB.IdBuilder = B.IdBuilder
		
	ORDER BY BuilderName
END
