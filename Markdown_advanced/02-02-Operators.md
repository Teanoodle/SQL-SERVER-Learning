# Operators

T-SQL uses 7 types of operators:

```
Arithmetic: + (add), - (subtract), * (multiply), / (divide), % (modulo)
Logical: AND, OR, LIKE, BETWEEN, IN, EXISTS, NOT, ALL, ANY
Assignment: = 
String: + (concatenation)
Comparison: =, >, <, >=, <=, <>
Bitwise: | (OR), & (AND), ^ (XOR)
Compound: +=, -=, /=, %=, *=
```

## Operator Examples

(1) Calculate perimeter and area of a rectangle given length and width:

```
declare @length int = 5
declare @width int = 10
declare @perimeter int
declare @area int
set @perimeter = (@length+@width)*2
set @area = @length * @width
print 'Perimeter:' + Convert(varchar(20),@perimeter)
print 'Area:' + Convert(varchar(20),@area)
```

(2) Query bank cards with frozen status AND balance > 1,000,000:

```
select * from BankCard where CardState = 3 and CardMoney > 1000000
```

(3) Query bank cards with frozen status OR zero balance:

```
select * from BankCard where CardState = 3 or CardMoney = 0
```

(4) Query accounts with names containing 'Liu' and their card info:

```
select * from AccountInfo 
left join BankCard on AccountInfo.AccountId = BankCard.AccountId 
where RealName like '%Liu%'
```

(5) Query bank cards with balance between 2000-5000:

```
select * from BankCard where CardMoney between 2000 and 5000
```

(6) Query bank cards with frozen OR closed status:

```
select * from BankCard where CardState in(3,4)
```

(7) Open account/card for Guan Yu (ID:420107199507104133) if doesn't exist:

```
declare @AccountId int
if exists(select * from AccountInfo where AccountCode = '420107199507104133')
    begin        
        select @AccountId = (select AccountId from AccountInfo where AccountCode = '420107199507104133')
        insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
        values('6225456875357896',@AccountId,'123456',0,1)                
    end
else
    begin
        insert into AccountInfo(AccountCode,AccountPhone,RealName,OpenTime)
        values('420107199507104133','13335645213','Guan Yu',GETDATE())
        set @AccountId = @@identity
        insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
        values('6225456875357896',@AccountId,'123456',0,1)        
    end
```

Extended version with 3-card limit per person:

```
declare @AccountId int
declare @count int
if exists(select * from AccountInfo where AccountCode = '420107199507104133')
    begin        
        select @AccountId = (select AccountId from AccountInfo where AccountCode = '420107199507104133')
        select @count = (select COUNT(*) from BankCard where AccountId = @AccountId)
        if @count <= 2
            begin
                insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
                values('6225456875357898',@AccountId,'123456',0,1)    
            end    
        else
            begin
                print 'Maximum 3 cards per person'
            end        
    end
else
    begin
        insert into AccountInfo(AccountCode,AccountPhone,RealName,OpenTime)
        values('420107199507104133','13335645213','Guan Yu',GETDATE())
        set @AccountId = @@identity
        insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
        values('6225456875357898',@AccountId,'123456',0,1)        
    end
```

(8) Check if ALL account balances exceed 3000:

```
if 3000 < ALL(select CardMoney from BankCard) 
    print 'All accounts have balance > 3000'
else
    print 'Some accounts have balance <= 3000'
```

(9) Check if ANY account balance exceeds 30,000,000:

```
if 30000000 < ANY(select CardMoney from BankCard) 
    print 'Some accounts have balance > 30,000,000'
else
    print 'No accounts have balance > 30,000,000'
```
