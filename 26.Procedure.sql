use DBTEST
select * from BankCard
select * from AccountInfo

-- Stored Procedure: SQL stored procedure collection

-- Example 1: Basic stored procedure without parameters
-- This procedure queries bank card and account information, showing card number, real name and balance
-- Method 1 (can only return one record)
drop proc proc_MinMoneyCard
create proc proc_MinMoneyCard
as
    select top 1 CardNo, RealName,CardMoney from BankCard
    inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
    order by CardMoney
go
exec proc_MinMoneyCard

-- Method 2 (can return multiple records if same minimum balance exists)
create proc proc_MinMoneyCard
as
    select top 1 CardNo, RealName,CardMoney from BankCard
    inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
    where CardMoney = (select min(CardMoney) from BankCard)
go
exec proc_MinMoneyCard

-- Example 2: Stored procedure with input parameters
-- Simulates card top-up operation with card number and amount parameters
create proc proc_TopUp
@CardNo varchar(30),
@Amount money
as
    update BankCard set CardMoney = CardMoney + @Amount
    where CardNo = @CardNo
    insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
    values(@CardNo,@Amount,0,GETDATE())
go
select * from BankCard
select * from CardExchange
exec proc_TopUp '6225547858741263',1000

-- Example 3: Stored procedure with return value
-- Simulates withdrawal operation, returns 1 for success, -1 for failure
drop proc proc_Withdraw
create proc proc_Withdraw
@CardNo varchar(30),
@Amount money
as
    update BankCard set CardMoney = CardMoney - @Amount
    where CardNo = @CardNo
    if @@ERROR <> 0
        return -1
    insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
    values(@CardNo,0,@Amount,GETDATE())
    return 1
go

declare @returnValue int
exec @returnValue = proc_Withdraw '6225123412357896',2000
select @returnValue
select * from BankCard
select * from CardExchange

-- Example 4: Stored procedure with output parameters
-- Queries transaction records between specified dates and calculates total deposit/withdrawal
drop proc proc_selectExChange
create proc proc_selectExChange
    @StartTime smalldatetime,  -- Start time
    @EndTime smalldatetime,  -- End time
    @TotalDeposit money output, -- Total deposit amount
    @TotalWithdrawal money output  -- Total withdrawal amount
as
    select @TotalDeposit = (select sum(MoneyInBank) from CardExchange
        where ExchangeTime between @StartTime + '00:00:00' and @EndTime + '23:59:59')
    select @TotalWithdrawal = (select sum(MoneyOutBank) from CardExchange
        where ExchangeTime between @StartTime + '00:00:00' and @EndTime + '23:59:59')
    select * from CardExchange where ExchangeTime between @StartTime + '00:00:00' and @EndTime + '23:59:59'
go

declare @TotalDeposit money
declare @TotalWithdrawal money
exec proc_selectExChange '2025-05-4','2025-05-30', @TotalDeposit output,@TotalWithdrawal output
select @TotalDeposit
select @TotalWithdrawal

-- Example 5: Stored procedure with password upgrade logic
-- Verifies card number and password, automatically extends password to 8 digits if too short
select * from BankCard
select floor(rand()*10)
drop proc procPwdUpgrade
create proc procPwdUpgrade
    @CardNo nvarchar(20),  -- Card number
    @Password nvarchar(20) output  -- Password (output parameter)
as
    if not exists(select * from BankCard where CardNo = @CardNo and CardPwd = @Password)
        set @Password=''  -- Clear password if verification fails
    else
        begin
            if len(@Password)<8  -- Extend password if less than 8 digits
                begin
                    declare @Length int = 8 - len(@Password)
                    declare @i int = 1
                    while @i <= @Length
                        begin
                            set @Password = @Password + cast(floor(rand()*10) as varchar(1))
                            set @i = @i + 1
                        end
                    update BankCard set CardPwd = @Password where CardNo = @CardNo
                end
        end
go

declare @Password nvarchar(20) = '123456'  -- Password to be updated
exec procPwdUpgrade '6225125478544587', @Password output
select @Password
