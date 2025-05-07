-- AWDFunktsioonid 
--Пример кода встроенной табличнозначной функции (ILTVF)
CREATE FUNCTION  fn_ILTVF_GetEmployees()
RETURNS TABLE
as
RETURN (SELECT EmployeeKey, FirstName, CAST(BirthDate as Date) as DOB
FROM dbo.DimEmployee);

SELECT * FROM fn_ILTVF_GetEmployees();

--Функции с табличным значением, состоящие из нескольких выражений e 
--многовыраженная табличная функция (MSTVF)
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


-- мы обновляем имя, где РаботникКей = 1, через функцию
UPDATE fn_ILTVF_GetEmployees() set FirstName = 'test' Where EmployeeKey = 1;

--Масштабируемая функция без шифрования
CREATE FUNCTION fn_GetEmployeeNameById(@Id int)
RETURNS nvarchar (20)
as
BEGIN
RETURN(SELECT FirstName from dbo.DimEmployee WHERE EmployeeKey = @Id)
End;

-- Мы изменим функцию и добавим шифрование, чтобы содержимое нельзя было просмотреть.
ALTER FUNCTION fn_GetEmployeeNameById(@Id int)
RETURNS nvarchar (20)
WITH Encryption
as
Begin
RETURN (SELECT FirstName from DimEmployee WHERE EmployeeKey = @Id)
END;

SELECT *FROM fn_GetEmployeeNameById(1);
SP_HELPTEXT fn_GetEmployeeNameById;

--Измените функцию и используйте опцию команды FOR SCHEMABINDING.
ALTER FUNCTION fn_GetEmployeeNameById(@Id int)
RETURNS nvarchar (20)
With SchemaBinding
as
BEGIN
RETURN(SELECT FirstName from dbo.DimEmployee WHERE EmployeeKey = @Id)
End;
------------------------------------------------------------------------

-- AjutisedTabelid

Create Table #PersonDetails(Id int, Name nvarchar(20))
INSERT INTO #PersonDetails values (1, 'John');
INSERT INTO #PersonDetails values (2, 'Johanna');
INSERT INTO #PersonDetails values (3, 'James');
INSERT INTO #PersonDetails values (4, 'Mike');

SELECT * FROM #PersonDetails;

SELECT name from tempdb..sysobjects
where name like '#PersonDetails%';

DROP TABLE #PersonDetails

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

----------------------------------------------------------------------------
-- index

Select * from DIMEmployee where BaseRate > 10 and BaseRate < 50;

-- klasteeritud ja mitte klasteeritud indexid
-- loome tabeli
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

SELECT * FROM tblEmployee

-- et luua klasteeritud indeksi on vaja kustutada PK index
-- parem klick tabeli peale-index ja rename ---kopeerime index nimi
-- PK__tblEmplo__3214EC07890056FE

-- kustutame automaatselt loodud index
ALTER TABLE tblEmployee 
DROP CONSTRAINT PK__tblEmplo__3214EC07890056FE;

DROP INDEX tblEmployee.PK__tblEmplo__3214EC07890056FE;

-- näitab loodud index
execute sp_helpindex tblEmployee;

ALTER TABLE tblEmployee 
ADD primary key(Id);


-- tühistame index grafiline liides ja teeme klasteeritud indexi
Create Clustered Index IX_tblEmployee_Name
ON tblEmployee(Name)


-- ALTER TABLE tblEmployee DROP CONSTRAINT
-- loome uue klastreeritud ühendindeksi loomiseks Gender ja Salary veeru põhjal
CREATE CLUSTERED INDEX IX_tblEmployee_Gender_Salary
ON tblEmployee(Gender DESC, Salary ASC)

Insert into tblEmployee Values(4, 'Kate', 4500, 'Female', 'Tokyo')
SELECT * FROM tblEmployee;

-- loome mitte-klasteeritud index
CREATE NONCLUSTERED INDEX IX_tblEmployee_Name
ON tblEmployee(Name)

-- 1. Ainult üks klastreeritud indeks tabeli peale, samas saab olla rohkem, kui mitte-klastreeritud indeks
-- 2. Klastreeritud indeks on kiirem, kui mitte-klastreeritud indeks kuna mitte-klastreeritud indeks peab tagasi viitama tabelile. Seda juhul, kui selekteeritud veerg ei ole olemas indeksis.
-- 3. Klastreeritud indeks määratleb ära tabeliridade salvestusjärjestuse ja ei nõua kettal lisaruumi. Samas mitte-klastreeritud on salvestatud tabelist eraldi ja on vaja lisaruumi.
-- На таблице может быть только один кластеризованный индекс, в то время как количество некластеризованных индексов может быть больше одного.
-- Кластеризованный индекс быстрее, чем некластеризованный, потому что некластеризованный индекс должен ссылаться на таблицу, если выбранный столбец отсутствует в индексе.
-- Кластеризованный индекс определяет порядок хранения строк таблицы и не требует дополнительного пространства на диске. В то время как некластеризованный индекс хранится отдельно от таблицы и требует дополнительного пространства.


