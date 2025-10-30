USE master;
GO

-- Завершаем все активные подключения к базе данных
ALTER DATABASE Laba4 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- Отсоединяем базу данных (detach)
EXEC sp_detach_db @dbname = 'Laba4';
GO
