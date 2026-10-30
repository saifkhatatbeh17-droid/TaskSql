use CourseHubDB;



-- Stage 1: setup through code, as requested.
create table dbo.TempInstructors
(TempID int, TempName varchar(50), JoinedDate date);

-- Stage 2: schema and relationships.
create table dbo.Departments
(
 DepartmentID int constraint PK_Departments primary key,
 DepartmentName varchar(100) not null constraint UQ_Departments_Name unique
);
create table dbo.Students
(
 StudentID int constraint PK_Students primary key,
 FullName varchar(100) not null,
 Email varchar(100) constraint UQ_Students_Email unique,
 GPA decimal(3,2),
 DepartmentID int constraint FK_Students_Departments references dbo.Departments(DepartmentID)
);
create table dbo.StudentProfiles
(
 ProfileID int constraint PK_StudentProfiles primary key,
 StudentID int constraint UQ_StudentProfiles_Student unique
     constraint FK_StudentProfiles_Students references dbo.Students(StudentID),
 Address varchar(200),
 EmergencyPhone varchar(20)
);
create table dbo.Courses
(
 CourseID int constraint PK_Courses primary key,
 CourseName varchar(100) not null,
 Credits int,
 DepartmentID int constraint FK_Courses_Departments references dbo.Departments(DepartmentID)
);
create table dbo.StudentCourses
(
 StudentID int constraint FK_StudentCourses_Students references dbo.Students(StudentID),
 CourseID int constraint FK_StudentCourses_Courses references dbo.Courses(CourseID),
 EnrollmentDate date constraint DF_StudentCourses_Date default getdate(),
 constraint PK_StudentCourses primary key (StudentID, CourseID)
);
alter table dbo.Students add Age int;
drop table dbo.TempInstructors;

-- Stage 3: exact sample data, update, and delete.
insert into dbo.Departments (DepartmentID, DepartmentName) values
(1,'Computer Science'),(2,'Software Engineering'),(3,'Business Administration');
insert into dbo.Students (StudentID,FullName,Email,GPA,DepartmentID,Age) values
(101,'Ali Smadi','ali@coursehub.com',3.80,1,22),
(102,'Omar Ahmad','omar@coursehub.com',2.90,1,21),
(103,'Laila Hassan','laila@coursehub.com',3.50,2,23),
(104,'Tariq Zaid','tariq@coursehub.com',2.10,3,20);
insert into dbo.StudentProfiles (ProfileID,StudentID,Address,EmergencyPhone) values
(1,101,'Amman, Jordan','0791111111'),
(2,102,'Irbid, Jordan','0792222222'),
(3,103,'Zarqa, Jordan','0793333333');
insert into dbo.Courses (CourseID,CourseName,Credits,DepartmentID) values
(201,'Database Systems',3,1),(202,'Web Development',3,1),(203,'Software Architecture',3,2);
insert into dbo.StudentCourses (StudentID,CourseID) values
(101,201),(101,202),(102,201),(103,203);
update dbo.Students set GPA=2.50 where StudentID=104;
delete from dbo.Students where StudentID=104;

-- Stage 6.2: explicitly requested index (in addition to the unique index).
create nonclustered index IX_Students_Email on dbo.Students(Email);
