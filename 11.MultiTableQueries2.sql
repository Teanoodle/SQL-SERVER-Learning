--1. Query employee information from Wuhan
--Show department name and employee details
select PeopleId as EmployeeId,DepartmentName as Department, PeopleName as EmployeeName,
PeopleSex as Gender,PeopleBirth as Birthdate,PeopleSalary as Salary,PeoplePhone as Phone,PeopleAddress as Address
from People 
left join Department on People.DepartmentId = Department.DepartmentId

--2. Query employee information from Wuhan
--Show department name, rank name and employee details
select PeopleId as EmployeeId,People.DepartmentId as DeptId, DepartmentName as Department,RankName as Rank, PeopleName as EmployeeName,
PeopleSex as Gender,PeopleBirth as Birthdate,PeopleSalary as Salary,PeoplePhone as Phone,PeopleAddress as Address
from People 
left join Department on People.DepartmentId = Department.DepartmentId
left join [Rank] on People.RankId = [Rank].RankId
where PeopleAddress = 'Wuhan'


--3. Statistics by department: employee count, total salary,
--average salary, max salary and min salary
select DepartmentName as Department, count(*) as EmployeeCount, sum(PeopleSalary) as TotalSalary,avg(PeopleSalary) as AvgSalary,
max(PeopleSalary) as MaxSalary, min(PeopleSalary) as MinSalary
from People
inner join Department on People.DepartmentId = Department.DepartmentId
group by Department.DepartmentId, DepartmentName --Group by both ID and name to avoid ambiguity

--4. Statistics by department: employee count, total salary, average salary,
--max salary and min salary, filtering departments with average salary >= 10000
--sorted by average salary descending
select DepartmentName as Department, count(*) as EmployeeCount, sum(PeopleSalary) as TotalSalary,avg(PeopleSalary) as AvgSalary,
max(PeopleSalary) as MaxSalary, min(PeopleSalary) as MinSalary
from People
inner join Department on People.DepartmentId = Department.DepartmentId
group by Department.DepartmentId, DepartmentName 
having avg(PeopleSalary) >= 10000
order by avg(PeopleSalary) desc

--5. Statistics by department and rank: employee count,
--total salary, average salary, max salary and min salary
select DepartmentName as Department, RankName as Rank, count(*) as EmployeeCount, sum(PeopleSalary) as TotalSalary,avg(PeopleSalary) as AvgSalary,
max(PeopleSalary) as MaxSalary, min(PeopleSalary) as MinSalary
from People
inner join Department on People.DepartmentId = Department.DepartmentId
inner join [Rank] on People.RankId = [Rank].RankId
group by Department.DepartmentId, DepartmentName, [Rank].RankId, [Rank].RankName

--Self join (table joining itself) for hierarchical data
create table Dept
(
	DeptId int Primary key, --Department ID
	DepName varchar(50), --Department name
	ParentId int, --Parent department ID
)
--Deptid		DeptName		ParentId
--1			Software			0 (root)
--2			Hardware			0 (root)
--3			Software R&D		1 
--4			Software Testing	1 

--Root departments
insert into Dept(DeptId, DepName, ParentId) values(1,'Software',0)
insert into Dept(DeptId, DepName, ParentId) values(2,'Hardware',0)
--Child departments
insert into Dept(DeptId, DepName, ParentId) values(3,'Software R&D',1)
insert into Dept(DeptId, DepName, ParentId) values(4,'Software Testing',1)
insert into Dept(DeptId, DepName, ParentId) values(5,'Software Implementation',1)
insert into Dept(DeptId, DepName, ParentId) values(6,'Hardware R&D',2)
insert into Dept(DeptId, DepName, ParentId) values(7,'Hardware Testing',2)
insert into Dept(DeptId, DepName, ParentId) values(8,'Hardware Implementation',2)

select * from Dept
--DepartmentID  DepartmentName		ParentDepartment
--3			Software R&D		Software
--4			Software Testing	Software
--.................................
--A: Child table B:Parent table
select A.DeptId as DepartmentID, A.DepName as DepartmentName,B.DepName as ParentDepartment from Dept A
inner join Dept B on A.ParentId = B.DeptId