-- Unikaalne ja mitte-unikaalne Index
DROP TABLE tblEmployee;

Create table tblEmployee(
Id int Primary key,
FirstName nvarchar (50),
LastName nvarchar (50),
Salary int,
Gender nvarchar(10),
City nvarchar(50));

INSERT INTO tblEmployee VALUES (1, 'Mike', 'Sandoz', 4500, 'Male', 'New York')
INSERT INTO tblEmployee VALUES (2, 'John', 'Menco', 2500, 'Male', 'London')
INSERT INTO tblEmployee VALUES (3, 'Maria', 'Smolina', 3500, 'Female', 'Tokyo')

SELECT * FROM tblEmployee

EXECUTE sp_helpindex tblEmployee;

-- tühistame index grafiline liides
-- DROP INDEX tblEmployee.PK__tblEmplo__3214EC070417C97C

-- loome unikaalset mitte-klastreeritud indeksit FirstName ja LastName veeru põhjal
Create Unique NonClustered Index UIX_tblEmployee_FirstName_LastName
On tblEmployee(FirstName, LastName)

-- lisame koodiga unikaalse piirangu City veerule
ALTER TABLE tblEmployee -- Ei saa kasutada dubleeritud andmeid City veerus
ADD CONSTRAINT UQ_tblEmployee_City 
UNIQUE NONCLUSTERED (City)

INSERT INTO tblEmployee VALUES (4, 'Maria1', 'Smolina1', 3500, 'Female', 'Tokyo')

DELETE FROM tblEmployee 

-- loome unikaalset indeksit, mis lubab dubleeritud andmeid
CREATE UNIQUE INDEX IX_tblEmployee_City
ON tblEmployee(City)
WITH IGNORE_DUP_KEY

-- tühistame vana tabelit
DROP TABLE tblEmployee;

-- loome uue tabeli tblEmployee
CREATE TABLE tblEmployee (
    Id INT PRIMARY KEY,
    Name NVARCHAR(30),
    DeptName INT
);

-- loome tabeli tblDepartment
CREATE TABLE tblDepartment (
    DeptId INT PRIMARY KEY,
    DeptName NVARCHAR(20)
);

-- sisetame andmed
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

-- loome VIEW
SELECT Id, Name, DeptName
FROM tblEmployee
JOIN tblDepartment
ON tblEmployee.DepartmentId = tblDepartment.DeptId;


-- vaatame andmeid läbi VIEW
SELECT * FROM vWEmployeesByDepartment

-- loome VIEW, mis tagastab ainult IT osakonna töötajad
CREATE VIEW vwITDepartment_Employees
AS
SELECT Id, Name, DeptName
FROM tblEmployee
JOIN tblDepartment
ON tblEmployee.DepartmentId = tblDepartment.DeptId
WHERE tblDepartment.DeptName = 'IT';

SELECT * FROM vWITDepartment_Employees

-- loome VIEW, kus ei ole Salary veergu
CREATE VIEW vwEmployeesNonConfidentialData
AS
SELECT Id, Name, Gender, DeptName
FROM tblEmployee
JOIN tblDepartment
ON tblEmployee.DepartmentId = tblDepartment.DeptId;

-- считаем loome VIEW, mis tagastab summeeritud andmed töötajate koondarvest
CREATE VIEW vwEmployeesCountByDepartment
AS
SELECT DeptName, COUNT(Id) AS TotalEmployees
FROM tblEmployee
JOIN tblDepartment
ON tblEmployee.DepartmentId = tblDepartment.DeptId
GROUP BY DeptName;

--SELECT ALL

SELECT * FROM vwEmployeesByDepartment;
SELECT * FROM vwITDepartment_Employees;
SELECT * FROM vwEmployeesNonConfidentialData;
SELECT * FROM vwEmployeesCountByDepartment;

-- VIEW
-- loome VIEW, mis tagastab peaaegu kõik veerud, aga va Salary veerg
CREATE VIEW vWEmployeesDataExceptSalary
AS
SELECT Id, Name, Gender, DepartmentId
FROM tblEmployee

select * from vWEmployeesDataExceptSalary
select * from tblEmployee

-- päring uuendab Name veerus olevat nime John Mikey peale VIEW kaudu
-- muutused on ka tblEmployee tabelis
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


-- dept update nimi abiga view kaudu
-- uuendab andmed tabelis Department, mitte tabelis Employee (vigane uuendus)
update vWEmployeesDetailsByDepartment
set DeptName = 'IT' where Name ='John'

select * from tblEmployee
select * from tblDepartment

-------------------------------------------------------------------

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