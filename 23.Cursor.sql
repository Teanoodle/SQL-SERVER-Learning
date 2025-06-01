use DBTEST	

create table Member
(
	MemberId int primary key identity(1,1),
	MemberAccount nvarchar(20) unique check(len(MemberAccount) between 6 and 12),
	MemberPwd nvarchar(20),
	MemberNickname nvarchar(20),
	MemberPhone nvarchar(20)
)

insert into Member(MemberAccount,MemberPwd,MemberNickname,MemberPhone)
values('liubei','123456','Liu Bei','4659874564')
insert into Member(MemberAccount,MemberPwd,MemberNickname,MemberPhone)
values('guanyu','123456','Guan Yu','42354234124')
insert into Member(MemberAccount,MemberPwd,MemberNickname,MemberPhone)
values('zhangfei','123456','Zhang Fei','41253445')
insert into Member(MemberAccount,MemberPwd,MemberNickname,MemberPhone)
values('zhangyun','123456','Zhao Yun','75675676547')
insert into Member(MemberAccount,MemberPwd,MemberNickname,MemberPhone)
values('machao','123456','Ma Chao','532523523')

--Cursor: A database object used to process one row at a time
--Cursor types:
--1. Static cursor: Data doesn't change when cursor is opened
--2. Dynamic cursor: Data changes when cursor is opened (default)
--3. Keyset-driven cursor: Detects row changes but not column changes

select * from Member
--Declare cursor (scroll: allows bidirectional movement)
declare mycur cursor scroll
for select MemberAccount from Member
--Open cursor
open mycur
--Fetch specific rows
fetch first from mycur     --First row
fetch last from mycur		--Last row
fetch absolute 1 from mycur --Absolute position from start (nth row)
fetch relative 3 from mycur --Relative position from current (n rows)
fetch next from mycur --Next row from current
fetch prior from mycur --Previous row from current

--Use cursor data in query
declare @acc varchar(20)
fetch relative 3 from mycur into @acc
select * from Member where MemberAccount = @acc

--Iterate through cursor
declare @acc varchar(20)
fetch absolute 1 from mycur into @acc
--@@fetch_status:0 success, -1 failure, -2 row missing
while @@FETCH_STATUS = 0
	begin
		print 'Fetch success: ' + @acc
		fetch next from mycur into @acc
	end

--Update and delete using cursor
select * from Member
fetch absolute 2 from mycur
update Member set MemberPwd = '654321' where current of mycur

fetch absolute 2 from mycur
delete from Member where current of mycur
--After deletion, need to reopen cursor


select * from Member
--Declare cursor with multiple columns and iterate
declare mycur cursor scroll
for select MemberAccount, MemberPwd, MemberNickName from Member

open mycur
declare @acc varchar(20)
declare @pwd varchar(20)
declare @nickname varchar(20)
fetch absolute 1 from mycur into @acc,@pwd,@nickname
--@@fetch_status:0 success, -1 failure, -2 row missing
while @@FETCH_STATUS = 0
	begin
		print 'Username: ' + @acc  + ', Password: ' + @pwd + ', Nickname: ' + @nickname
		fetch next from mycur into @acc,@pwd,@nickname
	end


--Close cursor
close mycur
--Deallocate cursor
deallocate mycur
