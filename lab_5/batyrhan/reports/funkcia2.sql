CREATE FUNCTION dbo.GetPerformerAge(@id INT)
RETURNS INT
AS
BEGIN
    DECLARE @age INT;

    SELECT @age = YEAR(GETDATE()) - YEAR(Дата_Рождения)
    FROM Исполнители
    WHERE КодИсполнителя = @id;

    RETURN @age;
END
GO
