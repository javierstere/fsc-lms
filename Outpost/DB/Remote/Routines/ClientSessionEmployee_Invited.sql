-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ClientSessionEmployee_Invited]
	@id_client_session AS INT,
	@id_employee AS INT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE ClientSessionEmployee SET InvitedAt = GETUTCDATE()
		WHERE IdClientSession = @id_client_session AND IdEmployee = @id_employee
END
