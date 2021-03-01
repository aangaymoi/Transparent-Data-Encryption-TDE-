drop FUNCTION dbo.fn_Split

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_Split(
    @rowData nvarchar(MAX),
    @splitOn nvarchar(5)
)
RETURNS @value TABLE
(
    ID INT IDENTITY(1,1),
    Data NVARCHAR(128)
)
WITH ENCRYPTION
AS
BEGIN
    DECLARE @count INT
    SET @count = 1

	declare @sl int
	select @sl = len(@splitOn)

	declare @idx int
	select @idx = CHARINDEX(@splitOn,@rowData)

    WHILE (@idx > 0)
    BEGIN
        INSERT INTO @value (Data) SELECT Data=LTRIM(RTRIM(SUBSTRING(@rowData, 1, @idx-1)))

        SET @rowData = SUBSTRING(@rowData, @idx+@sl, LEN(@rowData))
		SET @count = @count + @sl

		select @idx=CHARINDEX(@splitOn,@rowData)
    END

    INSERT INTO @value (Data) SELECT Data = LTRIM(RTRIM(@rowData))

	return
END