CREATE DATABASE CollegeDB;
GO

USE CollegeDB;
GO

-- Create Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    email VARCHAR(50),
    major VARCHAR(50),
    enrollment_year INT
);

-- Create Courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    credit_hours INT,
    department VARCHAR(50)
);

-- Create StudentCourses table for enrollment
CREATE TABLE StudentCourses (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    semester VARCHAR(20),
    grade CHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Insert sample data
INSERT INTO Students VALUES 
(1, 'John Doe', 'john@example.com', 'Computer Science', 2020),
(2, 'Jane Smith', 'jane@example.com', 'Mathematics', 2021),
(3, 'Mike Johnson', 'mike@example.com', 'Physics', 2020);

INSERT INTO Courses VALUES
(101, 'Database Systems', 3, 'CS'),
(102, 'Calculus II', 4, 'MATH'),
(103, 'Quantum Physics', 4, 'PHYSICS');

INSERT INTO StudentCourses VALUES
(1, 1, 101, 'Fall 2023', 'A'),
(2, 1, 102, 'Spring 2024', 'B'),
(3, 2, 102, 'Fall 2023', 'A'),
(4, 3, 103, 'Spring 2024', 'B+');

Select * FROM Students, Courses,StudentCourses;

UPDATE Students
    SET email= 'John_doe_university.edu'
    Where student_id = 1;

-- Simple view 
CREATE VIEW CS_Sudents AS
SELECT student_id,student_name,email
FROM Students
Where major = 'Computer Science';

Select * FROM CS_Sudents;

-- Complex View ( FRom mutiple Table with Joins)
Create VIEW dbo.StudentEnrollments AS
SELECT s.student_name,c.course_name,sc.semester,sc.grade
FROM dbo.Students s
Inner JOIN dbo.StudentCourses sc on s.student_id = sc.student_id
Inner JOIN dbo.Courses c on sc.course_id = c.course_id;

Select * FROM dbo.StudentEnrollments;

--Join and Inner join thery are exactly same, So inner is used for clarity 
--  Query and modify View 
Select TOP 100 * FROM dbo.CS_Sudents;
Select top 3 * FROM dbo.StudentEnrollments;

SELECT * FROM dbo.StudentEnrollments Where grade='A';

-- Updating data through a view 
BEGIN TRansaction;
    UPDATE dbo.CS_Sudents
    SET email= 'John_doe_university.edu'
    Where student_id = 1;

-- verifying the update operation 
SELECT  * FROM dbo.CS_Sudents Where student_id = 1;
ROLLBACK TRANSACTION -- Undoing the changes
-- IRCTC servers, Instead of doing every small chnages in in my main sysytem, we have views that works as dataset
-- where we can make local changes and later on when they are permanenet they are updated in the MAIN DB
-- Limitation with views :( V.IMP)

-- Attempting to update a complex view Using error handling 
BEGIN TRY
    BEGIN TRANSACTION;
        UPDATE dbo.StudentEnrollments
        SET Grade = 'A+'
        WHERE student_name ='John Doe' AND course_name = 'Database Systems';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'ERROR occured...!!' + ERROR_MESSAGE();
END CATCH;

-- Altering a view( MSSQL  uses CREATE or ALTER in newer version)
-- For older version, we need to DROP and CREATE 

IF EXISTS (SELECT * FROM sys.views WHERE name= 'CS_Sudents' AND schema_ID = SCHEMA_ID('dbo'))
    DROP VIEW dbo.CS_Sudents;
-- Simple view 
IF EXISTS (SELECT * FROM sys.views 
           WHERE name = 'CS_Sudents' AND schema_id = SCHEMA_ID('dbo'))
    DROP VIEW dbo.CS_Sudents;
GO  -- Ends the first batch

-- Now create the new view
CREATE VIEW dbo.CS_Students_New AS

SELECT student_id, student_name, email, enrollment_year
FROM dbo.Students
WHERE major = 'Computer Science';


Select * FROM dbo.CS_Students_New;

-- View Metadata in MS SQL 
-- Get view defination 
 SELECT OBJECT_DEFINITION(OBJECT_ID('dbo.CS_Students_New')) AS ViewDefinition;

 -- List all view in the database 

 SELECT name AS ViewName, create_Date, modify_date 
 FROM sys.views
 WHERE is_ms_shipped = 0
 ORDER BY name;