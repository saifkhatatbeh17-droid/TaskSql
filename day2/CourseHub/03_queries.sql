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
