SELECT 
table_name,
column_name,
data_type
FROM information_schema.columns
WHERE table_name = 'job_postings_fact';

--Untuk ngubah data ke tipe yang diiginkan
SELECT CAST('123' AS INTEGER);
SELECT CAST('12032002' AS VARCHAR);

SELECT 
CAST(job_id AS VARCHAR) || '-' || CAST(company_id AS VARCHAR), --'more'unique identifier
CAST(job_work_from_home AS INT) AS job_work_from_home, --from bool to INT
CAST(job_posted_date AS DATE) AS job_posted_date, --from timestamp to only date
CAST(salary_year_avg AS DECIMAL(10,0)) AS salary_year_avg --from double to no decimal plcaes
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL --pake ini, kalo gak dikasih NULL semua nanti
LIMIT 10;
/*
┌───────────────────────────────────────────────────────────────────┬────────────────────┬─────────────────┬─────────────────┐
│ ((CAST(job_id AS VARCHAR) || '-') || CAST(company_id AS VARCHAR)) │ job_work_from_home │ job_posted_date │ salary_year_avg │
│                              varchar                              │       int32        │      date       │  decimal(10,0)  │
├───────────────────────────────────────────────────────────────────┼────────────────────┼─────────────────┼─────────────────┤
│ 4651-4651                                                         │                  0 │ 2023-01-01      │          110000 │
│ 4699-4699                                                         │                  0 │ 2023-01-01      │           65000 │
│ 4804-4804                                                         │                  1 │ 2023-01-01      │           90000 │
│ 4810-4810                                                         │                  0 │ 2023-01-01      │           55000 │
│ 4833-4833                                                         │                  0 │ 2023-01-01      │          120531 │
│ 4846-4846                                                         │                  0 │ 2023-01-01      │          300000 │
│ 5089-5089                                                         │                  0 │ 2023-01-01      │           51000 │
│ 5123-5123                                                         │                  0 │ 2023-01-01      │          133500 │
│ 5321-5321                                                         │                  0 │ 2023-01-01      │           77500 │
│ 5325-5321                                                         │                  0 │ 2023-01-01      │          125000 │
├───────────────────────────────────────────────────────────────────┴────────────────────┴─────────────────┴─────────────────┤
│ 10 rows                                                                                                          4 columns │
└────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/