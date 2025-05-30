# Aggregate Functions

Main aggregate functions in SQL SERVER:

```
count: Count
max: Maximum
min: Minimum 
sum: Sum
avg: Average
```

## I. Examples of Aggregate Functions

(1) Count total number of employees

```
select COUNT(*) Count from People
```

(2) Find maximum salary

```
select MAX(PeopleSalary) MaxSalary from People
```

(3) Find minimum salary

```
select MIN(PeopleSalary) MinSalary from People
```

(4) Calculate total salary of all employees

```
select SUM(PeopleSalary) TotalSalary from People
```

(5) Calculate average salary

```
--Option 1:
select AVG(PeopleSalary) AvgSalary from People
--Option 2: Round to 2 decimal places
select ROUND(AVG(PeopleSalary),2) AvgSalary from People
--Option 3: Round to 2 decimal places
select Convert(decimal(12,2),AVG(PeopleSalary)) AvgSalary from People
```

ROUND function usage:

```
round(num,len,[type])
Where:
num is the number to process, len is the number of decimal places, type is processing type (0 is default for rounding, non-zero for truncation)
select ROUND(123.45454,3)  --123.45500
select ROUND(123.45454,3,1) --123.45400
```

(6) Display count, max, min, sum and avg in one row

```
select COUNT(*) Count,MAX(PeopleSalary) MaxSalary,MIN(PeopleSalary) MinSalary,SUM(PeopleSalary) TotalSalary,AVG(PeopleSalary) AvgSalary from People
```

(7) Query employee count, total salary, max salary, min salary and avg salary in Wuhan

```
select 'Wuhan' Region,COUNT(*) Count,MAX(PeopleSalary) MaxSalary,MIN(PeopleSalary) MinSalary
,SUM(PeopleSalary) TotalSalary,AVG(PeopleSalary) AvgSalary from People 
WHERE PEOPLEADDRESS = 'Wuhan'
```

(8) Query employees with salary higher than average

```
select * from People where PeopleSalary > (select AVG(PeopleSalary) AvgSalary from People)
```

(9) Display count, max age, min age, total age and avg age in one row

```
--Option 1:
select COUNT(*) Count,
MAX(year(getdate())-year(PeopleBirth)) MaxAge,
MIN(year(getdate())-year(PeopleBirth)) MinAge,
SUM(year(getdate())-year(PeopleBirth)) TotalAge,
AVG(year(getdate())-year(PeopleBirth)) AvgAge 
from People
--Option 2:
select COUNT(*) Count,
MAX(DATEDIFF(year, PeopleBirth, getDate())) MaxAge,
MIN(DATEDIFF(year, PeopleBirth, getDate())) MinAge,
SUM(DATEDIFF(year, PeopleBirth, getDate())) TotalAge,
AVG(DATEDIFF(year, PeopleBirth, getDate())) AvgAge 
from People
```

(10) Calculate max age, min age and avg age for male employees with salary > 10000

```
--Option 1:
select 'Male' Gender,COUNT(*) Count,
MAX(year(getdate())-year(PeopleBirth)) MaxAge,
MIN(year(getdate())-year(PeopleBirth)) MinAge,
SUM(year(getdate())-year(PeopleBirth)) TotalAge,
AVG(year(getdate())-year(PeopleBirth)) AvgAge 
from People where PeopleSex = 'Male' and PeopleSalary >= 10000
--Option 2:
select 'Male' Gender,COUNT(*) Count,
MAX(DATEDIFF(year, PeopleBirth, getDate())) MaxAge,
MIN(DATEDIFF(year, PeopleBirth, getDate())) MinAge,
SUM(DATEDIFF(year, PeopleBirth, getDate())) TotalAge,
AVG(DATEDIFF(year, PeopleBirth, getDate())) AvgAge 
from People where PeopleSex = 'Male' and PeopleSalary >= 10000
```

(11) Count female employees in Wuhan or Shanghai and calculate max age, min age and avg age

```
--Option 1:
select 'Wuhan or Shanghai' Region,'Female' Gender,COUNT(*) Count,
MAX(year(getdate())-year(PeopleBirth)) MaxAge,
MIN(year(getdate())-year(PeopleBirth)) MinAge,
SUM(year(getdate())-year(PeopleBirth)) TotalAge,
AVG(year(getdate())-year(PeopleBirth)) AvgAge  
from People where PeopleSex = 'Female' and PeopleAddress in('Wuhan','Shanghai')
--Option 2:
select 'Wuhan or Shanghai' Region,'Female' Gender,COUNT(*) Count,
MAX(DATEDIFF(year, PeopleBirth, getDate())) MaxAge,
MIN(DATEDIFF(year, PeopleBirth, getDate())) MinAge,
SUM(DATEDIFF(year, PeopleBirth, getDate())) TotalAge,
AVG(DATEDIFF(year, PeopleBirth, getDate())) AvgAge  
from People where PeopleSex = 'Female' and PeopleAddress in('Wuhan','Shanghai')
```

(12) Query employees older than average age

```
--Option 1:
select * from People where 
year(getdate())-year(PeopleBirth) > 
(select AVG(year(getdate())-year(PeopleBirth)) 
from People)
--Option 2:
select * from People where 
DATEDIFF(year, PeopleBirth, getDate()) > 
(select AVG(DATEDIFF(year, PeopleBirth, getDate())) 
from People)
```

## II. Common Date Functions in SQL

GETDATE() Returns current date and time

DATEPART() Returns specified part of a date

DATEADD() Adds or subtracts time interval from a date

DATEDIFF() Returns difference between two dates

DATENAME() Returns specified part of a date as integer

CONVERT() Returns date in different formats

**Examples:**

```
select DATEDIFF(day, '2019-08-20', getDate());    --Get difference in specified time unit
SELECT DATEADD(MINUTE,-5,GETDATE())               --Add/subtract time, here getting time 5 minutes ago
select DATENAME(month, getDate());                --Current month name
select DATENAME(WEEKDAY, getDate());              --Current day of week
select DATEPART(month, getDate());               --Current month number
select DAY(getDate());                           --Current day of month
select MONTH(getDate());                         --Current month number
select YEAR(getDate());                          --Current year number

SELECT CONVERT(VARCHAR(22),GETDATE(),20)         --2020-01-09 14:46:46
SELECT CONVERT(VARCHAR(24),GETDATE(),21)         --2020-01-09 14:46:55.91
SELECT CONVERT(VARCHAR(22),GETDATE(),23)         --2020-01-09
SELECT CONVERT(VARCHAR(22),GETDATE(),24)         --15:04:07
Select CONVERT(varchar(20),GETDATE(),14)         --15:05:49:330
```

**Date format control strings:**

| Name         | Date Unit    | Abbreviation |
| ------------ | ----------- | --------- |
| Year         | year        | yyyy or yy |
| Quarter      | quarter     | qq,q      |
| Month        | month       | mm,m      |
| Day of year  | dayofyear   | dy,y      |
| Day          | day         | dd,d      |
| Week of year | week        | wk,ww     |
| Weekday      | weekday     | dw        |
| Hour         | Hour        | hh        |
| Minute       | minute      | mi,n      |
| Second       | second      | ss,s      |
| Millisecond  | millisecond | ms        |
