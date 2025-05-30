# Data Modification and Deletion

## 1. Update Examples

Salary adjustment: Increase all employees' salary by 500 (batch update)

```
update People set PeopleSalary = PeopleSalary + 500
```

Increase salary by 1000 for employee with ID=8 (conditional update)

```
update People set PeopleSalary = PeopleSalary + 1000 WHERE PeopleId = 8
```

Adjust all software department (DepartmentId=1) employees with salary below 10,000 to 10,000 (multi-condition update)

```
update People set PEOPLESALARY = 10000 WHERE DepartmentId=1 and PEOPLESALARY < 10000
```

Double Liu Bei's salary and change his address to 'Beijing' (multiple column update)

```
UPDATE People SET PEOPLESALARY = PEOPLESALARY*2,PEOPLEADDRESS='Beijing' WHERE PEOPLENAME = 'Liu Bei'
```

## 2. Delete Examples

Delete all employee data

```
DELETE FROM People
```

Delete all marketing department (DepartmentId=3) employees with salary > 15,000

```
DELETE FROM People WHERE DepartmentId = 3 and PEOPLESALARY > 15000
```

## 3. Differences Between drop, truncate, and delete

drop table: Deletes the table object entirely - data, structure and the table itself are removed.

delete and truncate table: Only delete table data while keeping the table structure.

**Key differences between delete and truncate table:**

delete:
1. Can delete all data or conditionally delete specific data
2. Auto-increment IDs continue from last value (e.g. after deleting records 1-3, new records start at 4)

truncate table:
1. Only clears entire table (no conditional deletion)
2. Auto-increment IDs reset (e.g. after truncating, new records start at 1)
