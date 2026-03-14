--UNION
--Seperti INner join tapi duplicated diremove

--UNION ALL
--Seperti INner join tapi duplicated juga digabung

SELECT [1,1,1,2];

SELECT UNNEST([1,1,1,2]) --untuk membuat jadi ROW
UNION 
SELECT UNNEST([1,1,3]);
SELECT UNNEST([1,1,1,2]) --untuk membuat jadi ROW
UNION ALL
SELECT UNNEST([1,1,3]);

--INTERSECT
--mengembaikan rows A dan B. Duplicated removed
--INTERSECT
--mengembaikan rows A dan B. Duplicated tetap ada
SELECT UNNEST([1,1,1,2]) 
INTERSECT
SELECT UNNEST([1,1,3]);
SELECT UNNEST([1,1,1,2])
INTERSECT ALL
SELECT UNNEST([1,1,3]);

--EXCEPT
--mengembaikan rows A TAPI TIDAK DI B. Duplicated removed
--INTERSECT
--mengembaikan rows A MINUS B. Duplicated hanya di return sekali sisanya buang
SELECT UNNEST([1,1,1,2]) 
EXCEPT
SELECT UNNEST([1,1,3]);
SELECT UNNEST([1,1,1,2,3])
EXCEPT ALL
SELECT UNNEST([1,1,3,4,5]);

/*
CONTOH KASUS
Ingin pake job postings di 2023 dan 2024*/

--create dulu untuk table jobs 2023 tapi exluce job_id dan job posted date

CREATE TEMP TABLE jobs_2023 AS
SELECT * EXCLUDE (job_id, job_posted_date)
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2023; --Extract karena data asli benuk TIMESTAMPTZ tapi kita mau ambil tahunnya aja 
-- SELECT job_posted_date
-- FROM jobs_2023; INI HARUS DIJALANKAN ULANG KARENA code di atas hanya untuk buat table

CREATE TEMP TABLE jobs_2024 AS
SELECT * EXCLUDE (job_id, job_posted_date)
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2024;

--Which unique jobs postings appeared in either 2023 or 2024
SELECT *
FROM jobs_2023
UNION
SELECT *
FROM jobs_2024;

SELECT 
    'jobs_count' AS table_name, --Untuk memberi alias supaya lebih enak dibaca
    COUNT(*) AS record
FROM jobs_2023
UNION
SELECT 
    'jobs_count' AS table_name,
    COUNT(*) AS record
FROM jobs_2024;

--which job postings appeared accross both years, counting duplicate?
SELECT *
FROM jobs_2023
UNION ALL
SELECT *
FROM jobs_2024;

--KALO KITA PAKE CARA INI, maka hasil yang di return sama dengan UNIO
-- SELECT 
--     'jobs_count' AS table_name,
--     COUNT(*) AS record
-- FROM jobs_2023
-- UNION ALL
-- SELECT 
--     'jobs_count' AS table_name,
--     COUNT(*) AS record
-- FROM jobs_2024;

--What job postings appeared in 2023 but not in 2024
SELECT *
FROM jobs_2023
EXCEPT
SELECT *
FROM jobs_2024;

--Which job postings from 2023 remain after subtracting matching 2024 postings, 1 for 1?
SELECT *
FROM jobs_2023
EXCEPT ALL
SELECT *
FROM jobs_2024;

--Which job appeared in 2023 and 2024
SELECT *
FROM jobs_2023
INTERSECT
SELECT *
FROM jobs_2024;

--Which job appeared in 2023 and 2024 preserving duplicate counts
SELECT *
FROM jobs_2023
INTERSECT ALL
SELECT *
FROM jobs_2024;