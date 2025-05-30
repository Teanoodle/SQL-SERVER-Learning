# Functions, Stored Procedures and Triggers

## 1. Functions

Functions are divided into (1) System functions and (2) User-defined functions.

User-defined functions can be:
- Scalar functions (return single value)
- Table-valued functions (return query results)

(1) Function to calculate total bank balance:

```
create function GetSumCardMoney()
returns money 
as
begin
    declare @AllMOney money
    select @AllMOney = (select SUM(CardMoney) from BankCard)
    return @AllMOney
end
```

Call the function:
```
select dbo.GetSumCardMoney()
```

(2) Function to get account name by ID:

```
create function GetNameById(@AccountId int)
returns varchar(20)
as
begin
    declare @RealName varchar(20)
    select @RealName = (select RealName from AccountInfo where AccountId = @AccountId)
    return @RealName
end
```

Call the function:
```
print dbo.GetNameById(2)
```

(3) Function to get transactions between dates:

Option 1 (complex logic):
```
create function GetExchangeByTime(@StartTime varchar(30),@EndTime varchar(30))
returns @ExchangeTable table
(
    RealName varchar(30),  --Name
    CardNo varchar(30),    --Card number
    MoneyInBank money,     --Deposit amount
    MoneyOutBank money,    --Withdrawal amount
    ExchangeTime smalldatetime  --Transaction time
)
as
begin
    insert into @ExchangeTable
    select AccountInfo.RealName,CardExchange.CardNo,CardExchange.MoneyInBank,
    CardExchange.MoneyOutBank,CardExchange.ExchangeTime from CardExchange
    left join BankCard on CardExchange.CardNo = BankCard.CardNo
    left join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
    where CardExchange.ExchangeTime between @StartTime+' 00:00:00' and @EndTime+' 23:59:59'
    return
end
```

Option 2 (simple inline function):
```
create function GetExchangeByTime(@StartTime varchar(30),@EndTime varchar(30))
returns table
as
    return
    select AccountInfo.RealName,CardExchange.CardNo,CardExchange.MoneyInBank,
    CardExchange.MoneyOutBank,CardExchange.ExchangeTime from CardExchange
    left join BankCard on CardExchange.CardNo = BankCard.CardNo
    left join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
    where CardExchange.ExchangeTime between @StartTime+' 00:00:00' and @EndTime+' 23:59:59'
go
```

(4) Function to calculate age from birthdate:

```
create function GetAgeByBirth(@birth smalldatetime)
returns int
as
begin
    declare @age int
    set @age = year(getdate()) - year(@birth)
    if month(getdate()) < month(@birth)
        set @age = @age - 1
    if month(getdate()) = month(@birth) and day(getdate()) < day(@birth)
        set @age = @age -1
    return @age
end
```

## 2. Triggers

Trigger types:
- "Instead of" triggers: Execute before the operation
- "After" triggers: Execute after the operation

Sample tables:
```
create table Department
(
    DepartmentId varchar(10) primary key,
    DepartmentName nvarchar(50)
)

create table People
(
    PeopleId int primary key identity(1,1),
    DepartmentId varchar(10),
    PeopleName nvarchar(20),
    PeopleSex nvarchar(2),
    PeoplePhone nvarchar(20)
)
```

(1) Trigger to auto-create department if not exists when adding employee:
```
create trigger tri_InsertPeople on People
after insert
as
if not exists(select * from Department where DepartmentId = (select DepartmentId from inserted))
    insert into Department(DepartmentId,DepartmentName)
    values((select DepartmentId from inserted),'New Department')
go
```

(2) Trigger to delete all employees when department is deleted:
```
create trigger tri_DeleteDept on Department
after delete
as
delete from People where People.DepartmentId = 
(select DepartmentId from deleted)
go
```

(3) Trigger to prevent department deletion if it has employees:
```
create trigger tri_DeleteDept on Department
Instead of delete
as
  if not exists(select * from People where DepartmentId = (select DepartmentId from deleted))
  begin
    delete from Department where DepartmentId = (select DepartmentId from deleted)
  end
go
```

(4) Trigger to update employee department IDs when department ID changes:
```
create trigger tri_UpdateDept on Department
after update
as
    update People set DepartmentId = (select DepartmentId from inserted)
    where DepartmentId = (select DepartmentId from deleted)
go
```

## 3. Stored Procedures

(1) Procedure to get card with minimum balance:
```
create proc proc_MinMoneyCard
as
    select CardNo as 'CardNumber',RealName as 'Name',CardMoney as 'Balance'
    from BankCard inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
    where CardMoney=(select MIN(CardMoney) from BankCard)
go
```

(2) Procedure for deposit operation:
```
create proc proc_CunQian
@CardNo varchar(30),
@MoneyInBank money
as
    update BankCard set CardMoney = CardMoney + @MoneyInBank where CardNo = @CardNo
    insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
    values(@CardNo,@MoneyInBank,0,GETDATE())
go
```

(3) Procedure for withdrawal with return value:
```
create proc proc_QuQian
@CardNo varchar(30),
@MoneyOutBank money
as
    update BankCard set CardMoney = CardMoney - @MoneyOutBank where CardNo = @CardNo
    if @@ERROR <> 0
        return -1
    insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
    values(@CardNo,0,@MoneyOutBank,GETDATE())
    return 1
go
```

(4) Procedure with output parameters for transaction summary:
```
create proc proc_SelectExchange
    @startTime varchar(20),
    @endTime varchar(20),
    @SumIn money output,
    @SumOut money output
as
select @SumIn = (select SUM(MoneyInBank) from CardExchange 
                where ExchangeTime between @startTime+' 00:00:00' and @endTime+' 23:59:59')
select @SumOut = (select SUM(MoneyOutBank) from CardExchange 
                where ExchangeTime between @startTime+' 00:00:00' and @endTime+' 23:59:59')
select * from CardExchange 
where ExchangeTime between @startTime+' 00:00:00' and @endTime+' 23:59:59'
go
```

(5) Procedure for password upgrade:
```
create proc procPwdUpgrade
@cardno nvarchar(20),
@pwd nvarchar(20) output
as
    if not exists(select * from BankCard where CardNo=@cardno and CardPwd=@pwd)
        set @pwd = ''
    else
    begin
        if len(@pwd) < 8
        begin
            declare @len int = 8- len(@pwd)
            declare @i int = 1
            while @i <= @len
            begin
                set @pwd = @pwd + cast(FLOOR(RAND()*10) as varchar(1))
                set @i = @i+1
            end
            update BankCard set CardPwd = @pwd where CardNo=@cardno
        end
    end
go
```
