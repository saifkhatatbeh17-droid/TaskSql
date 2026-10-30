-- Stage 7.2: as is required syntax for create view.
create view dbo.vw_StudentAcademicDetails
as
select StudentID,FullName,GPA,DepartmentName
from dbo.Students inner join dbo.Departments
on dbo.Students.DepartmentID=dbo.Departments.DepartmentID;
