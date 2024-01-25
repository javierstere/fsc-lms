-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[MailQueue_Template_Group_Session]
	@id_client_session AS INT,
	@id_employee AS INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM Employee WHERE IdEmployee = @id_employee
    
	SELECT * FROM ClientSession WHERE IdClientSession = @id_client_session

	SELECT U.* FROM University U
		INNER JOIN Employee E ON U.IdClient = E.IdClient
	WHERE 
		E.IdEmployee = @id_employee

END
