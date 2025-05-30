# Fuzzy Queries

Fuzzy queries use the LIKE keyword combined with wildcards. The wildcards have the following meanings:

```
% : Matches zero, one, or multiple characters
_ : Matches exactly one character
[] : Matches any single character within the specified range
[^] : Matches any single character not within the specified range
```

(1) Query employees with surname "Liu"

```
select * from People where PeopleName like 'Liu%'
```

(2) Query employees whose name contains "Shang"

```
select * from People where PeopleName like '%Shang%'
```

(3) Query employees whose name contains either "Shang" or "Shi"

```
select * from People where PeopleName like '%Shang%' or PeopleName like '%Shi%'
```

(4) Query employees with surname "Liu" and two-character names

```
-- Option 1:
select * from People where PeopleName like 'Liu_'
-- Option 2:
select * from People where SUBSTRING(PeopleName,1,1) = 'Liu' and LEN(PeopleName) = 2
```

(5) Query employees whose name ends with "Xiang" and has exactly three characters

```
-- Option 1:
select * from People where PeopleName like '__Xiang'
-- Option 2:
select * from People where SUBSTRING(PeopleName,3,1) = 'Xiang' and LEN(PeopleName) = 3
```

(6) Query employees with phone numbers starting with 138

```
select * from People where PeoplePhone like '138%'
```

(7) Query employees with phone numbers starting with 138, where the 4th digit may be 7 or 8, and the last digit is 5

```
select * from People where PeoplePhone like '138[7,8]%5'
```

(8) Query employees with phone numbers starting with 133, where the 4th digit is between 2-5, and the last digit is neither 2 nor 3

```
-- Option 1:
select * from People where PeoplePhone like '133[2,3,4,5]%[^2,3]'
-- Option 2:
select * from People where PeoplePhone like '133[2-5]%[^2-3]'
```
