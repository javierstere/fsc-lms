
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[University_List]
	@id_client AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM University 
		WHERE ISNULL(@id_client, IdClient) = IdClient
			AND (@id_client IS NULL AND Enabled = '1' OR @id_client IS NOT NULL)
		ORDER BY Description

	SELECT MaxUniversities FROM Client WHERE IdClient = @id_client

END
