CREATE TRIGGER TRG_Движение_UPDATE
ON Движение
AFTER UPDATE
AS
BEGIN
    INSERT INTO TriggerLog (TableName, TriggerName, Operation, RecordID, OldValue, NewValue)
    SELECT 
        'Движение',
        'TRG_Движение_UPDATE',
        'UPDATE',
        i.НомерЗаписи,
        CONCAT(
            'Old DateReturn=', CONVERT(NVARCHAR, d.ДатаВозврата), '; ',
            'Old Client=', d.КодКлиента
        ),
        CONCAT(
            'New DateReturn=', CONVERT(NVARCHAR, i.ДатаВозврата), '; ',
            'New Client=', i.КодКлиента
        )
    FROM inserted i
    JOIN deleted d ON d.НомерЗаписи = i.НомерЗаписи;
END
GO
