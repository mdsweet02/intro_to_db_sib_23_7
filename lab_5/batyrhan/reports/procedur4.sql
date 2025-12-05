CREATE PROCEDURE dbo.ReserveCopies
    @diskId INT,  
    @count INT  
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @available INT;  
    DECLARE @i INT = 1; 

    IF NOT EXISTS (SELECT 1 FROM dbo.Диск WHERE КодДиска = @diskId)
    BEGIN
        PRINT 'Ошибка: Диск с таким кодом не найден.';
        RETURN;
    END;

    SELECT @available = НаличиеЭкземпляров
    FROM dbo.Диск
    WHERE КодДиска = @diskId;

    IF @available < @count
    BEGIN
        PRINT 'Ошибка: Недостаточно экземпляров для резервирования.';
        RETURN;
    END;

    WHILE @i <= @count
    BEGIN
        UPDATE dbo.Диск
        SET НаличиеЭкземпляров = НаличиеЭкземпляров - 1
        WHERE КодДиска = @diskId;

        SET @i = @i + 1;
    END;

    PRINT 'Экземпляры успешно зарезервированы.';
END;
GO
