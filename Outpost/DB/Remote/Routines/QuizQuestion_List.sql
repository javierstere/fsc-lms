
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[QuizQuestion_List]
	@id_module AS INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM QuizQuestion WHERE IdModule = @id_module ORDER BY Question
END
