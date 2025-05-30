select * from People
-- Query female employees
select * from People where PeopleSex = 'Female'
-- Query employees with salary >= 10000
select * from People where PeopleSalary >= 10000
-- Query female employees with salary >= 10000
select * from People where PeopleSex = 'Female' and PeopleSalary >= 10000
-- Query female employees born after 1990-1-1 with salary >= 10000
select * from People where PeopleBirth >= '1990-1-1' and 
(PeopleSalary >= 10000 and PeopleSex = 'Female')
-- Query employees with salary >= 15000 OR female employees with salary >= 8000
select * from People where PeopleSalary >= 15000 or 
(PeopleSalary >= 8000 and PeopleSex = 'Female')
-- Query employees with salary between 10000-20000 (inclusive)
select * from People where PeopleSalary >= 10000 and PeopleSalary <= 20000
select * from People where PeopleSalary between 10000 and 20000
-- Query employees from Wuhan or Beijing
select * from People where PeopleAddress ='Wuhan' or PeopleAddress = 'Beijing'
select * from People where PeopleAddress in('Wuhan','Beijing')

-- Sorting
-- Query employee info sorted by salary descending
-- asc ascending (default), desc descending
select * from People order by PeopleSalary desc
-- Query employee info sorted by name length descending
select * from People order by len(PeopleName) desc
-- Query top 5 highest paid employees
select top 5 * from People order by PeopleSalary desc
-- Query top 10% highest paid employees
select top 10 percent * from People order by PeopleSalary desc

-- null: empty value
insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(1,1,'Test','Male','1997-7-7',50000,'1385858585',null,GETDATE())
-- Empty string
insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(2,3,'Test2','Male','1945-10-7',43000,'1385890585','',GETDATE())

-- Query employees with empty address
select * from People where PeopleAddress is null
select * from People where PeopleAddress = ''
-- Query employees with non-empty address
select * from People where PeopleAddress is not null

-- Query employees born in the 1980s
select * from People where PeopleBirth >= '1980-1-1' and 
PeopleBirth <= '1989-12-31'
select * from People where PeopleBirth between '1980-1-1' and '1989-12-31'
select * from People where year(PeopleBirth) between 1980 and 1989
-- Query employees aged 30-40 with salary 15000-30000
-- Age = current year - birth year
select * from People where 
(year(getdate()) - year(PeopleBirth) >= 30 and 
year(getdate()) - year(PeopleBirth) <= 40) 
and
(PeopleSalary >= 15000 and PeopleSalary <= 30000)

select * from People where 
(year(getdate()) - year(PeopleBirth) between 30 and 40) 
and
(PeopleSalary between 15000 and 30000)

-- Query employees born during Cancer zodiac period (June 22-July 22)
select * from People where
(month(PeopleBirth)=6 and day(PeopleBirth) >= 22)
or
(month(PeopleBirth)=7 and day(PeopleBirth) <= 22)

-- Query employees with higher salary than 'John' (subquery)
select * from People where PeopleSalary > 
(select PeopleSalary from People where PeopleName = 'John')

-- Query employees living in same city as 'John'
select * from People where PeopleAddress = 
((select PeopleAddress from People where PeopleName = 'John'))

-- Query employees born in Year of the Rat
-- Rat, Ox, Tiger, Rabbit, Dragon, Snake, Horse, Goat, Monkey, Rooster, Dog, Pig
-- %: modulo
-- 4  5   6  7  8  9 10 11  0   1 2   3
select * from People where year(PeopleBirth) % 12 = 4

-- Query all employees with zodiac sign column
select *,
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
    else ''
end as Zodiac
from People

-- Simplified version
select *,
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
    else ''
end as Zodiac
from People
