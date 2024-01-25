
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Client_Details]
	@id_client AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM Client WHERE IdClient = @id_client
END
