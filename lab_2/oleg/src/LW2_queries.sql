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
		CHECK (functions IN (N'председатель', N'секретарь', N'член ГАКа')),
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
	who_issued_document NVARCHAR(60) DEFAULT N'Не указано',
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
		CHECK (final_assessment_type IN (N'гос. экзамен', N'защита дипл. проекта')),
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
(1, N'Информатика'),
(2, N'Математика'),
(3, N'Физика'),
(4, N'Экономика'),
(5, N'Филология'),
(6, N'Архитектура'),
(7, N'Автоматизация'),
(8, N'Электроэнергетика'),
(9, N'Менеджмент'),
(10, N'Химия');

INSERT INTO Specialties VALUES
(101, N'Программная инженерия'),
(102, N'Информационные системы'),
(103, N'Прикладная математика'),
(104, N'Экономика предприятия'),
(105, N'Филология'),
(106, N'Архитектура зданий'),
(107, N'Автоматизация производств'),
(108, N'Электротехника'),
(109, N'Менеджмент организаций'),
(110, N'Химическая технология');

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
(1, N'Исследовательский'),
(2, N'Прикладной'),
(3, N'Экспериментальный'),
(4, N'Теоретический'),
(5, N'Аналитический'),
(6, N'Инженерный'),
(7, N'Программный продукт'),
(8, N'Архитектурный проект'),
(9, N'Образовательный'),
(10, N'Маркетинговый');

INSERT INTO Professors VALUES
(1, N'Иванов', N'Пётр', N'Сергеевич', 1, 12, 2),
(2, N'Петров', N'Андрей', N'Игоревич', 1, 15, 3),
(3, N'Сидоров', N'Николай', N'Васильевич', 2, 10, 1),
(4, N'Ким', N'Дмитрий', N'Олегович', 3, 8, 2),
(5, N'Ахметов', N'Болат', N'Кайратович', 4, 5, 1),
(6, N'Смирнова', N'Елена', N'Павловна', 5, 7, 2),
(7, N'Громов', N'Олег', N'Николаевич', 6, 6, 1),
(8, N'Нурбеков', N'Алихан', N'Жанатович', 7, 4, 1),
(9, N'Волков', N'Илья', N'Александрович', 8, 9, 2),
(10, N'Зайцева', N'Мария', N'Петровна', 9, 3, 0);

INSERT INTO GAK_Reviewers VALUES
('900101300001', N'Абдуллин', N'Рустам', N'Равильевич', 1, N'Алматы', N'+77011234567', N'АО "ЭнергоСервис"', N'Инженер', 123456, '2023-05-01', N'МВД РК', 2),
('900101300002', N'Жумабеков', N'Ерлан', N'Серикович', 2, N'Астана', N'+77022345678', N'ТОО "ИнфоТех"', N'Разработчик', 123457, '2023-04-21', N'МВД РК', 3),
('900101300003', N'Иванова', N'Анна', N'Сергеевна', 3, N'Шымкент', N'+77033456789', N'ТОО "БанкСервис"', N'Аналитик', 123458, '2023-04-11', N'МВД РК', 4),
('900101300004', N'Ким', N'Елена', N'Олеговна', 4, N'Караганда', N'+77044567890', N'Kaspi.kz', N'Менеджер', 123459, '2023-03-10', N'МВД РК', 5),
('900101300005', N'Сулейменов', N'Дамир', N'Нурланович', 5, N'Костанай', N'+77055678901', N'TechnoLine', N'Инженер', 123460, '2023-02-10', N'МВД РК', 1),
('900101300006', N'Васильев', N'Игорь', N'Борисович', 6, N'Алматы', N'+77066789012', N'НИИ "Энергия"', N'Исследователь', 123461, '2023-01-01', N'МВД РК', 0),
('900101300007', N'Муратова', N'Айгерим', N'Кайратовна', 7, N'Астана', N'+77077890123', N'Kcell', N'Аналитик', 123462, '2022-12-10', N'МВД РК', 2),
('900101300008', N'Ермеков', N'Тимур', N'Серикович', 8, N'Шымкент', N'+77088901234', N'НИИ "Автоматика"', N'Разработчик', 123463, '2022-11-10', N'МВД РК', 3),
('900101300009', N'Попова', N'Светлана', N'Александровна', 9, N'Атырау', N'+77099012345', N'АО "ХимТех"', N'Технолог', 123464, '2022-10-10', N'МВД РК', 1),
('900101300010', N'Тлеуханов', N'Серик', N'Амангельдиевич', 10, N'Алматы', N'+77010123456', N'ForteBank', N'Экономист', 123465, '2022-09-01', N'МВД РК', 2);

INSERT INTO Groups VALUES
(1, N'ИС-11', 1),
(2, N'ИС-12', 1),
(3, N'ПИ-11', 1),
(4, N'ПМ-11', 2),
(5, N'ФИ-11', 3),
(6, N'ЭК-11', 4),
(7, N'ФЛ-11', 5),
(8, N'АР-11', 6),
(9, N'АВ-11', 7),
(10, N'ЭЛ-11', 8);

