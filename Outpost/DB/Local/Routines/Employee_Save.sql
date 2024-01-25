


CREATE PROCEDURE [dbo].[Employee_Save]
	@id_employee AS INT,
	@id_client AS INT,
	@employee_name AS VARCHAR(200),
	@employee_user AS VARCHAR(200),
	@password AS VARCHAR(100),
	@job AS VARCHAR(250),
	@email AS VARCHAR(200)
AS
BEGIN
	SET NOCOUNT ON;

	IF @id_employee = 0 BEGIN
		INSERT INTO Employee (IdClient) VALUES (@id_client)
		SET @id_employee = @@IDENTITY
	END

	DECLARE @index AS INT
	SET @index = 0
	DECLARE @eu AS VARCHAR(200)
	SET @eu = @employee_user
	WHILE EXISTS (SELECT * FROM Employee WHERE IdClient = @id_client AND EmployeeUser = @eu AND IdEmployee <> @id_employee) BEGIN
		SET @index = @index + 1
		SET @eu = @employee_user + '-' + CONVERT(VARCHAR, @index)
	END
	SET @employee_user = @eu


	UPDATE Employee
		SET EmployeeName = @employee_name,
			EmployeeUser = @employee_user,
			Password = ISNULL(@password, Password),
			Job = @job,
			Email = @email
		WHERE
			IdEmployee = @id_employee
			

	SELECT @id_employee AS Id
END

