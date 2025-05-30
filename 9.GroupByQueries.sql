select * from People
-- Basic statistics of all employees
select count(*) as EmployeeCount, sum(PeopleSalary) as TotalSalary, avg(PeopleSalary) as AvgSalary,
max(PeopleSalary) as MaxSalary, min(PeopleSalary) as MinSalary
from People

--1. Statistics by city (using UNION)
select 'Wuhan' as City, count(*) as EmployeeCount, sum(PeopleSalary) as TotalSalary, avg(PeopleSalary) as AvgSalary,
max(PeopleSalary) as MaxSalary, min(PeopleSalary) as MinSalary
from People
where PeopleAddress = 'Wuhan'
union
select 'Beijing' as City, count(*) as EmployeeCount, sum(PeopleSalary) as TotalSalary, avg(PeopleSalary) as AvgSalary,
max(PeopleSalary) as MaxSalary, min(PeopleSalary) as MinSalary
from People
where PeopleAddress = 'Beijing'

-- Better approach: using GROUP BY
select PeopleAddress as City, count(*) as EmployeeCount, sum(PeopleSalary) as TotalSalary, avg(PeopleSalary) as AvgSalary,
max(PeopleSalary) as MaxSalary, min(PeopleSalary) as MinSalary
from People
group by PeopleAddress

--2. Statistics by city for employees born before 1985
select PeopleAddress as City, count(*) as EmployeeCount, sum(PeopleSalary) as TotalSalary, avg(PeopleSalary) as AvgSalary,
max(PeopleSalary) as MaxSalary, min(PeopleSalary) as MinSalary
from People
where PeopleBirth <'1985-1-1'
group by PeopleAddress

--3. Statistics by city for employees born before 1985, 
-- filtering groups with at least 2 employees
select PeopleAddress as City, count(*) as EmployeeCount, sum(PeopleSalary) as TotalSalary, avg(PeopleSalary) as AvgSalary,
max(PeopleSalary) as MaxSalary, min(PeopleSalary) as MinSalary
from People
where PeopleBirth <'1985-1-1' -- WHERE filters rows before grouping
group by PeopleAddress
having count(*) >= 2          -- HAVING filters groups after grouping
