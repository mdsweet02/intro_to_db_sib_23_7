CREATE DATABASE DiplomaDesign
ON
(
	NAME = "DimplomaDesign",
	FILENAME = "C:\Files\MSSQL\DATA\DiplomaDesign.mdf",
	SIZE = 8MB,
	MAXSIZE = 16MB,
	FILEGROWTH = 100KB
)
LOG ON
(
	NAME = "DiplomaDesign_log",
	FILENAME = "C:\Files\MSSQL\DATA\DiplomaDeisgn_log.mdf",
	SIZE = 6MB,
	MAXSIZE = 16MB,
	FILEGROWTH = 100KB
)

USE DiplomaDesign
GO

CREATE TABLE Departments (
	department_code INT PRIMARY KEY,
	department_name NVARCHAR(60) NOT NULL
);

CREATE TABLE Specialties (
	specialty_code INT PRIMARY KEY,
	specialty_name NVARCHAR(60) NOT NULL
);

CREATE TABLE Groups (
	group_code INT PRIMARY KEY,
	group_name NVARCHAR(60) NOT NULL,
	department_code INT NOT NULL,
	FOREIGN KEY (department_code) REFERENCES Departments(department_code)
);

CREATE TABLE Students (
	student_code INT PRIMARY KEY,
	student_surname NVARCHAR(60) NOT NULL,
	student_first_name NVARCHAR(60) NOT NULL,
	student_patronymic NVARCHAR(60) NULL,
	group_code INT NOT NULL,
	specialty_code INT NOT NULL,
	gpa FLOAT DEFAULT 0.0 CHECK (gpa BETWEEN 0 AND 4),
	FOREIGN KEY (group_code) REFERENCES Groups(group_code),
	FOREIGN KEY (specialty_code) REFERENCES Specialties(specialty_code)
);

CREATE TABLE Professors (
	professor_code INT PRIMARY KEY,
	professor_surname NVARCHAR(60) NOT NULL,
	professor_first_name NVARCHAR(60) NOT NULL,
	professor_patronymic NVARCHAR(60) NULL,
	department_code INT NOT NULL,
	graduates_number INT DEFAULT 0 CHECK (graduates_number >= 0),
	vacancies_number INT DEFAULT 0 CHECK (vacancies_number >= 0),
	FOREIGN KEY (department_code) REFERENCES Departments(department_code)
);

CREATE TABLE GAK_Composition (
	specialty_code INT NOT NULL,
	iin CHAR(12) NOT NULL,
	functions NVARCHAR(60) NOT NULL
		CHECK (functions IN (N'������������', N'���������', N'���� ����')),
	PRIMARY KEY (specialty_code, iin),
	FOREIGN KEY (specialty_code) REFERENCES Specialties(specialty_code)
);

CREATE TABLE Projects_Categories_Types (
	project_category_type_code INT PRIMARY KEY,
	project_category_type_name NVARCHAR(60) NOT NULL
);

CREATE TABLE Banks (
	bank_code INT PRIMARY KEY,
	bank_name NVARCHAR(60) NOT NULL
);

CREATE TABLE GAK_Reviewers (
	iin CHAR(12) PRIMARY KEY,
	reviewer_surname NVARCHAR(60) NOT NULL,
	reviewer_first_name NVARCHAR(60) NOT NULL,
	reviewer_patronymic NVARCHAR(60) NULL,
	bank_code INT NULL,
	home_address NVARCHAR(60) NULL,
	phone_number NVARCHAR(30) NULL,
	work_place NVARCHAR(60) NULL,
	job_title NVARCHAR(60) NULL,
	identity_card_number INT NOT NULL,
	document_issue_date DATE NOT NULL,
	who_issued_document NVARCHAR(60) DEFAULT N'�� �������',
	graduates_number INT DEFAULT 0 CHECK (graduates_number >= 0),
	FOREIGN KEY (bank_code) REFERENCES Banks(bank_code)
);

