CREATE NONCLUSTERED INDEX IDX_Заказ_КодПриемщика
ON dbo.Заказ (КодПриемщика);
GO

CREATE NONCLUSTERED INDEX IDX_Заказ_Оправы_НомерЗаказа
ON dbo.Заказ_Оправы (НомерЗаказа);
GO

CREATE NONCLUSTERED INDEX IDX_Заказ_Оправы_АртикулОправы
ON dbo.Заказ_Оправы (АртикулОправы);
GO

CREATE NONCLUSTERED INDEX IDX_Заказ_Линзы_НомерЗаказа
ON dbo.Заказ_Линзы (НомерЗаказа);
GO

CREATE NONCLUSTERED INDEX IDX_Заказ_Линзы_АртикулЛинзы
ON dbo.Заказ_Линзы (АртикулЛинзы);
GO

CREATE NONCLUSTERED INDEX IDX_Заказ_Услуги_НомерЗаказа
ON dbo.Заказ_Услуги (НомерЗаказа);
GO

CREATE NONCLUSTERED INDEX IDX_Заказ_Услуги_КодУслуги
ON dbo.Заказ_Услуги (КодУслуги);
GO

CREATE NONCLUSTERED INDEX IDX_Заказ_Услуги_КодРаботника
ON dbo.Заказ_Услуги (КодРаботника);
GO

CREATE NONCLUSTERED INDEX IDX_Касса_Заказ_КодПриемщика
ON dbo.Касса_Заказ (КодПриемщика);
GO

CREATE NONCLUSTERED INDEX IDX_Касса_Заказ_НомерЗаказа
ON dbo.Касса_Заказ (НомерЗаказа);
GO
