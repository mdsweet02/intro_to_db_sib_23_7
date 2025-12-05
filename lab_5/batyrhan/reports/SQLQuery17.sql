DECLARE @x INT;
EXEC dbo.GetAvailableCopies 1, @available=@x OUTPUT;
PRINT @x;
