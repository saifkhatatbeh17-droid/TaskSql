-- day2 task
-- CourseHub master practical task. Run once on a new database.
USE master;
GO
CREATE DATABASE CourseHubDB_day2;
GO
USE CourseHubDB_day2;
GO
SET XACT_ABORT ON;
BEGIN TRANSACTION;

-- Stage 1: setup through code, as requested.
CREATE TABLE dbo.TempInstructors
(TempID INT, TempName VARCHAR(50), JoinedDate DATE);

-- Stage 2: schema and relationships.
CREATE TABLE dbo.Departments
(
 DepartmentID INT CONSTRAINT PK_Departments PRIMARY KEY,
 DepartmentName VARCHAR(100) NOT NULL CONSTRAINT UQ_Departments_Name UNIQUE
);
CREATE TABLE dbo.Students
(
 StudentID INT CONSTRAINT PK_Students PRIMARY KEY,
 FullName VARCHAR(100) NOT NULL,
 Email VARCHAR(100) CONSTRAINT UQ_Students_Email UNIQUE,
 GPA DECIMAL(3,2),
 DepartmentID INT CONSTRAINT FK_Students_Departments REFERENCES dbo.Departments(DepartmentID)
);
CREATE TABLE dbo.StudentProfiles
(
 ProfileID INT CONSTRAINT PK_StudentProfiles PRIMARY KEY,
 StudentID INT CONSTRAINT UQ_StudentProfiles_Student UNIQUE
     CONSTRAINT FK_StudentProfiles_Students REFERENCES dbo.Students(StudentID),
 Address VARCHAR(200),
 EmergencyPhone VARCHAR(20)
);
CREATE TABLE dbo.Courses
(
 CourseID INT CONSTRAINT PK_Courses PRIMARY KEY,
 CourseName VARCHAR(100) NOT NULL,
 Credits INT,
 DepartmentID INT CONSTRAINT FK_Courses_Departments REFERENCES dbo.Departments(DepartmentID)
);
CREATE TABLE dbo.StudentCourses
(
 StudentID INT CONSTRAINT FK_StudentCourses_Students REFERENCES dbo.Students(StudentID),
 CourseID INT CONSTRAINT FK_StudentCourses_Courses REFERENCES dbo.Courses(CourseID),
 EnrollmentDate DATE CONSTRAINT DF_StudentCourses_Date DEFAULT GETDATE(),
 CONSTRAINT PK_StudentCourses PRIMARY KEY (StudentID, CourseID)
);
ALTER TABLE dbo.Students ADD Age INT;
DROP TABLE dbo.TempInstructors;

-- Stage 3: exact sample data, update, and delete.
INSERT INTO dbo.Departments (DepartmentID, DepartmentName) VALUES
(1,'Computer Science'),(2,'Software Engineering'),(3,'Business Administration');
INSERT INTO dbo.Students (StudentID,FullName,Email,GPA,DepartmentID,Age) VALUES
(101,'Ali Smadi','ali@coursehub.com',3.80,1,22),
(102,'Omar Ahmad','omar@coursehub.com',2.90,1,21),
(103,'Laila Hassan','laila@coursehub.com',3.50,2,23),
(104,'Tariq Zaid','tariq@coursehub.com',2.10,3,20);
INSERT INTO dbo.StudentProfiles (ProfileID,StudentID,Address,EmergencyPhone) VALUES
(1,101,'Amman, Jordan','0791111111'),
(2,102,'Irbid, Jordan','0792222222'),
(3,103,'Zarqa, Jordan','0793333333');
INSERT INTO dbo.Courses (CourseID,CourseName,Credits,DepartmentID) VALUES
(201,'Database Systems',3,1),(202,'Web Development',3,1),(203,'Software Architecture',3,2);
INSERT INTO dbo.StudentCourses (StudentID,CourseID) VALUES
(101,201),(101,202),(102,201),(103,203);
UPDATE dbo.Students SET GPA=2.50 WHERE StudentID=104;
IF NOT EXISTS (SELECT * FROM dbo.Students WHERE StudentID=104 AND GPA=2.50)
 THROW 51000,'Task 3.6 GPA update failed.',1;
