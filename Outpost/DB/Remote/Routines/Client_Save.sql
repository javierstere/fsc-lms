
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Client_Save]
	@id_client AS INT,
	@id_builder AS INT,
	@client_name AS VARCHAR(100),
	@state AS VARCHAR(50),
	@city AS VARCHAR(50),
	@address AS VARCHAR(200),
	@phone AS VARCHAR(100),
	@email AS VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;

	IF @id_client = 0 BEGIN
		INSERT INTO Client (ClientName, MaxAdmins, MaxUniversities, MaxEmployees, MaxModules, MaxProjects) 
			VALUES (@client_name, 2, 1, 100, 5, 2)
		SET @id_client = @@IDENTITY
	END

	UPDATE Client SET
		ClientName = @client_name,
		State = @state,
		City = @city,
		Address = @address,
		Phone = @phone,
		Email = @email
	WHERE IdClient = @id_client


	INSERT INTO ClientBuilder (IdClient, IdBuilder)
		SELECT @id_client, IdBuilder FROM Builder WHERE Type='B'

	EXEC ClientBuilder_Save @id_client, @id_builder, '1'

	SELECT @id_client AS Id
END
