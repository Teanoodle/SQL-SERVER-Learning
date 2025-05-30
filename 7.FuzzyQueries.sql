select * from Department
select * from [Rank]
select * from People
-- % matches 0 or more characters
-- _ matches exactly 1 character
-- [] matches any single character within the specified range
-- [^] matches any single character not within the specified range

-- Query employees whose name starts with 'Li'
select * from People where PeopleName like 'Li%'
-- Query employees whose name contains 'Li'
select * from People where PeopleName like '%Li%'
-- Query employees whose name contains 'Li' or 'Shi'
select * from People where PeopleName like '%Li%' or PeopleName like '%Shi%'

-- Query employees with 2-character names starting with 'Li'
select * from People where PeopleName like 'Li_'
-- Using SUBSTRING function
select SUBSTRING('hello,world',2,1) -- Extract 1 character starting from position 2
select * from People where SUBSTRING(PeopleName,1,1) = 'Li'
and len(PeopleName) = 2
-- Query employees with 3-character names ending with 'an'
select * from People where PeopleName like '__an'
select * from People where SUBSTRING(PeopleName,3,3) = 'an'
and len(PeopleName) = 3

-- Query employees with phone numbers starting with '138'
select * from People where PeoplePhone like '138%'
-- Query employees with phone numbers starting with '138', 4th digit is 7 or 8, and ending with 5
select * from People where PeoplePhone like '138[7,8]%5'
-- Query employees with phone numbers starting with '138', 4th digit between 2-5, and last digit not 2 or 3
select * from People where PeoplePhone like '138[2,3,4,5]%[^2,3]'
select * from People where PeoplePhone like '138[2-5]%[^2-3]'