DELETE FROM dbo.Students WHERE StudentID=104;

-- Stage 6.2: explicitly requested index (in addition to the UNIQUE index).
CREATE NONCLUSTERED INDEX IX_Students_Email ON dbo.Students(Email);
COMMIT TRANSACTION;
GO

-- Stage 4.1: INNER JOIN, students and departments.
SELECT FullName,GPA,DepartmentName
FROM dbo.Students INNER JOIN dbo.Departments
ON dbo.Students.DepartmentID=dbo.Departments.DepartmentID;
-- Stage 4.2: LEFT JOIN includes the empty Business department.
SELECT DepartmentName,FullName
FROM dbo.Departments LEFT JOIN dbo.Students
ON dbo.Departments.DepartmentID=dbo.Students.DepartmentID;
-- Stage 4.3: one-to-one.
SELECT FullName,Address,EmergencyPhone
FROM dbo.Students INNER JOIN dbo.StudentProfiles
ON dbo.Students.StudentID=dbo.StudentProfiles.StudentID;
-- Stage 4.4: many-to-many.
SELECT FullName,CourseName,EnrollmentDate
FROM dbo.Students INNER JOIN dbo.StudentCourses
ON dbo.Students.StudentID=dbo.StudentCourses.StudentID
INNER JOIN dbo.Courses ON dbo.StudentCourses.CourseID=dbo.Courses.CourseID;

-- Stage 5.1: output labels without AS aliases.
SELECT COUNT(*) TotalStudents,AVG(GPA) AverageGPA,MAX(GPA) HighestGPA,MIN(GPA) LowestGPA
FROM dbo.Students;
-- Stage 5.2.
SELECT DepartmentID,AVG(GPA) AverageGPA,COUNT(*) TotalStudents
FROM dbo.Students GROUP BY DepartmentID;
-- Stage 5.3.
SELECT DepartmentID,AVG(GPA) AverageGPA
FROM dbo.Students GROUP BY DepartmentID HAVING AVG(GPA)>3.00;
-- Stage 5.4.
SELECT DepartmentID,COUNT(*) TotalStudents
FROM dbo.Students WHERE GPA>=2.50
GROUP BY DepartmentID HAVING COUNT(*)>1;

-- Stage 6.1: StudentID is clustered by its primary key by default.
SELECT sys.indexes.name,sys.indexes.type_desc,sys.columns.name
FROM sys.indexes INNER JOIN sys.index_columns
ON sys.indexes.object_id=sys.index_columns.object_id AND sys.indexes.index_id=sys.index_columns.index_id
INNER JOIN sys.columns
ON sys.columns.object_id=sys.index_columns.object_id AND sys.columns.column_id=sys.index_columns.column_id
WHERE sys.indexes.object_id=OBJECT_ID('dbo.Students') AND sys.indexes.type=1;

-- Stage 7.1: above overall average.
SELECT * FROM dbo.Students WHERE GPA>(SELECT AVG(GPA) FROM dbo.Students);
GO
-- Stage 7.2: AS is required syntax for CREATE VIEW.
CREATE VIEW dbo.vw_StudentAcademicDetails
AS
SELECT StudentID,FullName,GPA,DepartmentName
FROM dbo.Students INNER JOIN dbo.Departments
ON dbo.Students.DepartmentID=dbo.Departments.DepartmentID;
GO
-- Stage 7.3: AS is required syntax for this procedure body.
CREATE PROCEDURE dbo.sp_GetStudentsByDepartment @DeptID INT
AS
BEGIN
 SET NOCOUNT ON;
 SELECT * FROM dbo.Students WHERE DepartmentID=@DeptID;
END;
GO
SELECT * FROM dbo.vw_StudentAcademicDetails;
EXEC dbo.sp_GetStudentsByDepartment @DeptID=1;
GO

