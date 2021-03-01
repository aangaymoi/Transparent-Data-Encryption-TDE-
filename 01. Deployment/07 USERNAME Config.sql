
DECLARE @DBNAME VARCHAR(255)
SET @DBNAME = '[YOURDB]'

DECLARE @USERNAME VARCHAR(255)
SET @USERNAME = 'YOURDB-USERNAME'

DECLARE @sql varchar(max) = '
use {DBNAME}

DENY                          ALTER                                     TO {USERNAME};
DENY                          ALTER ANY APPLICATION ROLE                TO {USERNAME};
DENY                          ALTER ANY ASSEMBLY                        TO {USERNAME};
DENY                          ALTER ANY ASYMMETRIC KEY                  TO {USERNAME};
DENY                          ALTER ANY CERTIFICATE                     TO {USERNAME};
DENY                          ALTER ANY CONTRACT                        TO {USERNAME};
DENY                          ALTER ANY DATABASE AUDIT                  TO {USERNAME};
DENY                          ALTER ANY DATABASE DDL TRIGGER            TO {USERNAME};
DENY                          ALTER ANY DATABASE EVENT NOTIFICATION     TO {USERNAME};
DENY                          ALTER ANY DATASPACE                       TO {USERNAME};
DENY                          ALTER ANY FULLTEXT CATALOG                TO {USERNAME};
DENY                          ALTER ANY MESSAGE TYPE                    TO {USERNAME};
DENY                          ALTER ANY REMOTE SERVICE BINDING          TO {USERNAME};
DENY                          ALTER ANY ROLE                            TO {USERNAME};
DENY                          ALTER ANY ROUTE                           TO {USERNAME};
DENY                          ALTER ANY SCHEMA                          TO {USERNAME};
DENY                          ALTER ANY SERVICE                         TO {USERNAME};
DENY                          ALTER ANY SYMMETRIC KEY                   TO {USERNAME};
DENY                          ALTER ANY USER                            TO {USERNAME};
GRANT                         AUTHENTICATE                              TO {USERNAME};
GRANT                         BACKUP DATABASE                           TO {USERNAME};
GRANT                         BACKUP LOG                                TO {USERNAME};
--DENY                          CHECKPOINT                                TO {USERNAME};

-- delete from [resource] where ID=@ID checkpoint
-- this is allow clean filestream on disk immediately
GRANT                         CHECKPOINT                                TO {USERNAME};
---

GRANT                         CONNECT                                   TO {USERNAME};
GRANT                         CONNECT REPLICATION                       TO {USERNAME};
GRANT                         CONTROL                                   TO {USERNAME};
DENY                          CREATE AGGREGATE                          TO {USERNAME};
DENY                          CREATE ASSEMBLY                           TO {USERNAME};
DENY                          CREATE ASYMMETRIC KEY                     TO {USERNAME};
DENY                          CREATE CERTIFICATE                        TO {USERNAME};
DENY                          CREATE CONTRACT                           TO {USERNAME};
--GRANT                         CREATE DATABASE                           TO {USERNAME}; JUST MASTER
DENY                          CREATE DATABASE DDL EVENT NOTIFICATION    TO {USERNAME};
DENY                          CREATE DEFAULT                            TO {USERNAME};
DENY                          CREATE FULLTEXT CATALOG                   TO {USERNAME};
GRANT                         CREATE FUNCTION                           TO {USERNAME};
DENY                          CREATE MESSAGE TYPE                       TO {USERNAME};
GRANT                         CREATE PROCEDURE                          TO {USERNAME};
DENY                          CREATE QUEUE                              TO {USERNAME};
DENY                          CREATE REMOTE SERVICE BINDING             TO {USERNAME};
DENY                          CREATE ROLE                               TO {USERNAME};
DENY                          CREATE ROUTE                              TO {USERNAME};
DENY                          CREATE RULE                               TO {USERNAME};
DENY                          CREATE SCHEMA                             TO {USERNAME};
DENY                          CREATE SERVICE                            TO {USERNAME};
DENY                          CREATE SYMMETRIC KEY                      TO {USERNAME};
DENY                          CREATE SYNONYM                            TO {USERNAME};
DENY                          CREATE TABLE                              TO {USERNAME};
DENY                          CREATE TYPE                               TO {USERNAME};
GRANT                         CREATE VIEW                               TO {USERNAME};
DENY                          CREATE XML SCHEMA COLLECTION              TO {USERNAME};
GRANT                         DELETE                                    TO {USERNAME};
GRANT                         EXECUTE                                   TO {USERNAME};
GRANT                         INSERT                                    TO {USERNAME};
--GRANT                         KILL DATABASE CONNECTION                  TO {USERNAME};
DENY                          REFERENCES                                TO {USERNAME};
GRANT                         SELECT                                    TO {USERNAME};
DENY                          SHOWPLAN                                  TO {USERNAME};
DENY                          SUBSCRIBE QUERY NOTIFICATIONS             TO {USERNAME};
DENY                          TAKE OWNERSHIP                            TO {USERNAME};
GRANT                         UPDATE                                    TO {USERNAME};
GRANT                         VIEW DATABASE STATE                       TO {USERNAME};
GRANT                         VIEW DEFINITION                           TO {USERNAME};

