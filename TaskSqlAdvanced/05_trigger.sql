-- task 7.6
-- run separately in techworldhradvanceddb
create trigger tr_EmployeeDelete
on employees
after delete
as
begin
    insert into employeeaudit (employeeid, action, actiondate)
    select employeeid, 'DELETE', getdate()
    from deleted;
end;
