-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TrainingSessionStep_Save]
	@id_training_session AS INT,
	@id_step AS INT,
    @step_name AS VARCHAR(200),
    @resource AS VARCHAR(2000),
	@resource_type AS CHAR(1),
    @presentation_duration AS INT,
    @time_to_answer AS INT
    

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @id_step = 0 BEGIN
		INSERT INTO TrainingSessionStep (IdTrainingSession) VALUES (@id_training_session)
		SET @id_step = @@IDENTITY
		UPDATE TrainingSessionStep SET
			Position = @id_step
		WHERE IdStep = @id_step
	END

	UPDATE TrainingSessionStep SET
			StepName = @step_name,
			Resource = @resource,
			ResourceType = @resource_type,
			PresentationDuration = @presentation_duration,
			TimeToAnswer = @time_to_answer
		WHERE IdStep = @id_step

	SELECT @id_step AS Id
END
