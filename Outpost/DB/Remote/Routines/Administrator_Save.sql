
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Administrator_Save]
	@id_client AS INT,
	@id_administrator AS INT,
	@administrator_name AS VARCHAR(100),
	@job_title AS VARCHAR(100),
	@email AS VARCHAR(100),
	@phone AS VARCHAR(100),
	@password AS VARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF @id_administrator = 0 BEGIN
		INSERT INTO Administrator (IdClient) VALUES (@id_client)
		SET @id_administrator = @@IDENTITY
	END

	UPDATE Administrator 
		SET AdministratorName = @administrator_name,
			JobTitle = @job_title,
			Email = @email,
			Phone = @phone,
			Password = ISNULL(@password, Password)
		WHERE IdClient = @id_client 
			AND IdAdministrator = @id_administrator

	SELECT @id_administrator AS Id
END
