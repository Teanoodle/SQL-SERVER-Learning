# Data Insertion

## 1. Insert Data into Department Table

**Standard Syntax:**

```
insert into Department(DepartmentName,DepartmentRemark)
values('Software Department','......')
insert into Department(DepartmentName,DepartmentRemark)
values('Hardware Department','......')
insert into Department(DepartmentName,DepartmentRemark)
values('Marketing Department','......')
```

**Short Syntax (omitting column names):**

```
insert into Department values('Administration','Department handling administrative work')
```

This approach requires maintaining exact column order as in table structure. Not recommended as table structure changes may cause errors.

**Insert multiple rows in one statement:**

```
insert into Department(DepartmentName,DepartmentRemark)
select 'Marketing','Department for promotion' union
select 'Product','Creative department' union
select 'Executive','Leadership department' 
```

## 2. Insert Data into Rank Table

```
insert into [Rank](RankName,RankRemark)
values('Junior','Assisting others with tasks')
insert into [Rank](RankName,RankRemark)
values('Mid-level','Capable of independent work')
insert into [Rank](RankName,RankRemark)
values('Senior','Can lead and coordinate teams')
```

## 3. Insert Data into Employee Table

```
insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(1,3,'Liu Bei','Male','1984-7-9',20000,'13554785452','Chengdu',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(1,2,'Sun Shangxiang','Female','1987-7-9',15000,'13256854578','Jingzhou',getdate())

insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
values(1,1,'Guan Yu','Male','1988-8-8',12000,'13985745871','Jingzhou',getdate())

[... Additional employee records ...]
```

Note: DepartmentId, RankId, and PeopleSalary are numeric types and don't require quotes, while other types need single quotes.

## 4. Verify Inserted Data

```
select * from Department
select * from [Rank]
select * from People 
```
