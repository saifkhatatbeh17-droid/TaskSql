-- Safe to run repeatedly: read-only results for the completed task.
USE CourseHubDB;
GO
SELECT * FROM dbo.Departments;
SELECT * FROM dbo.Students;
SELECT * FROM dbo.StudentProfiles;
SELECT * FROM dbo.Courses;
SELECT * FROM dbo.StudentCourses;
SELECT * FROM dbo.vw_StudentAcademicDetails;
EXEC dbo.sp_GetStudentsByDepartment @DeptID=1;
GO
