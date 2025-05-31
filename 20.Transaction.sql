use DBTEST
--Transaction: Multiple operations must either all succeed or all fail together

--Bank card information table, containing ID number and bank card number

--Sample data:
--ID: 420107198905064135 CardNo: 6225125478544587
--ID: 420107199507104133 CardNo: 6225547858741263
--ID: 420107199602034138 CardNo: 6225547854125656
--CardMoney constraint: must be greater than or equal to 0
alter table BankCard add constraint ck_money check(CardMoney >= 0)


--Case 1: Withdraw 6000 (with check constraint account balance >=0)
--Requirement: Use transaction to implement, update withdrawal record table
--Error approach:
--update BankCard set CardMoney = CardMoney - 6000 where CardNo = '6225125478544587'
--insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
--values('6225125478544587',0,6000,GETDATE())
--Check error:
--print @@ERROR   --Print error number (0 means no error)

begin transaction
declare @myError int = 0
update BankCard set CardMoney = CardMoney - 6000 where CardNo = '6225125478544587'
set @myError = @myError + @@ERROR
insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
values('6225125478544587',0,6000,GETDATE())
set @myError = @myError + @@ERROR
if @myError = 0
	begin
		commit transaction
		print 'Withdrawal successful'
	end
else
	begin
		rollback transaction
		print 'Withdrawal failed'
	end

select * from BankCard
select * from CardExchange
--Case 2: Transfer 1000 from Zhang to Zhang Fei (with check constraint account balance >=0)
--Transaction steps: 1. Zhang Fei +1000 2. Zhang -1000 3. Insert transfer record
begin transaction
declare @myerr int = 0
update BankCard set CardMoney = CardMoney + 1000 where CardNo = '6225547854125656'
set @myerr = @myerr + @@ERROR
update BankCard set CardMoney = CardMoney - 1000 where CardNo = '6225125478544587'
set @myerr = @myerr + @@ERROR

insert into CardTransfer(CardNoOut,CardNoIn,TransferMoney,TransferTime)
values('6225125478544587','6225547854125656',1000,GETDATE())
set @myerr = @myerr + @@ERROR
if @myerr = 0
	begin
		commit transaction
		print 'Transfer successful'
	end
else
	begin
		rollback transaction
		print 'Transfer failed'
	end

select * from BankCard
select * from CardTransfer
