USE Academy;
GO


INSERT INTO Curators (NameCurators , SurnameCurators) VALUES
(N'John', 'Doe'),
(N'Jane', 'Smith'),
(N'Alex', 'Cloud');


INSERT INTO Faculties(NameFaculty, FinancingFaculties1) VALUES
(N'Computer Science', 100000),
(N'Engineering', 50000),
(N'Mathematics', 30000);


INSERT INTO Departments(NameDepartments, Financing, FacultyId) VALUES
(N'Software Engineering', 20000, 1),
(N'Electrical Engireering', 25000, 2),
(N'Applied Mathematics', 15000, 3);


INSERT INTO Groups(NameGroups, YearGroups, DepartmentId) VALUES
(N'P107', 1, 1),
(N'108', 2, 1),
(N'E201', 3, 2),
(N'M301', 4, 3);


INSERT INTO GroupsCurators(CuratorId, GroupId) VALUES 
(1,1),
(2,2),
(3,3);


INSERT INTO Teachers(NameTeachers, SurnameTeachers, Salary) VALUES
(N'Samantha', N'Adams', 50000),
(N'John', N'Smith', 60000),
(N'Alice', N'Johnson', 55000);


INSERT INTO Subjects(NameSubjects) VALUES
(N'Database Theory'),
(N'Software Engineering Basics'),
(N'Electricity and Magnetism');


INSERT INTO Lectures(LectureRoom, SubjectId, TeacherId) VALUES
(N'A101', 1, 1),
(N'B102', 2, 2),
(N'C103', 3, 3);


INSERT INTO GroupLectures(GroupId, LectureId) VALUES
(1,1),
(2,2),
(3,3);