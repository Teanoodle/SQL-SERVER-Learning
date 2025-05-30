use DBTEST
-- Database structure setup:
create table Student
(
    StuId int primary key identity(1,2), -- Auto-increment (increments by 2)
    StuName varchar(20),
    StuSex varchar(4)
)
-- Sample data insertion (Chinese names with gender)
insert into Student(StuName,StuSex) values('John','M')
insert into Student(StuName,StuSex) values('Mary','F')
insert into Student(StuName,StuSex) values('Mike','M')
insert into Student(StuName,StuSex) values('Sarah','F')
insert into Student(StuName,StuSex) values('David','M')
insert into Student(StuName,StuSex) values('Lisa','F')
insert into Student(StuName,StuSex) values('Robert','M')
insert into Student(StuName,StuSex) values('Emily','F')
insert into Student(StuName,StuSex) values('Michael','M')
insert into Student(StuName,StuSex) values('Jennifer','F')
insert into Student(StuName,StuSex) values('William','M')
insert into Student(StuName,StuSex) values('Jessica','F')
insert into Student(StuName,StuSex) values('Richard','M')
insert into Student(StuName,StuSex) values('Amanda','F')
insert into Student(StuName,StuSex) values('Joseph','M')
insert into Student(StuName,StuSex) values('Elizabeth','F')
insert into Student(StuName,StuSex) values('Thomas','M')
insert into Student(StuName,StuSex) values('Megan','F')
insert into Student(StuName,StuSex) values('Charles','M')
insert into Student(StuName,StuSex) values('Ashley','F')
insert into Student(StuName,StuSex) values('Daniel','M')
insert into Student(StuName,StuSex) values('Nicole','F')
insert into Student(StuName,StuSex) values('Matthew','M')
insert into Student(StuName,StuSex) values('Samantha','F')
insert into Student(StuName,StuSex) values('Christopher','M')
insert into Student(StuName,StuSex) values('Lauren','F')
insert into Student(StuName,StuSex) values('Andrew','M')
insert into Student(StuName,StuSex) values('Rachel','F')
insert into Student(StuName,StuSex) values('James','M')
insert into Student(StuName,StuSex) values('Olivia','F')
select * from Student

-- Pagination methods
-- Assume 5 records per page

-- Method 1: TOP-NOT IN pattern (basic but less efficient for large datasets)
-- Page 1
select top 5 * from Student
where StuId not in(select top 0 StuId from Student)
-- Page 2
select top 5 * from Student
where StuId not in(select top 5 StuId from Student)
-- Page 3
select top 5 * from Student
where StuId not in(select top 10 StuId from Student)

-- General formula:
-- select PageSize * from Student
-- where StuId not in(select top PageSize*(CurrentPage-1) StuId from Student)

-- Parameterized version (just change @PageIndex for different pages)
declare @PageSize int = 5
declare @PageIndex int = 1
select top (@PageSize) * from Student
where StuId not in(select top (@PageSize*(@PageIndex-1)) StuId from Student)

-- Method 2: ROW_NUMBER() (more efficient for large datasets)
-- General formula:
-- select * from
-- (select ROW_NUMBER() over (order by StuId) RowId, * from Student) Temp
-- where
-- RowId between (CurrentPage-1)*PageSize+1 and CurrentPage*PageSize

-- Parameterized version (just change @PageIndex for different pages)
declare @PageSize int = 5
declare @PageIndex int = 1
select * from
(select ROW_NUMBER() over (order by StuId) RowId, * from Student) Temp
where
RowId between (@PageIndex -1)*@PageSize+1 and @PageIndex*@PageSize
