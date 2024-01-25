
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Client_Authenticate]
	@link AS VARCHAR(50),
	@username AS VARCHAR(100),
	@password AS VARCHAR(50)


AS
BEGIN
	SET NOCOUNT ON;

	-- Client_Authenticate 'alpha', 'vvv', 'aaa' --- client
	-- Client_Authenticate 'alpha', '4444', 'www' --- admin
	-- Client_Authenticate 'alpha', 'pop2', 'pop2' --- user

	

	DECLARE @id_client AS INT
	SELECT @id_client = IdClient FROM University WHERE Link = @link AND Enabled = '1'

	IF @id_client IS NULL 
		RETURN

	print @id_client

	SELECT * FROM Client WHERE IdClient = @id_client AND AccessEmail = @username AND Password = @password

	SELECT * FROM Administrator WHERE IdClient = @id_client AND Email = @username AND Password = @password

	SELECT * FROM [Employee] WHERE IdClient = @id_client AND EmployeeUser = @username AND Password = @password
END
