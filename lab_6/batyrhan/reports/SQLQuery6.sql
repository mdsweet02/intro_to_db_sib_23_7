CREATE TRIGGER TRG_Движение_DELETE
ON Движение
AFTER DELETE
AS
BEGIN
    INSERT INTO TriggerLog (TableName, TriggerName, Operation, RecordID, OldValue)
    SELECT 
        'Движение',
        'TRG_Движение_DELETE',
        'DELETE',
        d.НомерЗаписи,
        CONCAT(
            'НомерДиска=', d.НомерДиска, '; ',
            'КодКлиента=', d.КодКлиента, '; ',
            'ДатаВыдачи=', CONVERT(NVARCHAR, d.ДатаВыдачи)
        )
    FROM deleted d;
END
GO
