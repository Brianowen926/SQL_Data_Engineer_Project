--Subquery
SELECT *
FROM job_postings_fact
LIMIT 10;

SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
    OR salary_hour_avg IS NOT NULL
) AS valid_salaries_1
LIMIT 10;

--CTE (Common Table Expression) sifatnya sementara artinya ketika di eksekusi dia tidak 
--tersimpan permanen di DB
WITH valid_salaries AS( --valid_salaries adalah ALIAS
     SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
    OR salary_hour_avg IS NOT NULL
)
SELECT *
FROM valid_salaries
LIMIT 10;

--Contoh kASUS
-- 1 - Subquery in SELECT
-- Show each job's salary nect to the overall market medians;
SELECT 
job_title_short,
salary_year_avg,( --ditambahain salary_year_avg biar tahu pembandingnya
    SELECT MEDIAN(salary_year_avg)
    FROM job_postings_fact
) AS median_market_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

--2 - Subquery in FROM
-- Stage only jobs that are remote before aggregating
SELECT 
job_title_short,
MEDIAN(salary_year_avg) AS median_salary,
( 
    SELECT MEDIAN(salary_year_avg)
    FROM job_postings_fact
    WHERE job_work_from_home = True
) AS median_market_remote_salary
FROM (
    SELECT
        job_title_short,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) AS clean_jobs
-- WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short
LIMIT 10;


-- 3 - Subquery in HAVING
-- Stage only jobs title whose medians salary is above the overall medians
SELECT 
job_title_short,
MEDIAN(salary_year_avg) AS median_salary,
( 
    SELECT MEDIAN(salary_year_avg)
    FROM job_postings_fact
    WHERE job_work_from_home = True
) AS median_market_remote_salary
FROM (
    SELECT
        job_title_short,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) AS clean_jobs
GROUP BY job_title_short
HAVING MEDIAN(salary_year_avg) > (
    SELECT MEDIAN(salary_year_avg)
    FROM job_postings_fact
    WHERE job_work_from_home = True
)
LIMIT 10;

--Skenario CTE
-- Compare how much more (or less) remote roles pay compared to onsite toles for each job title
-- Use CTE TO calculate median salary by title and work arrangement, then compare those medians
WITH title_median AS(
SELECT 
    job_title_short,
    job_work_from_home,
    MEDIAN(salary_year_avg):: INT AS median_salary --::INT bentuk lain dari parse
FROM job_postings_fact
WHERE job_country = 'United States'
GROUP BY
    job_title_short, --Ingat karna ada fungsi aggregation, maka yg di griup by sisanya yg tidak di aggregate
    job_work_from_home
)
SELECT 
    r.job_title_short,
    r.median_salary AS remote_median_salary,
    o.median_salary AS onsite_median_salary,
    (r.median_salary - o.median_salary) AS remote_premium
FROM title_median AS r
INNER JOIN title_median AS o
ON r.job_title_short = o.job_title_short
WHERE r.job_work_from_home = TRUE
    AND o.job_work_from_home = FALSE
ORDER by remote_premium DESC;


--EXIST VS NOT EXIST
/*Konsepnya ada source tbl dan target tbl
EXIST = akan menampilkan nilai jika kedua tabl punya value
NOT EXIST = hanya menampilkan nilai source tbl jika tidak ada juga di target tbl*/
--Indentify job postings that have no associated skills bedore loading them into data mart
SELECT *
FROM job_postings_fact AS tgt
WHERE NOT EXISTS(
    SELECT *
    FROM skills_job_dim AS src
    WHERE tgt.job_id = src.job_id
)
ORDER BY job_id
LIMIT 10;

SELECT *
FROM job_postings_fact AS tgt
WHERE EXISTS(
    SELECT *
    FROM skills_job_dim AS src
    WHERE tgt.job_id = src.job_id
)
ORDER BY job_id
LIMIT 10;