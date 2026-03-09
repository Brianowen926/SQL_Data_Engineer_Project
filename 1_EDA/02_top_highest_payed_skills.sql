/*
Question: What are the highest paying skills for data engineer?
-Calculate median salary for each skill required in DE
-Focues on remote positions with specified salaries
-Include skills frequency to identify both salary and demand
-Why? Helps identify which skills command the highest compensation while showing
how common those skills are, providing a more complete picture for skill dev
*/

SELECT
sd.skills,
ROUND(MEDIAN(jpf.salary_year_avg),0) AS median_salary,
COUNT(jpf.*) AS demand_count

FROM
job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
ON sjd.skill_id = sd.skill_id
WHERE
jpf.job_title_short = 'Data Engineer'
AND 
jpf.job_work_from_home = True
GROUP BY
sd.skills
HAVING
COUNT(jpf.*) > 100
ORDER BY
median_salary DESC
LIMIT 25;

/*
┌───────────────┬──────────────┬───────────┐
│ median_salary │ demand_count │  skills   │
│    double     │    int64     │  varchar  │
├───────────────┼──────────────┼───────────┤
│      210000.0 │          232 │ rust      │
│      196698.0 │           98 │ sheets    │
│      192500.0 │           45 │ solidity  │
│      184000.0 │          912 │ golang    │
│      184000.0 │         3248 │ terraform │
│      180000.0 │           19 │ next.js   │
│      176250.0 │           15 │ ggplot2   │
│      175500.0 │          364 │ spring    │
│      172500.0 │            9 │ erlang    │
│      172500.0 │            1 │ ocaml     │
│      172500.0 │           17 │ haskell   │
│      170000.0 │          277 │ neo4j     │
│      169616.0 │          582 │ gdpr      │
│      168438.0 │          127 │ zoom      │
│      167500.0 │          445 │ graphql   │
│      162500.0 │           61 │ plotly    │
│      162250.0 │          265 │ mongo     │
│      159350.0 │           31 │ centos    │
│      157500.0 │            5 │ mxnet     │
│      157500.0 │          204 │ fastapi   │
│      156000.0 │            9 │ drupal    │
│      156000.0 │           71 │ vue       │
│      155000.0 │          265 │ django    │
│      155000.0 │           37 │ elixir    │
│      155000.0 │          478 │ bitbucket │
├───────────────┴──────────────┴───────────┤
│ 25 rows                        3 columns │
└──────────────────────────────────────────┘
*/