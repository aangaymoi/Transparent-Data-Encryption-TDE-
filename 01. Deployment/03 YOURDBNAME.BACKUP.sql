declare @data varchar(64)     = 'c:\YOURPATH'
declare @dbname varchar(64)   = 'YOURDBNAME'

DECLARE @sql varchar(max) = '
BACKUP DATABASE [{DBNAME}] TO  DISK = N''{DATA}\{DBNAME}.BAK'' WITH NOFORMAT, NOINIT,  NAME = N''{DBNAME}-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10'

select @sql = REPLACE(@sql, '{DATA}', @data)
select @sql = REPLACE(@sql, '{DBNAME}', @dbname)

EXECUTE (@sql)