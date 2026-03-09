/*
QUESTION: Apa most demanded skills for data engineer?
- Identify top 10 demand skills for data engineer
- Focus on remote job postings
- Why?
    Retrieve top 10 skills with hifhest demand in the remote job market,
    providng insight into the most valuable skills for data engineer 
    seeking remote work
*/

SELECT 
sd.skills,
COUNT(jpf.*) AS demand_skills_count

FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
ON sjd.skill_id = sd.skill_id
WHERE
jpf.job_title_short = 'Data Engineer'
AND jpf.job_work_from_home = True
GROUP BY --SETIAP Kali ada Aggregation funct pastikan ada GROUP BY
sd.skills
ORDER BY
demand_skills_count DESC
LIMIT 10;

/*
Ini contoh real case untuk dilihat coworker
┌────────────┬─────────────────────┐
│   skills   │ demand_skills_count │
│  varchar   │        int64        │
├────────────┼─────────────────────┤
│ sql        │               29221 │
│ python     │               28776 │
│ aws        │               17823 │
│ azure      │               14143 │
│ spark      │               12799 │
│ airflow    │                9996 │
│ snowflake  │                8639 │
│ databricks │                8183 │
│ java       │                7267 │
│ gcp        │                6446 │
├────────────┴─────────────────────┤
│ 10 rows                2 columns │
└──────────────────────────────────┘
*/