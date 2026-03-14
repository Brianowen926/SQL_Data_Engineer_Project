/*
LENGTH/ CHAR_LENGTH SAMA KOK
*/
SELECT LENGTH('SQL');

--Case Conversion
SELECT UPPER('sql');
SELECT LOWER('SQL');

--Substring/Extraction
SELECT LEFT('Worchester',2);
SELECT RIGHT('Worchester',2);
SELECT SUBSTRING('Worchester',4,2);


SELECT CONCAT('SQL' || '+' ||'GUGU');

--Trimming
SELECT TRIM('SQL');
SELECT LTRIM('SQL');
SELECT RTRIM('SQL');

--REPLACEMENT
SELECT REPLACE('SQL', 'Q', '_');
SELECT REGEXP_REPLACE('data.nerd@gmail.com','^.*(@)','\1'); --pake chatgpt ae wkwk untuk fungsinya

--FINAL EXAMPLE
/* Ceritanya jika ada huruf kecil, typo maka dikateogirkan other
Gimana caranya jika ada typo atau huruf besar/kecil diseragmkan
*/
WITH lower_title AS(
    SELECT
        job_title,
        LOWER((job_title)) AS job_title_clean
    FROM job_postings_fact
)

SELECT 
    job_title,
    CASE
        WHEN job_title_clean LIKE '%data%'
        AND job_title_clean LIKE '%analyst%' THEN 'Data Analyst'
        WHEN job_title_clean LIKE '%data%'
        AND job_title_clean LIKE '%scientist%' THEN 'Data Scientist'
        WHEN job_title_clean LIKE '%data%'
        AND job_title_clean LIKE '%engineer%' THEN 'Data Engineer'
        ELSE 'Other' 
    END AS job_title_company
FROM lower_title
ORDER BY RANDOM()
LIMIT 30;

--NULLIF
--Jika 2 kondisi nilainya sama maka hasilnya NULL
--Jika berbeda, maka nilai pertama yang akan direturn
SELECT NULLIF(10,20);

--COALESCE
--Me return non null value pertama
/* Contoh
(NULL,A,B) -> A
(FIRSST, NULL,200) -> FIRSST
*/
SELECT COALESCE(1,3,NULL);
SELECT COALESCE(NULL,1,3,NULL);

SELECT 
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg*2080) AS coalesce_standardized
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL
LIMIT 20;

--FINAL eXAMPLE, simplify with coalesce
SELECT
    job_title_short,
    salary_hour_avg,
    salary_year_avg,
    COALESCE(salary_year_avg, salary_hour_avg*2080) AS standardized_salary,
    CASE
        WHEN COALESCE(salary_year_avg, salary_hour_avg*2080) IS NULL THEN 'Missing'
        WHEN COALESCE(salary_year_avg, salary_hour_avg*2080) < 75000 THEN 'Low'
        WHEN COALESCE(salary_year_avg, salary_hour_avg*2080) < 150000 THEN 'Medium'
        ELSE 'High'
    END AS salary_bucket
FROM job_postings_fact
ORDER BY standardized_salary DESC;