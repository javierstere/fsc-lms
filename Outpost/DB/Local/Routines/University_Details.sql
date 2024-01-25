
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[University_Details]
	@id_university AS INT,
	@id_client AS INT	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM University 
		WHERE @id_client = IdClient
			AND @id_university = IdUniversity
		
END
