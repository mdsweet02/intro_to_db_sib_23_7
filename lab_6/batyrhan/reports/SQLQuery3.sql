CREATE TRIGGER TRG_Движение_INSERT
ON Движение
AFTER INSERT
AS
BEGIN
    INSERT INTO TriggerLog (TableName, TriggerName, Operation, RecordID, NewValue)
    SELECT 
        'Движение',
        'TRG_Движение_INSERT',
        'INSERT',
        i.НомерЗаписи,
        CONCAT(
            'НомерДиска=', i.НомерДиска, '; ',
            'КодКлиента=', i.КодКлиента, '; ',
            'ДатаВыдачи=', CONVERT(NVARCHAR, i.ДатаВыдачи), ';'
        )
    FROM inserted i;
END
GO
