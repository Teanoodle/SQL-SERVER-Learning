--count: count rows
--max: maximum value
--min: minimum value
--sum: summation
--avg: average value

select * from People
--1. Count total employees
select count(*) as TotalCount from People
--2. Get maximum salary
select max(PeopleSalary) as MaxSalary from People
--3. Get minimum salary
select min(PeopleSalary) as MinSalary from People
--4. Sum all salaries
select sum(PeopleSalary) as TotalSalary from People

--5. Calculate average salary
select avg(PeopleSalary) as AvgSalary from People
select round(avg(PeopleSalary),2) as AvgSalary from People
--ROUND function usage:
--round(num,len,[type])
--Parameters:
--num: number to round
--len: precision length
--type: optional (0 or default for rounding, non-zero for truncation)
select ROUND(123.45454,3)  --123.45500
select ROUND(123.45454,3,1) --123.45400

--6. Display count, max, min, sum and avg in one query
select count(*) as TotalCount,max(PeopleSalary) as MaxSalary,min(PeopleSalary) as MinSalary,
sum(PeopleSalary) as TotalSalary, avg(PeopleSalary) as AvgSalary
from People

--7. Query statistics for employees in Wuhan
select count(*) as TotalCount,max(PeopleSalary) as MaxSalary,min(PeopleSalary) as MinSalary,
sum(PeopleSalary) as TotalSalary, avg(PeopleSalary) as AvgSalary
from People
where PeopleAddress = 'Wuhan'

--8. Query employees with salary higher than average
select * from People where PeopleSalary >
(select round(avg(PeopleSalary),2) as AvgSalary from People)

--9. Calculate age statistics (max, min, sum, avg)
--Method 1
select *,year(getdate())-year(PeopleBirth) as Age from People 

select COUNT(*) as TotalCount,
max(year(getdate()) -year(PeopleBirth)) as MaxAge,
min(year(getdate()) -year(PeopleBirth)) as MinAge,
sum(year(getdate()) -year(PeopleBirth)) as TotalAge,
avg(year(getdate()) -year(PeopleBirth)) as AvgAge
from People

--Method 2
select DATEDIFF(year, '1991-1-1','1993-3-3')
select COUNT(*) as TotalCount,
max(DATEDIFF(year, PeopleBirth,getdate())) as MaxAge,
min(DATEDIFF(year, PeopleBirth,getdate())) as MinAge,
sum(DATEDIFF(year, PeopleBirth,getdate())) as TotalAge,
avg(DATEDIFF(year, PeopleBirth,getdate())) as AvgAge
from People

--10. Statistics for male employees with salary >=10000
select 'Salary>=10000' as SalaryRange, 'Male' as Gender,
COUNT(*) as TotalCount,
max(year(getdate()) -year(PeopleBirth)) as MaxAge,
min(year(getdate()) -year(PeopleBirth)) as MinAge,
sum(year(getdate()) -year(PeopleBirth)) as TotalAge,
avg(year(getdate()) -year(PeopleBirth)) as AvgAge
from People
where PeopleSalary >= 10000 and PeopleSex = 'Male'

--11. Statistics for female employees in Wuhan or Shanghai
select 'Wuhan/Shanghai Female' as Category,
COUNT(*) as TotalCount,
max(year(getdate()) -year(PeopleBirth)) as MaxAge,
min(year(getdate()) -year(PeopleBirth)) as MinAge,
sum(year(getdate()) -year(PeopleBirth)) as TotalAge,
avg(year(getdate()) -year(PeopleBirth)) as AvgAge
from People
where PeopleAddress in('Wuhan','Shanghai') and PeopleSex = 'Female'

--12. Query employees older than average age
select * from People where DATEDIFF(year, PeopleBirth,getdate()) >
(select avg(DATEDIFF(year, PeopleBirth,getdate())) as AvgAge from People)
