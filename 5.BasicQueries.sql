-- Query all data from tables
select * from Department
select * from [Rank]
select * from People

-- Query specific columns (name, gender, birthdate, salary, phone)
select PeopleName, PeopleSex, PeopleBirth, PeopleSalary, PeoplePhone from People
-- Query specific columns with Chinese aliases
select PeopleName as Name, PeopleSex as Gender, PeopleBirth as Birthdate, 
PeopleSalary as Salary, PeoplePhone as Phone from People
-- Query distinct employee addresses (remove duplicates)
select distinct PeopleAddress from People
-- Calculate 20% salary increase and compare with original salary
select PeopleName, PeopleSex, PeopleSalary, PeopleSalary*1.2 as IncreasedSalary from People
