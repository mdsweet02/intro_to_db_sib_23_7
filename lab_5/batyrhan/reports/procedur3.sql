CREATE PROCEDURE dbo.GetAvailableCopies
    @diskId INT,                   
    @available INT OUTPUT          
AS
BEGIN
    SET NOCOUNT ON;

    
    SELECT @available = [НаличиеЭкземпляров]
    FROM [dbo].[Диск]
    WHERE [КодДиска] = @diskId;

END;
