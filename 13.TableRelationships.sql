-- Table relationships (one-to-one, one-to-many, many-to-many)
-- One-to-many relationship (Major to Students - one major can have many students)
create table Profession -- Major table
(
	ProId int primary key identity(1,1), -- Major ID
	ProName varchar(50) not null -- Major name
)
create table Student
(
	StuId int primary key identity(1,1), -- Student ID
	ProId int not null, -- Major ID (foreign key referencing Profession table)
	StuName varchar(50) not null, -- Student name
	StuSex varchar(2) not null -- Student gender
)
insert into Profession(ProName) values('Computer Science')
insert into Profession(ProName) values('Business Administration')
insert into Student(ProId,StuName, StuSex) values(1,'John','M')
insert into Student(ProId,StuName, StuSex) values(1,'Mary','F')
insert into Student(ProId,StuName, StuSex) values(2,'Mike','M')
insert into Student(ProId,StuName, StuSex) values(2,'Sarah','F')
select * from Profession
select * from Student

-- One-to-one relationship (Student basic info and student detail info)
-- Basic info: student number, name, gender
-- Detail info: phone, address, etc. - naturally belongs to the same entity but stored separately!
create table StudentBasicInfo  -- Student basic info
(
	StuNo varchar(20) primary key not null,  -- Student number
	StuName varchar(20) not null, -- Name
	StuSex nvarchar(1) not null  -- Gender
)
create table StudentDetailInfo  -- Student detail info
(
	StuNo varchar(20) primary key not null,
	StuQQ varchar(20), -- QQ number
	stuPhone varchar(20), -- Phone
	StuMail varchar(100), -- Email
	StuBirth date         -- Birthdate
)
-- Insert data in order: basic info first, then detail info
insert into StudentBasicInfo(StuNo,StuName,StuSex) values('QH001','John','M')
insert into StudentBasicInfo(StuNo,StuName,StuSex) values('QH002','Mary','F')
-- Insert data in order: detail info first, then basic info
insert into StudentDetailInfo(StuNo,StuQQ,stuPhone,StuMail,StuBirth)
values('QH002','156545214','13654525478','mary@163.com','1996-6-6')
insert into StudentDetailInfo(StuNo,StuQQ,stuPhone,StuMail,StuBirth)
values('QH001','186587854','15326545214','john@163.com','1998-8-8')

-- Alternative structure:
create table StudentBasicInfo  -- Student basic info
(
	StuNo int primary key identity(1,1),  -- Student number
	StuName varchar(20) not null, -- Name
	StuSex nvarchar(1) not null  -- Gender
)
create table StudentDetailInfo  -- Student detail info
(
	StuNo int primary key,  -- Student number
	StuQQ varchar(20), -- QQ number
	stuPhone varchar(20), -- Phone
	StuMail varchar(100), -- Email
	StuBirth date         -- Birthdate
)

-- Many-to-many relationship (Students and Courses - one student can take many courses, one course can have many students)
create table Course -- Course table
(
	CourseId int primary key identity(1,1),-- Course ID
	CourseName varchar(30) not null, -- Course name
	CourseContent text -- Course description
)
insert into Course(CourseName,CourseContent) values('HTML','Static web page development')
insert into Course(CourseName,CourseContent) values('WinForm','Windows application development')

create table Student -- Student table
(
	StuId int primary key identity(1,1), -- Student ID
	StuName varchar(50) not null, -- Student name
	StuSex char(2) not null -- Student gender
)
insert into Student(StuName,StuSex) values('John','M')
insert into Student(StuName,StuSex) values('Mary','F')

create Table Exam -- Exam results (junction table for many-to-many)
(
	ExamId int primary key identity(1,1), -- Exam record ID
	StuId int not null, -- Student ID
	CourseId int not null,  -- Course ID
	Score int not null, -- Exam score
)
insert into Exam(StuId,CourseId,Score) values(1,1,90)
insert into Exam(StuId,CourseId,Score) values(1,2,80)
insert into Exam(StuId,CourseId,Score) values(2,2,85)

-- Join query to show student-course relationships
select * from Student inner join Exam on Student.StuId = Exam.StuId
inner join Course on Course.CourseId = Exam.CourseId
