CREATE FUNCTION dbo.CountDisksByCategory(@categoryId INT)
RETURNS INT
AS
BEGIN
    DECLARE @c INT;

    SELECT @c = COUNT(*) 
    FROM Диск 
    WHERE КодКатегорииДиска = @categoryId;

    RETURN @c;
END
GO
