drop function [dbo].fn_FromDateToLong

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].fn_FromDateToLong
(
	@datetime DateTime
)
returns bigint
WITH ENCRYPTION
AS
BEGIN	
	return FORMAT(@datetime, 'yyyyMMddHHmmss')
END
