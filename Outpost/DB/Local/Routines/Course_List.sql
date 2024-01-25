-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Course_List]
	@id_client AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM Course WHERE IdClient = @id_client ORDER BY CourseName

END
