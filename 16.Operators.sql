use DBTEST
-- T-SQL supports 7 types of operators:

-- Arithmetic: + (add), - (subtract), * (multiply), / (divide), % (modulo)
-- Logical: AND, OR, LIKE, BETWEEN, IN, EXISTS, NOT, ALL, ANY
-- Assignment: =
-- String concatenation: +
-- Comparison: =, >, <, >=, <=, <>
-- Bitwise: | (OR), & (AND), ^ (XOR)
-- Compound: +=, -=, /=, %=, *=

-- 1. Calculate perimeter and area of rectangle given length and width
declare @length int = 10
declare @width int = 5
declare @perimeter int
declare @area int
set @perimeter = (@length+@width)*2
set @area = @length*@width
print 'Perimeter: ' + Convert(varchar(10),@perimeter)
print 'Area: ' + Convert(varchar(10),@area)
-- Alternative:
-- print 'Perimeter: ' + cast(@perimeter as varchar(10))
-- print 'Area: ' + cast(@area as varchar(10))


-- 2. Query frozen cards with balance > 1,000,000
select * from BankCard where CardState = 3 and CardMoney > 1000000

-- 3. Query frozen cards with zero balance
select * from BankCard where CardState = 3 and CardMoney = 0

-- 4. Query accounts and cards for customers with 'Li' in name
select * from AccountInfo
inner join BankCard on BankCard.AccountId = AccountInfo.AccountId
where RealName like '%Li%'

-- 5. Query cards with balance between 2000-5000
select * from BankCard where CardMoney between 2000 and 5000

-- 6. Query cards that are frozen or closed
select * from BankCard where CardState in(3,4)

-- 7. Check if customer (ID: 420107199507104133) exists before issuing new card
declare @AccountId int
if exists (select * from AccountInfo where AccountCode = '420107199507104133')
    begin
        select @AccountId =
        (select AccountId from AccountInfo where AccountCode = '420107199507104133')
        insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
        values('6225547858741264',@AccountId,'123456',0,1)
    end
else
    begin
        insert into AccountInfo(AccountId,AccountPhone,RealName,OpenTime)
        values('420107199507104133','13656565656','Mary',GETDATE())
        set @AccountId = @@IDENTITY
        insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
        values('6225547858741264',@AccountId,'123456',0,1)
    end

-- Extended example: Enforce maximum 3 cards per customer
declare @AccountId int -- Account ID
declare @CardCount int -- Card count
if exists (select * from AccountInfo where AccountCode = '420107199507104133')
    begin
        select @AccountId =
        (select AccountId from AccountInfo where AccountCode = '420107199507104133')
        select @CardCount = 
        (select count(*) from BankCard where AccountId = @AccountId)
        if @CardCount <= 2
            begin
                insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
                values('6225547858741266',@AccountId,'123456',0,1)
            end
        else
            begin
                print 'Cannot issue more cards (maximum 3 per customer)'
            end
    end
else
    begin
        insert into AccountInfo(AccountId,AccountPhone,RealName,OpenTime)
        values('420107199507104133','13656565656','Mary',GETDATE())
        set @AccountId = @@IDENTITY
        insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
        values('6225547858741264',@AccountId,'123456',0,1)
    end


select * from AccountInfo
select * from BankCard
-- 8. Check if all card balances exceed 3000
if 3000 < All(select CardMoney from BankCard) -- ALL operator
    begin
        print 'All card balances exceed 3000'
    end
else
    begin
        print 'Not all card balances exceed 3000'
    end

-- 9. Check if any card balance exceeds 30,000,000
if 30000000 < Any(select CardMoney from BankCard) -- ANY operator
    begin
        print 'Some card balances exceed 30,000,000'
    end
else
    begin
        print 'No card balances exceed 30,000,000'
    end