CREATE TABLE Projects (
	student_code INT NOT NULL,
	professor_code INT NOT NULL,
	graduation_project_topic NVARCHAR(60) NOT NULL,
	project_category_type_code INT NOT NULL,
	reviewer_code CHAR(12) NULL,
	PRIMARY KEY (student_code),
	FOREIGN KEY (student_code) REFERENCES Students(student_code),
	FOREIGN KEY (professor_code) REFERENCES Professors(professor_code),
	FOREIGN KEY (project_category_type_code) REFERENCES Projects_Categories_Types(project_category_type_code),
	FOREIGN KEY (reviewer_code) REFERENCES GAK_Reviewers(iin)
);

CREATE TABLE Projects_Defense_Schedule (
	defense_date DATE NOT NULL,
	student_code INT NOT NULL,
	PRIMARY KEY (defense_date, student_code),
	FOREIGN KEY (student_code) REFERENCES Students(student_code)
);

CREATE TABLE GAK_Results (
	result_id INT PRIMARY KEY IDENTITY,
	defense_date DATE NOT NULL,
	student_code INT NOT NULL,
	grade INT NOT NULL CHECK (grade BETWEEN 0 AND 100),
	final_assessment_type NVARCHAR(60) NOT NULL
		CHECK (final_assessment_type IN (N'���. �������', N'������ ����. �������')),
	FOREIGN KEY (student_code) REFERENCES Students(student_code)
);

GO

USE DiplomaDesign;
GO

CREATE INDEX IX_Groups_DepartmentCode
ON Groups (department_code);

CREATE INDEX IX_Students_GroupCode
ON Students (group_code);

CREATE INDEX IX_Students_SpecialtyCode
ON Students (specialty_code);

CREATE INDEX IX_Professors_DepartmentCode
ON Professors (department_code);

CREATE INDEX IX_GAK_Composition_SpecialtyCode
ON GAK_Composition (specialty_code);

CREATE INDEX IX_GAK_Reviewers_BankCode
ON GAK_Reviewers (bank_code);

CREATE INDEX IX_Projects_StudentCode
ON Projects (student_code);

CREATE INDEX IX_Projects_ProfessorCode
ON Projects (professor_code);

CREATE INDEX IX_Projects_ProjectCategoryTypeCode
ON Projects (project_category_type_code);

CREATE INDEX IX_Projects_ReviewerCode
ON Projects (reviewer_code);

CREATE INDEX IX_Projects_Defense_Schedule_StudentCode
ON Projects_Defense_Schedule (student_code);

CREATE INDEX IX_GAK_Results_DefenseDate_StudentCode
ON GAK_Results (defense_date, student_code);

GO

USE DiplomaDesign;
GO

INSERT INTO Departments VALUES
(1, N'�����������'),
(2, N'����������'),
(3, N'������'),
(4, N'���������'),
(5, N'���������'),
(6, N'�����������'),
(7, N'�������������'),
(8, N'�����������������'),
(9, N'����������'),
(10, N'�����');

INSERT INTO Specialties VALUES
(101, N'����������� ���������'),
(102, N'�������������� �������'),
(103, N'���������� ����������'),
(104, N'��������� �����������'),
(105, N'���������'),
(106, N'����������� ������'),
(107, N'������������� �����������'),
(108, N'��������������'),
(109, N'���������� �����������'),
(110, N'���������� ����������');

INSERT INTO Banks VALUES
(1, N'Kaspi Bank'),
(2, N'Halyk Bank'),
(3, N'ForteBank'),
(4, N'Jusan Bank'),
(5, N'ATF Bank'),
(6, N'SberBank'),
(7, N'CenterCredit'),
(8, N'Eurasian Bank'),
(9, N'Tengri Bank'),
(10, N'VTB Bank');

INSERT INTO Projects_Categories_Types VALUES
(1, N'�����������������'),
(2, N'����������'),
(3, N'�����������������'),
(4, N'�������������'),
(5, N'�������������'),
(6, N'����������'),
(7, N'����������� �������'),
(8, N'������������� ������'),
(9, N'���������������'),
(10, N'�������������');

INSERT INTO Professors VALUES
(1, N'������', N'ϸ��', N'���������', 1, 12, 2),
(2, N'������', N'������', N'��������', 1, 15, 3),
(3, N'�������', N'�������', N'����������', 2, 10, 1),
(4, N'���', N'�������', N'��������', 3, 8, 2),
(5, N'�������', N'�����', N'����������', 4, 5, 1),
(6, N'��������', N'�����', N'��������', 5, 7, 2),
(7, N'������', N'����', N'����������', 6, 6, 1),
(8, N'��������', N'������', N'���������', 7, 4, 1),
(9, N'������', N'����', N'�������������', 8, 9, 2),
(10, N'�������', N'�����', N'��������', 9, 3, 0);

