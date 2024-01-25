-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE dbo.TrainingSessionStep_SaveResourcePath
	@id_step AS INT,
	@resource AS VARCHAR(2000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE TrainingSessionStep SET Resource = @resource WHERE IdStep = @id_step
END
