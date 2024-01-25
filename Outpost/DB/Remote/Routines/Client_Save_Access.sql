
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Client_Save_Access]
	@id_client AS INT,
	@contact_person AS VARCHAR(200),
	@title_role AS VARCHAR(200),
	@access_email AS VARCHAR(100),
	@password AS VARCHAR(50),
	@max_admins AS INT,
	@max_universities AS INT,
	@max_employees AS INT,
	@max_modules AS INT,
	@max_projects AS INT
AS
BEGIN
	SET NOCOUNT ON;


	UPDATE Client SET 
		ContactPerson = @contact_person, 
		TitleRole = @title_role,
		AccessEmail = @access_email,
		Password = ISNULL(@password, Password),
		MaxAdmins = @max_admins,
		MaxUniversities = @max_universities,
		MaxEmployees = @max_employees,
		MaxModules = @max_modules,
		MaxProjects = @max_projects
	WHERE
		IdClient = @id_client
END
