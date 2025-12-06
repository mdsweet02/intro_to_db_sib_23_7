CREATE TABLE dbo.Оправы (
    АртикулОправы INT IDENTITY PRIMARY KEY,
    Наименование NVARCHAR(100) NOT NULL,
    Цена DECIMAL(10,2) NOT NULL CHECK (Цена >= 0),
    Примечание NVARCHAR(200) NULL,
    ДоступноеКоличество INT NOT NULL DEFAULT 0 CHECK (ДоступноеКоличество >= 0)
);
GO

CREATE TABLE dbo.Линзы (
    АртикулЛинзы INT IDENTITY PRIMARY KEY,
    Наименование NVARCHAR(100) NOT NULL,
    Цена DECIMAL(10,2) NOT NULL CHECK (Цена >= 0),
    Примечание NVARCHAR(200) NULL,
    ДоступноеКоличество INT NOT NULL DEFAULT 0 CHECK (ДоступноеКоличество >= 0)
);
GO

CREATE TABLE dbo.Услуги (
    КодУслуги INT IDENTITY PRIMARY KEY,
    Наименование NVARCHAR(100) NOT NULL,
    Цена DECIMAL(10,2) NOT NULL CHECK (Цена >= 0)
);
GO

CREATE TABLE dbo.Приемщик (
    КодПриемщика INT IDENTITY PRIMARY KEY,
    ФИО NVARCHAR(100) NOT NULL
);
GO

CREATE TABLE dbo.Работники (
    ТабельныйНомер INT IDENTITY PRIMARY KEY,
    ФИО NVARCHAR(100) NOT NULL
);
GO

CREATE TABLE dbo.Заказ (
    НомерЗаказа INT IDENTITY PRIMARY KEY,
    ДатаОформления DATE NOT NULL DEFAULT GETDATE(),
    ФИОЗаказчика NVARCHAR(100) NOT NULL,
    АдресПроживания NVARCHAR(200) NOT NULL,
    Телефон VARCHAR(20) NULL,
    КодПриемщика INT NOT NULL,
    СуммаЗаказа DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (СуммаЗаказа >= 0),
    СрокИзготовления NVARCHAR(50) NOT NULL,
    Срочность BIT NOT NULL DEFAULT 0,
    ДоплатаЗаСрочность DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (ДоплатаЗаСрочность >= 0),
    ДатаВыдачи DATE NULL,
    FOREIGN KEY (КодПриемщика) REFERENCES dbo.Приемщик(КодПриемщика)
);
GO

CREATE TABLE dbo.Заказ_Оправы (
    НомерЗаказа INT NOT NULL,
    АртикулОправы INT NOT NULL,
    Количество INT NOT NULL CHECK (Количество > 0),
    PRIMARY KEY (НомерЗаказа, АртикулОправы),
    FOREIGN KEY (НомерЗаказа) REFERENCES dbo.Заказ(НомерЗаказа) ON DELETE CASCADE,
    FOREIGN KEY (АртикулОправы) REFERENCES dbo.Оправы(АртикулОправы)
);
GO

CREATE TABLE dbo.Заказ_Линзы (
    НомерЗаказа INT NOT NULL,
    АртикулЛинзы INT NOT NULL,
    Количество INT NOT NULL CHECK (Количество > 0),
    PRIMARY KEY (НомерЗаказа, АртикулЛинзы),
    FOREIGN KEY (НомерЗаказа) REFERENCES dbo.Заказ(НомерЗаказа) ON DELETE CASCADE,
    FOREIGN KEY (АртикулЛинзы) REFERENCES dbo.Линзы(АртикулЛинзы)
);
GO

CREATE TABLE dbo.Заказ_Услуги (
    НомерЗаказа INT NOT NULL,
    КодУслуги INT NOT NULL,
    КодРаботника INT NOT NULL,
    PRIMARY KEY (НомерЗаказа, КодУслуги),
    FOREIGN KEY (НомерЗаказа) REFERENCES dbo.Заказ(НомерЗаказа) ON DELETE CASCADE,
    FOREIGN KEY (КодУслуги) REFERENCES dbo.Услуги(КодУслуги),
    FOREIGN KEY (КодРаботника) REFERENCES dbo.Работники(ТабельныйНомер)
);
GO

CREATE TABLE dbo.Касса_Заказ (
    Дата DATE NOT NULL DEFAULT GETDATE(),
    КодПриемщика INT NOT NULL,
    НомерЗаказа INT NOT NULL,
    Сумма DECIMAL(10,2) NOT NULL CHECK (Сумма >= 0),
    PRIMARY KEY (Дата, КодПриемщика, НомерЗаказа),
    FOREIGN KEY (КодПриемщика) REFERENCES dbo.Приемщик(КодПриемщика),
    FOREIGN KEY (НомерЗаказа) REFERENCES dbo.Заказ(НомерЗаказа)
);
GO
