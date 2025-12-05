CREATE PROCEDURE dbo.AddClient
    @name NVARCHAR(100),
    @address NVARCHAR(200),
    @phone NVARCHAR(20)
AS
BEGIN
    BEGIN TRY
        IF EXISTS(SELECT 1 FROM Клиент WHERE Телефон = @phone)
        BEGIN
            PRINT 'Клиент с таким телефоном уже существует';
            RETURN;
        END

        INSERT INTO Клиент (ФИОКлиента, АдресПроживания, Телефон, КоличествоДисков, НазванияДисков)
        VALUES (@name, @address, @phone, 0, NULL);

        PRINT 'Клиент успешно добавлен';
    END TRY

    BEGIN CATCH
        PRINT 'Ошибка: ' + ERROR_MESSAGE();
    END CATCH
END
GO
