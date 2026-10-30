-- task 7.4
-- run separately in TechWorldHRDB
create view vw_EmployeeDetails
as
select employees.employeeid, employees.fullname,
       employees.email, departments.departmentname
from employees
inner join departments
on employees.departmentid = departments.departmentid;
