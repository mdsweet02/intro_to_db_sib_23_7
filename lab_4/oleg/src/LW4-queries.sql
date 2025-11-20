--- 1.1 ---
CREATE VIEW Report_Graduation_Results AS
SELECT
    r.defense_date,
    s.student_code,
    CONCAT(s.student_surname, ' ', s.student_first_name, ' ', ISNULL(s.student_patronymic, '')) AS student_fio,
    g.group_name,
    CONCAT(p.professor_surname, ' ', p.professor_first_name, ' ', ISNULL(p.professor_patronymic, '')) AS professor_fio,
    CONCAT(rw.reviewer_surname, ' ', rw.reviewer_first_name, ' ', ISNULL(rw.reviewer_patronymic, '')) AS reviewer_fio,
    r.grade
FROM GAK_Results r
JOIN Students s ON r.student_code = s.student_code
JOIN Groups g ON s.group_code = g.group_code
JOIN Projects pr ON pr.student_code = s.student_code
JOIN Professors p ON pr.professor_code = p.professor_code
LEFT JOIN GAK_Reviewers rw ON pr.reviewer_code = rw.iin;

GO

SELECT * FROM Report_Graduation_Results
WHERE defense_date = '2025-06-20';

GO
--- 1.2 ---
CREATE VIEW Report_Reviewers_Payment AS
SELECT
    rw.iin,
    CONCAT(rw.reviewer_surname, ' ', rw.reviewer_first_name, ' ', ISNULL(rw.reviewer_patronymic, '')) AS reviewer_fio,
    COUNT(p.student_code) AS reviewed_projects,
    COUNT(p.student_code) * 2000 AS total_payment
FROM GAK_Reviewers rw
LEFT JOIN Projects p ON rw.iin = p.reviewer_code
GROUP BY rw.iin, rw.reviewer_surname, rw.reviewer_first_name, rw.reviewer_patronymic;

GO
--- 1.3 ---
CREATE VIEW Report_GAK_Composition AS
SELECT
    sp.specialty_code,
    sp.specialty_name,
    gc.iin,
    CONCAT(rw.reviewer_surname, ' ', rw.reviewer_first_name, ' ', ISNULL(rw.reviewer_patronymic, '')) AS fio,
    gc.functions
FROM GAK_Composition gc
JOIN Specialties sp ON gc.specialty_code = sp.specialty_code
LEFT JOIN GAK_Reviewers rw ON gc.iin = rw.iin;

GO

SELECT * FROM Report_GAK_Composition
WHERE specialty_code = 101;

GO
--- 2 ---
CREATE VIEW Editable_Projects_View AS
SELECT
    pr.student_code,
    CONCAT(s.student_surname, ' ', s.student_first_name) AS student_fio,
    pr.graduation_project_topic,
    pr.professor_code,
    CONCAT(p.professor_surname, ' ', p.professor_first_name) AS professor_fio,
    pr.reviewer_code
FROM Projects pr
JOIN Students s ON pr.student_code = s.student_code
JOIN Professors p ON pr.professor_code = p.professor_code;

GO

UPDATE Editable_Projects_View
SET reviewer_code = '990011223344'
WHERE student_code = 1005;

GO
--- 3 ---
CREATE VIEW Editable_Students_View AS
SELECT
    student_code,
    student_surname,
    student_first_name,
    student_patronymic,
    gpa
FROM Students;

GO

UPDATE Editable_Students_View
SET gpa = 3.8
WHERE student_code = 5001;