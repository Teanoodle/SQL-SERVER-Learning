# Transactions, Indexes, Views and Cursors

## 1. Transactions

Sample account information (ID number, card number):
--Liu Bei 420107198905064135 6225125478544587
--Guan Yu 420107199507104133 6225547858741263
--Zhang Fei 420107199602034138 6225547854125656

(1) Withdraw 6000 from Liu Bei's account (with CHECK constraint ensuring balance >= 0):

```
begin transaction
declare @MyError int = 0
update BankCard set CardMoney = CardMoney-6000 where CardNo = '6225125478544587'
set @MyError = @MyError + @@ERROR
insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
values('6225125478544587',0,6000,GETDATE())
set @MyError = @MyError + @@ERROR
if @MyError = 0
begin
    commit transaction
    print 'Withdrawal successful'
end    
else
begin
    rollback transaction
    print 'Insufficient balance'
end
```

(2) Transfer 1000 from Liu Bei to Zhang Fei (3 steps: deduct, add, record):

```
begin transaction
declare @Error int = 0
update BankCard set CardMoney = CardMoney -1000 where CardNo = '6225125478544587'
set @Error = @@ERROR + @Error
update BankCard set CardMoney = CardMoney + 1000 where CardNo = '6225547854125656'
set @Error = @@ERROR + @Error
insert into CardTransfer(CardNoOut,CardNoIn,TransferMoney,TransferTime)
values('6225125478544587','6225547854125656',1000,GETDATE())
set @Error = @@ERROR + @Error
if @Error = 0
    begin
        commit
        print 'Transfer successful'
    end
else
    begin
        rollback
        print 'Transfer failed'        
    end
```

## 2. Indexes

Indexes improve query efficiency.

**SQL Server index types by storage:**
- Clustered index: Sorts and stores data rows based on key values (physical order). Only one per table.
- Nonclustered index: Separate structure with pointers to data (logical order).

**Other classifications:**
- By uniqueness: Unique vs non-unique
- By columns: Single-column vs multi-column

**Creating indexes:**
1. Explicit CREATE INDEX command
2. Implicitly through constraints (PRIMARY KEY = clustered, UNIQUE = unique index)

**Syntax:**
```
CREATE [UNIQUE] [CLUSTERED | NONCLUSTERED]
INDEX <index name> ON <table or view>(<column> [ASC|DESC][,...n])
```

**Examples:**
```
--Create nonclustered index
--create nonclustered index indexAccount on AccountInfo(AccountCode)
--Drop index
--drop index indexAccount on AccountInfo
```

**Query using specific index:**
```
select * from AccountInfo with(index=indexAccount) where AccountCode='6225125478544587'
```

## 3. Views

Views act as virtual tables.

(1) Create view showing card and account info:

```
create view CardAndAccount as
select 
    CardNo as 'CardNumber',
    AccountCode as 'ID', 
    RealName as 'Name',
    CardMoney as 'Balance' 
from BankCard 
left join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
go
```

Query using view:
```
select * from CardAndAccount
```

## 4. Cursors

Cursors allow row-by-row processing.

**Cursor types:**
1. Static: Data snapshot (changes not reflected)
2. Dynamic: Reflects all changes (default)
3. Keyset: Reflects changes only to key columns

Sample table:
```
create table Member
(
    MemberId int primary key identity(1,1),
    MemberAccount nvarchar(20) unique check(len(MemberAccount) between 6 and 12),
    MemberPwd nvarchar(20),
    MemberNickname nvarchar(20),
    MemberPhone nvarchar(20)
)
--Insert statements omitted...
```

**Cursor operations:**

Create cursor:
```
declare CURSORMember cursor scroll 
for select MemberAccount from Member
```

Open cursor:
```
open CURSORMember
```

Fetch data:
```
fetch first from CURSORMember --First row
fetch last from CURSORMember  --Last row
fetch absolute 1 from CURSORMember --Row n from start
fetch relative 3 from CURSORMember --Row n from current
fetch next from CURSORMember --Next row
fetch prior from CURSORMember --Previous row
```

Fetch into variable:
```
declare @MemberAccount varchar(30)
fetch absolute 3 from CURSORMember into @MemberAccount
select * from Member where MemberAccount = @MemberAccount
```

Iterate through all rows:
```
--Option 1:
fetch absolute 1 from CURSORMember
while @@FETCH_STATUS = 0  --0=success, -1=failure, -2=missing
    begin
        fetch next from CURSORMember
    end
    
--Option 2:
declare @MemberAccount varchar(30)
fetch absolute 1 from CURSORMember into @MemberAccount
while @@FETCH_STATUS = 0
    begin
        print 'Success:' + @MemberAccount
        fetch next from CURSORMember into @MemberAccount
    end
```

Update/delete using cursor:
```
fetch absolute 3 from CURSORMember
update Member set MemberPwd = '1234567' where Current of CURSORMember

fetch absolute 3 from CURSORMember
delete Member where Current of CURSORMember
```

Close and deallocate:
```
close CURSORMember
deallocate CURSORMember
```

Multi-column cursor:
```
declare CURSORMember cursor scroll
for select MemberAccount,MemberPwd,MemberNickname,MemberPhone from Member

open CURSORMember

declare @MemberAccount varchar(30)
declare @MemberPwd nvarchar(20)
declare @MemberNickname nvarchar(20)
declare @MemberPhone nvarchar(20)
fetch next from CURSORMember into @MemberAccount,@MemberPwd,@MemberNickname,@MemberPhone
while @@FETCH_STATUS = 0
    begin
        print 'Success:' + @MemberAccount+','+@MemberPwd+','+@MemberNickname+','+@MemberPhone
        fetch next from CURSORMember into @MemberAccount,@MemberPwd,@MemberNickname,@MemberPhone
    end
close CURSORMember
```
