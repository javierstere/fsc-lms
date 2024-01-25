-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CourseNotification_Add]
	@id_client AS INT,
	@id_employee AS INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @cn AS INT

	SELECT Id FROM CourseNotification
		WHERE IdEmployee = @id_employee AND IdClient = @id_client

	SELECT @cn = Id FROM CourseNotification
		WHERE IdEmployee = @id_employee AND IdClient = @id_client

	IF @cn IS NULL BEGIN
		INSERT INTO CourseNotification (IdClient, IdEmployee, Timestamp) 
			VALUES (@id_client, @id_employee, GETUTCDATE())

		SET @cn = @@IDENTITY
	END

END
