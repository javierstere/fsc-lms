
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ClientBuilder_Save]
	@id_client AS INT,
	@id_builder AS INT,
	@active AS CHAR(1)
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (SELECT * FROM Builder WHERE IdBuilder = @id_builder AND Type = 'B')
		SET @active = '1'

	IF @active = '1' BEGIN
		IF NOT EXISTS (SELECT * FROM ClientBuilder WHERE IdClient = @id_client AND IdBuilder = @id_builder)
			INSERT INTO ClientBuilder (IdClient, IdBuilder) VALUES (@id_client, @id_builder)
	END ELSE BEGIN
		DELETE FROM ClientBuilder WHERE IdClient = @id_client AND IdBuilder = @id_builder
	END
END
