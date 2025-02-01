IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'Academy')
    CREATE DATABASE Academy

GO

USE Academy 
GO

CREATE Table Groups
(
[Id] int identity(1,1) NOT NULL PRIMARY KEY,
[Name] nvarchar(10) NOT NULL UNIQUE,
[Rating] int NOT NULL CHECK ([Rating] >= 0 and [Rating] <= 5),
[Year] int NOT NULL  CHECK ([Year] >= 0 and [Year] <= 5)
)
GO

CREATE Table Departments
(
[Id] int identity(1,1) NOT NULL PRIMARY KEY,
[Financing] money NOT NULL CHECK (Financing >= 0) DEFAULT 0,
[Name] nvarchar(100) NOT NULL UNIQUE,
)
GO

CREATE Table Faculties
(
[Id] int identity(1,1) NOT NULL PRIMARY KEY,
[Name] nvarchar(100) NOT NULL UNIQUE,
)
GO

CREATE Table Teachers
(
[Id] int identity(1,1) NOT NULL PRIMARY KEY,
[EmploymentDate] date NOT NULL CHECK (EmploymentDate >= '01.01.1990'),
[Name] nvarchar(max) NOT NULL,
[Premium] money NOT NULL DEFAULT 0 CHECK (Premium >= 0),
[Salary] money NOT NULL CHECK (Salary > 0),
[Surname] nvarchar(max) NOT NULL
)
GO