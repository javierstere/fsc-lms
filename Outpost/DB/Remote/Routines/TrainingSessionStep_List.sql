-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TrainingSessionStep_List]
	@id_training_session AS INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM TrainingSessionStep 
		WHERE IdTrainingSession = @id_training_session 
			AND _deleted_ IS NULL
		ORDER BY Position
END
