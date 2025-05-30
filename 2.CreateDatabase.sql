if exists(select * from sys.databases where name = 'DBTEST')
	drop database DBTEST  -- First check if database exists before dropping (for learning purposes only, avoid in production)
-- Create database
create database DBTEST
on -- Data file
(
	name = 'DBTEST', -- Logical name
	filename = 'D:\SQL_DATA\DBTEST.mdf', -- Physical path
	size = 5MB, -- Initial size
	filegrowth = 2MB -- Growth increment (can also specify percentage)
)
log on -- Log file
(
	name = 'DBTEST_log', -- Logical name
	filename = 'D:\SQL_DATA\DBTEST_log.ldf', -- Physical path
	size = 5MB, -- Initial size
	filegrowth = 2MB -- Growth increment (can also specify percentage)
)

-- Simple database creation with system defaults
create database DBTEST
