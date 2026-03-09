/*
Temukan job osting yang memposting 
> 3000 postings
Limit only in US jobs
*/

SELECT 
cd.name AS company_name,
COUNT(jpf.job_id) AS posting_count
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States' --harus petik satu
GROUP BY
cd.name
HAVING COUNT(jpf.job_id) > 3000
ORDER BY posting_count DESC;


EXPLAIN SELECT 
cd.name AS company_name,
COUNT(jpf.job_id) AS posting_count
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States' --harus petik satu
GROUP BY
cd.name
HAVING COUNT(jpf.job_id) > 3000
ORDER BY posting_count DESC;

EXPLAIN ANALYZE 
SELECT 
cd.name AS company_name,
COUNT(jpf.job_id) AS posting_count
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States' --harus petik satu
GROUP BY
cd.name
HAVING COUNT(jpf.job_id) > 3000
ORDER BY posting_count DESC;