use DBTEST
--Query without index
select * from AccountInfo where AccountCode = '420107199507104133'

--Create unique nonclustered index on AccountCode column in AccountInfo table
create unique nonclustered index index_code
on AccountInfo(AccountCode)
--with
--(
	--FILLFACTOR
	--PAD_INDEX
	--SORT_IN_TEMPDB
	--...
--)
--View index in sys.indexes
select * from sys.indexes where name = 'index_code'
--Drop index
drop index index_code on AccountInfo
--Query with index hint
select * from AccountInfo with(index = index_code)
where AccountCode = '420107199507104133'
