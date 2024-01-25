

CREATE PROCEDURE [dbo].[Project_Save]
	@id_project AS INT,
	@id_client AS INT,
	@project_name AS VARCHAR(2000),
	@job AS VARCHAR(250)
AS
BEGIN
	SET NOCOUNT ON;

	IF @id_project = 0 BEGIN
		INSERT INTO [Project] (IdClient) VALUES (@id_client)
		SET @id_project = @@IDENTITY
	END

	UPDATE [Project]
		SET ProjectName = @project_name,
			Job = @job
		WHERE 
			IdProject = @id_project

	SELECT @id_project AS Id
END
