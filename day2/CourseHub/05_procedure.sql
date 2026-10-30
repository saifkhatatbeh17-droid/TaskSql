-- Stage 7.3: as is required syntax for this procedure body.
create procedure dbo.sp_GetStudentsByDepartment @DeptID int
as
begin
 select * from dbo.Students where DepartmentID=@DeptID;
end;
