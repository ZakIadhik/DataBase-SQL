IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'Academy')
    CREATE DATABASE Academy  
GO


USE Academy
GO

CREATE TABLE Departments
(
	[Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Financing] MONEY NOT NULL CHECK ([Financing] >= 0) DEFAULT 0,
	[NameDepartments] NVARCHAR(100) NOT NULL CHECK (LEN([NameDepartments]) > 0) UNIQUE,
);
GO

CREATE TABLE Faculties
(
	[Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Dean] NVARCHAR(MAX) NOT NULL CHECK (LEN([Dean]) > 0),
	[NameFaculties] NVARCHAR(100) NOT NULL CHECK (LEN([NameFaculties]) > 0) UNIQUE,
);
GO

CREATE TABLE Groups
(
	[Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[NameGroups] NVARCHAR(100) NOT NULL CHECK (LEN([NameGroups]) > 0) UNIQUE,
	[Rating] INT NOT NULL CHECK ([Rating] >= 0 AND [Rating] <= 5),
	[YearGroups] INT NOT NULL CHECK ([YearGroups] >= 1 AND [YearGroups] <= 5),
);
GO

CREATE TABLE Teachers
(
	[Id] INT IDENTITY NOT NULL PRIMARY KEY,
	[EmployementDate] DATE NOT NULL CHECK([EmployementDate] >= '1990.01.01'),
	[IsAssistant] BIT NOT NULL DEFAULT 0,
	[IsProfessor] BIT NOT NULL DEFAULT 0,
	[NameTeachers] NVARCHAR(MAX) NOT NULL CHECK (LEN([NameTeachers]) > 0),
	[Position] NVARCHAR(MAX) NOT NULL CHECK (LEN([Position]) > 0),
	[Premium] MONEY NOT NULL CHECK ([Premium] >= 0)  DEFAULT 0,
	[Salary] MONEY NOT NULL CHECK ([Salary] >= 0),
	[Surname] NVARCHAR(MAX) NOT NULL CHECK (LEN([Surname]) > 0),
);
GO