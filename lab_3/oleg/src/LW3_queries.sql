SELECT DISTINCT g.group_name
FROM Groups g
JOIN Students s ON g.group_code = s.group_code
JOIN Projects_Defense_Schedule pds ON s.student_code = pds.student_code
WHERE DAY(pds.defense_date) = 1;

SELECT sp.specialty_name, COUNT(DISTINCT s.student_code) AS students_count
FROM Students s
JOIN Specialties sp ON s.specialty_code = sp.specialty_code
JOIN Projects_Defense_Schedule pds ON s.student_code = pds.student_code
GROUP BY sp.specialty_name;

SELECT DISTINCT pr.professor_surname, pr.professor_first_name, pr.professor_patronymic
FROM Professors pr
JOIN Projects p ON pr.professor_code = p.professor_code
JOIN Projects_Defense_Schedule pds ON p.student_code = pds.student_code
JOIN GAK_Results gr ON pds.defense_date = gr.defense_date
WHERE gr.grade = 5;

SELECT g.group_name, AVG(gr.grade) AS average_grade
FROM Groups g
JOIN Students s ON g.group_code = s.group_code
JOIN Projects_Defense_Schedule pds ON s.student_code = pds.student_code
JOIN GAK_Results gr ON pds.defense_date = gr.defense_date
GROUP BY g.group_name;

SELECT DISTINCT pct.project_category_type_name
FROM Projects_Categories_Types pct
JOIN Projects p ON pct.project_category_type_code = p.project_category_type_code
JOIN Projects_Defense_Schedule pds ON p.student_code = pds.student_code
WHERE DAY(pds.defense_date) = 1;