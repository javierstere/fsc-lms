
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Builder_Save]
	@id_builder AS INT,
	@builder_name AS VARCHAR(100),
	@email AS VARCHAR(100),
	@phone AS VARCHAR(50),
	@initiation_date AS DATE,
	@type AS CHAR(1),
	@password AS VARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF @id_builder = 0 BEGIN
		INSERT INTO Builder (Type) VALUES (@type)
		SET @id_builder = @@IDENTITY
	END
	UPDATE Builder 
		SET BuilderName = @builder_name,
			Email = @email,
			Phone = @phone,
			InitiationDate = @initiation_date,
			Type = @type,
			Password = ISNULL(@password, Password)
		WHERE
			IdBuilder = @id_builder

	SELECT @id_builder AS Id
END
