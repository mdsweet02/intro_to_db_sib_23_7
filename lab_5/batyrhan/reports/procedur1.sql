CREATE PROCEDURE dbo.GetDisksByCategory
    @categoryName NVARCHAR(50)
AS
BEGIN
    IF @categoryName IS NULL
    BEGIN
        PRINT 'Категория не может быть пустой';
        RETURN;
    END

    SELECT 
        Диск.КодДиска,
        Диск.Наименование,
        КатегорииДисков.Наименование AS Категория,
        Диск.СтоимостьАрендыЗаДень
    FROM Диск
    INNER JOIN КатегорииДисков 
        ON Диск.КодКатегорииДиска = КатегорииДисков.КодКатегорииДиска
    WHERE КатегорииДисков.Наименование = @categoryName;
END
GO
