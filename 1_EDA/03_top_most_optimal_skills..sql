/*
Question: What are the most optimal skills for data engineer
balancing demand san salary?
-Create a ranking column thath combines demand count and median 
salary to identify the most valuable skills
-Focus on remote DE positions with specified annual salaries
-Why? The approach hihglight skills thath balance market demand
and financial rewar. It weitght core skills appropriately, rather than letting rare,
outlier skills sistort the results
*/

SELECT
sd.skills,
ROUND(MEDIAN(jpf.salary_year_avg),0) AS median_salary,
-- COUNT(jpf.*) AS demand_count,
ROUND(LN(COUNT(jpf.*)),1) AS ln_demand_count,
ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*)))/1000000,2) AS optimal_score

FROM
job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
ON sjd.skill_id = sd.skill_id
WHERE
jpf.job_title_short = 'Data Engineer'
AND jpf.job_work_from_home = True
AND jpf.salary_year_avg IS NOT NULL --Supaya Logaritma tidak error.

GROUP BY
sd.skills
HAVING
COUNT(jpf.*) > 100
ORDER BY
median_salary DESC
LIMIT 25;

/*
┌────────────┬───────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ ln_demand_count │ optimal_score │
│  varchar   │    double     │     double      │    double     │
├────────────┼───────────────┼─────────────────┼───────────────┤
│ terraform  │      184000.0 │             5.3 │          0.97 │
│ kubernetes │      150500.0 │             5.0 │          0.75 │
│ airflow    │      150000.0 │             6.0 │          0.89 │
│ kafka      │      145000.0 │             5.7 │          0.82 │
│ git        │      140000.0 │             5.3 │          0.75 │
│ pyspark    │      140000.0 │             5.0 │           0.7 │
│ spark      │      140000.0 │             6.2 │          0.87 │
│ go         │      140000.0 │             4.7 │          0.66 │
│ aws        │      137320.0 │             6.7 │          0.91 │
│ scala      │      137290.0 │             5.5 │          0.76 │
│ gcp        │      136000.0 │             5.3 │          0.72 │
│ mongodb    │      135750.0 │             4.9 │          0.67 │
│ snowflake  │      135500.0 │             6.1 │          0.82 │
│ bigquery   │      135000.0 │             4.8 │          0.65 │
│ mysql      │      130500.0 │             4.6 │           0.6 │
│ redshift   │      130000.0 │             5.6 │          0.73 │
│ sql        │      130000.0 │             7.0 │          0.91 │
├────────────┴───────────────┴─────────────────┴───────────────┤
│ 25 rows                                            4 columns │
└──────────────────────────────────────────────────────────────┘
*/