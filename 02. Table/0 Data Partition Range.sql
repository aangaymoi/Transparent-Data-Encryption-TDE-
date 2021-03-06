--A
--Partitioning of the tables depends on the partition range defined by Partition Function. Let us assume that we are going to partition the table into four parts, onto four different file groups.

declare @dbname varchar(64) = 'YOURDB'
DECLARE @sql varchar(max) = '
use [{DBNAME}]

IF EXISTS (SELECT * FROM sys.partition_schemes WHERE name = ''Data Partition Scheme'')
    DROP PARTITION SCHEME [Data Partition Scheme]

IF EXISTS (SELECT * FROM sys.partition_schemes WHERE name = ''FileStreamPS'')
    DROP PARTITION SCHEME [FileStreamPS]	

IF EXISTS (SELECT * FROM sys.partition_functions WHERE name = ''Data Partition Range'')
	DROP PARTITION FUNCTION [Data Partition Range]

CREATE PARTITION FUNCTION [Data Partition Range](BIGINT)
        AS RANGE RIGHT FOR VALUES (
		  --1
		    10000000
		  --2
		  , 20000000
		  --3
		  , 30000000
		  --4
		  , 40000000
		  --5
		  , 50000000
		  --6
		  , 60000000
		  --7
		  , 70000000
		  --8		  	  
		  )

--RECOMMENT RIGHT
SELECT * FROM sys.partition_range_values

CREATE PARTITION SCHEME [Data Partition Scheme]
        AS PARTITION [Data Partition Range]
        TO (
		   [{DBNAME} FG01]
		 , [{DBNAME} FG02]
		 , [{DBNAME} FG03]
		 , [{DBNAME} FG04]
		 , [{DBNAME} FG05]
		 , [{DBNAME} FG06]
		 , [{DBNAME} FG07]
		 , [{DBNAME} FG08]
		 )		 

CREATE PARTITION SCHEME [FileStreamPS]
        AS PARTITION [Data Partition Range]
        TO ([FS1], [FS2], [FS3], [FS4], [FS5], [FS6], [FS7], [FS8])		
'		
select @sql = REPLACE(@sql, '{DBNAME}', @dbname)
EXECUTE (@sql)

select * from sys.partitions where object_name(object_id)='Logs'

--Microsoft provided the following catalog views to query information about partition.
select * from sys.partition_functions
select * from sys.partition_parameters
select * from sys.partition_range_values
select * from sys.partition_schemes
select * from sys.partitions
