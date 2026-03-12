-- Nek mau aman jalankan .read Lessons/1.24/1.24_priority_tables.sql

--FILE ini belajar membuat pipeline dari CRUD

--.read Lessons/1.24/1.24_priority_tables_snapshot.sql
-- CREATE TEMP TABLE
-- Tujuannya sebagai referensi untuk update,insert,delete
CREATE OR REPLACE TEMP TABLE src_priority_jobs AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP AS updated_at
FROM
    data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id
INNER JOIN staging.priority_roles AS r
    ON jpf.job_title_short = r.role_name;

-- --CREATE UPDATE STATEMENT
-- UPDATE main.priority_jobs_snapshot AS tgt
-- SET
--     priority_lvl = src.priority_lvl,
--     updated_at = src.updated_at
-- FROM src_priority_jobs AS src
-- WHERE tgt.job_id = src.job_id
--     AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl;

    
-- --CREATE INSERT STATEMENT 
-- --coba insert lalu jalankan file Lessons\1.24\1.24_priority_tables.sql
-- INSERT INTO main.priority_jobs_snapshot(
--     job_id,
--     job_title_short,
--     company_name,
--     job_posted_date,
--     salary_year_avg,
--     priority_lvl,
--     updated_at
-- )
-- SELECT
--     src.job_id,
--     src.job_title_short,
--     src.company_name,
--     src.job_posted_date,
--     src.salary_year_avg,
--     src.priority_lvl,
--     src.updated_at
-- FROM
--     src_priority_jobs AS src
-- WHERE NOT EXISTS (
--     SELECT 1
--     FROM main.priority_jobs_snapshot AS tgt
--     WHERE tgt.job_id = src.job_id
-- );

-- --CREATE DELETE STATEMENT
-- -- coba delete lalu jalankan file Lessons\1.24\1.24_priority_tables.sql
-- DELETE FROM main.priority_jobs_snapshot AS tgt
-- WHERE NOT EXISTS(
--     SELECT 1
--     FROM src_priority_jobs AS src
--     WHERE src.job_id = tgt.job_id
-- );

--MERGE
MERGE INTO main.priority_jobs_snapshot AS tgt
USING src_priority_jobs AS src
ON tgt.job_id = src.job_id

WHEN MATCHED AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl THEN
    UPDATE SET
        priority_lvl = src.priority_lvl,
        updated_at = src.updated_at
WHEN NOT MATCHED THEN
INSERT ( --Ketika insert nama baru, jika job tittle tidak sesuai, maka tidak akan ditambahkan dan ditampilkan
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
    )
VALUES(
    src.job_id,
    src.job_title_short,
    src.company_name,
    src.job_posted_date,
    src.salary_year_avg,
    src.priority_lvl,
    src.updated_at
    )
WHEN NOT MATCHED BY SOURCE THEN DELETE;

SELECT 
    job_title_short,
    COUNT(*) AS job_count,
    MIN(priority_lvl) AS priority_lvl,
    MIN(updated_at) AS updated_at
FROM priority_jobs_snapshot
GROUP BY job_title_short
ORDER BY job_count DESC;