INSERT INTO Students VALUES
(1, N'Абдрахманов', N'Ержан', N'Кайратович', 1, 101, 3.7),
(2, N'Иванов', N'Сергей', N'Петрович', 1, 101, 3.5),
(3, N'Ким', N'Алина', N'Владимировна', 2, 102, 3.8),
(4, N'Петрова', N'Ольга', N'Игоревна', 3, 101, 3.6),
(5, N'Ахметова', N'Айжан', N'Дамировна', 4, 103, 3.9),
(6, N'Сидоров', N'Павел', N'Николаевич', 5, 103, 3.3),
(7, N'Кузнецов', N'Андрей', N'Дмитриевич', 6, 104, 3.1),
(8, N'Нурланов', N'Аслан', N'Болатович', 6, 104, 3.4),
(9, N'Тимофеева', N'Екатерина', N'Андреевна', 7, 105, 3.8),
(10, N'Ермеков', N'Тимур', N'Серикович', 8, 106, 3.6),
(11, N'Мусаева', N'Айжан', N'Нуртаевна', 9, 107, 3.2),
(12, N'Орлов', N'Виктор', N'Геннадьевич', 10, 108, 3.9),
(13, N'Соколова', N'Мария', N'Викторовна', 10, 108, 3.7),
(14, N'Жуманов', N'Алмаз', N'Кайратович', 9, 107, 3.5),
(15, N'Поляков', N'Даниил', N'Ильич', 8, 106, 3.8),
(16, N'Исабеков', N'Нурсултан', N'Ерланович', 7, 105, 3.6),
(17, N'Караев', N'Максат', N'Жанатович', 6, 104, 3.4),
(18, N'Жуков', N'Денис', N'Владимирович', 5, 103, 3.9),
(19, N'Омарова', N'Динара', N'Асхатовна', 3, 102, 3.3),
(20, N'Садырбек', N'Бекзат', N'Ерболатович', 2, 102, 3.7);

INSERT INTO GAK_Composition VALUES
(101, '900101300001', N'председатель'),
(101, '900101300002', N'член ГАКа'),
(101, '900101300003', N'член ГАКа'),
(102, '900101300004', N'председатель'),
(102, '900101300005', N'член ГАКа'),
(102, '900101300006', N'секретарь'),
(103, '900101300007', N'председатель'),
(103, '900101300008', N'член ГАКа'),
(103, '900101300009', N'член ГАКа'),
(104, '900101300010', N'председатель'),
(104, '900101300001', N'член ГАКа'),
(105, '900101300002', N'член ГАКа'),
(106, '900101300003', N'секретарь'),
(107, '900101300004', N'член ГАКа'),
(108, '900101300005', N'член ГАКа'),
(109, '900101300006', N'член ГАКа'),
(110, '900101300007', N'член ГАКа'),
(110, '900101300008', N'член ГАКа'),
(110, '900101300009', N'секретарь'),
(110, '900101300010', N'председатель');

INSERT INTO Projects VALUES
(1, 1, N'Система учёта студентов', 7, '900101300001'),
(2, 2, N'Мобильное приложение колледжа', 7, '900101300002'),
(3, 3, N'CRM для кафедры', 7, '900101300003'),
(4, 4, N'Модель прогнозирования спроса', 2, '900101300004'),
(5, 5, N'Анализ учебной нагрузки', 5, '900101300005'),
(6, 6, N'Разработка системы учёта', 7, '900101300006'),
(7, 7, N'Экономический анализ фирмы', 10, '900101300007'),
(8, 8, N'Программа оптимизации затрат', 5, '900101300008'),
(9, 9, N'Лингвистический анализ текста', 9, '900101300009'),
(10, 10, N'Проект жилого комплекса', 8, '900101300010'),
(11, 1, N'Система документооборота', 7, '900101300001'),
(12, 2, N'Электронный журнал оценок', 7, '900101300002'),
(13, 3, N'Сайт колледжа', 7, '900101300003'),
(14, 4, N'Учёт студентов', 7, '900101300004'),
(15, 5, N'Система анализа успеваемости', 5, '900101300005'),
(16, 6, N'Электронная библиотека', 7, '900101300006'),
(17, 7, N'Бухгалтерский отчёт', 10, '900101300007'),
(18, 8, N'Планирование бюджета', 5, '900101300008'),
(19, 9, N'Анализ речи', 9, '900101300009'),
(20, 10, N'3D макет здания', 8, '900101300010');

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
('2025-06-01', 1, 95, N'защита дипл. проекта'),
('2025-06-01', 2, 88, N'гос. экзамен'),
('2025-06-01', 3, 90, N'защита дипл. проекта'),
('2025-06-02', 4, 92, N'гос. экзамен'),
('2025-06-02', 5, 85, N'защита дипл. проекта'),
('2025-06-02', 6, 87, N'гос. экзамен'),
('2025-06-03', 7, 91, N'защита дипл. проекта'),
('2025-06-03', 8, 89, N'гос. экзамен'),
('2025-06-03', 9, 94, N'защита дипл. проекта'),
('2025-06-04', 10, 90, N'гос. экзамен'),
('2025-06-04', 11, 93, N'защита дипл. проекта'),
('2025-06-04', 12, 84, N'гос. экзамен'),
('2025-06-05', 13, 88, N'защита дипл. проекта'),
('2025-06-05', 14, 91, N'гос. экзамен'),
('2025-06-05', 15, 92, N'защита дипл. проекта'),
('2025-06-06', 16, 96, N'гос. экзамен'),
('2025-06-06', 17, 89, N'защита дипл. проекта'),
('2025-06-06', 18, 87, N'гос. экзамен'),
('2025-06-07', 19, 93, N'защита дипл. проекта'),
('2025-06-07', 20, 85, N'гос. экзамен');