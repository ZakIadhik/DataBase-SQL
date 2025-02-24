USE Academy
GO

-- 1. Limiting the number of students in a group
-- Create a trigger that prevents adding a new student to a group if it already has 30 students.
CREATE TRIGGER trg_CheckGroupLimit
ON Student
AFTER INSERT
AS
BEGIN
    DECLARE @GroupId INT;
    DECLARE @StudentsCount INT;

    SELECT @GroupId = GroupId FROM inserted;

    SELECT @StudentsCount = StudentsCount FROM Groups WHERE GroupId = @GroupId;

    IF (@StudentsCount >= 30)
    BEGIN
        RAISERROR('The group already has 30 students. Cannot add a new student.', 16, 1);
        ROLLBACK TRANSACTION;  
    END
END;

DROP TRIGGER trg_CheckGroupLimit

INSERT INTO Student (Name, AverageGrade, GroupId) 
VALUES ('Ivan Ivanov', 4.5, 1);

INSERT INTO Student (Name, AverageGrade, GroupId) 
VALUES ('Maria Petrova', 4.2, 1);

INSERT INTO Student (Name, AverageGrade, GroupId) 
VALUES ('Petr Sidorov', 4.0, 1); 

SELECT * FROM Student
DELETE FROM Student
SELECT * FROM Groups WHERE GroupId = 1;
DELETE FROM Groups

-- 2. Updating the number of students in a group
-- Write a trigger that automatically updates the StudentsCount field in the Groups table 
-- when a student is added or removed.
CREATE TRIGGER trg_UpdateStudentCount
ON Student
AFTER INSERT, DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        UPDATE Groups
        SET StudentsCount = (SELECT COUNT(*) FROM Student WHERE GroupId = Groups.GroupId)
        WHERE GroupId IN (SELECT GroupId FROM inserted);
    END
    IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        UPDATE Groups
        SET StudentsCount = (SELECT COUNT(*) FROM Student WHERE GroupId = Groups.GroupId)
        WHERE GroupId IN (SELECT GroupId FROM deleted);
    END
END;

DROP TRIGGER trg_UpdateStudentCount

INSERT INTO Groups (GroupName, StudentsCount) VALUES ('Group 1', 29);

INSERT INTO Student (Name, AverageGrade, GroupId) VALUES ('Ivan Ivanov', 4.5, 1);

INSERT INTO Student (Name, AverageGrade, GroupId) VALUES ('Ivan Ivanov3123', 4.5, 1);

SELECT * FROM Groups WHERE GroupId = 1; 
DELETE FROM Student WHERE StudentId = 173;
SELECT * FROM Groups WHERE GroupId = 1;

-- 3. Automatic enrollment of a student in a common course
-- Create a trigger that, when a new student is added, automatically enrolls them 
-- in the "Introduction to Programming" course (if such a course exists).
CREATE TRIGGER trg_AutoRegisterOnCourse
ON Student
AFTER INSERT
AS
BEGIN
    INSERT INTO StudentCourse (StudentId, CourseName)
    SELECT StudentId, 'Introduction to Programming'
    FROM inserted;
END;

DROP TRIGGER trg_AutoRegisterOnCourse

INSERT INTO Student (Name, AverageGrade, GroupId)
VALUES ('Ivan Ivanov', 4.5, 1);

SELECT * FROM StudentCourse WHERE StudentId = 4 AND CourseName = 'Introduction to Programming';

-- 4. Warning about a low grade
-- Implement a trigger that, when inserting or updating a grade in the Grade table, 
-- checks if the grade is below 3 and adds a record to the Warnings table (StudentId, Reason, Date).
CREATE TRIGGER trg_LowGradeWarning
ON Grade
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @StudentId INT;
    DECLARE @GradeValue DECIMAL(3,2);
    DECLARE @CourseName VARCHAR(100);
    SELECT @StudentId = StudentId, @GradeValue = GradeValue, @CourseName = CourseName FROM inserted;
    IF (@GradeValue < 3.0)
    BEGIN
        INSERT INTO Warnings (StudentId, Reason)
        VALUES (@StudentId, 'Grade below 3.0');
    END
END;

DROP TRIGGER trg_LowGradeWarning

INSERT INTO Student (Name, AverageGrade, GroupId)
VALUES ('Anna Sergeeva', 2.8, 1);

INSERT INTO Grade (StudentId, CourseName, GradeValue)
VALUES (3, 'Introduction to Programming', 2.5);

SELECT * FROM Warnings WHERE StudentId = 3;

-- 5. Preventing deletion of teachers with assigned courses
-- Create a trigger that prohibits deleting a teacher if they are assigned to active courses.
CREATE TRIGGER trg_PreventTeacherDelete
ON Teachers
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @TeacherId INT;

    SELECT @TeacherId = TeacherId FROM deleted;

    IF EXISTS (SELECT 1 FROM Course WHERE TeacherId = @TeacherId)
    BEGIN
        RAISERROR('Cannot delete the teacher because they are assigned to courses!', 16, 1);
    END
    ELSE
    BEGIN
        DELETE FROM Teachers WHERE TeacherId = @TeacherId;
        PRINT 'Teacher successfully deleted as they have no assigned courses.';
    END
END;

DROP TRIGGER trg_PreventTeacherDelete

INSERT INTO Teachers (TeacherId, TeacherName) VALUES (1, 'Petr Ivanov');
INSERT INTO Course (CourseId, CourseName, TeacherId) VALUES (1, 'Mathematics', 1);

DELETE FROM Teachers WHERE TeacherId = 1;
DELETE FROM Teachers WHERE TeacherId = 2; 

