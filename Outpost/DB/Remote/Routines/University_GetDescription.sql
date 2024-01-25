
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[University_GetDescription]
	@link AS VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM University WHERE Link = @link
END
