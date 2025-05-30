-- Insert department data
insert into Department(DepartmentName,DepartmentRemark)
values('Finance','......')
insert into Department(DepartmentName,DepartmentRemark)
values('Hardware','......')
insert into Department(DepartmentName,DepartmentRemark)
values('Marketing','......')

-- Insert position ranks
insert into [Rank](RankName,RankRemark)
values('Junior','Basic programming skills required')
insert into [Rank](RankName,RankRemark)
values('Intermediate','Advanced programming skills required')
insert into [Rank](RankName,RankRemark)
values('Senior','Ability to design complete systems required')

-- Insert employee data
insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(1,3,'John','Male','1984-7-9',20000,'13554785452','Chengdu',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(1,2,'Mary','Female','1987-7-9',15000,'13256854578','Beijing',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(1,1,'Mike','Male','1988-8-8',12000,'13985745871','Shanghai',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(2,1,'Zhang','Male','1990-8-8',8000,'13535987412','Yichang',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(2,3,'Li','Male','1989-4-8',9000,'13845789568','Yichang',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(3,3,'Wang','Male','1995-4-8',9500,'13878562568','Chongqing',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(3,2,'Zhao','Male','1989-4-20',8500,'13335457412','Wuhan',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(3,1,'Qian','Female','1989-4-20',6500,'13437100050','Wuhan',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(2,2,'Sun','Male','1987-12-20',25000,'13889562354','Guangzhou',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(2,3,'Zhou','Male','1981-11-11',9000,'13385299632','Shenzhen',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(2,1,'Wu','Male','1978-1-13',8000,'13478545263','Shanghai',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(1,1,'Zheng','Male','1998-12-12',7500,'13878523695','Hangzhou',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(1,3,'Feng','Male','1968-11-22',9000,'13698545841','Nanjing',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(3,3,'Chen','Male','1988-1-22',11000,'13558745874','Tianjin',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(3,2,'Wei','Male','1990-2-21',12000,'13698745214','Suzhou',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(3,2,'Jiang','Female','1995-2-21',13000,'13985478512','Shanghai',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(2,1,'Xiao','Female','1996-2-21',13500,'13778787874','Guangzhou',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(1,2,'Dong','Male','1992-10-11',8000,'13987455214','Wuhan',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(2,3,'Lu','Male','1984-9-10',5500,'13254785965','Chengdu',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(3,3,'Jin','Male','1987-5-19',8500,'13352197364','Chengdu',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(1,1,'Lu','Male','1996-5-19',7500,'13025457392','Nanjing',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(1,2,'Tai','Male','1983-6-1',7500,'13077778888','Shanghai',getdate())

-- Verify data insertion
select * from Department
select * from [Rank]
select * from People

-- Data modification
-- Syntax:
-- update table_name set column1=value1, column2=value2 where condition

-- Give everyone a 1000 salary raise
update People set PeopleSalary = PeopleSalary+1000

-- Give employee with ID 7 a 500 raise
update People set PeopleSalary = PeopleSalary+500 where PeopleId=7

-- Set all department 1 employees with salary <10000 to 10000
update People set PeopleSalary = 10000 where DepartmentId=1 and PeopleSalary<10000

-- Modify multiple columns:
-- Double salary and change address to 'Beijing' for employee with ID 1
update People set PeopleSalary = PeopleSalary*2, PeopleAddress = 'Beijing'
where PeopleId = 1

-- Data deletion
-- Syntax:
-- delete from table_name where condition

-- Delete all employees from department 3 with salary >10000
delete from People where DepartmentId=3 and PeopleSalary>10000

-- Comparison of deletion methods (drop, truncate, delete)
-- drop table People  -- Completely removes table structure and data
-- delete removes data but keeps table structure
-- truncate table People -- Faster deletion but keeps table structure

-- Differences between truncate and delete:
-- truncate removes all data unconditionally, delete can use WHERE clause
-- Auto-increment IDs:
-- After truncate, new records start from 1
-- After delete, new records continue from last ID
