# Conditional Queries

**Common SQL Operators**

```
= : Equal to (comparison and assignment)
!= : Not equal to
> : Greater than
< : Less than
>= : Greater than or equal to
<= : Less than or equal to
IS NULL : Is null
IS NOT NULL : Is not null
in : Is in a set
like : Pattern matching
BETWEEN...AND... : Between two values
and : Logical AND (both conditions must be true)
or : Logical OR (either condition must be true)
not : Logical NOT (negates the condition)
```

**Query Examples:**

(1) Query female employees with specified columns (Name, Gender, Monthly Salary, Phone) and custom English column names

```
SELECT PeopleName Name,PeopleSex Gender,PeopleSalary Salary,PeoplePhone Phone from People
WHERE PEOPLESEX = 'Female'
```

(2) Query employees with monthly salary >= 10000 (single condition)

```
select * from People where PeopleSalary >= 10000 
```

(3) Query female employees with monthly salary >= 10000 (multiple conditions)

```
select * from People where PeopleSalary >= 10000 and PeopleSex = 'Female'
```

(4) Query female employees born after 1980-1-1 with monthly salary >= 10000

```
select * from People where PeopleBirth >= '1980-1-1' and PeopleSalary >= 10000 and PeopleSex = 'Female'
```

(5) Query employees with salary >= 15000 OR female employees with salary >= 8000

```
select * from People where PeopleSalary >= 15000 or (PeopleSalary >= 8000 and PeoPleSex = 'Female')
```

(6) Query employees with salary between 10000-20000 (multiple conditions)

```
--Option 1:
select * from People where PeopleSalary >= 10000 and PeopleSalary <= 20000
--Option 2:
select * from People where PeopleSalary between 10000 and 20000
```

(7) Query employees from Beijing or Shanghai

```
--Option 1:
select * from People where PeopleAddress = 'Beijing' or PeopleAddress = 'Shanghai'
--Option 2:
select * from People where PeopleAddress in('Beijing','Shanghai')
```

(8) Query all employees ordered by salary (descending)

```
--order by: sorting  asc: ascending  desc: descending
select * from People order by PeopleSalary desc
```

(9) Query all employees ordered by name length (descending)

```
select * from People order by len(PeopleName) desc
```

(10) Query top 5 highest paid employees

```
select top 5 * from People order by PeopleSalary desc
```

(11) Query top 10% highest paid employees

```
select top 10 percent * from People order by PeopleSalary desc
```

(12) Query employees with empty address field

```
select * from People where PeopleAddress is null
```

(13) Query employees with non-empty address field

```
select * from People where PeopleAddress is not null
```

(14) Query all employees born in the 1980s (80后)

```
--Option 1:
select * from People where PeopleBirth >= '1980-1-1' and PeopleBirth <= '1989-12-31'
--Option 2:
select * from People where PeopleBirth between '1980-1-1' and '1989-12-31'
--Option 3:
select * from People where year(PeopleBirth) >= 1980 and year(PeopleBirth) <= 1989
```

(15) Query employees aged 30-40 with salary between 15000-30000

```
--Option 1:
select * from People where
(year(getdate())-year(PeopleBirth) >= 30 and year(getdate())-year(PeopleBirth) <= 40) and
(PeopleSalary >= 15000 and PeopleSalary <= 30000)
--Option 2:
select * from People where
(year(getdate())-year(PeopleBirth) between 30 and 40)
and PeopleSalary between 15000 and 30000
```

(16) Query employees born during Cancer period (6.22--7.22)

```
select * from People where 
(month(PeopleBirth) = 6 and DAY(PeopleBirth) >= 22) or
(month(PeopleBirth) = 7 and DAY(PeopleBirth) <= 22)
```

(17) Query employees with higher salary than Zhao Yun

```
select * from People where PeopleSalary > 
(select PeopleSalary from People where PEOPLENAME = 'Zhao Yun')
```

(18) Query employees from the same city as Zhao Yun

```
select * from People where PEOPLEADDRESS = 
(select PEOPLEADDRESS from People where PEOPLENAME = 'Zhao Yun')
```

(19) Query employees born in Year of the Rat

```
select * from People where year(PeopleBirth) % 12 = 4
```

(20) Query all employees with an additional column showing Chinese zodiac sign

```
--Option 1:
select PeopleName Name,PeopleSex Gender,PeopleSalary Salary,PeoplePhone Phone,PEOPLEBIRTH Birthday,
case
	when year(PeopleBirth) % 12 = 4 then 'Rat'
	when year(PeopleBirth) % 12 = 5 then 'Ox'
	when year(PeopleBirth) % 12 = 6 then 'Tiger'
	when year(PeopleBirth) % 12 = 7 then 'Rabbit'
	when year(PeopleBirth) % 12 = 8 then 'Dragon'
	when year(PeopleBirth) % 12 = 9 then 'Snake'
	when year(PeopleBirth) % 12 = 10 then 'Horse'
	when year(PeopleBirth) % 12 = 11 then 'Goat'
	when year(PeopleBirth) % 12 = 0 then 'Monkey'
	when year(PeopleBirth) % 12 = 1 then 'Rooster'
	when year(PeopleBirth) % 12 = 2 then 'Dog'
	when year(PeopleBirth) % 12 = 3 then 'Pig'
	ELSE ''
end Zodiac
from People

--Option 2:
select PeopleName Name,PeopleSex Gender,PeopleSalary Salary,PeoplePhone Phone,PEOPLEBIRTH Birthday,
case year(PeopleBirth) % 12
	when 4 then 'Rat'
	when 5 then 'Ox'
	when 6 then 'Tiger'
	when 7 then 'Rabbit'
	when 8 then 'Dragon'
	when 9 then 'Snake'
	when 10 then 'Horse'
	when 11 then 'Goat'
	when 0 then 'Monkey'
	when 1 then 'Rooster'
	when 2 then 'Dog'
	when 3 then 'Pig'
	ELSE ''
end Zodiac
from People
```
