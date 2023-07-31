
-- SELECT

-- 1. Selezionare tutti gli studenti nati nel 1990 (160)

SELECT * 
FROM `students`
WHERE YEAR(`date_of_birth`) = 1990;

-- 2. Selezionare tutti i corsi che valgono più di 10 crediti (479)

SELECT * 
FROM `courses`
WHERE `cfu` >10;

-- 3. Selezionare tutti gli studenti che hanno più di 30 anni

SELECT * 
FROM `students`
WHERE (YEAR(CURRENT_TIMESTAMP) - YEAR(`date_of_birth`)>30);

-- 4. Selezionare tutti i corsi del primo semestre del primo anno di un qualsiasi corso di laurea (286)

SELECT * 
FROM `courses`
WHERE`period`= "I semestre" 
AND `year`=1;

-- 5. Selezionare tutti gli appelli d'esame che avvengono nel pomeriggio (dopo le 14) del 20/06/2020 (21)

SELECT * 
FROM `exams`
WHERE `date`= '2020-06-20'
AND `hour`>'14:00:00';

-- 6. Selezionare tutti i corsi di laurea magistrale (38)

SELECT * 
FROM `degrees`
WHERE `level` = 'magistrale';

-- 7. Da quanti dipartimenti è composta l'università? (12)

SELECT COUNT(*) AS 'Totale Dipartimenti'
FROM `departments`;

-- 8. Quanti sono gli insegnanti che non hanno un numero di telefono? (50)

SELECT COUNT(*) AS 'Insegnanti senza numero' 
FROM `teachers`
WHERE `phone` IS NULL;

-- GROUP BY

-- 1. Contare quanti iscritti ci sono stati ogni anno

SELECT COUNT(*) AS 'Iscritti', YEAR(`enrolment_date`) AS 'anno'
FROM `students`
GROUP BY `anno`;

-- 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio

SELECT COUNT(*) AS 'Insegnanti', `office_address` AS 'Ufficio'
FROM `teachers`
GROUP BY `Ufficio`;

-- 3. Calcolare la media dei voti di ogni appello d'esame

SELECT `exam_id` AS 'Appello', ROUND(AVG(`vote`),2) AS 'Media'
FROM `exam_student`
GROUP BY `Appello`;

-- 4. Contare quanti corsi di laurea ci sono per ogni dipartimento

SELECT `department_id` AS 'Dipartimento', COUNT(`id`) AS 'Corso di Laurea'
FROM `degrees`
GROUP BY `Dipartimento`;

-- JOIN

-- 1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia

SELECT S.`name`AS 'nome_studente', S.`surname` AS 'cognome_studente'
FROM `students`AS S
JOIN `degrees` AS D
ON  S.`degree_id` = `D`.`id`
WHERE D.`name`= 'Corso di Laurea in Economia';

-- 2. Selezionare tutti i Corsi di Laurea del Dipartimento di Neuroscienze

SELECT DEG.`name`,DEG.`level`,DEG.`website`,DEG.`address`
FROM `degrees` AS DEG
JOIN `departments`AS DEP
ON DEG.`department_id`= DEP.`id`
WHERE DEP.`name`='Dipartimento di Neuroscienze';

-- 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)

SELECT C.`name`AS 'corso' ,`C`.`year`, T.`id` 
FROM `courses` AS C
JOIN `course_teacher` AS CT
ON CT.`course_id` = C.`id`
JOIN `teachers` AS T
ON CT.`teacher_id` = T.`id`
WHERE T.`name`= 'Fulvio'
AND T.surname= 'Amato';


-- 4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il relativo dipartimento, in ordine alfabetico per cognome e nome

SELECT S.`surname`, S.`name`, DEP.`name`
FROM `students` AS S
JOIN `degrees`AS DEG
ON S.`degree_id`= DEG.`id`
JOIN `departments` AS DEP
ON DEG.`department_id` = DEP.`id`
ORDER BY S.`surname`, S.`name`;

-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti

SELECT D.`name`AS 'corso_laurea', C.`name`AS 'corso', T.`name`AS 'nome_insegnate', T.`surname` AS 'cognome_insegnante'
FROM `degrees` AS D
JOIN `courses`AS C
ON C.`degree_id` = D.`id`
JOIN `course_teacher` AS CT
ON CT.`course_id` = C.`id`
JOIN `teachers`AS T
ON CT.`teacher_id`=T.`id`;

-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)

SELECT DISTINCT T.`id`, T.`name` AS 'nome_insegnate', T.`surname`AS 'cognome_insegnante', DEP.`name`AS 'dipartimento'
FROM `departments` AS DEP
JOIN `degrees`AS DEG
ON DEG.`department_id`= DEP.`id`
JOIN `courses` AS C
ON C.`degree_id` = DEG.`id`
JOIN `course_teacher` AS CT
ON CT.`course_id`=C.`id`
JOIN `teachers`AS T
ON CT.`teacher_id`= T.`id`
WHERE DEP.`name`='Dipartimento di Matematica';

-- 7. BONUS: Selezionare per ogni studente quanti tentativi d’esame ha sostenuto per superare ciascuno dei suoi esami

SELECT COUNT(ES.`vote`) AS 'tentativi', S.`name`AS 'nome_studente' , S.`surname` AS `cognome_studente`, C.`name` AS 'corso'
FROM `students` AS S
JOIN `exam_student` AS ES
ON ES.`student_id` = S.`id`
JOIN `exams` AS E
ON ES.`exam_id` = E.`id`
JOIN`courses` AS C
ON `E`.`course_id`=C.`id`
GROUP BY S.`id`, C.`id`;
