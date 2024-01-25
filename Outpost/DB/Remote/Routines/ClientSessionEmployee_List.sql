-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ClientSessionEmployee_List]
	@id_client_session AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		E.IdEmployee, E.EmployeeName, 
		--DATEADD(hh, CS.TimeZone, CSE.InvitedAt) AS InvitedAt,
		CSE.InvitedAt,
		CS.TimeZone
		FROM ClientSessionEmployee CSE
			INNER JOIN ClientSession CS ON CSE.IdClientSession = CS.IdClientSession
			INNER JOIN Employee E ON E.IdEmployee = CSE.IdEmployee
		WHERE CSE.IdClientSession = @id_client_session
	ORDER BY EmployeeName
END
