SELECT
    job_posted_date
FROM job_postings_fact
LIMIT 10;

SELECT
    job_posted_date,
    job_posted_date:: DATE AS date,
    job_posted_date:: TIME AS time,
    job_posted_date:: TIMESTAMP AS timestamp,
    job_posted_date:: TIMESTAMPTZ AS timestampz
FROM job_postings_fact
LIMIT 10;

SELECT
    EXTRACT(YEAR FROM job_posted_date) AS job_posted_year,
    EXTRACT(MONTH FROM job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer'
GROUP BY
    EXTRACT(YEAR FROM job_posted_date),
    EXTRACT(MONTH FROM job_posted_date)
ORDER BY job_posted_year, job_posted_month;

--DATE TRUNC
SELECT
    job_posted_date,
    DATE_TRUNC('year', job_posted_date) AS truncated_year,
    DATE_TRUNC('quarter', job_posted_date) AS truncated_quarter,
    DATE_TRUNC('month', job_posted_date) AS truncated_month,
    DATE_TRUNC('week', job_posted_date) AS truncated_week,
    DATE_TRUNC('day', job_posted_date) AS truncated_day,
    DATE_TRUNC('hour', job_posted_date) AS truncated_hour
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 10;

SELECT
    DATE_TRUNC('month', job_posted_date) AS job_posted_month, --kalo date_truct dia akan mengembalikan format yy-MM-dd
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE 
    job_title_short = 'Data Engineer' 
    AND EXTRACT(YEAR FROM job_posted_date) = 2024
GROUP BY
    DATE_TRUNC('month', job_posted_date)
ORDER BY job_posted_month;

--TIMESTAMP TIMEZONE 
SELECT
    job_posted_date AT TIME ZONE 'UTC'
FROM job_postings_fact
LIMIT 10;
--kita ubah menjadi EST caranya
SELECT
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' --jadi apa datettime data nya kemudian convert ke datetime yang diinginkan
FROM job_postings_fact
LIMIT 10;

--Misal kita ingin mengetahui jenis pekerjaan yang di post di NYC
SELECT
    job_title_short,
    job_location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'
FROM job_postings_fact
WHERE
    job_location LIKE 'New York, NY'
LIMIT 30;

--Kemudian kita bisa analisa, berapa banyak job posting tiap jam nya
SELECT
    EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') AS job_posted_hour,
    COUNT(job_id)
FROM job_postings_fact
WHERE
    job_location LIKE 'New York, NY'
GROUP BY EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST')
ORDER BY 
    job_posted_hour
LIMIT 30;

/*
KESIMPULAN
EXTRACT FROM lebih enak kalo dipake buat tampilin yang micro contoh hourly dia nampilin dari jam 0-24
DATE_TRUNC enak kalo mau lihat harian, bulanan, tahunan*/