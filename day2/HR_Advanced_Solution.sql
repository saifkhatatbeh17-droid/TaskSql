create database TechWorldHRDB;

use TechWorldHRDB;

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

insert into employees
(employeeid, fullname, email, salary, departmentid, phonenumber)
values
(1, 'Ahmad Ali', 'ahmad@techworld.com', 1350.00, 1, '0791111111'),
(2, 'Sara Hassan', 'sara@techworld.com', 950.00, 2, '0792222222'),
(3, 'Zaid Omar', 'zaid@techworld.com', 1500.00, 1, '0793333333');

create table accesscards (
    cardid int primary key,
    cardnumber varchar(50) not null unique,
    employeeid int not null unique,
    foreign key (employeeid) references employees(employeeid)
);

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

create table employeeaudit (
    auditid int primary key identity(1,1),
    employeeid int,
    action varchar(50),
    actiondate datetime
);

create view vw_EmployeeDetails
as
select employees.employeeid, employees.fullname,
       employees.email, departments.departmentname
from employees
inner join departments
on employees.departmentid = departments.departmentid;

create procedure sp_GetEmployeesByDepartment
    @deptid int
as
begin
    select * from employees
    where departmentid = @deptid;
end;

create trigger tr_EmployeeDelete
on employees
after delete
as
begin
    insert into employeeaudit (employeeid, action, actiondate)
    select employeeid, 'DELETE', getdate()
    from deleted;
end;

use TechWorldHRDB;

select employees.fullname, employees.salary, departments.departmentname
from employees
inner join departments
on employees.departmentid = departments.departmentid;

select departments.departmentname, employees.fullname
from departments
left join employees
on departments.departmentid = employees.departmentid;

select employees.fullname, accesscards.cardnumber
from employees
inner join accesscards
on employees.employeeid = accesscards.employeeid;

select employees.fullname, projects.projectname, employeeprojects.assigneddate
from employees
inner join employeeprojects
on employees.employeeid = employeeprojects.employeeid
inner join projects
on employeeprojects.projectid = projects.projectid;

select departmentid, sum(salary) TotalSalary, count(*) EmployeeCount
from employees
group by departmentid;

select departmentid, avg(salary) AvgSalary
from employees
group by departmentid
having avg(salary) > 1000.00;

select * from employees
where salary > (select avg(salary) from employees);

select * from vw_EmployeeDetails;
exec sp_GetEmployeesByDepartment @deptid = 1;
exec sp_GetEmployeesByDepartment @deptid = 3;

select * from departments;
select * from employees;
select * from accesscards;
select * from projects;
select * from employeeprojects;
select * from employeeaudit;

select name, is_disabled from sys.triggers
where name = 'tr_EmployeeDelete';
