-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ClientSession_List]
	@id_client AS INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT CS.*, TS.SessionName AS TemplateName FROM ClientSession CS
		INNER JOIN TrainingSession TS ON TS.IdTrainingSession = CS.IdTrainingSession
		WHERE CS.IdClient = @id_client
	ORDER BY CreatedAt DESC
END
