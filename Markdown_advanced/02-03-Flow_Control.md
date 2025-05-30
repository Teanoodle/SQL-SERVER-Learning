# Flow Control

## 1. Selection Structures

(1) Withdrawal operation for card "6225547854125656" - withdraw 5000 if sufficient balance:

```
declare @balance money
select @balance = (select CardMoney from BankCard where CardNo='6225547854125656')
if @balance >= 5000
    begin
        update BankCard set CardMoney = CardMoney - 5000
        insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
        values('6225547854125656',0,5000,GETDATE())
    end
else
    print 'Insufficient balance'
```

(2) Query bank card info with status and VIP level:

```
select 
    CardNo as 'Card Number',
    AccountCode as 'ID Number', 
    RealName as 'Name',
    CardMoney as 'Balance',
    case
        when CardMoney < 300000 then 'Regular User'
        else 'VIP User' 
    end as 'User Level',
    case
        when CardState = 1 then 'Normal'
        when CardState = 2 then 'Reported Lost'
        when CardState = 3 then 'Frozen'
        when CardState = 4 then 'Closed'
        else 'Abnormal'
    end as 'Card Status'
from BankCard 
inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
```

Alternative CASE syntax:

```
select 
    CardNo as 'Card Number',
    AccountCode as 'ID Number',
    RealName as 'Name',
    CardMoney as 'Balance',
    case
        when CardMoney < 300000 then 'Regular User'
        else 'VIP User' 
    end as 'User Level',
    case CardState
        when 1 then 'Normal'
        when 2 then 'Reported Lost'
        when 3 then 'Frozen'
        when 4 then 'Closed'
        else 'Abnormal'
    end as 'Card Status'
from BankCard 
inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
```

## 2. Loop Structures

(1) Print numbers 1 through 10:

```
declare @i int = 1
while @i <= 10
begin
    print @i
    set @i = @i + 1
end
```

(2) Print multiplication table (9x9):

```
declare @i int = 1
declare @str varchar(1000)
while @i<=9
begin
    declare @j int = 1
    set @str = ''
    while @j <= @i
    begin
        --Option 1
        --set @str = @str + cast(@i as varchar(2)) + '*' + cast(@j as varchar(2)) + 
        --'=' + cast(@i*@j as varchar(2)) + CHAR(9)
        --Option 2
        set @str = @str + Convert(varchar(2),@i) + '*' + Convert(varchar(2),@j) + 
        '=' + Convert(varchar(2),@i*@j) + CHAR(9)        
        set @j = @j + 1
    end
    print @str
    set @i = @i + 1
end
```

Notes:
1. Special characters: 
   - Tab: CHAR(9)
   - Line feed: CHAR(10) 
   - Carriage return: CHAR(13)

2. BREAK and CONTINUE work same as in Java/C# languages.
