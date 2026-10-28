-- hr management system
-- database techworldhrdb already exists.
-- setup and data statements have already been executed.
-- do not execute the full script again.

use techworldhrdb;

-- phase 1: temporary staff
create table temporarystaff (
    staffid int,
    staffname varchar(50),
    hiredate date
);

-- task 2.1
create table departments (
    departmentid int primary key,
    departmentname varchar(50) not null unique
);

-- task 2.2
create table employees (
    employeeid int primary key,
    fullname varchar(100) not null,
    email varchar(100) unique,
    salary decimal(10,2),
    departmentid int
);

-- task 2.3
alter table employees add phonenumber varchar(20);

-- task 3.1
insert into departments (departmentid, departmentname)
values (1, 'IT'), (2, 'HR'), (3, 'Finance');

-- task 3.2
insert into employees
(employeeid, fullname, email, salary, departmentid, phonenumber)
values
(1, 'Ahmad Ali', 'ahmad@techworld.com', 1200.00, 1, '0791111111'),
(2, 'Sara Hassan', 'sara@techworld.com', 950.00, 2, '0792222222'),
(3, 'Zaid Omar', 'zaid@techworld.com', 1500.00, 1, '0793333333'),
(4, 'Mona Khaled', 'mona@techworld.com', 800.00, 3, '0794444444');

-- task 3.3
update employees
set salary = 1350.00
where employeeid = 1;

-- task 2.4
drop table temporarystaff;

-- task 3.4
delete from employees where employeeid = 4;

-- task 4.1
select * from employees;

-- task 4.2
select fullname, salary from employees;

-- task 4.3
select sum(salary) as totalsalaries from employees;

-- task 4.4
select avg(salary) as averagesalary from employees;

-- task 4.5
select max(salary) as highestsalary,
       min(salary) as lowestsalary
from employees;

-- task 4.6
select count(*) as totalemployees from employees;
