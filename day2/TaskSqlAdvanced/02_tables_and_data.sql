use techworldhradvanceddb;

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
