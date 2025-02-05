SELECT Teachers.NameTeachers, Teachers.SurnameTeachers, Groups.NameGroups
FROM Teachers
JOIN Lectures ON Teachers.Id = Lectures.TeacherId
JOIN GroupLectures ON Lectures.Id = GroupLectures.LectureId
JOIN Groups ON GroupLectures.GroupId = Groups.Id;


SELECT Faculties.NameFaculty, Faculties.FinancingFaculties1
FROM Faculties
JOIN Departments ON Faculties.Id = Departments.FacultyId
WHERE Departments.Financing > Faculties.FinancingFaculties1;


SELECT Curators.SurnameCurators, Groups.NameGroups
FROM Curators
JOIN GroupsCurators ON Curators.Id = GroupsCurators.CuratorId
JOIN Groups ON GroupsCurators.GroupId = Groups.Id;


SELECT Teachers.NameTeachers, Teachers.SurnameTeachers
FROM Teachers
JOIN Lectures ON Teachers.Id = Lectures.TeacherId
JOIN GroupLectures ON Lectures.Id = GroupLectures.LectureId
JOIN Groups ON GroupLectures.GroupId = Groups.Id
WHERE Groups.NameGroups = 'P107';


SELECT Teachers.SurnameTeachers, Faculties.NameFaculty
FROM Teachers
JOIN Lectures ON Teachers.Id = Lectures.TeacherId
JOIN Subjects ON Lectures.SubjectId = Subjects.Id
JOIN Departments ON Subjects.Id = Departments.FacultyId
JOIN Faculties ON Departments.FacultyId = Faculties.Id;


SELECT Departments.NameDepartments, Groups.NameGroups
FROM Departments
JOIN Groups ON Departments.Id = Groups.DepartmentId;


SELECT Subjects.NameSubjects
FROM Subjects
JOIN Lectures ON Subjects.Id = Lectures.SubjectId
JOIN Teachers ON Lectures.TeacherId = Teachers.Id
WHERE Teachers.NameTeachers = 'Samantha' AND Teachers.SurnameTeachers = 'Adams';


SELECT Departments.NameDepartments
FROM Departments
JOIN Subjects ON Departments.Id = Subjects.Id
WHERE Subjects.NameSubjects = 'Database Theory';


SELECT Groups.NameGroups
FROM Groups
JOIN Departments ON Groups.DepartmentId = Departments.Id
JOIN Faculties ON Departments.FacultyId = Faculties.Id
WHERE Faculties.NameFaculty = 'Computer Science';


SELECT Groups.NameGroups, Faculties.NameFaculty
FROM Groups
JOIN Departments ON Groups.DepartmentId = Departments.Id
JOIN Faculties ON Departments.FacultyId = Faculties.Id
WHERE Groups.YearGroups = 5;


SELECT Teachers.NameTeachers, Teachers.SurnameTeachers, Subjects.NameSubjects, Groups.NameGroups
FROM Teachers
JOIN Lectures ON Teachers.Id = Lectures.TeacherId
JOIN Subjects ON Lectures.SubjectId = Subjects.Id
JOIN GroupLectures ON Lectures.Id = GroupLectures.LectureId
JOIN Groups ON GroupLectures.GroupId = Groups.Id
WHERE Lectures.LectureRoom = 'B103';
