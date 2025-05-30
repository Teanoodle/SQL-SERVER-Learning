# Multi-Table Queries

## I. Cartesian Product

```
select * from People,Department
```

This query combines all records from People table with all records from Department table. For example, if People table has 10 records and Department table has 3 records, the result will have 10*3=30 records.

## II. Simple Multi-Table Queries

Records that don't satisfy primary-foreign key relationships won't be displayed.

**Query employee information with department names**

```
select * from People,Department where People.DepartmentId = Department.DepartmentId 
```

**Query employee information with rank names**

```
select * from People,Rank where People.RankId = Rank.RankId
```

**Query employee information with department names and rank names**

```
select * from People,Department,Rank
where People.DepartmentId = Department.DepartmentId and People.RankId = Rank.RankId
```

## III. Inner Join

Records that don't satisfy primary-foreign key relationships won't be displayed.

**Query employee information with department names**

```
select * from People inner join Department on People.DepartmentId = Department.DepartmentId 
```

**Query employee information with rank names**

```
select * from People inner join Rank on People.RankId = Rank.RankId
```

**Query employee information with department names and rank names**

```
select * from People 
inner join Department on People.DepartmentId = Department.DepartmentId 
inner join Rank on People.RankId = Rank.RankId
```

## IV. Outer Joins

Outer joins include left outer join, right outer join and full outer join.

Left outer join: Displays all data from left table, replaces unmatched data with null.

**Examples of left outer join:**

**Query employee information with department names**

```
select * from People left join Department on People.DepartmentId = Department.DepartmentId 
```

**Query employee information with rank names**

```
select * from People left join Rank on People.RankId = Rank.RankId
```

**Query employee information with department names and rank names**

```
select * from People 
left join Department on People.DepartmentId = Department.DepartmentId 
left join Rank on People.RankId = Rank.RankId
```

Right outer join (right join): Similar to left join, A left join B == B right join A

Full outer join (full join): Displays all data from both tables, replaces unmatched data with null.

## V. Comprehensive Examples

(1) Query all employee information in Wuhan, showing department names and employee details

```
select PeopleName Name,People.DepartmentId DepartmentId,DepartmentName DepartmentName,
PeopleSex Gender,PeopleBirth Birthday,
PeopleSalary Salary,PeoplePhone Phone,PeopleAddress Region
from People left join DEPARTMENT on Department.DepartmentId = People.DepartmentId
where PeopleAddress = 'Wuhan'
```

(2) Query all employee information in Wuhan, showing department names, rank names and employee details

```
select PeopleName Name,DepartmentName DepartmentName,RankName RankName,
PeopleSex Gender,PeopleBirth Birthday,
PeopleSalary Salary,PeoplePhone Phone,PeopleAddress Region
from People left join DEPARTMENT on Department.DepartmentId = People.DepartmentId
left join [Rank] on [Rank].RankId = People.RankId
where PeopleAddress = 'Wuhan'
```

(3) Group by department to count employees, calculate total salary, average salary, max salary and min salary

```
select DepartmentName DepartmentName,COUNT(*) EmployeeCount,SUM(PeopleSalary) TotalSalary,
AVG(PeopleSalary) AvgSalary,MAX(PeopleSalary) MaxSalary,MIN(PeopleSalary) MinSalary 
from People left join DEPARTMENT on Department.DepartmentId = People.DepartmentId
group by Department.DepartmentId,DepartmentName
```

(4) Group by department to count employees, calculate total salary, average salary, max salary and min salary, excluding departments with average salary < 10000, ordered by average salary descending

```
select DepartmentName DepartmentName,COUNT(*) EmployeeCount,SUM(PeopleSalary) TotalSalary,
AVG(PeopleSalary) AvgSalary,MAX(PeopleSalary) MaxSalary,MIN(PeopleSalary) MinSalary 
from People left join DEPARTMENT on Department.DepartmentId = People.DepartmentId
group by Department.DepartmentId,DepartmentName
having AVG(PeopleSalary) >= 10000
order by AVG(PeopleSalary) desc
```

(5) Group by department name and rank name to count employees, calculate total salary, average salary, max salary and min salary

```
select DepartmentName DepartmentName,RANKNAME RankName,COUNT(*) EmployeeCount,SUM(PeopleSalary) TotalSalary,
AVG(PeopleSalary) AvgSalary,MAX(PeopleSalary) MaxSalary,MIN(PeopleSalary) MinSalary 
from People 
LEFT JOIN DEPARTMENT on Department.DepartmentId = People.DepartmentId
LEFT JOIN [Rank] on [Rank].RANKID = People.RANKID
group by Department.DepartmentId,DepartmentName,[Rank].RANKID,RANKNAME
```

## VI. Self Join

Self join: Joining a table to itself.

Example table structure and data:

```
create table Dept
(
	DeptId int primary key,  --Department ID
	DeptName varchar(50) not null, --Department name
	ParentId int not null,  --Parent department ID
)
insert into Dept(DeptId,DeptName,ParentId)
values(1,'Software Department',0)
insert into Dept(DeptId,DeptName,ParentId)
values(2,'Hardware Department',0)

insert into Dept(DeptId,DeptName,ParentId)
values(3,'Software R&D',1)
insert into Dept(DeptId,DeptName,ParentId)
values(4,'Software Testing',1)
insert into Dept(DeptId,DeptName,ParentId)
values(5,'Software Implementation',1)

insert into Dept(DeptId,DeptName,ParentId)
values(6,'Hardware R&D',2)
insert into Dept(DeptId,DeptName,ParentId)
values(7,'Hardware Testing',2)
insert into Dept(DeptId,DeptName,ParentId)
values(8,'Hardware Implementation',2)
```

Query all departments with their parent departments:

```
--Department ID  Department Name  Parent Department
-- 3            Software R&D      Software Department
-- 4            Software Testing  Software Department
-- 5            Software Implementation Software Department
-- 6            Hardware R&D      Hardware Department
-- 7            Hardware Testing   Hardware Department
-- 8            Hardware Implementation Hardware Department

select A.DeptId DepartmentID,A.DeptName DepartmentName,B.DeptName ParentDepartment from Dept A 
inner join Dept B on A.ParentId = B.DeptId
```
