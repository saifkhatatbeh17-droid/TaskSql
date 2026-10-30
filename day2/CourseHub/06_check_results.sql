use CourseHubDB;
select * from dbo.Departments;
select * from dbo.Students;
select * from dbo.StudentProfiles;
select * from dbo.Courses;
select * from dbo.StudentCourses;
select * from dbo.vw_StudentAcademicDetails;
exec dbo.sp_GetStudentsByDepartment @DeptID = 1;
