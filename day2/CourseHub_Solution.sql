-- CourseHub - Day 2
-- database: CourseHubDB
-- all task code in one file, without GO
-- select and execute each numbered section separately, in order
-- do not execute the entire file at once
-- the databases already exist; do not rerun setup against them

-- section 1: create database
-- day2 - CourseHub university management
create database CourseHubDB;

-- section 2: tables and data
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

-- section 3: queries
use CourseHubDB;


-- Stage 4.1: inner join, students and departments.
select FullName,GPA,DepartmentName
from dbo.Students inner join dbo.Departments
on dbo.Students.DepartmentID=dbo.Departments.DepartmentID;
-- Stage 4.2: left join includes the empty Business department.
select DepartmentName,FullName
from dbo.Departments left join dbo.Students
on dbo.Departments.DepartmentID=dbo.Students.DepartmentID;
-- Stage 4.3: one-to-one.
select FullName,Address,EmergencyPhone
from dbo.Students inner join dbo.StudentProfiles
on dbo.Students.StudentID=dbo.StudentProfiles.StudentID;
-- Stage 4.4: many-to-many.
select FullName,CourseName,EnrollmentDate
from dbo.Students inner join dbo.StudentCourses
on dbo.Students.StudentID=dbo.StudentCourses.StudentID
inner join dbo.Courses on dbo.StudentCourses.CourseID=dbo.Courses.CourseID;

-- Stage 5.1: output labels without as aliases.
select count(*) TotalStudents,avg(GPA) AverageGPA,max(GPA) HighestGPA,min(GPA) LowestGPA
from dbo.Students;
-- Stage 5.2.
select DepartmentID,avg(GPA) AverageGPA,count(*) TotalStudents
from dbo.Students group by DepartmentID;
-- Stage 5.3.
select DepartmentID,avg(GPA) AverageGPA
from dbo.Students group by DepartmentID having avg(GPA)>3.00;
-- Stage 5.4.
select DepartmentID,count(*) TotalStudents
from dbo.Students where GPA>=2.50
group by DepartmentID having count(*)>1;

-- Stage 6.1: StudentID is clustered by its primary key by default.
select sys.indexes.name,sys.indexes.type_desc,sys.columns.name
from sys.indexes inner join sys.index_columns
on sys.indexes.object_id=sys.index_columns.object_id and sys.indexes.index_id=sys.index_columns.index_id
inner join sys.columns
on sys.columns.object_id=sys.index_columns.object_id and sys.columns.column_id=sys.index_columns.column_id
where sys.indexes.object_id=object_id('dbo.Students') and sys.indexes.type=1;

-- Stage 7.1: above overall average.
select * from dbo.Students where GPA>(select avg(GPA) from dbo.Students);

-- section 4: view
-- Stage 7.2: as is required syntax for create view.
create view dbo.vw_StudentAcademicDetails
as
select StudentID,FullName,GPA,DepartmentName
from dbo.Students inner join dbo.Departments
on dbo.Students.DepartmentID=dbo.Departments.DepartmentID;

-- section 5: procedure
-- Stage 7.3: as is required syntax for this procedure body.
create procedure dbo.sp_GetStudentsByDepartment @DeptID int
as
begin
 select * from dbo.Students where DepartmentID=@DeptID;
end;
