USE Academy
GO

--- 1. Ограничение количества студентов в группе 
--Создайте триггер, который запрещает добавление нового студента в группу, если в ней 
--уже 30 человек.

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
        RAISERROR(N'В группе уже 30 студентов. Невозможно добавить нового студента.', 16, 1);
        ROLLBACK TRANSACTION;  
    END
END;

DROP TRIGGER trg_CheckGroupLimit


INSERT INTO Student (Name, AverageGrade, GroupId) 
VALUES (N'Иван Иванов', 4.5, 1);

INSERT INTO Student (Name, AverageGrade, GroupId) 
VALUES (N'Мария Петрова', 4.2, 1);

INSERT INTO Student (Name, AverageGrade, GroupId) 
VALUES (N'Петр Сидоров', 4.0, 1); 


SELECT * FROM Student
DELETE FROM Student
SELECT * FROM Groups WHERE GroupId = 1;
DELETE FROM Groups

--2. Обновление количества студентов в группе 
--Напишите триггер, который автоматически обновляет поле StudentsCount в таблице Group 
--при добавлении или удалении студента.

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

INSERT INTO Groups (GroupName, StudentsCount) VALUES (N'Группа 1', 29);

INSERT INTO Student (Name, AverageGrade, GroupId) VALUES (N'Иван Иванов', 4.5, 1);

INSERT INTO Student (Name, AverageGrade, GroupId) VALUES (N'Иван Иванов3123', 4.5, 1);


SELECT * FROM Groups WHERE GroupId = 1; 
DELETE FROM Student WHERE StudentId = 173;
SELECT * FROM Groups WHERE GroupId = 1;


--3. Автоматическая регистрация студента на общий курс 
--Создайте триггер, который при добавлении нового студента автоматически добавляет его 
--в курс "Введение в программирование" (если такой курс существует). 

CREATE TRIGGER trg_AutoRegisterOnCourse
ON Student
AFTER INSERT
AS
BEGIN
    INSERT INTO StudentCourse (StudentId, CourseName)
    SELECT StudentId, N'Введение в программирование'
    FROM inserted;
END;

DROP TRIGGER trg_AutoRegisterOnCourse


INSERT INTO Student (Name, AverageGrade, GroupId)
VALUES ('Иван Иванов', 4.5, 1);

SELECT * FROM StudentCourse WHERE StudentId = 4 AND CourseName = N'Введение в программирование';



--4. Предупреждение о низкой оценке 
--Реализуйте триггер, который при вставке или обновлении оценки в таблице Grade 
--проверяет, если оценка ниже 3, то добавляет запись в таблицу Warnings (StudentId, Reason, 
--Date). 

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
        VALUES (@StudentId, N'Оценка ниже 3.0');
    END
END;

DROP TRIGGER trg_LowGradeWarning

INSERT INTO Student (Name, AverageGrade, GroupId)
VALUES (N'Анна Сергеева', 2.8, 1);

INSERT INTO Grade (StudentId, CourseName, GradeValue)
VALUES (3, N'Введение в программирование', 2.5);

SELECT * FROM Warnings WHERE StudentId = 3;

--5. Запрет удаления учителей с курсами 
--Создайте триггер, который запрещает удаление преподавателя, если за ним закреплены 
--активные курсы. 


CREATE TRIGGER trg_PreventTeacherDelete
ON Teachers
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @TeacherId INT;

    SELECT @TeacherId = TeacherId FROM deleted;

    IF EXISTS (SELECT 1 FROM Course WHERE TeacherId = @TeacherId)
    BEGIN
        RAISERROR(N'Невозможно удалить преподавателя, так как он привязан к курсам!', 16, 1);
    END
    ELSE
    BEGIN
        DELETE FROM Teachers WHERE TeacherId = @TeacherId;
        PRINT N'Преподаватель успешно удален, так как у него нет привязанных курсов.';
    END
END;


DROP TRIGGER trg_PreventTeacherDelete

