# Database Design

## 1. Three Paradigms of Database Structure Design

**First Normal Form:** Requires atomicity of attributes, meaning attributes cannot be further decomposed.

Example table structure:

```
create table Student --Student table
(
    StuId varchar(20) primary key, --Student ID
    StuName varchar(20) not null, --Student name
    StuContact varchar(50) not null, --Contact info
)
insert into Student(StuId,StuName,StuContact) 
values('001','Liu Bei','QQ:185699887;Tel:13885874587')
select * from Student
```

This design violates 1NF because the contact column can be further divided. Correct structure:

```
create table Student --Student table
(
    StuId varchar(20) primary key, --Student ID
    StuName varchar(20) not null, --Student name
    Tel varchar(20) not null, --Phone number
    QQ varchar(20) not null,  --QQ number
)
```

**Second Normal Form:** Requires unique identification of records, ensuring entity uniqueness with no partial dependencies.

Example violating 2NF:

```
--Course selection table
create table StudentCourse
(
    StuId varchar(20), --Student ID
    StuName varchar(20) not null, --Student name
    CourseId varchar(20) not null, --Course ID
    CourseName varchar(20) not null, --Course name
    CourseScore int not null, --Exam score
)
```

This design mixes student and course information without proper separation. Correct approach:

```
create table Course --Course
(
    CourseId int primary key identity(1,1), --Course ID
    CourseName varchar(30) not null, --Course name
    CourseContent text --Course description
)

create table Student --Student
(
    StuId int primary key identity(1,1), --Student ID
    StuName varchar(50) not null, --Student name
    StuSex char(2) not null --Gender
)

create Table Exam --Exam info
(
    ExamId int primary key identity(1,1), --Exam ID
    StuId int not null, --Student ID
    CourseId int not null,  --Course ID
    Score int not null, --Score
)
```

**Third Normal Form:** Requires no derived fields and eliminates redundancy (no transitive dependencies).

Example violating 3NF:

```
create table Student
(
    StuId varchar(20) primary key, --Student ID
    StuName varchar(20) not null, --Student name
    ProfessionalId int not null, --Major ID
    ProfessionalName varchar(50), --Major name
    ProfessionalRemark varchar(200), --Major description
)
```

This creates redundancy in major information. Correct approach:

```
create table Professional
(
    ProfessionalId int primary key identity(1,1), --Major ID
    ProfessionalName varchar(50), --Major name
    ProfessionalRemark varchar(200) --Major description
)

create table Student
(
    StuId varchar(20) primary key, --Student ID
    StuName varchar(20) not null, --Student name
    ProfessionalId int not null, --Major ID
)
```

## 2. Table Relationships

**(1) One-to-Many (Major-Student)**

```
create table Profession  --Major
(
    ProId int primary key identity(1,1), --Major ID
    ProName varchar(50) not null --Major name
)

create table Student --Student
(
    StuId int primary key identity(1,1), --Student ID
    ProId int references Profession(ProId), --Major ID
    StuName varchar(50) not null, --Student name
    StuSex char(2) not null --Gender
)
```

**(2) One-to-One (Basic Student Info - Student Details)**

Option 1:
```
create table StudentBasicInfo  --Basic info
(
    StuNo varchar(20) primary key not null,  --Student ID
    StuName varchar(20) not null, --Name
    StuSex nvarchar(1) not null  --Gender
)

create table StudentDetailInfo  --Details
(
    StuNo varchar(20) primary key not null, --Student ID
    StuQQ varchar(20), --QQ
    stuPhone varchar(20), --Phone
    StuMail varchar(100), --Email
    StuBirth date         --Birthday
)
```

Option 2 (better for auto-increment IDs):
```
create table StudentBasicInfo  --Basic info
(
    StuNo int primary key identity(1,1),  --Student ID
    StuName varchar(20) not null, --Name
    StuSex nvarchar(1) not null  --Gender
)

create table StudentDetailInfo  --Details
(
    StuDetailNo int primary key identity(1,1),  --Detail ID
    StuNo int references StudentBasicInfo(StuNo), --Student ID
    StuQQ varchar(20), --QQ
    stuPhone varchar(20), --Phone
    StuMail varchar(100), --Email
    StuBirth date         --Birthday
)
```

