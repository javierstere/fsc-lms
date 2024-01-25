
 CREATE PROCEDURE [dbo].[Employee_Find]
 	@id_client AS INT,
	@type AS CHAR(1),
 	@filter AS VARCHAR(1000)
 AS
 BEGIN
 	SET NOCOUNT ON;
 
 	SET @filter = REPLACE(@filter, '*', '%')
 

	-- Employee_Find 3, 'i', ''


 	SELECT * FROM Employee E	
 		LEFT JOIN (
 			SELECT IdEmployee, EQ.IdModule, EQ.IdClientSession, ISNULL(M.ModuleName, CS.SessionName) AS ModuleName, Points, Timestamp 
				FROM EmployeeQuiz EQ 
 					LEFT JOIN Module M ON M.IdModule = EQ.IdModule AND @type = 'i' AND EQ.IdModule IS NOT NULL
 					LEFT JOIN ClientSession CS ON CS.IdClientSession = EQ.IdClientSession AND @type = 'g' AND EQ.IdClientSession IS NOT NULL
 				WHERE IdEmployee IN (SELECT IdEmployee FROM Employee WHERE IdClient = @id_client)
					AND (
						(@type = 'i' AND EQ.IdModule IS NOT NULL) 
						OR 
						(@type = 'g' AND EQ.IdClientSession IS NOT NULL  AND EQ.IdClientSession IN (SELECT IdClientSession FROM ClientSession WHERE IdClient = @id_client))
					)
 		) EQ ON EQ.IdEmployee = E.IdEmployee
 		WHERE IdClient = @id_client
 			AND (EmployeeName LIKE @filter + '%'
 				OR EmployeeUser LIKE @filter + '%')
 
 		ORDER BY EmployeeName, EmployeeUser
 END