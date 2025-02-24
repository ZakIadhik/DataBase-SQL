IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'Academy')
    CREATE DATABASE Academy;
GO


USE master
GO

ALTER DATABASE Academy SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE Academy;

USE Academy;
GO


CREATE TABLE Groups (
    GroupId INT IDENTITY(1,1) PRIMARY KEY,
    GroupName VARCHAR(100),
    StudentsCount INT DEFAULT 0
);


CREATE TABLE Student (
    StudentId INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100),
    AverageGrade DECIMAL(3, 2),
    GroupId INT,
    FOREIGN KEY (GroupId) REFERENCES Groups(GroupId)
);


CREATE TABLE Grade (
    GradeId INT IDENTITY(1,1) PRIMARY KEY, 
    StudentId INT,
    CourseName VARCHAR(100),
    GradeValue DECIMAL(3, 2),
    FOREIGN KEY (StudentId) REFERENCES Student(StudentId) ON DELETE NO ACTION
);



CREATE TABLE Warnings (
    WarningId INT IDENTITY(1,1) PRIMARY KEY,
    StudentId INT,
    Reason VARCHAR(255),
    Date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (StudentId) REFERENCES Student(StudentId)
);



CREATE TABLE GradeHistory (
    HistoryId INT IDENTITY(1,1) PRIMARY KEY,
    GradeId INT,
    OldGrade DECIMAL(3, 2),
    ChangeTime DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (GradeId) REFERENCES Grade(GradeId)
);


CREATE TABLE Payments (
    PaymentId INT IDENTITY(1,1) PRIMARY KEY,
    StudentId INT,
    Amount DECIMAL(10, 2),
    PaymentDate DATE DEFAULT GETDATE(),
    FOREIGN KEY (StudentId) REFERENCES Student(StudentId) ON DELETE NO ACTION
);


CREATE TABLE StudentCourse (
    StudentCourseId INT PRIMARY KEY IDENTITY,
    StudentId INT,
    CourseName VARCHAR(100),
    FOREIGN KEY (StudentId) REFERENCES Student(StudentId)
);


CREATE TABLE Teachers (
    TeacherId INT PRIMARY KEY,
    TeacherName VARCHAR(100) NOT NULL,
);


CREATE TABLE Course (
    CourseId INT IDENTITY(1,1) PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    TeacherId INT,
    FOREIGN KEY (TeacherId) REFERENCES Teachers(TeacherId)
);


CREATE TABLE Attendance (
    AttendanceId INT IDENTITY(1,1) PRIMARY KEY,
    StudentId INT,
    Date DATE,
    IsAbsent BIT, 
    FOREIGN KEY (StudentId) REFERENCES Student(StudentId)
);

CREATE TABLE RetakeList (
    RetakeId INT PRIMARY KEY IDENTITY(1,1),
    StudentId INT,
    Reason VARCHAR(255),
    FOREIGN KEY (StudentId) REFERENCES Student(StudentId)
);


