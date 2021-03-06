declare @dbname varchar(64)   = 'YOURDB'
declare @username varchar(64) = 'YOURDB-USERNAME'

DECLARE @sql varchar(max) = '
use {DBNAME}

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N''{USERNAME}'' AND type in (''U'', ''S'', ''C'', ''K''))
BEGIN
	DROP USER [{USERNAME}];
END

CREATE USER [{USERNAME}] FOR LOGIN [{USERNAME}] WITH DEFAULT_SCHEMA=[dbo];

EXEC sp_addrolemember N''db_owner'', N''{USERNAME}''

-- grant access on schema
-- GRANT SELECT, INSERT, UPDATE ON ACCOUNT TO {USERNAME}

-- grant access for database permission
-- GRANT CREATE TABLE TO {USERNAME};
'

select @sql = REPLACE(@sql, '{DBNAME}', @DBNAME)
select @sql = REPLACE(@sql, '{USERNAME}', @USERNAME)
EXECUTE (@sql)