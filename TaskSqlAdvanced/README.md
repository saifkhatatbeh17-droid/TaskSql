# HR Management System Task 2

Run the six SQL files in numerical order in SSMS. Run each file separately. Files 03, 04, and 05 must use the techworldhradvanceddb database selected in the toolbar. Their CREATE statements must start their own batch; this is why the solution uses separate files without GO.

The new database is independent of the first task. Its base data represents the end of task 1: Ahmad earns 1350, Sara earns 950, and Zaid earns 1500. Finance has no employees. Badge numbers TW-101 to TW-103 and assignment dates 2026-10-30 are sample values because the assignment does not specify them.

The new task explicitly requires foreign keys, joins, a composite primary key, grouping, a subquery, a view, a procedure, and a trigger. Output aliases omit AS. AS remains in view, procedure, and trigger definitions because it is required SQL syntax there.

The access card constraints prevent a card from belonging to a nonexistent employee and prevent multiple cards for one employee. All three sample employees receive a card. These constraints alone do not force every future employee to have a card.

Expected query results:

- Task 6.1: three employees with department names.
- Task 6.2: four rows, including Finance with a NULL employee name.
- Task 6.3: three employee badges.
- Task 6.4: four project assignments.
- Task 7.1: department 1 total 2850 and count 2; department 2 total 950 and count 1.
- Task 7.2: department 1 only, with average salary 1425.
- Task 7.3: Ahmad and Zaid, since the company average is about 1266.67.
- View: three employee records.
- Procedure: department 1 returns Ahmad and Zaid; department 3 returns no rows.

The audit trigger logs every employee ID from SQL Server's deleted table when a successful employee deletion occurs, including multiple deleted rows. Existing card or project references must be removed before deleting a referenced employee. No cascading deletion is configured.

Do not run the creation or insertion scripts again against the populated database.
