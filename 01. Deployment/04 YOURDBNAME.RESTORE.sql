declare @data varchar(64)     = 'c:\YOURPATH'
declare @dbname varchar(64)   = 'YOURDBNAME'
declare @cert varchar(64)     = 'YOURDBCERTNAME'
declare @certPass varchar(64) = 'CERT-PASSWORD'
declare @bakPass varchar(64)  = 'BAKPASSWORD'

DECLARE @sql varchar(max) = '
--Restoring the Certificate
USE master

-- enabled file stream
-- sql server configuration manager
-- choose enable filestream and then run below command, afterward restart sqlserver instances

EXEC sp_configure filestream_access_level, 2
RECONFIGURE

CREATE MASTER KEY ENCRYPTION BY PASSWORD = ''{CERTPASS}''

CREATE CERTIFICATE {CERTIFICATE}
 FROM FILE=''{DATA}\{CERTIFICATE}.certbak''
 WITH PRIVATE KEY(FILE=''{DATA}\{CERTIFICATE}.pkbak''
			, DECRYPTION BY PASSWORD=''{BAKPASS}'')

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

USE [master]
RESTORE DATABASE [{DBNAME}] FROM  DISK = N''{DATA}\{DBNAME}.BAK'' WITH NOUNLOAD,  REPLACE,  STATS = 5
'

select @sql = REPLACE(@sql, '{DATA}', @data)
select @sql = REPLACE(@sql, '{DBNAME}', @dbname)
select @sql = REPLACE(@sql, '{CERTIFICATE}', @cert)
select @sql = REPLACE(@sql, '{CERTPASS}', @certPass)
select @sql = REPLACE(@sql, '{BAKPASS}', @bakPass)

EXECUTE (@sql)


