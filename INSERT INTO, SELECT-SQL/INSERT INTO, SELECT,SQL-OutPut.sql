USE Academy
GO


SELECT [NameDepartments], [Financing], [Id]
FROM Departments;


SELECT [NameGroups] AS "Group Name", [Rating] AS "Group Rating"
FROM Groups;


SELECT Surname,
	Premium / Salary * 100 AS 'Bonus Percentage',
	(Salary + Premium) / Salary * 100 AS 'Total Salary Percentage'
FROM Teachers;


SELECT 'The dean of faculty ' + NameFaculties + ' is ' + Dean AS 'Faculty Info' 
FROM Faculties;


SELECT Surname FROM Teachers
WHERE IsProfessor = 1 AND Salary > 1050;


SELECT NameDepartments FROM Departments
WHERE Financing < 11000 OR Financing > 25000;


SELECT NameFaculties FROM Faculties
WHERE NameFaculties !=  'Computer Science';


SELECT Surname, Position FROM Teachers
WHERE IsProfessor = 0;


SELECT Surname, Position, Salary, Premium FROM Teachers
WHERE IsAssistant = 1 AND Premium BETWEEN 160 AND 550;


SELECT Surname, Salary FROM Teachers
WHERE IsAssistant = 1;


SELECT Surname, Position FROM Teachers
WHERE EmployementDate < '2000-01-01';


SELECT NameDepartments AS N'Name of Department'
FROM Departments
WHERE NameDepartments < N'Software Development'
ORDER BY NameDepartments;


SELECT Surname FROM Teachers
WHERE IsAssistant = 1 AND (Salary + Premium) <= 1200;


SELECT NameGroups FROM Groups
WHERE YearGroups = 5 AND Rating BETWEEN 2 AND 4;


SELECT Surname FROM Teachers
WHERE IsAssistant = 1 AND (Salary < 550 OR Premium < 200);