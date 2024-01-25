
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Employee_Details]
	@id_client AS INT,
	@id_employee AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM Employee WHERE IdClient = @id_client AND IdEmployee = @id_employee

	SELECT DISTINCT Job FROM Employee WHERE IdClient = @id_client AND Job <> ''
		UNION 
	SELECT DISTINCT Job FROM Project WHERE IdClient = @id_client AND Job <> ''
	ORDER BY Job
END
