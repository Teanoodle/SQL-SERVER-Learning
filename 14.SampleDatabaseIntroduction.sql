-- Bank business scenario: Simulates a simple banking system database structure with the following core functions:
-- 1. Account opening (one person can open multiple accounts, maximum 3 cards)
-- 2. Deposit money
-- 3. Check balance
-- 4. Withdraw money
-- 5. Transfer funds
-- 6. View transaction history
-- 7. Report lost card
-- 8. Close account

-- Database design: -----------------------------------------------------------

-- 1. AccountInfo - stores customer information
-- 2. BankCard - stores bank card information
-- 3. CardExchange - stores deposit/withdrawal records
-- 4. CardTransfer - stores fund transfer records
-- 5. CardStateChange - stores card status changes (1: normal, 2: lost, 3: frozen, 4: closed)

-- Table structure design:
create table AccountInfo -- Account information
(
	AccountId int primary key identity(1,1), -- Account ID
	AccountCode varchar(20) not null, -- ID card number
	AccountPhone varchar(20) not null, -- Phone number
	RealName varchar(20) not null, -- Real name
	OpenTime smalldatetime not null -- Account opening time
)

create table BankCard -- Bank card
(
	CardNo varchar(30) primary key, -- Card number
	AccountId int not null, -- Account ID (foreign key to AccountInfo)
	CardPwd varchar(30) not null, -- Card password
	CardMoney money not null, -- Card balance
	CardState int not null, -- 1: normal, 2: lost, 3: frozen, 4: closed
	CardTime smalldatetime default(getdate()) -- Card creation time
)

create table CardExchange -- Transaction records (stores deposit/withdrawal)
(
	ExchangeId int primary key identity(1,1), -- Auto-increment ID
	CardNo varchar(30) not null, -- Card number (foreign key to BankCard)
	MoneyInBank money not null, -- Deposit amount
	MoneyOutBank money not null, -- Withdrawal amount
	ExchangeTime smalldatetime not null, -- Transaction time
)

-- Stores fund transfer records
create table CardTransfer
(
	TransferId int primary key identity(1,1),-- Auto-increment ID
	CardNoOut varchar(30) not null, -- Source card number (foreign key to BankCard)
	CardNoIn varchar(30) not null, -- Destination card number (foreign key to BankCard)
	TransferMoney money not null,-- Transfer amount
	TransferTime smalldatetime not null, -- Transfer time
)

-- Stores card status change history (1: normal, 2: lost, 3: frozen, 4: closed)
create table CardStateChange
(
	StateId int primary key identity(1,1),-- Auto-increment ID
	CardNo varchar(30) not null, -- Card number (foreign key to BankCard)
	OldState int not null, -- Previous status
	NewState int not null, -- New status
	StateWhy varchar(200) not null, -- Reason for change
	StateTime smalldatetime not null, -- Change time
)

-- Sample data: Three customers open accounts
-- John's ID: 420107198905064135
-- Mary's ID: 420107199507104133
-- Mike's ID: 420107199602034138
insert into AccountInfo(AccountCode,AccountPhone,RealName,OpenTime)
values('420107198905064135','13554785425','John',GETDATE())
insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
values('6225125478544587',1,'123456',0,1)

insert into AccountInfo(AccountCode,AccountPhone,RealName,OpenTime)
values('420107199507104133','13454788854','Mary',GETDATE())
insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
values('6225547858741263',2,'123456',0,1)

insert into AccountInfo(AccountCode,AccountPhone,RealName,OpenTime)
values('420107199602034138','13456896321','Mike',GETDATE())
insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
values('6225547854125656',3,'123456',0,1)

select * from AccountInfo
select * from BankCard

-- Deposit transactions:
-- John deposits 2000
-- Mary deposits 8000
-- Mike deposits 500000
select * from AccountInfo
update BankCard set CardMoney = CardMoney + 2000 where CardNo = '6225125478544587'
insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
values('6225125478544587',2000,0,GETDATE())

update BankCard set CardMoney = CardMoney + 8000 where CardNo = '6225547858741263'
insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
values('6225547858741263',8000,0,GETDATE())

update BankCard set CardMoney = CardMoney + 500000 where CardNo = '6225547854125656'
insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
values('6225547854125656',500000,0,GETDATE())

select * from AccountInfo
select * from BankCard
select * from CardExchange

-- Transfer: John transfers 1000 to Mike
update BankCard set CardMoney = CardMoney -1000 where CardNo = '6225125478544587'
update BankCard set CardMoney = CardMoney + 1000 where CardNo = '6225547854125656'
insert into CardTransfer(CardNoOut,CardNoIn,TransferMoney,TransferTime)
values('6225125478544587','6225547854125656',1000,GETDATE())
select * from CardTransfer
