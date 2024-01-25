
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Employee_List]
	@id_client AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM Employee WHERE IdClient = @id_client ORDER BY EmployeeName

	IF @id_client IS NOT NULL AND @id_client <> 0 BEGIN
		SELECT MaxEmployees FROM Client WHERE IdClient = @id_client
	END ELSE BEGIN
		SELECT 1000 AS MaxEmployees 
	END
END
