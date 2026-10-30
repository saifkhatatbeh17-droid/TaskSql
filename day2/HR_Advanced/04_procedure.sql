-- task 7.5
-- run separately in TechWorldHRDB
create procedure sp_GetEmployeesByDepartment
    @deptid int
as
begin
    select * from employees
    where departmentid = @deptid;
end;
