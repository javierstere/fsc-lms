
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Module_Save]
	@id_module AS INT,
	@id_client AS INT,
	@module_name AS VARCHAR(100),
	@type AS VARCHAR(50),
	@quiz_sessions AS CHAR(1) = null,
	@direct_check AS CHAR(1) = null,
	@delay AS INT = 0,
	@path AS VARCHAR(4000)
AS
BEGIN
	SET NOCOUNT ON;

	IF @id_module = 0 BEGIN
		INSERT INTO Module (Type, IdClient) VALUES (@type, @id_client)
		SET @id_module = @@IDENTITY
	END

	UPDATE Module 
		SET ModuleName = ISNULL(@module_name, ModuleName),
			Type = ISNULL(@type, Type),
			Path = ISNULL(@path, Path),
			QuizSessions = ISNULL(@quiz_sessions, QuizSessions),
			DirectCheck = ISNULL(@direct_check, DirectCheck),
			Delay = ISNULL(@delay, Delay)
	WHERE IdModule = @id_module

	SELECT @id_module AS Id
END
