/*Bucket Salaries
 < 25 = 'Low'
 25-50 = 'Medium'
> 50 = 'High'
*/
SELECT 
    job_title_short,
    salary_hour_avg,
    CASE --Penggunaan CASE selalu di akhiri dengan END
        -- WHEN salary_hour_avg IS NULL THEN 'Missing'
        WHEN salary_hour_avg < 25 THEN 'Low'
        WHEN salary_hour_avg < 50 THEN 'Medium'
        ELSE 'High'
    END AS salary_category
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL --karena ada nilai yang NULL jika tidak di statement, maka NULL = High
LIMIT 10;

/*Categorizing Categorixal values
Classify job_title column values as:
'Data Analyst','Data Engineer','Data Scientist'*/

SELECT
    job_title,
    job_title_short,
    CASE
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Analyst%' THEN 'Data Analyst'
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Engineer%' THEN 'Data Engineer'
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Scientist%' THEN 'Data Scientist' 
        ELSE 'Other'
    END AS job_category
FROM job_postings_fact
ORDER BY RANDOM() --buat merandom tapi opsional
LIMIT 10;
--Tapi kalo dilihat ada yang uppercase, ketambahan huruf S atau typo di categorize Other
--Akan dibahas di materi sealnjutnya 

/*Conditional Aggregation
-Calculate median salaries for different buckets
 < $100K
 >= $100K*/
SELECT
    job_title_short,
    MEDIAN(
        CASE
            WHEN salary_year_avg < 100000 THEN salary_year_avg
        END
    ) AS median_low_salary, --bISA CASE END di dalem aggregate func
    MEDIAN(
        CASE
            WHEN salary_year_avg >= 100000 THEN salary_year_avg
        END
    ) AS median_HIGH_salary,
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short
LIMIT 10;

/*
-Final Example: Conditioinal Calculation
-Compute a satandardized_salary using yearly salary and adjusted hourly salary (2000 hour/year)
-Categorize salaries into tiers of:
- <75k 'Low'
- 75K - 150K 'Medium'
- >= 150K 'High'
*/

--Nah STEP 2 kita pake CTE untuk lebih gampang mengkategorikannya
WITH salaries AS( 
    SELECT
        job_title_short,
        salary_hour_avg,
        salary_year_avg,
        CASE
            WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
            WHEN salary_hour_avg IS NOT NULL THEN (salary_hour_avg*2000)
        END AS standardized_salary
    FROM job_postings_fact
)
SELECT 
    *,
    CASE
        WHEN standardized_salary IS NULL THEN 'Missing'
        WHEN standardized_salary < 75000 THEN 'Low'
        WHEN standardized_salary < 150000 THEN 'Medium'
        ELSE 'High'
    END AS salary_bucket
FROM salaries
ORDER BY standardized_salary DESC --bisa kamu comment kalo mau lihat LOw or missing
LIMIT 10;