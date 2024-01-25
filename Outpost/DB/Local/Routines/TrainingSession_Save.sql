-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TrainingSession_Save]
	@id_training_session AS INT,
	@session_name AS VARCHAR(200)
AS
BEGIN
	SET NOCOUNT ON;

	IF @id_training_session = 0 BEGIN
		INSERT INTO TrainingSession (SessionName) VALUES (@session_name)
		SET @id_training_session = @@IDENTITY
	END

	UPDATE TrainingSession 
		SET SessionName = @session_name
	WHERE IdTrainingSession = @id_training_session

	SELECT @id_training_session AS Id
END
