IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'Academy')
    CREATE DATABASE Academy
   
GO


USE Academy

CREATE TABLE Curators
(
	[Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[NameCurators] NVARCHAR(MAX) NOT NULL,
	[SurnameCurators] NVARCHAR(MAX) NOT NULL
)

GO


CREATE TABLE Faculties 
(
    [Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[NameFaculty] NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN([NameFaculty]) > 0),
    [FinancingFaculties1] MONEY NOT NULL DEFAULT 0 CHECK ([FinancingFaculties1] >= 0)
);


GO

CREATE Table Departments
(
	[Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[NameDepartments] NVARCHAR(100) NOT NULL UNIQUE CHECK(LEN([NameDepartments]) > 0),
	[Financing] MONEY NOT NULL DEFAULT 0 CHECK ([Financing] >= 0),
	[FacultyId] INT NOT NULL FOREIGN KEY REFERENCES Faculties(Id)
);

GO


CREATE Table Groups
(
	[Id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[NameGroups] NVARCHAR(10) UNIQUE NOT NULL,
	[YearGroups] INT NOT NULL CHECK ([YearGroups] >= 1 and [YearGroups] <= 5),
	[DepartmentId] INT NOT NULL FOREIGN KEY REFERENCES Departments(Id)
);

GO



CREATE Table GroupsCurators
(
	[Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[CuratorId] INT NOT NULL FOREIGN KEY REFERENCES Curators(Id),
	[GroupId] INT NOT NULL FOREIGN KEY REFERENCES Groups(Id),
);

GO



CREATE Table Teachers
(
	[Id] INT IDENTITY(1,1)  NOT NULL  PRIMARY KEY,
	[NameTeachers] NVARCHAR(MAX) NOT NULL CHECK (LEN([NameTeachers]) > 0),
	[SurnameTeachers] NVARCHAR(MAX) NOT NULL CHECK (LEN([SurnameTeachers]) > 0),
	[Salary] MONEY NOT NULL CHECK ([Salary] >= 0),
);

GO

CREATE Table Subjects
(
	[Id] INT IDENTITY(1,1) NOT NULL  PRIMARY KEY,
	[NameSubjects] NVARCHAR(100) UNIQUE NOT NULL CHECK (LEN([NameSubjects]) > 0),
);

GO

CREATE Table Lectures
(
	[Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[LectureRoom] NVARCHAR(MAX) NOT NULL CHECK (LEN([LectureRoom]) > 0),
	[SubjectId] INT NOT NULL FOREIGN KEY REFERENCES Subjects(Id),
	[TeacherId] INT NOT NULL FOREIGN KEY REFERENCES Teachers(Id)
);

GO

CREATE Table GroupLectures	
(
	[Id] INT IDENTITY(1,1) NOT NULL  PRIMARY KEY,
	[GroupId] INT NOT NULL FOREIGN KEY REFERENCES Groups(Id),
	[LectureId] INT NOT NULL FOREIGN KEY REFERENCES Lectures(Id)
);

GO