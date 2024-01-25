-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE dbo.TrainingSessionStep_Move
	@id_session AS INT,
	@id_step AS INT,
	@direction AS INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @position AS INT
	DECLARE @other_position AS INT
	DECLARE @other_id AS INT
	
	SELECT @position = Position FROM TrainingSessionStep WHERE IdStep = @id_step
	
	
	IF @direction = -1 BEGIN
		SELECT @other_position = MAX(Position) 
			FROM TrainingSessionStep 
			WHERE IdTrainingSession = @id_session AND 
				Position < @position
		SELECT @other_id = IdStep
			FROM TrainingSessionStep 
			WHERE IdTrainingSession = @id_session AND 
				Position = @other_position
	END ELSE BEGIN
		SELECT @other_position = MIN(Position )
			FROM TrainingSessionStep 
			WHERE IdTrainingSession = @id_session AND 
				Position > @position
		SELECT @other_id = IdStep
			FROM TrainingSessionStep 
			WHERE IdTrainingSession = @id_session AND 
				Position = @other_position
	END
	
	IF @other_id IS NOT NULL AND @other_position IS NOT NULL BEGIN
		UPDATE TrainingSessionStep SET Position = @other_position WHERE IdStep = @id_step
		UPDATE TrainingSessionStep SET Position = @position WHERE IdStep = @other_id
	END
END
