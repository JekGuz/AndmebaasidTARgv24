CREATE FUNCTION  fn_ILTVF_GetEmployees()
RETURNS TABLE
as
RETURN (SELECT EmployeeKey, FirstName, CAST(BirthDate as Date) as DOB
FROM dbo.DimEmployee);

SELECT * FROM fn_ILTVF_GetEmployees();


CREATE FUNCTION fn_MSTVF_GetEmployees()
RETURNS @Table Table(
EmployeeKey int, 
FistName nvarchar(20),
DOB date)
as
Begin 
INSERT into @Table
SELECT EmployeeKey, FirstName, Cast(BirthDate as Date) as DOB
FROM dbo.DimEmployee
RETURN
END

SELECT * FROM fn_MSTVF_GetEmployees();

-- uuendame nimi kus EmployeeKey = 1 funktsiooni kaudu 
UPDATE fn_ILTVF_GetEmployees() set FirstName = 'test' Where EmployeeKey = 1;

-- Muudame funktiooni lisame inkriptioni, et ei saa sisu vaadara
ALTER FUNCTION fn_GetEmployeeNameById(@Id int)
RETURNS nvarchar (20)
WITH Encryption
as
Begin
RETURN (SELECT FirstName from DimEmployee WHERE EmployeeKey = @Id)
END

SELECT *FROM fn_GetEmployeeNameById(1);

SP_HELPTEXT fn_GetEmployeeNameById

Create Table #PersonDetails(Id int, Name nvarchar(20))
INSERT INTO #PersonDetails values (1, 'John');
INSERT INTO #PersonDetails values (2, 'Johanna');
INSERT INTO #PersonDetails values (3, 'James');
INSERT INTO #PersonDetails values (4, 'Mike');

SELECT * FROM #PersonDetails;

SELECT name from tempdb..sysobjects
where name like '#PersonDetails%';

CREATE PROCEDURE spCreateLocalTempTable
AS
BEGIN
    CREATE TABLE #PersonDetails (
        Id INT,
        Name NVARCHAR(20)
    )

    INSERT INTO #PersonDetails VALUES (1, 'Mike')
    INSERT INTO #PersonDetails VALUES (2, 'John')
    INSERT INTO #PersonDetails VALUES (3, 'Todd')

    SELECT * FROM #PersonDetails;
END

-- glovaalne ajatine table
Create Table ##EmployeeDetails(Id int, Name nvarchar(20))

-- index
Select * from DIMEmployee where BaseRate > 10 and BaseRate < 50;


DROP TABLE tblEmployee;

CREATE TABLE tblEmployee (
    Id int PRIMARY KEY,
    FirstName nvarchar(50),
    LastName nvarchar(50),
    Salary int,
    Gender nvarchar(50),
    City nvarchar(50)
);

EXECUTE sp_helpindex tblEmployee;

INSERT INTO tblEmployee VALUES(1, 'Mike', 'Sandoz', 4500, 'Male', 'NY');
INSERT INTO tblEmployee VALUES(2, 'Mike2', 'Sandoz2', 2500, 'Female', 'NY2');
INSERT INTO tblEmployee VALUES(3, 'Mike3', 'Sandoz3', 6500, 'Female', 'NY3');
INSERT INTO tblEmployee VALUES(4, 'Mike4', 'Sandoz4', 5500, 'Male', 'NY4');

-- Удаляем индекс вручную

Create Unique NonClustered Index UIX_tblEmployee_FirstName_LastName -- не допускаются дубликаты 
On tblEmployee(FirstName, LastName)

ALTER TABLE tblEmployee
ADD CONSTRAINT UQ_tblEmployee_City
UNIQUE NONCLUSTERED (City)

DELETE FROM tblEmployee

CREATE UNIQUE INDEX IX_tblEmployee_City -- Игнорирует дубликаты
ON tblEmployee(City)
WITH IGNORE_DUP_KEY

CREATE TABLE tblEmployee (
    Id INT PRIMARY KEY,
    Name NVARCHAR(30),
    Salary INT,
    Gender NVARCHAR(10),
    DepartmentId INT
);

CREATE TABLE tblDepartment (
    DeptId INT PRIMARY KEY,
    DeptName NVARCHAR(20)
);
INSERT INTO tblDepartment VALUES (1, 'IT');
INSERT INTO tblDepartment VALUES (2, 'Payroll');
INSERT INTO tblDepartment VALUES (3, 'HR');
INSERT INTO tblDepartment VALUES (4, 'Admin');

