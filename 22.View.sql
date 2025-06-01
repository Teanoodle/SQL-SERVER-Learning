use DBTEST
--Query all account holder information, display card number, ID number, name and balance.
select CardNo as CardNumber, AccountCode as IDNumber, RealName as Name, CardMoney as Balance from BankCard
inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId

--Create a view to encapsulate this query
create view View_Account_Card
as
select CardNo as CardNumber, AccountCode as IDNumber, RealName as Name, CardMoney as Balance from BankCard
inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
go

select * from View_Account_Card
--Drop the view
drop view View_Account_Card