**(3) Many-to-Many (Student-Course)**

```
create table Course --Course
(
    CourseId int primary key identity(1,1), --Course ID
    CourseName varchar(30) not null, --Course name
    CourseContent text --Description
)

create table Student --Student
(
    StuId int primary key identity(1,1), --Student ID
    StuName varchar(50) not null, --Student name
    StuSex char(2) not null --Gender
)

create Table Exam --Exam
(
    ExamId int primary key identity(1,1), --Exam ID
    StuId int not null, --Student ID
    CourseId int not null,  --Course ID
    Score int not null, --Score
)
```

## 3. Database Design Case: Banking System

**Requirements:**
1. Account opening (personal info) and card issuance (max 3 cards per person)
2. Deposit
3. Balance inquiry
4. Withdrawal
5. Transfer
6. Transaction history
7. Card loss reporting
8. Account closure

**Table Design:**

```
--Account info
create table AccountInfo
(
    AccountId int primary key identity(1,1), --Account ID
    AccountCode varchar(20) not null, --ID number
    AccountPhone varchar(20) not null, --Phone
    RealName varchar(20) not null, --Name
    OpenTime smalldatetime not null, --Open time
)

--Bank card
create table BankCard
(
    CardNo varchar(30) primary key, --Card number
    AccountId int not null, --Account ID
    CardPwd varchar(30) not null, --Password
    CardMoney money not null, --Balance
    CardState int not null, --1:Normal, 2:Lost, 3:Frozen, 4:Closed
    CardTime smalldatetime default(getdate()) --Issue time
)

--Transactions
create table CardExchange
(
    ExchangeId int primary key identity(1,1), --Transaction ID
    CardNo varchar(30) not null, --Card number
    MoneyInBank money not null, --Deposit amount
    MoneyOutBank money not null, --Withdrawal amount
    ExchangeTime smalldatetime not null, --Time
)

--Transfers
create table CardTransfer
(
    TransferId int primary key identity(1,1), --Transfer ID
    CardNoOut varchar(30) not null, --Sender card
    CardNoIn varchar(30) not null, --Receiver card
    TransferMoney money not null, --Amount
    TransferTime smalldatetime not null, --Time
)

--Status changes
create table CardStateChange
(
    StateId int primary key identity(1,1), --Change ID
    CardNo varchar(30) not null, --Card number
    OldState int not null, --Previous state
    NewState int not null, --New state
    StateWhy varchar(200) not null, --Reason
    StateTime smalldatetime not null, --Time
)
```

**Test Data:**

```
--Open accounts for Liu Bei, Guan Yu, Zhang Fei
insert into AccountInfo(AccountCode,AccountPhone,RealName,OpenTime)
values('420107198905064135','13554785425','Liu Bei',GETDATE())
insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
values('6225125478544587',1,'123456',0,1)

insert into AccountInfo(AccountCode,AccountPhone,RealName,OpenTime)
values('420107199507104133','13454788854','Guan Yu',GETDATE())
insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
values('6225547858741263',2,'123456',0,1)

insert into AccountInfo(AccountCode,AccountPhone,RealName,OpenTime)
values('420107199602034138','13456896321','Zhang Fei',GETDATE())
insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
values('6225547854125656',3,'123456',0,1)

--Deposits
update BankCard set CardMoney = CardMoney + 2000 where CardNo = '6225125478544587'
insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
values('6225125478544587',2000,0,GETDATE())

update BankCard set CardMoney = CardMoney + 8000 where CardNo = '6225547858741263'
insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
values('6225547858741263',8000,0,GETDATE())

update BankCard set CardMoney = CardMoney + 500000 where CardNo = '6225547854125656'
insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
values('6225547854125656',500000,0,GETDATE())

--Transfer: Liu Bei to Zhang Fei 1000
update BankCard set CardMoney = CardMoney -1000 where CardNo = '6225125478544587'
update BankCard set CardMoney = CardMoney + 1000 where CardNo = '6225547854125656'
insert into CardTransfer(CardNoOut,CardNoIn,TransferMoney,TransferTime)
values('6225125478544587','6225547854125656',1000,GETDATE())
