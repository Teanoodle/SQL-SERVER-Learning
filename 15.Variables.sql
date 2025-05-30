use DBTEST
-- Message printing
print 'hello,sql'
select 'hello,sql'

-- Variable types: 1. Local variables 2. Global variables
-- 1. Local variables: start with @, need declaration and assignment
declare @str varchar(20)
set @str = 'i like sql'
-- or select @str = 'i like sql'
print @str

-- Differences between SET and SELECT for assignment:
-- SET: assigns a specific value directly
-- SELECT: can assign values from query results (must return single value)
-- Example: select @a = column_name from table
-- If query returns multiple rows, @a gets last row's value

-- 2. Global variables: start with @@, maintained by system
-- @@ERROR: error number of last executed statement
-- @@IDENTITY: last identity value inserted
-- @@MAX_CONNECTIONS: maximum allowed user connections
-- @@ROWCOUNT: number of rows affected by last statement
-- @@SERVERNAME: local SQL Server name
-- @@SERVICENAME: SQL Server service name
-- @@TRANCOUNT: current transaction count for connection
-- @@LOCK_TIMEOUT: current lock timeout setting (ms)

-- Examples:
-- 1. Open account and bank card for new customer (ID: 420107199904054233)
insert into AccountInfo(AccountCode,AccountPhone,RealName,OpenTime)
values('420107199904054233','15878547898','John',GETDATE())
declare @AccountId int
set @AccountId = @@identity
insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
values('6225123412357896',@AccountId,'123456',0,1)
select * from AccountInfo
select * from BankCard

-- 2. Query Mike's card info (ID: 420107199602034138)
select CardNo as CardNumber, CardMoney as Balance from BankCard
inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
where AccountCode = '420107199602034138'

select * from AccountInfo
select * from BankCard

-- Alternative using variable
declare @AccountId int
select @AccountId = 
(select AccountId from AccountInfo where AccountCode = '420107199602034138')
select CardNo as CardNumber, CardMoney as Balance from BankCard
where AccountId = @AccountId


-- GO statement:
-- 1. Separates batches - statements before GO execute first
create database DBTEST1
go -- Creates database first, then executes following statements
use DBTEST1
create table AccountInfo
(
	AccountId int primary key identity(1,1),
	AccountCode varchar(20) not null,
	AccountPhone varchar(20) not null,
	RealName	varchar(20) not null,
	OpenTime	smalldatetime not null
)

-- 2. Variable scope demonstration
declare @num int -- @num scope is entire batch
set @num = 100
set @num = 200

go
declare @num1 int -- @num1 scope ends at next GO
set @num1 = 100
go
set @num1 = 200 -- Error: @num1 not defined
