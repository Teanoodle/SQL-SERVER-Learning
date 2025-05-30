select * from Department
select * from People
-- Cartesian product
select * from People,Department
-- This query combines each record from Department with each record from People


-- Simple multi-table query
-- Query employee info with department info (matching DepartmentId)
select * from People,Department 
where People.DepartmentId = Department.DepartmentId
-- Query employee info with rank info
select * from [Rank]
select * from People
select * from People,[Rank]
where People.RankId = [Rank].RankId
-- Query employee info with both department and rank info
select * from People,Department,[Rank]
where People.DepartmentId = Department.DepartmentId
and
People.RankId = [Rank].RankId


-- JOIN query
-- Query employee info with department info
select * from People 
inner join Department on People.DepartmentId = Department.DepartmentId
-- Query employee info with rank info
select * from People 
inner join [Rank] on People.RankId = [Rank].RankId
-- Query employee info with both department and rank info
select * from People 
inner join Department on People.DepartmentId = Department.DepartmentId
inner join [Rank] on People.RankId = [Rank].RankId


-- Common limitation of simple multi-table and JOIN queries:
-- Records without matching relationships won't be displayed
insert into People([DepartmentId],[RankId],[PeopleName],[PeopleSex],[PeopleBirth],
[PeopleSalary],[PeoplePhone],[PeopleAddress],[PeopleAddTime])
values(99,99,'Test','Male','1975-8-9',8000,'13556857548','Test',getdate())
-- Test employee has invalid DepartmentId


select * from Department
select * from People
-- Outer join (includes all records from one or both tables)
select * from People
insert into Department([DepartmentName],[DepartmentRemark])
values('HR','......')

-- Outer join shows all records from one table, with NULL for non-matches
-- Query employee info with department info (all employees)
select * from People
left join Department on People.DepartmentId = Department.DepartmentId
select * from Department
left join People on People.DepartmentId = Department.DepartmentId
-- Query employee info with rank info (all employees)
select * from People 
left join [Rank] on People.RankId = [Rank].RankId
-- Query employee info with both department and rank info (all employees)
select * from People 
left join Department on People.DepartmentId = Department.DepartmentId
left join [Rank] on People.RankId = [Rank].RankId

-- Note: A left join B = B right join A
-- These two queries are equivalent
select * from People
left join Department on People.DepartmentId = Department.DepartmentId

select * from Department
right join People on People.DepartmentId = Department.DepartmentId

-- Full outer join: shows all records from both tables
select * from People
full join Department on People.DepartmentId = Department.DepartmentId