INSERT INTO GAK_Reviewers VALUES
('900101300001', N'��������', N'������', N'����������', 1, N'������', N'+77011234567', N'�� "������������"', N'�������', 123456, '2023-05-01', N'��� ��', 2),
('900101300002', N'���������', N'�����', N'���������', 2, N'������', N'+77022345678', N'��� "�������"', N'�����������', 123457, '2023-04-21', N'��� ��', 3),
('900101300003', N'�������', N'����', N'���������', 3, N'�������', N'+77033456789', N'��� "����������"', N'��������', 123458, '2023-04-11', N'��� ��', 4),
('900101300004', N'���', N'�����', N'��������', 4, N'���������', N'+77044567890', N'Kaspi.kz', N'��������', 123459, '2023-03-10', N'��� ��', 5),
('900101300005', N'����������', N'�����', N'����������', 5, N'��������', N'+77055678901', N'TechnoLine', N'�������', 123460, '2023-02-10', N'��� ��', 1),
('900101300006', N'��������', N'�����', N'���������', 6, N'������', N'+77066789012', N'��� "�������"', N'�������������', 123461, '2023-01-01', N'��� ��', 0),
('900101300007', N'��������', N'�������', N'����������', 7, N'������', N'+77077890123', N'Kcell', N'��������', 123462, '2022-12-10', N'��� ��', 2),
('900101300008', N'�������', N'�����', N'���������', 8, N'�������', N'+77088901234', N'��� "����������"', N'�����������', 123463, '2022-11-10', N'��� ��', 3),
('900101300009', N'������', N'��������', N'�������������', 9, N'������', N'+77099012345', N'�� "������"', N'��������', 123464, '2022-10-10', N'��� ��', 1),
('900101300010', N'���������', N'�����', N'��������������', 10, N'������', N'+77010123456', N'ForteBank', N'���������', 123465, '2022-09-01', N'��� ��', 2);

INSERT INTO Groups VALUES
(1, N'��-11', 1),
(2, N'��-12', 1),
(3, N'��-11', 1),
(4, N'��-11', 2),
(5, N'��-11', 3),
(6, N'��-11', 4),
(7, N'��-11', 5),
(8, N'��-11', 6),
(9, N'��-11', 7),
(10, N'��-11', 8);

INSERT INTO Students VALUES
(1, N'�����������', N'�����', N'����������', 1, 101, 3.7),
(2, N'������', N'������', N'��������', 1, 101, 3.5),
(3, N'���', N'�����', N'������������', 2, 102, 3.8),
(4, N'�������', N'�����', N'��������', 3, 101, 3.6),
(5, N'��������', N'�����', N'���������', 4, 103, 3.9),
(6, N'�������', N'�����', N'����������', 5, 103, 3.3),
(7, N'��������', N'������', N'����������', 6, 104, 3.1),
(8, N'��������', N'�����', N'���������', 6, 104, 3.4),
(9, N'���������', N'���������', N'���������', 7, 105, 3.8),
(10, N'�������', N'�����', N'���������', 8, 106, 3.6),
(11, N'�������', N'�����', N'���������', 9, 107, 3.2),
(12, N'�����', N'������', N'�����������', 10, 108, 3.9),
(13, N'��������', N'�����', N'����������', 10, 108, 3.7),
(14, N'�������', N'�����', N'����������', 9, 107, 3.5),
(15, N'�������', N'������', N'�����', 8, 106, 3.8),
(16, N'��������', N'���������', N'���������', 7, 105, 3.6),
(17, N'������', N'������', N'���������', 6, 104, 3.4),
(18, N'�����', N'�����', N'������������', 5, 103, 3.9),
(19, N'�������', N'������', N'���������', 3, 102, 3.3),
(20, N'��������', N'������', N'�����������', 2, 102, 3.7);

