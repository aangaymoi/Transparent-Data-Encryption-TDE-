declare @data varchar(64)     = 'c:\YOURPATH'
declare @dbname varchar(64)   = 'YOURDBNAME'
declare @cert varchar(64)     = 'YOURDBCERTNAME'
declare @certPass varchar(64) = 'CERT-PASSWORD'
declare @bakPass varchar(64)  = 'BAKPASSWORD'

DECLARE @sql varchar(max) = '

--Creating a Service Master Key (SMK)
USE master
CREATE MASTER KEY ENCRYPTION BY PASSWORD = ''{CERTPASS}'' 
CREATE CERTIFICATE {CERTIFICATE} WITH SUBJECT = ''{CERTIFICATE}'' 
SELECT name, pvt_key_encryption_type_desc FROM sys.certificates WHERE name = ''{CERTIFICATE}''

USE {DBNAME}
CREATE DATABASE ENCRYPTION KEY WITH ALGORITHM = AES_256 ENCRYPTION BY SERVER CERTIFICATE {CERTIFICATE}

ALTER DATABASE {DBNAME} SET ENCRYPTION ON
SELECT
   dbs.name,
   keys.encryption_state,
   keys.percent_complete,
   keys.key_algorithm,
   keys.key_length
 FROM
   sys.dm_database_encryption_keys AS keys
   INNER JOIN sys.databases AS dbs ON keys.database_id = dbs.database_id

--1 = Unencrypted
--2 = Encryption in progress
--3 = Encrypted
--4 = Key change in progress
--5 = Decryption in progress (after ALTER DATABASE ... SET ENCRYPTION OFF)

use master;
--Backing Up the Certificate
BACKUP CERTIFICATE {CERTIFICATE} TO FILE=''{DATA}\{CERTIFICATE}.certbak''
 WITH PRIVATE KEY (
  FILE=''{DATA}\{CERTIFICATE}.pkbak'',
  ENCRYPTION BY PASSWORD=''{BAKPASS}'')'

select @sql = REPLACE(@sql, '{DATA}', @data)
select @sql = REPLACE(@sql, '{DBNAME}', @dbname)
select @sql = REPLACE(@sql, '{CERTIFICATE}', @cert)
select @sql = REPLACE(@sql, '{CERTPASS}', @certPass)
select @sql = REPLACE(@sql, '{BAKPASS}', @bakPass)

EXECUTE (@sql)