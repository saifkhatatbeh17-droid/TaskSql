use techworldhradvanceddb;

-- task 6.1
select employees.fullname, employees.salary, departments.departmentname
from employees
inner join departments
on employees.departmentid = departments.departmentid;

-- task 6.2
select departments.departmentname, employees.fullname
from departments
left join employees
on departments.departmentid = employees.departmentid;

-- task 6.3
select employees.fullname, accesscards.cardnumber
from employees
inner join accesscards
on employees.employeeid = accesscards.employeeid;

-- task 6.4
select employees.fullname, projects.projectname, employeeprojects.assigneddate
from employees
inner join employeeprojects
on employees.employeeid = employeeprojects.employeeid
inner join projects
on employeeprojects.projectid = projects.projectid;

-- task 7.1
select departmentid, sum(salary) TotalSalary, count(*) EmployeeCount
from employees
group by departmentid;

-- task 7.2
select departmentid, avg(salary) AvgSalary
from employees
group by departmentid
having avg(salary) > 1000.00;

-- task 7.3
select * from employees
where salary > (select avg(salary) from employees);

-- check the view and procedure
select * from vw_EmployeeDetails;
exec sp_GetEmployeesByDepartment @deptid = 1;
exec sp_GetEmployeesByDepartment @deptid = 3;

-- show the new data
select * from departments;
select * from employees;
select * from accesscards;
select * from projects;
select * from employeeprojects;
select * from employeeaudit;

-- check that the trigger exists and is enabled
select name, is_disabled from sys.triggers
where name = 'tr_EmployeeDelete';
