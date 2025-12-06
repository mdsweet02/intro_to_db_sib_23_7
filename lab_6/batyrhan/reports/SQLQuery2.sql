CREATE TABLE TriggerLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(50),          -- над какой таблицей выполнялась операция
    TriggerName NVARCHAR(100),       -- имя триггера
    Operation NVARCHAR(20),          -- INSERT / UPDATE / DELETE
    RecordID INT NULL,               -- ключ изменённой записи
    OldValue NVARCHAR(MAX) NULL,     -- данные ДО изменения (для UPDATE/DELETE)
    NewValue NVARCHAR(MAX) NULL,     -- данные ПОСЛЕ изменения (для INSERT/UPDATE)
    TriggerDate DATETIME DEFAULT GETDATE(), -- дата и время события
    UserName NVARCHAR(100) DEFAULT SUSER_SNAME()  -- пользователь, вызвавший триггер
);
GO