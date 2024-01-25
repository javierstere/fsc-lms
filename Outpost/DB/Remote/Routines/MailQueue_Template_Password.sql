-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[MailQueue_Template_Password]
	@id_employee AS INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--  MailQueue_Template_Password 52
    
	SELECT * FROM Employee WHERE IdEmployee = @id_employee

	SELECT U.* FROM University U
		INNER JOIN Employee E ON U.IdClient = E.IdClient
	WHERE 
		E.IdEmployee = @id_employee
END