INSERT INTO tblEmployee VALUES (1, 'John', 3);
INSERT INTO tblEmployee VALUES (2, 'Mike', 2);
INSERT INTO tblEmployee VALUES (3, 'Pam', 1);
INSERT INTO tblEmployee VALUES (4, 'Todd',  4);
INSERT INTO tblEmployee VALUES (5, 'Sara',  1);
INSERT INTO tblEmployee VALUES (6, 'Ben',  3);

SELECT Id, Name, Salary, Gender, DeptName
FROM tblEmployee
JOIN tblDepartment
ON tblEmployee.DepartmentId = tblDepartment.DeptId;

CREATE VIEW vwEmployeesByDepartment
AS
SELECT Id, Name, Salary, Gender, DeptName
FROM tblEmployee
JOIN tblDepartment
ON tblEmployee.DepartmentId = tblDepartment.DeptId;

-- ищим по IT
CREATE VIEW vwITDepartment_Employees
AS
SELECT Id, Name, Salary, Gender, DeptName
FROM tblEmployee
JOIN tblDepartment
ON tblEmployee.DepartmentId = tblDepartment.DeptId
WHERE tblDepartment.DeptName = 'IT';

CREATE VIEW vwEmployeesNonConfidentialData
AS
SELECT Id, Name, Gender, DeptName
FROM tblEmployee
JOIN tblDepartment
ON tblEmployee.DepartmentId = tblDepartment.DeptId;

-- считаем
CREATE VIEW vwEmployeesCountByDepartment
AS
SELECT DeptName, COUNT(Id) AS TotalEmployees
FROM tblEmployee
JOIN tblDepartment
ON tblEmployee.DepartmentId = tblDepartment.DeptId
GROUP BY DeptName;

--SELECT

SELECT * FROM vwEmployeesByDepartment;
SELECT * FROM vwITDepartment_Employees;
SELECT * FROM vwEmployeesNonConfidentialData;
SELECT * FROM vwEmployeesCountByDepartment;

-- VIEW

CREATE VIEW vWEmployeesDataExceptSalary
AS
SELECT Id, Name, Gender, DepartmentId
FROM tblEmployee

select * from vWEmployeesDataExceptSalary
select * from tblEmployee

-- muutub nimi id jargi view kaudu
-- muutused 
update vWEmployeesDataExceptSalary
set name = 'Mikey' where Id = 2

delete from vWEmployeesDataExceptSalary where Id=2
insert into vWEmployeesDataExceptSalary values (2, 'Mikey', 'Male', 2)

CREATE VIEW vWEmployeeDetailsByDepartment
AS
SELECT Id, Name, Salary, Gender, DeptName
FROM tblEmployee
JOIN tblDepartment
ON tblEmployee.DepartmentId = tblDepartment.DeptId;

SELECT * FROM vWEmployeeDetailsByDepartment;


--dept tabelis uursdus view kaudu
update vWEmployeesDetailsByDepartment
set DeptName = 'IT' where Name ='John'

select * from tblEmployee
select * from tblDepartment

-- 

-- CREATE TRIGGER

CREATE TRIGGER trMyFirstTrigger
ON Database
FOR CREATE_TABLE
AS 
BEGIN
Print 'New table created'
END;

-- сообщить что сделали
ALTER TRIGGER trMyFirstTrigger
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
    PRINT 'A table has just been created, modified or deleted';
END;

-- не даст сделать с таблицами что то
ALTER TRIGGER trMyFirstTrigger
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
	Rollback
    PRINT 'You cannot create, aler or drop table';
END;

--выкл триггер
DISABLE TRIGGER trMyFirstTrigger on Database;

-- вкл триггер
Enable trigger trMyFirstTrigger on Database;

-- делает rename - переминовать одну таблицу в другую таблицу
CREATE TRIGGER trRenameTable
ON DATABASE
FOR RENAME
AS
BEGIN
	Print 'Youjust renamed something'
END;
-- table test
CREATE TABLE test (Id int);
-- переменовываем test в newtest
sp_rename 'test', 'newtest';

SELECT * FROM NEWTEST;
-- menjaem nazvania colonki
sp_rename 'newtast.Id', 'NewId', 'column';


--
CREATE TRIGGER tr_DatabeseScoreTrigger
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
	Rollback
    PRINT 'You cannot create, aler or drop table';
END;

-- на весь сервер сделан триггер
CREATE TRIGGER tr_ServerScropeTrigger
ON ALL Server
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
	Rollback
    PRINT 'You cannot create, aler or drop table';
END;

DROP TRIGGER tr_ServerScropeTrigger;
DISABLE TRIGGER tr_DatabeseScoreTrigger ON DATABASE;

CREATE table test (id int)
SELECT * FROM test;