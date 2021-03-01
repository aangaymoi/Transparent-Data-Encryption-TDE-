-- enabled file stream
-- sql server configuration manager
-- choose enable filestream and then run below command, afterward restart sqlserver instances

EXEC sp_configure filestream_access_level, 2
RECONFIGURE;

declare @data varchar(64) = 'c:\YOURPATH'
declare @dbname varchar(64) = 'YOURDB'

DECLARE @sql varchar(max) = '
--~~~~~
USE [MASTER]
--Step 1
EXEC master.dbo.xp_create_subdir ''{DATA}\Primary''
EXEC master.dbo.xp_create_subdir ''{DATA}\FG01''
EXEC master.dbo.xp_create_subdir ''{DATA}\FG02''
EXEC master.dbo.xp_create_subdir ''{DATA}\FG03''
EXEC master.dbo.xp_create_subdir ''{DATA}\FG04''
EXEC master.dbo.xp_create_subdir ''{DATA}\FG05''
EXEC master.dbo.xp_create_subdir ''{DATA}\FG06''
EXEC master.dbo.xp_create_subdir ''{DATA}\FG07''
EXEC master.dbo.xp_create_subdir ''{DATA}\FG08''

--Step 2
--Let us assume that we have a database, "{DBNAME}," with five different file groups, as shown below.
use master;
IF  EXISTS (SELECT name FROM sys.databases WHERE name = ''{DBNAME}'')
	DROP DATABASE {DBNAME}

CREATE DATABASE {DBNAME}
      ON PRIMARY
       (NAME=''{DBNAME} Primary'',
        FILENAME=
          ''{DATA}\Primary\{DBNAME} Primary.mdf'',
        SIZE=5,
        MAXSIZE=UNLIMITED,
        FILEGROWTH=1 ),
      FILEGROUP [{DBNAME} FG01]
       (NAME = ''{DBNAME} FG01'',
        FILENAME =
         ''{DATA}\FG01\{DBNAME} FG01.ndf'',
        SIZE = 5MB,
        MAXSIZE=UNLIMITED,
        FILEGROWTH=1 ),
      FILEGROUP [{DBNAME} FG02]
       (NAME = ''{DBNAME} FG02'',
        FILENAME =
         ''{DATA}\FG02\{DBNAME} FG02.ndf'',
        SIZE = 5MB,
        MAXSIZE=UNLIMITED,
        FILEGROWTH=1 ),
      FILEGROUP [{DBNAME} FG03]
       (NAME = ''{DBNAME} FG03'',
        FILENAME =
         ''{DATA}\FG03\{DBNAME} FG03.ndf'',
        SIZE = 5MB,
        MAXSIZE=UNLIMITED,
        FILEGROWTH=1 ),
      FILEGROUP [{DBNAME} FG04]
       (NAME = ''{DBNAME} FG04'',
        FILENAME =
         ''{DATA}\FG04\{DBNAME} FG04.ndf'',
        SIZE = 5MB,
        MAXSIZE=UNLIMITED,
        FILEGROWTH=1),
      FILEGROUP [{DBNAME} FG05]
       (NAME = ''{DBNAME} FG05'',
        FILENAME =
         ''{DATA}\FG05\{DBNAME} FG05.ndf'',
        SIZE = 5MB,
        MAXSIZE=UNLIMITED,
        FILEGROWTH=1),
      FILEGROUP [{DBNAME} FG06]
       (NAME = ''{DBNAME} FG06'',
        FILENAME =
         ''{DATA}\FG06\{DBNAME} FG06.ndf'',
        SIZE = 5MB,
        MAXSIZE=UNLIMITED,
        FILEGROWTH=1),
      FILEGROUP [{DBNAME} FG07]
       (NAME = ''{DBNAME} FG07'',
        FILENAME =
         ''{DATA}\FG07\{DBNAME} FG07.ndf'',
        SIZE = 5MB,
        MAXSIZE=UNLIMITED,
        FILEGROWTH=1),
      FILEGROUP [{DBNAME} FG08]
       (NAME = ''{DBNAME} FG08'',
        FILENAME =
         ''{DATA}\FG08\{DBNAME} FG08.ndf'',
        SIZE = 5MB,
        MAXSIZE=UNLIMITED,
        FILEGROWTH=1)

	, FILEGROUP [FS0] CONTAINS FILESTREAM DEFAULT
		(NAME = ''FS0'',
		FILENAME = ''{DATA}\Primary\FS0'')
	, FILEGROUP [FS1] CONTAINS FILESTREAM
		(NAME = ''FS1'',
		FILENAME = ''{DATA}\FG01\FS1'')
	, FILEGROUP [FS2] CONTAINS FILESTREAM
		(NAME = ''FS2'',
		FILENAME = ''{DATA}\FG02\FS2'')
	, FILEGROUP [FS3] CONTAINS FILESTREAM
		(NAME = ''FS3'',
		FILENAME = ''{DATA}\FG03\FS3'')
	, FILEGROUP [FS4] CONTAINS FILESTREAM
		(NAME = ''FS4'',
		FILENAME = ''{DATA}\FG04\FS4'')
	, FILEGROUP [FS5] CONTAINS FILESTREAM
		(NAME = ''FS5'',
		FILENAME = ''{DATA}\FG05\FS5'')
	, FILEGROUP [FS6] CONTAINS FILESTREAM
		(NAME = ''FS6'',
		FILENAME = ''{DATA}\FG06\FS6'')
	, FILEGROUP [FS7] CONTAINS FILESTREAM
		(NAME = ''FS7'',
		FILENAME = ''{DATA}\FG07\FS7'')
	, FILEGROUP [FS8] CONTAINS FILESTREAM
		(NAME = ''FS8'',
		FILENAME = ''{DATA}\FG08\FS8'')'

select @sql = REPLACE(@sql, '{DATA}', @data)
select @sql = REPLACE(@sql, '{DBNAME}', @dbname)

EXECUTE (@sql)

--~~~~~
-- Setup iFilters for pdf, docx, pptx. Reload system
-- See: documents\sql\ifilter

--~~~~~
EXEC sp_configure 'show advanced options', 1;
GO  
RECONFIGURE WITH OVERRIDE;  
GO  
EXEC sp_configure 'max degree of parallelism', 8; --cores
GO  
RECONFIGURE WITH OVERRIDE;
GO  

--~~~~~
exec sp_configure 'advanced',1
GO
RECONFIGURE
GO
exec sp_configure 'cost threshold for parallelism', 25;
GO
RECONFIGURE
GO
exec sp_configure 'cost threshold for parallelism'

--~~~~~
DBCC TRACESTATUS
--make sure -T272 is trace on


