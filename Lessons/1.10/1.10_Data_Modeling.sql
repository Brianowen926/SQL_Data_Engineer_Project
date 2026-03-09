SELECT
job_id,
job_title_short,
salary_year_avg,
company_id
FROM
job_postings_fact
LIMIT 10;

SELECT *
FROM
company_dim
LIMIT 10;

SELECT *
FROM information_schema.tables
WHERE table_catalog='data_jobs';

PRAGMA show_tables; --Untuk lihat schemas
PRAGMA show_tables_expanded; --untuk lihat schemas dan kolom
DESCRIBE skills_dim; --untuk lihat deskripsi data
