-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE dbo.ClientSessionEmployee_Add
	@id_client_session AS INT,
	@id_employee AS INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF NOT EXISTS (SELECT * FROM ClientSessionEmployee WHERE IdClientSession = @id_client_session AND IdEmployee = @id_employee)
		INSERT INTO ClientSessionEmployee (IdClientSession, IdEmployee)
			VALUES (@id_client_session, @id_employee)
END
