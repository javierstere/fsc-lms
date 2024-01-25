
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[University_Save]
	@id_university AS INT,
	@id_client AS INT,
	@enabled AS CHAR(1),
	@description AS VARCHAR(200),
	@link AS VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	IF @id_university = 0 BEGIN
		INSERT INTO University (IdClient) VALUES (@id_client)
		SET @id_university = @@IDENTITY
	END

	DECLARE @checked_link AS VARCHAR(50)
	DECLARE @index AS INT
	SET @checked_link = @link
	SET @index = 0

	WHILE 1 = 1 BEGIN
		IF NOT EXISTS (SELECT * FROM University WHERE Link = @checked_link) 
			BREAK
		SET @index = @index + 1
		SET @checked_link = @link + '-' + CONVERT(VARCHAR, @index)
	END
		
	UPDATE University
		SET 
			Description = @description,
			Link = @checked_link,
			Enabled = @enabled
		WHERE
			IdUniversity = @id_university
			AND IdClient = @id_client

	SELECT @id_university AS Id
END