INSERT INTO GAK_Composition VALUES
(101, '900101300001', N'������������'),
(101, '900101300002', N'���� ����'),
(101, '900101300003', N'���� ����'),
(102, '900101300004', N'������������'),
(102, '900101300005', N'���� ����'),
(102, '900101300006', N'���������'),
(103, '900101300007', N'������������'),
(103, '900101300008', N'���� ����'),
(103, '900101300009', N'���� ����'),
(104, '900101300010', N'������������'),
(104, '900101300001', N'���� ����'),
(105, '900101300002', N'���� ����'),
(106, '900101300003', N'���������'),
(107, '900101300004', N'���� ����'),
(108, '900101300005', N'���� ����'),
(109, '900101300006', N'���� ����'),
(110, '900101300007', N'���� ����'),
(110, '900101300008', N'���� ����'),
(110, '900101300009', N'���������'),
(110, '900101300010', N'������������');

INSERT INTO Projects VALUES
(1, 1, N'������� ����� ���������', 7, '900101300001'),
(2, 2, N'��������� ���������� ��������', 7, '900101300002'),
(3, 3, N'CRM ��� �������', 7, '900101300003'),
(4, 4, N'������ ��������������� ������', 2, '900101300004'),
(5, 5, N'������ ������� ��������', 5, '900101300005'),
(6, 6, N'���������� ������� �����', 7, '900101300006'),
(7, 7, N'������������� ������ �����', 10, '900101300007'),
(8, 8, N'��������� ����������� ������', 5, '900101300008'),
(9, 9, N'��������������� ������ ������', 9, '900101300009'),
(10, 10, N'������ ������ ���������', 8, '900101300010'),
(11, 1, N'������� ����������������', 7, '900101300001'),
(12, 2, N'����������� ������ ������', 7, '900101300002'),
(13, 3, N'���� ��������', 7, '900101300003'),
(14, 4, N'���� ���������', 7, '900101300004'),
(15, 5, N'������� ������� ������������', 5, '900101300005'),
(16, 6, N'����������� ����������', 7, '900101300006'),
(17, 7, N'������������� �����', 10, '900101300007'),
(18, 8, N'������������ �������', 5, '900101300008'),
(19, 9, N'������ ����', 9, '900101300009'),
(20, 10, N'3D ����� ������', 8, '900101300010');

INSERT INTO Projects_Defense_Schedule VALUES
('2025-06-01', 1),
('2025-06-01', 2),
('2025-06-01', 3),
('2025-06-02', 4),
('2025-06-02', 5),
('2025-06-02', 6),
('2025-06-03', 7),
('2025-06-03', 8),
('2025-06-03', 9),
('2025-06-04', 10),
('2025-06-04', 11),
('2025-06-04', 12),
('2025-06-05', 13),
('2025-06-05', 14),
('2025-06-05', 15),
('2025-06-06', 16),
('2025-06-06', 17),
('2025-06-06', 18),
('2025-06-07', 19),
('2025-06-07', 20);

INSERT INTO GAK_Results (defense_date, student_code, grade, final_assessment_type) VALUES
('2025-06-01', 1, 95, N'������ ����. �������'),
('2025-06-01', 2, 88, N'���. �������'),
('2025-06-01', 3, 90, N'������ ����. �������'),
('2025-06-02', 4, 92, N'���. �������'),
('2025-06-02', 5, 85, N'������ ����. �������'),
('2025-06-02', 6, 87, N'���. �������'),
('2025-06-03', 7, 91, N'������ ����. �������'),
('2025-06-03', 8, 89, N'���. �������'),
('2025-06-03', 9, 94, N'������ ����. �������'),
('2025-06-04', 10, 90, N'���. �������'),
('2025-06-04', 11, 93, N'������ ����. �������'),
('2025-06-04', 12, 84, N'���. �������'),
('2025-06-05', 13, 88, N'������ ����. �������'),
('2025-06-05', 14, 91, N'���. �������'),
('2025-06-05', 15, 92, N'������ ����. �������'),
('2025-06-06', 16, 96, N'���. �������'),
('2025-06-06', 17, 89, N'������ ����. �������'),
('2025-06-06', 18, 87, N'���. �������'),
('2025-06-07', 19, 93, N'������ ����. �������'),
('2025-06-07', 20, 85, N'���. �������');