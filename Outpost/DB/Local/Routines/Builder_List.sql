
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Builder_List]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM Builder ORDER BY BuilderName
END
