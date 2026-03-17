/*
Windows function penting?
-> Untuk memberi konteks tanpa merusak rows (PASTI AKAN DIPAKE)
- Pipeline need row level data
- Aggregate collapes rows
- Window funct keep rows AND add insight
*/

--COUNT ROWS - Aggregate
SELECT  
    COUNT(job_id)
FROM job_postings_fact;

--count - Windows fun
SELECT  
    COUNT(job_id) OVER() --Keyword nya OVER
FROM job_postings_fact;

/*SYNTAX
SELECT
    column_1,
    window_function() OVER(
        partition by <...>
        ORDER BY <...>
    ) AS window_column_alias
FROM table_name
*/

--PARTITION BY - FIND hourly salary
--PARTITION untuk semacam memfilter berdasarkan apa nya. Dalam kasus ini mau di partition by job_title_short dan company nya
SELECT
    job_id,
    job_title_short,
    company_id,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER (
        PARTITION BY job_title_short, company_id
    ) AS average_salary_job_title
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY RANDOM()
LIMIT 10;

--ORDER BY - Ranking hourly salary
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER (
        ORDER BY salary_hour_avg DESC
    ) AS rank_hourly_salary
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
-- ORDER BY RANDOM()
LIMIT 10;

--PARTITIOIN BY & ORDER BY - Ranking average hourly salary
SELECT
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) 
    OVER(
        PARTITION BY job_title_short
        ORDER BY job_posted_date
    ) AS running_avg_hourly_by_title
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY 
    job_posted_date,
    job_title_short
LIMIT 10;

--Partition BY & ORDER BY - ranking by job_title_sshort
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER ( --Windows function independen dengan ORDER BY DI luar windows func
        PARTITION BY job_title_short
        ORDER BY salary_hour_avg DESC
    ) AS rank_hourly_salary
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY 
    salary_hour_avg DESC,
    job_title_short --kalo urutannya diubah hasil nya juga beda (bisa dicoba)
LIMIT 10;

--Windows function - ROW NUMBER() -providing new jobs
SELECT
    *,
     --Katakanklah kita inign menambah ID baru
    ROW_NUMBER() OVER (
        ORDER BY job_posted_date
    )
FROM job_postings_fact
ORDER BY 
    job_posted_date
LIMIT 20;

SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    ROW_NUMBER() OVER (
        ORDER BY salary_hour_avg DESC
    ) AS rank_hourly_salary
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY 
    rank_hourly_salary
LIMIT 50;

--Windows function LAG()
SELECT
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LAG(salary_year_avg) OVER( --ADA LEAD() fungisnya sama sama mengurangi
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS next_position_salary,
    salary_year_avg - LAG(salary_year_avg) OVER( --ini untuk membuat kolom baru salary_year_avg - next position salary
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS salary_change
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY company_id, job_posted_date
LIMIT 30;