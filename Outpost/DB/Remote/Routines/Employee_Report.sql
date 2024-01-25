
CREATE PROCEDURE [dbo].[Employee_Report]
	@id_client AS INT,
	@type AS CHAR(1),
	@filter AS VARCHAR(1000)
AS
BEGIN
	SET NOCOUNT ON;

	SET @filter = REPLACE(@filter, '*', '%')

	SELECT E.EmployeeName AS 'Name', E.EmployeeUser AS 'Username', EQ.ModuleName AS 'Session', CONVERT(VARCHAR, EQ.Timestamp, 101) AS Date, EQ.Points AS 'Score' FROM Employee E	
		LEFT JOIN (
			SELECT IdEmployee, EQ.IdModule, ISNULL(ModuleName, SessionName) AS ModuleName, Points, Timestamp FROM EmployeeQuiz EQ 
 					LEFT JOIN Module M ON M.IdModule = EQ.IdModule AND @type = 'i'
 					LEFT JOIN ClientSession CS ON CS.IdClientSession = EQ.IdClientSession AND @type = 'g'
				WHERE IdEmployee IN (SELECT IdEmployee FROM Employee WHERE IdClient = @id_client)
					AND ((@type = 'i' AND EQ.IdModule IS NOT NULL) OR (@type = 'g' AND EQ.IdClientSession IS NOT NULL))
		) EQ ON EQ.IdEmployee = E.IdEmployee
		WHERE IdClient = @id_client
			AND (EmployeeName LIKE @filter + '%'
				OR EmployeeUser LIKE @filter + '%')

		ORDER BY EmployeeName, EmployeeUser
END