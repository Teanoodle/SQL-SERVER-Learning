-- Insert department data (explicit column names)
insert into Department(DepartmentName, DepartmentRemark)
values('Marketing','......')
insert into Department(DepartmentName, DepartmentRemark)
values('Finance','......')
insert into Department(DepartmentName, DepartmentRemark)
values('HR','......')

-- Implicit column insertion (risky as it depends on column order)
insert into Department values('Hardware', '......')
insert into Department values('CEO Office', '......')

-- Batch insert using UNION
insert into Department(DepartmentName, DepartmentRemark)
select 'Testing','......' union
select 'Implementation','......' union
select 'Product','......'

-- Insert position ranks -------------------------
insert into [Rank](RankName, RankRemark)
values('Junior','.....')
insert into [Rank](RankName, RankRemark)
values('Intermediate','.....') 
insert into [Rank](RankName, RankRemark)
values('Senior','.....')

-- Insert employee data -------------------------
insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(9,1,'John','Male','1988-8-8',10000,'1388888888','China',getdate())

-- Additional rank inserts
insert into [Rank](RankName,RankRemark)
values('Junior','Basic programming skills required')
insert into [Rank](RankName,RankRemark)
values('Intermediate','Advanced programming skills required')
insert into [Rank](RankName,RankRemark)
values('Senior','Ability to design complete systems required')
