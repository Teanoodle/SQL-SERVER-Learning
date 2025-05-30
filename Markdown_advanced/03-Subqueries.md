# Subqueries

(1) Find cards with balance higher than Guan Yu's (card no. "6225547858741263"):

```
--Option 1:
declare @gyBalance money
select @gyBalance = (select CardMoney from BankCard where CardNo='6225547858741263')
select 
    CardNo as 'Card Number',
    AccountCode as 'ID',
    RealName as 'Name',
    CardMoney as 'Balance' 
from BankCard 
left join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
where CardMoney > @gyBalance
```

```
--Option 2:
select 
    CardNo as 'Card Number',
    AccountCode as 'ID', 
    RealName as 'Name',
    CardMoney as 'Balance' 
from BankCard 
left join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
where CardMoney > 
(select CardMoney from BankCard where CardNo='6225547858741263')
```

(2) Find transaction details for accounts with highest balance:

```
--Option 1:
select * from CardExchange where CardNo in 
(select CardNo from BankCard where CardMoney = 
  (select MAX(CardMoney) from BankCard)
)
```

```
--Option 2 (returns only one if multiple cards have same max balance):
select * from CardExchange where CardNo = 
(select top 1 CardNo from BankCard order by CardMoney desc)
```

(3) Find cards with withdrawal records:

```
select 
    CardNo as 'Card Number',
    AccountCode as 'ID',
    RealName as 'Name',
    CardMoney as 'Balance' 
from BankCard 
left join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
where CardNo in
(select CardNo from CardExchange where MoneyOutBank <> 0)
```

(4) Find cards with no deposit records:

```
select 
    CardNo as 'Card Number',
    AccountCode as 'ID',
    RealName as 'Name',
    CardMoney as 'Balance' 
from BankCard 
left join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
where CardNo not in
(select CardNo from CardExchange where MoneyInBank <> 0)
```

(5) Check if Guan Yu's card received transfers today:

```
if exists(select * from CardTransfer where CardNoIn = '6225547858741263'
and convert(varchar(10),TransferTime, 120) = convert(varchar(10),getdate(), 120)
)
    print 'Has transfer records'
else
    print 'No transfer records'
--Note: Can also use NOT EXISTS
```

(6) Find card with most transactions (deposits/withdrawals):

```
--Option 1
select top 1 
    BankCard.CardNo as 'Card Number',
    AccountCode as 'ID',
    RealName as 'Name',
    CardMoney as 'Balance',
    exchangeCount as 'Transaction Count' 
from BankCard 
inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
inner join
(select CardNo,COUNT(*) exchangeCount from CardExchange group by CardNo) CarcExchageTemp
on BankCard.CardNo = CarcExchageTemp.CardNo
order by exchangeCount desc
```

```
--Option 2 (handles ties for most transactions)
select  
    BankCard.CardNo as 'Card Number',
    AccountCode as 'ID',
    RealName as 'Name',
    CardMoney as 'Balance',
    TransactionCount 
from AccountInfo
inner join BankCard on AccountInfo.AccountId = BankCard.AccountId
inner join
(select CardNo,COUNT(*) TransactionCount from CardExchange group by CardNo) Temp 
on BankCard.CardNo = Temp.CardNo
where TransactionCount = (select max(TransactionCount) from
(select CardNo,COUNT(*) TransactionCount from CardExchange group by CardNo) Temp )
```

(7) Find cards with no transfer records:

```
select 
    CardNo as 'Card Number',
    AccountCode as 'ID',
    RealName as 'Name',
    CardMoney as 'Balance' 
from BankCard 
left join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
where BankCard.CardNo not in (select CardNoIn from CardTransfer)
and BankCard.CardNo not in (select CardNoOut from CardTransfer)
```

(8) Pagination:

```
--Table structure and sample data:
create table Student
(
    StuId int primary key identity(1,2), --Auto-increment
    StuName varchar(20),
    StuSex varchar(4)
)
--Insert statements omitted for brevity...
```

```
--Option 1: Using ROW_NUMBER()
declare @PageSize int = 5
declare @PageIndex int = 1
select * from (select ROW_NUMBER() over(order by StuId) RowId,Student.* from Student) TempStu
where RowId between (@PageIndex-1)*@PageSize+1 and @PageIndex*@PageSize
```

```
--Option 2: Using TOP
declare @PageSize int = 5
declare @PageIndex int = 1
select top(@PageSize) * from Student
where StuId not in (select top((@PageIndex-1)*@PageSize) StuId from Student)
```
