use DBTEST
--1. For card "6225547858741263"
--Query cards with higher balance, showing card number, ID, name and balance
select * from BankCard
select * from AccountInfo
--Method 1 (using variable)
declare @balance money
select @balance = (select CardMoney from BankCard where CardNo = '6225547858741263')
select [CardNo] as CardNumber,[AccountCode] as ID,[RealName] as Name,[CardMoney] as Balance from BankCard
inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
where CardMoney > @balance

--Method 2 (using subquery directly)
select [CardNo] as CardNumber,[AccountCode] as ID,[RealName] as Name,[CardMoney] as Balance from BankCard
inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
where CardMoney > 
(select CardMoney from BankCard where CardNo = '6225547858741263')

--2. Query transaction details (deposit/withdrawal) for the richest account
select * from CardExchange
--Note: If multiple accounts have same max balance, this returns only one
select * from CardExchange where CardNo = 
(select top 1 CardNo from BankCard order by CardMoney desc)
--Better solution handling ties
select * from CardExchange where CardNo in
(select CardNo from BankCard where CardMoney = 
(select max(CardMoney) from BankCard) )

--3. Query accounts that have withdrawal records
select [CardNo] as CardNumber,[AccountCode] as ID,[RealName] as Name,[CardMoney] as Balance from BankCard
inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
where CardNo in 
(select CardNo from CardExchange where MoneyOutBank > 0)

--4. Query accounts with no withdrawal records
select [CardNo] as CardNumber,[AccountCode] as ID,[RealName] as Name,[CardMoney] as Balance from BankCard
inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
where CardNo not in 
(select CardNo from CardExchange where MoneyOutBank > 0)

--5. Check if card "6225547858741263" received any transfers today
select * from BankCard
update BankCard set CardMoney = CardMoney -100 where CardNo = '6225547854125656'
update BankCard set CardMoney = CardMoney +100 where CardNo = '6225547858741263'
insert into CardTransfer(CardNoOut,CardNoIn,TransferMoney,TransferTime)
values('6225547854125656','6225547858741263',100,GETDATE())

if exists(select * from CardTransfer where CardNoIn = '6225547858741263'
and
convert(varchar(22),getdate(),23) = convert(varchar(22),TransferTime,23) )
    begin
        print 'Received transfer today'
    end
else
    begin
        print 'No transfers received today'
    end


--6. Query account(s) with most transactions (deposit/withdrawal)
select * from CardExchange
select count(*) from CardExchange
select CardNo,count(*) as TransactionCount from CardExchange group by CardNo

--Method 1 (returns only one account if tie)
select top 1 BankCard.CardNo as CardNumber,[AccountCode] as ID,[RealName] as Name,
[CardMoney] as Balance, Temp.myCount as TransactionCount from BankCard
inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
inner join 
(select CardNo,count(*) myCount from CardExchange group by CardNo) Temp
on BankCard.CardNo = Temp.CardNo
order by Temp.myCount desc
--Method 2 (handles ties)
select BankCard.CardNo as CardNumber,[AccountCode] as ID,[RealName] as Name,
[CardMoney] as Balance, Temp.myCount as TransactionCount from BankCard
inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
inner join 
(select CardNo,count(*) myCount from CardExchange group by CardNo) Temp
on BankCard.CardNo = Temp.CardNo
where Temp.myCount = (
select max(Temp.myCount) maxcount from 
(select CardNo,count(*) myCount from CardExchange group by CardNo) Temp
)

--7. Query accounts with no transfer records (neither sent nor received)
select * from CardTransfer
select * from AccountInfo
select * from BankCard
select BankCard.CardNo as CardNumber,[AccountCode] as ID,[RealName] as Name,
[CardMoney] as Balance from BankCard
inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
where 
CardNo not in (select CardNoOut from CardTransfer)
and 
CardNo not in (select CardNoIn from CardTransfer)