INSERT INTO Teachers (TeacherId, TeacherName) VALUES (1, N'Петр Иванов');
INSERT INTO Course (CourseId, CourseName, TeacherId) VALUES (1, N'Математика', 1);

DELETE FROM Teachers WHERE TeacherId = 1;
DELETE FROM Teachers WHERE TeacherId = 2; 

SELECT * FROM Course WHERE TeacherId = 1;
SELECT * FROM Teachers
SELECT * FROM Course


--6. История изменений оценок 
--Разработайте триггер, который при обновлении таблицы Grade сохраняет старое значение 
--в таблице GradeHistory с указанием времени изменения. 

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

INSERT INTO Student (Name, AverageGrade, GroupId) VALUES (N'Иван Иванов', 4.5, 1);
INSERT INTO Grade (StudentId, CourseName, GradeValue) VALUES (1, N'Введение в программирование', 4.5);

SELECT * FROM Student
SELECT * FROM Grade

UPDATE Grade
SET GradeValue = 5.0
WHERE GradeId = 2;

SELECT * FROM Grade
SELECT * FROM GradeHistory;


--7. Контроль пропусков занятий 
--Создайте триггер, который при добавлении записи о пропуске занятия (Attendance) 
--проверяет, если студент пропустил более 5 занятий подряд, то добавляет его в список на 
--пересдачу (RetakeList). 


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
            VALUES (@StudentId, N'Пропуск более 5 занятий подряд');
        END
    END
END;


DROP TRIGGER trg_ControlAbsences

INSERT INTO Groups (GroupId, GroupName, StudentsCount) VALUES (1, N'Группа 1', 29);

INSERT INTO Student (Name, AverageGrade, GroupId)
VALUES (N'Иван Иванов', 4.5, 1);

INSERT INTO Attendance (StudentId, Date, IsAbsent)
VALUES (1, N'2025-02-01', 1),
       (1, N'2025-02-02', 1),
       (1, N'2025-02-03', 1),
       (1, N'2025-02-04', 1),
       (1, N'2025-02-05', 1);

SELECT * FROM RetakeList;


--8. Запрет удаления студентов с долгами 
--Напишите триггер, который запрещает удаление студента, если у него есть задолженности 
--по оплате (Payments) или неудовлетворительные оценки. 


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
        RAISERROR (N'Нельзя удалить студента с задолженностями или неудовлетворительными оценками.', 16, 1);
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
VALUES (N'Group A', 2);

INSERT INTO Student (Name, AverageGrade, GroupId)
VALUES (N'Иван Иванов', 3.5, 1),
       (N'Петр Петров', 2.8, 1);

INSERT INTO Payments (StudentId, Amount, PaymentDate)
VALUES (1, -500.00, '2025-02-24');

INSERT INTO Grade (StudentId, CourseName, GradeValue)
VALUES (2, N'Математика', 1.5);

DELETE FROM Student WHERE StudentId = 1;

DELETE FROM Student WHERE StudentId = 2;

INSERT INTO Student (Name, AverageGrade, GroupId)
VALUES (N'Анна Сидорова', 4.0, 1);

DELETE FROM Student WHERE StudentId = 4;




--9. Обновление среднего балла студента
--Создайте триггер, который при добавлении или изменении оценки пересчитывает средний 
--балл студента в таблице Student


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


-- Добавляем группу
INSERT INTO Groups (GroupName, StudentsCount)
VALUES (N'Group A', 1);

-- Добавляем студента
INSERT INTO Student (Name, GroupId)
VALUES (N'Иван Иванов', 1);

-- Добавляем первую оценку студенту
INSERT INTO Grade (StudentId, CourseName, GradeValue)
VALUES (1, N'Математика', 4.50);

-- Проверяем средний балл после первой оценки
SELECT Name, AverageGrade
FROM Student
WHERE StudentId = 1;

-- Добавляем вторую оценку студенту
INSERT INTO Grade (StudentId, CourseName, GradeValue)
VALUES (1, N'Физика', 5.00);

-- Проверяем средний балл после второй оценки
SELECT Name, AverageGrade
FROM Student
WHERE StudentId = 1;