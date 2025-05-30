use DBTEST
-- Conditional branching structure ----------------------------------------------------------
select * from BankCard
select * from CardExchange
-- 1. For card number '6225547854125656'
-- Process withdrawal of 5000, check balance first
-- Display "Withdrawal successful" or "Insufficient balance"
declare @balance money
select @balance = 
(select CardMoney from BankCard where CardNo = '6225547854125656')
if @balance >= 5000 -- Allow withdrawal
    begin
        update BankCard set CardMoney = CardMoney - 5000
        where CardNo = '6225547854125656'
        insert into CardExchange([CardNo],[MoneyInBank],[MoneyOutBank],[ExchangeTime])
        values('6225547854125656',0,5000,GETDATE())
        print 'Withdrawal successful'
    end
else  -- Reject withdrawal
    begin
        print 'Insufficient balance'
    end


-- 2. Query card info, convert status codes 1,2,3,4 to text
-- Also classify users as "Regular" (balance <300,000) or "VIP" (balance >=300,000)
-- Display card number, ID, name, balance, user type and card status
select CardNo as CardNumber, AccountCode as ID, RealName as Name, CardMoney as Balance,
case   -- Range comparison simplifies logic
    when CardMoney >= 300000 then 'VIP'
    else 'Regular'
end UserType,
case CardState  -- Equality comparison simplifies logic
    when 1 then 'Normal'
    when 2 then 'Lost'
    when 3 then 'Frozen'
    when 4 then 'Closed'
    else 'Abnormal'
end Status
from BankCard
inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId



-- Loop structure (WHILE) --------------------------------------------------------------
-- 1. Print numbers 1-10
declare @i int = 1  -- Initialize counter
while @i <= 10
    begin
        print @i
        set @i = @i+1
    end

-- 2. Print multiplication table (Chinese style)
declare @i int = 1
while @i <= 9 -- Outer loop for multiplicand
    begin
        declare @str varchar(1000) = ''
        declare @j int = 1
        while @j <= @i -- Inner loop for multiplier
            begin
                set @str = @str + cast(@i as varchar(1)) + '*' + cast(@j as varchar(1))
                + '=' + cast(@i*@j as varchar(3)) + char(9) -- Tab separator
                set @j = @j + 1
            end
        set @i = @i + 1
        print @str 
    end

-- Common special characters: TAB CHAR(9), LineFeed CHAR(10), CarriageReturn CHAR(13)
