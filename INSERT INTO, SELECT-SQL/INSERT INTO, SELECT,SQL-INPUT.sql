USE Academy
GO


INSERT INTO Departments(Financing, NameDepartments) VALUES
(15000, N'Psychology'),
(18000, N'Computer Science'),
(25000, N'Mathematics'),
(12000, N'Physics'),
(22000, N'Chemistry');
GO


INSERT INTO Faculties(Dean, NameFaculties) VALUES
(N'Prof. Smith', N'Engineering'),
(N'Dr. Johnson', N'Literature'),
(N'Prof. Brown', N'Medicine'),
(N'Dr. Williams', N'Law'),
(N'Prof. Taylor', N'Art');
GO


INSERT INTO Groups(NameGroups, Rating, YearGroups) VALUES
(N'B101', 3, 1),
(N'B102', 4, 1),
(N'B104', 5, 2),
(N'C301', 2, 3),
(N'C302', 1, 4);
GO


INSERT INTO Teachers(EmployementDate, IsAssistant, IsProfessor, NameTeachers, Position, Premium, Salary, Surname) VALUES
('2020-09-01', 0, 1, N'Olivia', N'Professor', 1500, 4500, N'Smith'),
('2018-05-15', 1, 0, N'Ethan', N'Assistant', 800, 2200, N'Johnson'),
('2019-11-20', 0, 1, N'Mia', N'Professor', 1800, 4000, N'Brown'),
('2021-02-12', 1, 0, N'Lucas', N'Assistant', 600, 2500, N'Williams'),
('2022-07-23', 1, 0, N'Ava', N'Assistant', 1000, 2100, N'Taylor');
GO
