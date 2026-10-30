create database CourseHubDB;

use CourseHubDB;



create table dbo.TempInstructors
(TempID int, TempName varchar(50), JoinedDate date);

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

create nonclustered index IX_Students_Email on dbo.Students(Email);

use CourseHubDB;


select FullName,GPA,DepartmentName
from dbo.Students inner join dbo.Departments
on dbo.Students.DepartmentID=dbo.Departments.DepartmentID;
select DepartmentName,FullName
from dbo.Departments left join dbo.Students
on dbo.Departments.DepartmentID=dbo.Students.DepartmentID;
select FullName,Address,EmergencyPhone
from dbo.Students inner join dbo.StudentProfiles
on dbo.Students.StudentID=dbo.StudentProfiles.StudentID;
select FullName,CourseName,EnrollmentDate
from dbo.Students inner join dbo.StudentCourses
on dbo.Students.StudentID=dbo.StudentCourses.StudentID
inner join dbo.Courses on dbo.StudentCourses.CourseID=dbo.Courses.CourseID;

select count(*) TotalStudents,avg(GPA) AverageGPA,max(GPA) HighestGPA,min(GPA) LowestGPA
from dbo.Students;
select DepartmentID,avg(GPA) AverageGPA,count(*) TotalStudents
from dbo.Students group by DepartmentID;
select DepartmentID,avg(GPA) AverageGPA
from dbo.Students group by DepartmentID having avg(GPA)>3.00;
select DepartmentID,count(*) TotalStudents
from dbo.Students where GPA>=2.50
group by DepartmentID having count(*)>1;

select sys.indexes.name,sys.indexes.type_desc,sys.columns.name
from sys.indexes inner join sys.index_columns
on sys.indexes.object_id=sys.index_columns.object_id and sys.indexes.index_id=sys.index_columns.index_id
inner join sys.columns
on sys.columns.object_id=sys.index_columns.object_id and sys.columns.column_id=sys.index_columns.column_id
where sys.indexes.object_id=object_id('dbo.Students') and sys.indexes.type=1;

select * from dbo.Students where GPA>(select avg(GPA) from dbo.Students);

create view dbo.vw_StudentAcademicDetails
as
select StudentID,FullName,GPA,DepartmentName
from dbo.Students inner join dbo.Departments
on dbo.Students.DepartmentID=dbo.Departments.DepartmentID;

create procedure dbo.sp_GetStudentsByDepartment @DeptID int
as
begin
 select * from dbo.Students where DepartmentID=@DeptID;
end;
