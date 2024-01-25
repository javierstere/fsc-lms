-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TrainingSessionStep_Delete]
	@id_step AS INT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE TrainingSessionStep 
		SET _deleted_ = 1
	WHERE IdStep = @id_step

END
