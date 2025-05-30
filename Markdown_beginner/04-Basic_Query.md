# Basic Queries

(1) Query all rows and columns

```
-- Query all departments
SELECT * FROM Department
-- Query all ranks
SELECT * FROM [Rank]
-- Query all employee information
SELECT * FROM People
```

(2) Query specified columns (Name, Gender, Monthly Salary, Phone)

```
SELECT PeopleName,PeopleSex,PeopleSalary,PeoplePhone from People
```

(3) Query specified columns with custom English column names (Name, Gender, Monthly Salary, Phone)

```
SELECT PeopleName Name,PeopleSex Gender,PeopleSalary Salary,PeoplePhone Phone from People
```

(4) Query cities where company employees are located (no duplicate data needed)

```
select distinct PeopleAddress from People
```

(5) Assuming a 10% salary increase, query original salary and adjusted salary, display (Name, Gender, Monthly Salary, Increased Monthly Salary) (Add column query).

```
SELECT PeopleName Name,PeopleSex Gender,PeopleSalary MonthlySalary,PeopleSalary*1.1 IncreasedMonthlySalary from People
```
