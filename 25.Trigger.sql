use DBTEST

--Department table
create table Department
(
    DepartmentId varchar(10) primary key , --Department ID (auto increment)
    DepartmentName nvarchar(50), --Department name
)
--Employee information
create table People
(
    PeopleId int primary key identity(1,1), --ID, auto increment
    DepartmentId varchar(10), --Department ID, foreign key, references Department table
    PeopleName nvarchar(20), --Employee name
    PeopleSex nvarchar(2), --Employee gender
    PeoplePhone nvarchar(20), --Phone number/contact info
)
insert into Department(DepartmentId,DepartmentName)
values('001','General Manager Office')
insert into Department(DepartmentId,DepartmentName)
values('002','Marketing Department')
insert into Department(DepartmentId,DepartmentName)
values('003','HR Department')
insert into Department(DepartmentId,DepartmentName)
values('004','Finance Department')
insert into Department(DepartmentId,DepartmentName)
values('005','Development Department')
insert into People(DepartmentId,PeopleName,PeopleSex,PeoplePhone)
values('001','Zhang San','Male','13558785478')
insert into People(DepartmentId,PeopleName,PeopleSex,PeoplePhone)
values('001','Li Si','Female','13558788785')
insert into People(DepartmentId,PeopleName,PeopleSex,PeoplePhone)
values('002','Wang Wu','Male','13698547125')


select * from Department
select * from People
-- Instead of trigger: executes before the operation
-- After trigger: executes after the operation

--1. When inserting employee information, if the department doesn't exist,
--automatically add the department information with name "New Department"
create trigger tri_InsertPeople on People after insert  --Trigger on People table, executes after insert
as
    if not exists(select * from Department where DepartmentId = (select DepartmentId from inserted))
        begin
            insert into Department(DepartmentId,DepartmentName)
            values((select DepartmentId from inserted),'New Department')
        end
go
--Test case
insert into People(DepartmentId,PeopleName,PeopleSex,PeoplePhone)
values('003','Zhao Liu','Male','13698547125')
insert into People(DepartmentId,PeopleName,PeopleSex,PeoplePhone)
values('006','Qian Qi','Male','13698547125')

--2. When deleting a department, delete all employees in that department
create trigger tri_DeleteDept on Department after delete
as
    delete from People where DepartmentId = (select DepartmentId from deleted)
go
--Test case
select * from Department
select * from People
delete from Department where DepartmentId = '006'


--3. When deleting a department, check if it has employees. Only delete if no employees.
drop trigger tri_DeleteDept
create trigger tri_DeleteDept on Department instead of delete
as
    if not exists(select * from People where DepartmentId = (select DepartmentId from deleted))
        delete from Department where DepartmentId = (select DepartmentId from deleted)
go
--Test case
select * from Department
select * from People
delete from Department where DepartmentId = '005'
delete from Department where DepartmentId = '001'


--4. When updating a department ID, update all employees' department IDs accordingly
create trigger tri_UpdateDept on Department after update
as
    update People set DepartmentId = (select DepartmentId from inserted) --New ID, for updated records
    where DepartmentId = (select DepartmentId from deleted)   --Old ID, for records to be updated
go
--Test case
select * from Department
select * from People
update Department set DepartmentId = '005' where  DepartmentId = '001'
