declare @username varchar(64) = 'YOURDB-USERNAME'

DECLARE @sql varchar(max) = '

USE [msdb]
IF EXISTS (SELECT * FROM sys.server_principals WHERE name = N''{USERNAME}'')
BEGIN	
	DROP LOGIN [{USERNAME}];
END

CREATE LOGIN [{USERNAME}] WITH
PASSWORD = ''YOURDB-USERNAME-PASSWORD'',
CHECK_EXPIRATION = OFF,
CHECK_POLICY = OFF,
DEFAULT_DATABASE = [master],
DEFAULT_LANGUAGE = [us_english]
'

select @sql = REPLACE(@sql, '{USERNAME}', @username)
EXECUTE (@sql)
