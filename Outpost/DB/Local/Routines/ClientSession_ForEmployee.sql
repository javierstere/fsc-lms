

CREATE PROCEDURE [dbo].[ClientSession_ForEmployee]
	@id_client AS INT,
	@id_employee AS INT
AS
BEGIN 
	SET NOCOUNT ON;

	--DECLARE @job AS VARCHAR(250)
	--SELECT @job = Job FROM Employee WHERE IdClient = @id_client AND IdEmployee = @id_employee

	SELECT * FROM ClientSession CS
	WHERE (CS.IdClient IS NULL OR CS.IdClient = @id_client)
		--AND Job = @job
		AND IdClientSession IN (SELECT IdClientSession FROM ClientSessionEmployee WHERE IdEmployee = @id_employee)
		AND Status > 0
END

