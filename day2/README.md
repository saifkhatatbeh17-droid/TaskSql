# SQL Day 2 Tasks

This folder contains two separate assignments.

| Assignment | Folder | Database |
| --- | --- | --- |
| Master TaskCourseHub Big Task | CourseHub | CourseHubDB |
| SQL Task HR Advanced System | HR_Advanced | TechWorldHRDB |

Run the SQL files inside each task folder in numerical order, one file at a time. Run creation and insertion files once on a fresh database. Select the correct database in SSMS before running a view, procedure, or trigger file. These object definitions require separate batches, so the files do not use GO.

Both assignments use code for database and table creation as requested. CourseHub includes the update and deletion of Tariq and the removal of TempInstructors required by its assignment.

The HR assignment continues the first HR task. Its setup includes the three remaining employees and Ahmad's updated salary. Badge numbers TW-101 to TW-103 and assignment date 2026-10-30 are sample values where the document does not specify values.

The HR access-card foreign key and unique constraint allow at most one card per employee. Each sample employee is assigned one card. A future employee does not receive a card automatically.

The HR trigger records successfully deleted employee IDs. Employees referenced by an access card or project assignment cannot be deleted until those references are removed. No cascading deletion is configured.