use IETFCO5;
DROP PROCEDURE [dbo].sp_updateBIGINTdetailIDs

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].sp_updateBIGINTdetailIDs
(
	@table     varchar(32), 
		       
	@col0      varchar(16),  
	@col1      varchar(16),  
	@ID        BIGINT,

	@detailIDs varchar(max) = '', -- '1,2,3,4,5'
	@xidt      varchar(16)  = 'BIGINT'
)
WITH ENCRYPTION--, RECOMPILE
AS
BEGIN
	SET NOCOUNT ON;

	declare @sql nvarchar(1024) = ''

	begin try
		begin transaction		
			select @sql = N'
			update {TABLE} set F=0 where {col0}=@ID;

			if (isnull(datalength(@detailIDs), 0) > 0)
			begin				
				DECLARE CUR	CURSOR FOR SELECT Data from dbo.fn_split(@detailIDs, '','')

				declare @detailID BIGINT

				OPEN CUR
				declare @xid {xidt}

				FETCH NEXT FROM CUR INTO @xid

				WHILE (@@FETCH_STATUS = 0)
				BEGIN
				
					select @detailID=0
					select @detailID=ID from {TABLE} where {col0}=@ID AND {col1}=@xid

					if @detailID > 0
					begin
						update {TABLE} set F=1 where ID=@detailID
					end
					else
					begin
						insert into {TABLE}({col0}, {col1})
						values (@ID, @xid)
					end

					FETCH NEXT FROM CUR INTO @xid
				END
			
				CLOSE CUR;
				DEALLOCATE CUR;
			end
			'

			select @sql = REPLACE(@sql, '{TABLE}', @table)
			select @sql = REPLACE(@sql, '{col0}',  @col0)
			select @sql = REPLACE(@sql, '{col1}',  @col1)
			select @sql = REPLACE(@sql, '{xidt}',  @xidt)

			EXEC sp_executesql @sql, N'@ID BIGINT, @detailIDs varchar(max)', @ID, @detailIDs
		commit tran
	end try
	begin catch	
		if @@trancount > 0 rollback;
		throw
	end catch
END
GO
