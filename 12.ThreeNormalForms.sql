-- Database Normalization
-- First Normal Form (1NF): Atomicity - Each column must contain atomic values that cannot be divided further
create table Student -- Student table
(
	StuId varchar(20) primary key, -- Student ID
	StuName varchar(20) not null, -- Student name
	StuContact varchar(50) not null -- Contact information
)
insert into Student(StuId,StuName,StuContact) 
values('001','John','QQ:185699887;Tel:13885874587')
select * from Student

-- The contact information in this table violates 1NF as it contains multiple values, should be modified to:
drop table Student
create table Student -- Student table
(
	StuId varchar(20) primary key, -- Student ID
	StuName varchar(20) not null, -- Student name
  	Tel varchar(20) not null, -- Phone number
  	QQ varchar(20) not null  -- QQ number
)
select * from Student

-- Second Normal Form (2NF): Requires records to have unique identifiers and eliminates partial dependencies
-- Student course grades
create table StudentCourse
(
	StuId varchar(20), -- Student ID
	StuName varchar(20) not null, -- Student name
	CourseId varchar(20) not null, -- Course ID
	CourseName varchar(20) not null, -- Course name
	CourseScore int not null -- Exam score
)
insert into StudentCourse(StuId,StuName,CourseId,CourseName,CourseScore)
values('001','John','001','Math',80)
insert into StudentCourse(StuId,StuName,CourseId,CourseName,CourseScore)
values('001','John','002','Physics',70)
insert into StudentCourse(StuId,StuName,CourseId,CourseName,CourseScore)
values('002','Mary','003','English',80)
insert into StudentCourse(StuId,StuName,CourseId,CourseName,CourseScore)
values('003','Mike','003','English',90)
select * from StudentCourse

-- This design violates 2NF as student information and course information are not uniquely identified
-- The composite key should be (StudentID, CourseID)
-- Better design following 2NF:
create table Course -- Course table
(
	CourseId int primary key identity(1,1), -- Course ID
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

create Table Exam -- Exam results
(
	ExamId int primary key identity(1,1), -- Exam record ID
	StuId int not null, -- Student ID
	CourseId int not null, -- Course ID
	Score int not null, -- Exam score
)
insert into Exam(StuId,CourseId,Score) values(1,1,90)
insert into Exam(StuId,CourseId,Score) values(1,2,80)
insert into Exam(StuId,CourseId,Score) values(2,2,85)

select * from Course
select * from Student
select * from Exam
-- Join query
select Student.StuId, StuName, CourseName, Score from Student
inner join
Exam on Student.StuId = Exam.StuId
inner join
Course on Course.CourseId = Exam.CourseId


-- Third Normal Form (3NF): Eliminates transitive dependencies - no non-key column should depend on another non-key column
create table Student
(
	StuId varchar(20) primary key, -- Student ID
	StuName varchar(20) not null, -- Student name
	ProfessionalId int not null, -- Major ID
	ProfessionalName varchar(50), -- Major name
	ProfessionalRemark varchar(200) -- Major description
)
insert into Student(StuId,StuName,ProfessionalId,ProfessionalName,ProfessionalRemark)
values('001','John',1,'Computer Science','Top major')
insert into Student(StuId,StuName,ProfessionalId,ProfessionalName,ProfessionalRemark)
values('002','Mary',2,'Business Management','Basic business major')
insert into Student(StuId,StuName,ProfessionalId,ProfessionalName,ProfessionalRemark)
values('003','Mike',1,'Computer Science','Top major')
select * from Student
-- This design violates 3NF as major information depends on ProfessionalID (non-key column)
-- Better design following 3NF:
create table Professional
(
	ProfessionalId int primary key identity(1,1), -- Major ID
	ProfessionalName varchar(50), -- Major name
	ProfessionalRemark varchar(200) -- Major description
)
create table Student
(
	StuId varchar(20) primary key, -- Student ID
	StuName varchar(20) not null, -- Student name
	ProfessionalId int not null -- Major ID
)
insert into Professional(ProfessionalName,ProfessionalRemark) values('Computer Science','Top major')
insert into Professional(ProfessionalName,ProfessionalRemark) values('Business Management','Basic business major')
insert into Student(StuId,StuName,ProfessionalId) values('001','John',1)
insert into Student(StuId,StuName,ProfessionalId) values('002','Mary',2)
insert into Student(StuId,StuName,ProfessionalId) values('003','Mike',1)
select * from Professional
select * from Student
