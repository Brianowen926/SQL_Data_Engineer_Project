-- LEFT JOIN
/*LEFT/RIGHT JOIN dipake jika ada table yang tidak punya FK dengan table 1 nya*/
--Kita mau menghubungkan table job_posting_fact dengan company_dim

--Print dulu lihat isi table job posting dan company dim
PRAGMA show_tables_expanded;
DESCRIBE job_postings_fact;
DESCRIBE company_dim;

/*caranya 
1. tulis APA YANG MAU DI JOIN DULU
2. tulis SELECT kan apa yang mau ditampilkan dengan ALIAS
*/
SELECT
jpf.job_id,
jpf.job_title_short,
cd.company_id,
cd.name AS company_name,
jpf.job_location
FROM
job_postings_fact AS jpf --TULIS DULU APA YANG MAU DI JOIN kan
LEFT JOIN company_dim AS cd --Bikin Alias supaya gampang
ON jpf.company_id = cd.company_id -- hubungkan foreign key nya.
LIMIT 10;

-- SAMA kayak LEFT JOIN
SELECT
jpf.job_id,
jpf.job_title_short,
cd.company_id,
cd.name AS company_name,
jpf.job_location
FROM
job_postings_fact AS jpf --TULIS DULU APA YANG MAU DI JOIN kan
RIGHT JOIN company_dim AS cd --Bikin Alias supaya gampang
ON jpf.company_id = cd.company_id -- hubungkan foreign key nya.
LIMIT 10;

--INER JOIN Hanya akan mengembalikan 2 table yang berasosiasi. Gampangannya Logika AND 
SELECT
jpf.job_id,
jpf.job_title_short,
cd.company_id,
cd.name AS company_name,
jpf.job_location
FROM
job_postings_fact AS jpf 
INNER JOIN company_dim AS cd 
ON jpf.company_id = cd.company_id; 
-- LIMIT 20;

--FULL OUTER AKAN mengembalikan semua nya walaupun tidak ada asosisasi didalamnya
SELECT
jpf.job_id,
jpf.job_title_short,
cd.company_id,
cd.name AS company_name,
jpf.job_location
FROM
job_postings_fact AS jpf 
FULL OUTER JOIN company_dim AS cd 
ON jpf.company_id = cd.company_id 
LIMIT 20;

SELECT *
FROM skills_dim
LIMIT 10;

SELECT *
FROM skills_job_dim
LIMIT 10;

SELECT
jpf.job_id,
jpf.job_title_short,
sjd.skill_id,
sd.skills
FROM
job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
ON sjd.skill_id = sd.skill_id
LIMIT 20;

-- DESCRIBE skills_dim;

SELECT
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id;
-- LIMIT 20;

--misal kita ingin mengetahui dari table lain
SELECT
jpf.job_title_short,
cd.company_id, 
cd.name,
sd.skills,
sd.type

FROM job_postings_fact AS jpf
INNER JOIN company_dim AS cd
ON jpf.company_id = cd.company_id
INNER JOIN skills_job_dim as sjd 
ON sjd.job_id = jpf.job_id
INNER JOIN skills_dim AS sd
ON sd.skill_id = sjd.skill_id
LIMIT 10;