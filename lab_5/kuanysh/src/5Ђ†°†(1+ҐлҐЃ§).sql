CREATE PROCEDURE dbo.ПолучитьЗаказыСНесовпадающейДатой
AS
BEGIN
    SELECT *
    FROM dbo.Заказ
    WHERE DATEADD(DAY, TRY_CAST(LEFT(СрокИзготовления, PATINDEX('%[^0-9]%', СрокИзготовления + 't')-1) AS INT), ДатаОформления)
          <> CAST(GETDATE() AS DATE);
END;
GO

CREATE PROCEDURE dbo.ПолучитьЗаказыПриемщикаНаДату
    @КодПриемщика INT,
    @Дата DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.Заказ
    WHERE КодПриемщика = @КодПриемщика
      AND ДатаОформления = @Дата;
END;
GO

CREATE PROCEDURE dbo.ВставитьЧетырехПриемщиков
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;

    WHILE @i <= 4
    BEGIN
        INSERT INTO dbo.Приемщик (ФИО)
        VALUES (N'Новый приемщик ' + CAST(@i AS NVARCHAR(10)));

        SET @i = @i + 1;
    END;
END;
GO

CREATE PROCEDURE dbo.РассчитатьСтоимостьЛинз
    @АртикулЛинзы INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        АртикулЛинзы,
        Наименование,
        Цена,
        ДоступноеКоличество,
        Стоимость = Цена * ДоступноеКоличество
    FROM dbo.Линзы
    WHERE АртикулЛинзы = @АртикулЛинзы;
END;
GO

EXEC dbo.ПолучитьЗаказыСНесовпадающейДатой;

EXEC dbo.ПолучитьЗаказыПриемщикаНаДату 
     @КодПриемщика = 1,
     @Дата = '2025-12-04';

EXEC dbo.ВставитьЧетырехПриемщиков;
SELECT * FROM dbo.Приемщик;

EXEC dbo.РассчитатьСтоимостьЛинз 
     @АртикулЛинзы = 1;