# T-SQL Programming

## 1. Message Printing

```
--print: Directly prints a message
--select: Prints message in table format, can set multiple columns and their names
```

## 2. Variables

**T-SQL has local variables and global variables**

**Local Variables: (1) Prefixed with @ (2) Must be declared before assignment**

```
declare @str varchar(20)
set @str = 'I love database programming' --or select @str = 'I love database programming'
print @str
```

Note: Differences between set and select assignment:

set: Assigns specified value to variable

select: Typically used for data queried from tables. If query returns multiple records, assigns value from last record to variable, e.g.:

```
select @variable_name = field_name from table_name
```

For single-record queries, both set and select work, but select is conventionally preferred.

**Global Variables: (1) Prefixed with @@ (2) System-defined and maintained, read-only**

```
--@@ERROR: Error number of last executed statement
--@@IDENTITY: Last inserted identity value  
--@@MAX_CONNECTIONS: Maximum allowed user connections
--@@ROWCOUNT: Number of rows affected by last statement
--@@SERVERNAME: Local SQL Server name
--@@SERVICENAME: Registry key name under which SQL Server runs  
--@@TRANCOUNT: Number of active transactions for current connection
--@@LOCK_TIMEOUT: Current lock timeout setting (ms) for session
```

**Variable Examples:**

(1) Open account and issue card for Zhao Yun (ID: 420107199904054233)

```
declare @AccountId int
insert into AccountInfo(AccountCode,AccountPhone,RealName,OpenTime)
values('420107199904054233','15878547898','Zhao Yun',GETDATE())
set @AccountId = @@identity
insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
values('6225123412357896',@AccountId,'123456',0,1)
```

(2) Get Zhang Fei's card number and balance (ID: 420107199602034138)

```
--Option 1: Join query
select CardNo as 'Card Number', CardMoney as 'Balance' from BankCard 
left join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
where AccountCode = '420107199602034138'

--Option 2: Using variables
declare @AccountId int
select @AccountId = (select AccountId from AccountInfo where AccountCode = '420107199602034138')
select CardNo as 'Card Number', CardMoney as 'Balance' from BankCard where BankCard.AccountId = @AccountId
```

## 3. GO Statement

GO statement:

(1) Waits for code before GO to complete before executing subsequent code

(2) Marks end of batch statement

```
--Below @num has global scope
--declare @num int  
--set @num = 0

--Below @num has local scope (only between GO statements), last line would error
--.........sql code
--go
--declare @num int
--set @num = 0  
--go
--set @num = 1
```
