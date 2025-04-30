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

--shows table from 10 to 50
Select * From DIMEmployee where BaseRate > 10 and BaseRate < 50;
--the index has been created for columb BaseRate (ASC -increase)
create index IX_tblEmployee_BaseRate
ON DIMEmployee (BaseRate ASC)

--shows table from 50 to 70  - works
Select * From DIMEmployee where BaseRate > 50 and BaseRate < 70;


--cklasteeritud ja mitte klasteeritud indeksid
--loome tabeli
create table tblEmployee (
Id int Primary Key,
Name nvarchar (50),
Salary int,
Gender nvarchar (10),
City nvarchar(50));

Insert into tblEmployee Values(3, 'John', 4500, 'Male', 'New York');
Insert into tblEmployee Values(1, 'Sam', 4500, 'Male', 'London');
Insert into tblEmployee Values(4, 'JSara', 5500, 'Female', 'Tokyo');

Select * FROM tblEmployee;

-- et luua klasteeritud indeksi on vaja kasturada PK index
--parem klisk tabeli paele - index ja rename ---kopeerimine index nimi
-- näitab index pärast execute sp_helpindex tblEmployee;
-- PK__tblEmplo__3214EC07D9745E45  nimu
--kustutame autamaatselt loodud index
DROP CLUSTERED INDEX PK__tblEmplo__3214EC07D9745E45
-- näitab loodud index
execute sp_helpindex tblEmployee;
Alter table tblEmployee add primary key (Id);
drop index tblEmployee.PK__tblEmplo__3214EC07D9745E45;