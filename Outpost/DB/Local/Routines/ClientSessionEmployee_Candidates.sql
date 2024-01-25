-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE dbo.ClientSessionEmployee_Candidates
	@id_client_session AS INT,
	@name AS VARCHAR(200)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @id_client AS INT
	SELECT @id_client = IdClient FROM ClientSession WHERE IdClientSession = @id_client_Session

	SELECT * FROM Employee WHERE IdClient = @id_client
		AND EmployeeName LIKE @name + '%%'
		AND IdEmployee NOT IN (SELECT IdEmployee FROM ClientSessionEmployee WHERE IdClientSession = @id_client_session)
		ORDER BY EmployeeName
END