--VA2000 - Minimal set of principals should be granted high impact database-scoped permissions
REVOKE AUTHENTICATE FROM {USERNAME};
REVOKE BACKUP DATABASE FROM {USERNAME};
REVOKE BACKUP LOG FROM {USERNAME};
REVOKE CONTROL FROM {USERNAME};

--VA2030 - Minimal set of principals should be granted database-scoped SELECT or EXECUTE permissions
REVOKE EXECUTE FROM {USERNAME};
REVOKE SELECT FROM {USERNAME};

--VA2040 - Minimal set of principals should be granted low impact database-scoped permissions
REVOKE DELETE FROM {USERNAME};
REVOKE INSERT FROM {USERNAME};
REVOKE UPDATE FROM {USERNAME};

--VA2010 - Minimal set of principals should be granted medium impact database-scoped permissions
REVOKE CONNECT REPLICATION FROM {USERNAME};
REVOKE CHECKPOINT FROM {USERNAME};
REVOKE CREATE FUNCTION FROM {USERNAME};
REVOKE CREATE PROCEDURE FROM {USERNAME};
REVOKE CREATE VIEW FROM {USERNAME};
REVOKE VIEW DATABASE STATE FROM {USERNAME};

--VA2050 - Minimal set of principals should be granted database-scoped VIEW DEFINITION permissions
REVOKE VIEW DEFINITION FROM {USERNAME};

--VA1094 - Database permissions shouldn''t be granted directly to principals
REVOKE AUTHENTICATE ON DATABASE::{DBNAME} FROM {USERNAME};
REVOKE BACKUP DATABASE ON DATABASE::{DBNAME} FROM {USERNAME};
REVOKE BACKUP LOG ON DATABASE::{DBNAME} FROM {USERNAME};
REVOKE CHECKPOINT ON DATABASE::{DBNAME} FROM {USERNAME};
REVOKE CONNECT REPLICATION ON DATABASE::{DBNAME} FROM {USERNAME};
REVOKE CONTROL ON DATABASE::{DBNAME} FROM {USERNAME};
REVOKE CREATE FUNCTION ON DATABASE::{DBNAME} FROM {USERNAME};
REVOKE CREATE PROCEDURE ON DATABASE::{DBNAME} FROM {USERNAME};
REVOKE CREATE VIEW ON DATABASE::{DBNAME} FROM {USERNAME};
REVOKE DELETE ON DATABASE::{DBNAME} FROM {USERNAME};
REVOKE EXECUTE ON DATABASE::{DBNAME} FROM {USERNAME};
REVOKE INSERT ON DATABASE::{DBNAME} FROM {USERNAME};
REVOKE SELECT ON DATABASE::{DBNAME} FROM {USERNAME};
REVOKE UPDATE ON DATABASE::{DBNAME} FROM {USERNAME};
REVOKE VIEW DATABASE STATE ON DATABASE::{DBNAME} FROM {USERNAME};
REVOKE VIEW DEFINITION ON DATABASE::{DBNAME} FROM {USERNAME};
'

select @sql = REPLACE(@sql, '{DBNAME}', @DBNAME)
select @sql = REPLACE(@sql, '{USERNAME}', @USERNAME)

EXECUTE (@sql)