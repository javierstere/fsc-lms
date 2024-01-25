-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ClientSession_Details]
	@id_client_session AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT CS.*, TS.SessionName AS TemplateName FROM ClientSession CS
		INNER JOIN TrainingSession TS ON TS.IdTrainingSession = CS.IdTrainingSession
		 WHERE IdClientSession = @id_client_session

END
