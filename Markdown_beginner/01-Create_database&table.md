# Database and Table Creation

## 1. Check Database Existence

When creating a database, name conflicts may occur. We can use the following code to check if a database exists and drop it if needed:

```
--Drop database if exists
if exists(select * from sys.databases where name = 'DBTEST')
	drop database DBTEST
```

This checks for and drops the "DBTEST" database if it exists. Use with caution in production environments as it may delete important data.

## 2. Create Database

```
--Create database with specified file properties
create database DBTEST
on  --Data file
(
	name = 'DBTEST',   --Logical name
	filename = 'D:\Data\DBTEST.mdf',  --Physical path
	size = 5MB,  --Initial size
	filegrowth = 2MB --Growth increment (can use percentage)
)
log on  --Log file
(
	name = 'DBTEST_log', --Logical name
	filename = 'D:\Data\DBTEST_log.ldf', --Physical path
	size = 5MB, --Initial size
	filegrowth = 2MB --Growth increment
)
```

The above creates "DBTEST" database with specified data and log file properties.

Simpler syntax with default values:

```
create database DBTEST
```

## 3. Create Tables

**Use Database and Drop Tables:**

```
use DBTEST  --Switch to DBTEST database
--Drop table if exists (type='U' checks for user-defined tables)
if exists(select * from sys.objects where name = 'Department' and type = 'U')
	drop table Department
```

**Table Creation Syntax:**

```
create table table_name
(
	column1 datatype(length),
	column2 datatype(length)
)
```

**Example Tables (Department, Rank, Employee):**

```
--Create Department table
create table Department
(
	--Department ID: int for integer, primary key, auto-increment from 1
	DepartmentId int primary key identity(1,1),
	--Department name: nvarchar(50) for Unicode string, not null
	DepartmentName nvarchar(50) not null,
	--Department description: text for long text
	DepartmentRemark text
)
```

**String Type Comparison:**

char: Fixed-length (e.g. char(10) always uses 10 bytes)
varchar: Variable-length (e.g. varchar(10) uses up to 10 bytes)
text: Long text (up to 2^31-1 characters)
nchar/nvarchar/ntext: Unicode versions (support all characters equally)

```
--Create Rank table (using brackets as rank is a keyword)
create table [Rank]
(
	RankId int primary key identity(1,1),
	RankName nvarchar(50) not null,
	RankRemark text
)
```

```
--Create Employee table
create table People
(
	PeopleId int primary key identity(1,1),
	--Foreign key references
	DepartmentId int references Department(DepartmentId) not null,
	RankId int references [Rank](RankId) not null,
	PeopleName nvarchar(50) not null,
	--Default value and check constraint
	PeopleSex nvarchar(1) default('Male') check(PeopleSex='Male' or PeopleSex='Female') not null,
	PeopleBirth datetime not null,
	PeopleSalary decimal(12,2) check(PeopleSalary>=1000 and PeopleSalary<=100000) not null,
	--Unique constraint
	PeoplePhone nvarchar(20) unique not null,
	PeopleAddress nvarchar(100),
	--Default with current time
	PeopleAddTime smalldatetime default(getdate())
)
```

## 4. Modify Table Structure

(1) Add column:

```
ALTER TABLE table_name
ADD column_name datatype
```

Example adding email column:

```
alter table People
add PeopleMail nvarchar(100)
```

(2) Drop column:

```
ALTER TABLE table_name
DROP COLUMN column_name
```

Example removing email column:

```
alter table People
drop column PeopleMail
```

(3) Modify column datatype:

```
ALTER TABLE table_name
ALTER COLUMN column_name datatype
```

Example changing email column type:

```
alter table People
alter column PeopleMail varchar(100)
```

## 5. Constraints Management

Drop constraint:

```
if exists(select * from sysobjects where name=constraint_name)
alter table table_name drop constraint constraint_name;
go
```

Add constraints:

```
--Primary key
alter table table_name add constraint constraint_name primary key(column)
--Check
alter table table_name add constraint constraint_name check(condition)
--Unique
alter table table_name add constraint constraint_name unique(column)
--Default
alter table table_name add constraint constraint_name default default_value for column
--Foreign key
alter table table_name add constraint constraint_name foreign key (column) references related_table(related_column)
```
