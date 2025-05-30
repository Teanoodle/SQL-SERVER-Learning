-- Switch database
use DBTEST

-- Check if table exists
if exists(select * from sys.objects where name='Department' and type='U')
	drop table Department

-- Basic table creation syntax
--create table table_name
--(
--	column1 datatype,
--	column2 datatype,
--)

-- Create department table
create table Department
(
	-- Department ID; primary key constraint; identity(1,1) auto-increment, start value 1, increment by 1
	DepartmentId int primary key identity(1,1),
	-- Department name
	DepartmentName nvarchar(50) not null,
	-- Department remarks
	DepartmentRemark nvarchar(max)
)

-- String type explanation
-- char: fixed length, e.g. char(10), always occupies 10 bytes regardless of actual content
-- varchar: variable length, e.g. varchar(10), occupies only the actual length

-- nchar, nvarchar: store unicode characters, more international friendly
-- varchar(100): stores 100 English letters or 50 Chinese characters
-- nvarchar(100): stores 100 English letters or 100 Chinese characters

-- Create position rank table
create table [Rank]
(
	-- Position ID; primary key constraint; identity(1,1) auto-increment
	RankId int primary key identity(1,1),
	-- Position name
	RankName nvarchar(50) not null,
	-- Position remarks
	RankRemark nvarchar(max)
)

-- Employee table
create table People
(
	-- Employee ID
	PeopleId int primary key identity(1,1),

	-- Department ID foreign key reference
	DepartmentId int references Department(DepartmentId) not null,
	-- Position ID foreign key reference
	RankId int references [Rank](RankId) not null,

	PeopleName nvarchar(50) not null,
	-- Gender constraint, default 'Male'
	PeopleSex nvarchar(1) default('Male') check(PeopleSex='Male' or PeopleSex='Female') not null,
	-- date type: date only; datetime: date and time; small+ for smaller range, better query performance
	PeopleBirth smalldatetime not null,
	-- decimal with high precision, 12 total digits with 2 decimal places
	PeopleSalary decimal(12,2) check(PeopleSalary>= 1000 and PeopleSalary<= 1000000) not null,
	-- unique constraint for phone number
	PeoplePhone varchar(20) unique not null,
	PeopleAddress varchar(300),
	-- Employee join time, defaults to current system time
	PeopleAddTime smalldatetime default(getdate())
)

-- Table structure modification operations
-- 1. Add column
--alter table table_name add column_name datatype
-- Add email column
alter table People add PeopleMail varchar(200)

-- 2. Delete column
--alter table table_name drop column column_name
-- Delete email column
alter table People drop column PeopleMail

-- 3. Modify column
--alter table table_name alter column column_name datatype
-- Change address length from 300 to 200
alter table People alter column PeopleAddress varchar(200)

-- Constraint maintenance: delete and add
-- Delete constraint
--alter table table_name drop constraint constraint_name
-- Delete salary constraint
alter table People drop constraint CK__People__PeopleSa__59063A47

-- Add check constraint
--alter table table_name add constraint constraint_name check(expression)
-- Add salary range constraint (1000-1000000)
alter table People add constraint CK_People_PeopleSa1
check(PeopleSalary>= 1000 and PeopleSalary<= 1000000)

-- Other constraint types:
-- Primary key:
--alter table table_name add constraint constraint_name primary key(column)
-- Unique:
--alter table table_name add constraint constraint_name unique(column)
-- Default:
--alter table table_name add constraint constraint_name default default_value for column
-- Foreign key:
--alter table table_name add constraint constraint_name foreign key(column)
--references referenced_table(referenced_column)
