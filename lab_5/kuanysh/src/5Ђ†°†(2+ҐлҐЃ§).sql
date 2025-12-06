CREATE FUNCTION dbo.ПолучитьСтоимостьЛинзы
(
    @АртикулЛинзы INT
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Стоимость DECIMAL(18,2);

    SELECT @Стоимость = Цена * ДоступноеКоличество
    FROM dbo.Линзы
    WHERE АртикулЛинзы = @АртикулЛинзы;

    RETURN ISNULL(@Стоимость, 0);
END;
GO

CREATE FUNCTION dbo.ПолучитьЗаказыПриемщика
(
    @КодПриемщика INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM dbo.Заказ
    WHERE КодПриемщика = @КодПриемщика
);
GO

SELECT dbo.ПолучитьСтоимостьЛинзы(1) AS Стоимость;

SELECT * FROM dbo.ПолучитьЗаказыПриемщика(1);
