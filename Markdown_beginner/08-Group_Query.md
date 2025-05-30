# Group Queries

(1) Group employees by region and count employees, calculate total salary, average salary, max salary and min salary

```
--Option 1: Using union (requires knowing all regions in advance)
select 'Wuhan' Region,COUNT(*) Count,MAX(PeopleSalary) MaxSalary,MIN(PeopleSalary) MinSalary
,SUM(PeopleSalary) TotalSalary,AVG(PeopleSalary) AvgSalary from People
 where PeopleAddress = 'Wuhan' union
select 'Beijing' Region,COUNT(*) Count,MAX(PeopleSalary) MaxSalary,MIN(PeopleSalary) MinSalary
,SUM(PeopleSalary) TotalSalary,AVG(PeopleSalary) AvgSalary from People
 where PeopleAddress = 'Beijing'
 --...Other regions
 --...Other regions
 
--Option 2: Using Group by
select PeopleAddress Region,COUNT(*) EmployeeCount,SUM(PeopleSalary) TotalSalary,
AVG(PeopleSalary) AvgSalary,MAX(PeopleSalary) MaxSalary,MIN(PeopleSalary) MinSalary 
from People group by PeopleAddress
```

(2) Group employees by region and count employees, calculate total salary, average salary, max salary and min salary, excluding employees born in or after 1985

```
select PeopleAddress Region,COUNT(*) EmployeeCount,SUM(PeopleSalary) TotalSalary,
AVG(PeopleSalary) AvgSalary,MAX(PeopleSalary) MaxSalary,MIN(PeopleSalary) MinSalary 
from People
where PeopleBirth < '1985-1-1'
group by PeopleAddress
```

(3) Group employees by region and count employees, calculate total salary, average salary, max salary and min salary, filtering for regions with at least 2 employees, excluding employees born in or after 1985

```
select PeopleAddress Region,COUNT(*) EmployeeCount,SUM(PeopleSalary) TotalSalary,
AVG(PeopleSalary) AvgSalary,MAX(PeopleSalary) MaxSalary,MIN(PeopleSalary) MinSalary 
from People 
where PeopleBirth < '1985-1-1'
group by PeopleAddress
having COUNT(*) >= 2
```
