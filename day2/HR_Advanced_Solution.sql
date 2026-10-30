-- HR Advanced - Day 2
-- database: TechWorldHRDB
-- all task code in one file, without GO
-- select and execute each numbered section separately, in order
-- do not execute the entire file at once
-- the databases already exist; do not rerun setup against them

-- section 1: create database
-- run this file first, once
create database TechWorldHRDB;

-- section 2: tables and data
use TechWorldHRDB;

-- base tables from task 1
create table departments (
    departmentid int primary key,
    departmentname varchar(50) not null unique
);

create table employees (
    employeeid int primary key,
    fullname varchar(100) not null,
    email varchar(100) unique,
    salary decimal(10,2),
    departmentid int,
    phonenumber varchar(20),
    foreign key (departmentid) references departments(departmentid)
);

insert into departments (departmentid, departmentname)
values (1, 'IT'), (2, 'HR'), (3, 'Finance');

-- remaining employees after task 1
insert into employees
(employeeid, fullname, email, salary, departmentid, phonenumber)
values
(1, 'Ahmad Ali', 'ahmad@techworld.com', 1350.00, 1, '0791111111'),
(2, 'Sara Hassan', 'sara@techworld.com', 950.00, 2, '0792222222'),
(3, 'Zaid Omar', 'zaid@techworld.com', 1500.00, 1, '0793333333');

-- task 5.1
create table accesscards (
    cardid int primary key,
    cardnumber varchar(50) not null unique,
    employeeid int not null unique,
    foreign key (employeeid) references employees(employeeid)
);

-- task 5.2
create table projects (
    projectid int primary key,
    projectname varchar(100) not null
);

create table employeeprojects (
    employeeid int,
    projectid int,
    assigneddate date,
    primary key (employeeid, projectid),
    foreign key (employeeid) references employees(employeeid),
    foreign key (projectid) references projects(projectid)
);

-- task 5.3
-- sample badge numbers and assignment dates
insert into accesscards (cardid, cardnumber, employeeid)
values (101, 'TW-101', 1),
       (102, 'TW-102', 2),
       (103, 'TW-103', 3);

insert into projects (projectid, projectname)
values (1, 'AI & Security Training'),
       (2, 'Cloud Migration');

insert into employeeprojects (employeeid, projectid, assigneddate)
values (1, 1, '2026-10-30'),
       (1, 2, '2026-10-30'),
       (2, 1, '2026-10-30'),
       (3, 2, '2026-10-30');

-- task 7.6 audit table
create table employeeaudit (
    auditid int primary key identity(1,1),
    employeeid int,
    action varchar(50),
    actiondate datetime
);

-- section 3: view
-- task 7.4
-- run separately in TechWorldHRDB
create view vw_EmployeeDetails
as
select employees.employeeid, employees.fullname,
       employees.email, departments.departmentname
from employees
inner join departments
on employees.departmentid = departments.departmentid;

-- section 4: procedure
-- task 7.5
-- run separately in TechWorldHRDB
create procedure sp_GetEmployeesByDepartment
    @deptid int
as
begin
    select * from employees
    where departmentid = @deptid;
end;

-- section 5: trigger
-- task 7.6
-- run separately in TechWorldHRDB
create trigger tr_EmployeeDelete
on employees
after delete
as
begin
    insert into employeeaudit (employeeid, action, actiondate)
    select employeeid, 'DELETE', getdate()
    from deleted;
end;

-- section 6: queries and checks
use TechWorldHRDB;

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
