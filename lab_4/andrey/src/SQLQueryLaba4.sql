USE master;
GO

-- ��������� ��� �������� ����������� � ���� ������
ALTER DATABASE Laba4 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- ����������� ���� ������ (detach)
EXEC sp_detach_db @dbname = 'Laba4';
GO