SELECT * FROM Course WHERE TeacherId = 1;
SELECT * FROM Teachers
SELECT * FROM Course

-- 6. History of grade changes
-- Develop a trigger that, when updating the Grade table, saves the old value 
-- in the GradeHistory table with the change timestamp.
CREATE TRIGGER trg_SaveGradeHistory
ON Grade
AFTER UPDATE
AS
BEGIN
    DECLARE @GradeId INT;
    DECLARE @OldGrade DECIMAL(3, 2);
    DECLARE @NewGrade DECIMAL(3, 2);
    SELECT @GradeId = GradeId, @OldGrade = GradeValue FROM deleted;
    SELECT @NewGrade = GradeValue FROM inserted;
    INSERT INTO GradeHistory (GradeId, OldGrade)
    VALUES (@GradeId, @OldGrade);
END;

DROP TRIGGER trg_SaveGradeHistory

INSERT INTO Student (Name, AverageGrade, GroupId) VALUES ('Ivan Ivanov', 4.5, 1);
INSERT INTO Grade (StudentId, CourseName, GradeValue) VALUES (1, 'Introduction to Programming', 4.5);

SELECT * FROM Student
SELECT * FROM Grade

UPDATE Grade
SET GradeValue = 5.0
WHERE GradeId = 2;

SELECT * FROM Grade
SELECT * FROM GradeHistory;

-- 7. Monitoring class absences
-- Create a trigger that, when adding an absence record in the Attendance table, 
-- checks if the student has missed more than 5 consecutive classes and adds them 
-- to the RetakeList.
CREATE TRIGGER trg_ControlAbsences
ON Attendance
AFTER INSERT
AS
BEGIN
    DECLARE @StudentId INT;
    DECLARE @AbsenceCount INT;
    DECLARE @MaxDate DATE;
    SELECT @StudentId = StudentId, @MaxDate = Date FROM inserted;
    SELECT @AbsenceCount = COUNT(*) 
    FROM Attendance
    WHERE StudentId = @StudentId AND IsAbsent = 1
    AND Date >= DATEADD(DAY, -4, @MaxDate);  
    IF @AbsenceCount >= 5
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM RetakeList WHERE StudentId = @StudentId)
        BEGIN
            INSERT INTO RetakeList (StudentId, Reason)
            VALUES (@StudentId, 'More than 5 consecutive absences');
        END
    END
END;

DROP TRIGGER trg_ControlAbsences

INSERT INTO Groups (GroupId, GroupName, StudentsCount) VALUES (1, 'Group 1', 29);

INSERT INTO Student (Name, AverageGrade, GroupId)
VALUES ('Ivan Ivanov', 4.5, 1);

INSERT INTO Attendance (StudentId, Date, IsAbsent)
VALUES (1, '2025-02-01', 1),
       (1, '2025-02-02', 1),
       (1, '2025-02-03', 1),
       (1, '2025-02-04', 1),
       (1, '2025-02-05', 1);

SELECT * FROM RetakeList;

-- 8. Preventing deletion of students with debts
-- Write a trigger that prohibits deleting a student if they have payment debts 
-- (Payments) or unsatisfactory grades.
CREATE TRIGGER PreventStudentDeletion
ON Student
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM deleted d
        LEFT JOIN Payments p ON d.StudentId = p.StudentId
        LEFT JOIN Grade g ON d.StudentId = g.StudentId
        WHERE p.Amount < 0 OR g.GradeValue < 2.0
    )
    BEGIN
        RAISERROR ('Cannot delete a student with debts or unsatisfactory grades.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        DELETE FROM Student
        WHERE StudentId IN (SELECT StudentId FROM deleted);
    END
END;
GO

DROP TRIGGER trg_PreventStudentDelete

SELECT * FROM Student

INSERT INTO Groups (GroupName, StudentsCount) 
VALUES ('Group A', 2);

INSERT INTO Student (Name, AverageGrade, GroupId)
VALUES ('Ivan Ivanov', 3.5, 1),
       ('Petr Petrov', 2.8, 1);

INSERT INTO Payments (StudentId, Amount, PaymentDate)
VALUES (1, -500.00, '2025-02-24');

INSERT INTO Grade (StudentId, CourseName, GradeValue)
VALUES (2, 'Mathematics', 1.5);

DELETE FROM Student WHERE StudentId = 1;

DELETE FROM Student WHERE StudentId = 2;

INSERT INTO Student (Name, AverageGrade, GroupId)
VALUES ('Anna Sidorova', 4.0, 1);

DELETE FROM Student WHERE StudentId = 4;

-- 9. Updating the student’s average grade
-- Create a trigger that recalculates the student’s average grade in the Student table 
-- when a grade is added or updated.
CREATE TRIGGER UpdateAverageGrade
ON Grade
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Student
    SET AverageGrade = (
        SELECT AVG(GradeValue)
        FROM Grade
        WHERE Grade.StudentId = Student.StudentId
    )
    WHERE StudentId IN (
        SELECT StudentId
        FROM INSERTED
    );
END;


INSERT INTO Groups (GroupName, StudentsCount)
VALUES ('Group A', 1);


INSERT INTO Student (Name, GroupId)
VALUES ('Ivan Ivanov', 1);


INSERT INTO Grade (StudentId, CourseName, GradeValue)
VALUES (1, 'Mathematics', 4.50);


SELECT Name, AverageGrade
FROM Student
WHERE StudentId = 1;


INSERT INTO Grade (StudentId, CourseName, GradeValue)
VALUES (1, 'Physics', 5.00);


SELECT Name, AverageGrade
FROM Student
WHERE StudentId = 1;