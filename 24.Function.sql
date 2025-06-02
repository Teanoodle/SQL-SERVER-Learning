use DBTEST

--(1) Create a function to calculate the total amount of the bank (no parameters, returns scalar value)
create function GetSumMoney() returns money
as
begin
	declare @sum money
	select @sum = (select sum(CardMoney) from BankCard)
	return @sum
end

--Function call
select dbo.GetSumMoney()

---(2) Pass in account ID and return the account holder's real name
create function GetRealNameById(@accid int) returns varchar(30)
as
begin
	declare @name varchar(30)
	select @name = (select RealName from AccountInfo where AccountId = @accid)
	return @name
end

select dbo.GetRealNameById(4)

--(3) Pass start time and end time, return transaction records (deposit/withdrawal)
--Transaction records include: real name, card number, deposit amount, withdrawal amount, transaction time (three-table join query)
--Option 1 (Define return data structure)
--Can handle complex logic, function body can contain other logic code besides SQL queries
drop function GetRecordByTime
create function GetRecordByTime(@start varchar(30),@end varchar(30))
returns @result table
(
	RealName varchar(20),
	CardNumber varchar(30),
	Deposit money,
	Withdrawal money,
	TransactionTime smalldatetime
)
as
begin
	insert into @result
	--declare @i int can be defined here
	select RealName as Name, CardExchange.CardNo as CardNumber, MoneyInBank as DepositAmount, MoneyOutBank as WithdrawalAmount, ExchangeTime as TransactionTime
	from CardExchange
	inner join BankCard on CardExchange.CardNo = BankCard.CardNo
	inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
	where ExchangeTime between @start+' 00:00:00' and @end+' 23:59:59'
	--Assuming the transaction table only has date, need to manually add time
	return
end

select * from GetRecordByTime('2025-1-1','2025-12-12')

--Option 2 (No defined return data structure, 2)
--Limitation: Function body can only contain return + SQL query result, cannot define new variables, cannot handle complex logic
drop function GetRecordByTime
create function GetRecordByTime(@start varchar(30),@end varchar(30))
returns table
as
	return
	--declare @i int cannot be defined here, will cause error
	select RealName as Name, CardExchange.CardNo as CardNumber, MoneyInBank as DepositAmount, MoneyOutBank as WithdrawalAmount, ExchangeTime as TransactionTime
	from CardExchange
	inner join BankCard on CardExchange.CardNo = BankCard.CardNo
	inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
	where ExchangeTime between @start+' 00:00:00' and @end+' 23:59:59'
	--Assuming the transaction table only has date, need to manually add time
go

select * from GetRecordByTime('2025-1-1','2025-12-12')




--（4）(4) Query the bank card information and convert the bank card status 1,2,3, and 4 into
--characters "Normal", "Reported Lost", "Frozen", "Cancelled" respectively.
--According to the balance of the bank card, those with a bank card level of less than 300,000 yuan are classified as "ordinary users", 
--while those with a level of 300,000 yuan or more are classified as "VIP users ".
--Display card number, ID number, name, balance, user level, card status.
--Option 1: Directly use case when in SQL statement
select * from AccountInfo
select * from BankCard

select CardNo as CardNumber,AccountCode as IDNumber,RealName as Name,CardMoney as Balance,

case
	when CardMoney < 300000 then 'Regular User'
	else 'VIP User' 
end UserLevel,
case
	when CardState = 1 then 'Normal'
	when CardState = 2 then 'Lost'
	when CardState = 3 then 'Frozen'
	when CardState = 4 then 'Cancelled'
	else 'Abnormal'
end CardStatus

from BankCard inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId

--Option 2: Implement level and status with functions
--User level function
create function GetGrade(@cardmoney money) returns varchar(30)
as
begin
	declare @result varchar(30)
	if @cardmoney >= 300000
		set @result = 'VIP User'
	else
		set @result = 'Regular User'
	return @result
end

--Bank card status function
create function GetState(@state int) returns varchar(30)
as
begin
	declare @result varchar(30)
	if @state = 1
		set @result = 'Normal'
	else if @state = 2
		set @result = 'Lost'
	else if @state = 3
		set @result = 'Frozen'
	else if @state = 4
		set @result = 'Cancelled'
	else
		set @result = 'Abnormal'
	return @result
end

--Display the card number, ID card, name, balance, user level and bank card status respectively.
select * from AccountInfo
select * from BankCard

select CardNo as CardNumber,AccountCode as IDNumber,RealName as Name,CardMoney as Balance,
dbo.GetGrade(CardMoney) as UserLevel, dbo.GetState(CardState) as CardStatus
from BankCard inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId



--(5) Create a function to calculate exact age based on birth date, for example:
--Birth date 2000-5-5, current date 2018-5-4, age is 17
--Birth date 2000-5-5, current date 2018-5-6, age is 18
--Test data:
create table Emp
(
	EmpId int primary key identity(1,2), --Auto ID
	empName varchar(20), --Name
	empSex varchar(4),   --Gender
	empBirth smalldatetime --Birthdate
)
insert into Emp(empName,empSex,empBirth) values('Liu Bei','Male','2008-5-8')
insert into Emp(empName,empSex,empBirth) values('Guan Yu','Male','1998-10-10')
insert into Emp(empName,empSex,empBirth) values('Zhang Fei','Male','1999-7-5')
insert into Emp(empName,empSex,empBirth) values('Zhao Yun','Male','2003-12-12')
insert into Emp(empName,empSex,empBirth) values('Ma Chao','Male','2003-1-5')
insert into Emp(empName,empSex,empBirth) values('Huang Zhong','Male','1988-8-4')
insert into Emp(empName,empSex,empBirth) values('Wei Yan','Male','1998-5-2')
insert into Emp(empName,empSex,empBirth) values('Jian Yong','Male','1992-2-20')
insert into Emp(empName,empSex,empBirth) values('Zhuge Liang','Male','1993-3-1')
insert into Emp(empName,empSex,empBirth) values('Xu Shu','Male','1994-8-5')

select * from Emp

--Old method, doesn't distinguish between nominal and exact age
select *,year(getdate()) - year(empBirth) as Age from emp


--New function method. Distinguishes nominal and exact age (check if birthday has passed this year, if not subtract 1 year)
create function GetAge(@birth smalldatetime) returns int
as
begin
	declare @age int
	set @age = year(GETDATE()) - year(@birth)
	if month(GETDATE()) < month(@birth)
		set @age = @age-1
	if month(GETDATE()) = month(@birth) and day(getdate()) < day(@birth)
		set @age = @age-1
	return @age
end

select *,dbo.GetAge(empBirth) as Age from Emp