-- ARRAY
SELECT [1,2,3];
SELECT ['a','b','c'] AS var;

--Misal kita akan membikin 1 table baru
WITH skills AS(
    SELECT 'Python' AS skill
    UNION ALL
    SELECT 'SQL'
    UNION ALL
    SELECT 'R'
), skills_array AS( --mengubah jadi array
    SELECT ARRAY_AGG(skill ORDER BY skill) AS skills  --ARRAY_AGG DAN ORDER BY agar index tidak berubah ini PENTING !!!
    FROM skills
)
SELECT 
    skills[1] AS first_skill,
    skills[2] AS second_skill,
    skills[3] AS third_skill,
FROM skills_array;

--STRUCT
SELECT {skills:'python', type:'programming'} AS skill_struct;

WITH skill_struct AS(
    SELECT
        STRUCT_PACK(
            skill := 'PYTHON',
            type := 'Programming'
    ) AS s
)
SELECT
    s.skill,
    s.type
FROM skill_struct;

WITH skill_table AS(
    SELECT 'Python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'SQL', 'query_language'
    UNION ALL
    SELECT 'R', 'programming'
)
SELECT
    STRUCT_PACK(
        skill := skills,
        type := types
    ) AS struct_skill
FROM skill_table;

--Array of struct
SELECT [
    {skills: 'python', type:'programming'},
    {skills: 'sql', type:'query_language'}
];

WITH skill_table AS(
    SELECT 'Python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'SQL', 'query_language'
    UNION ALL
    SELECT 'R', 'programming'
), skills_array_struct AS(
    SELECT
        ARRAY_AGG(
            STRUCT_PACK(
                skill := skills,
                type := types
            ) ORDER BY skills --ARRAY_AGG DAN ORDER BY agar index tidak berubah ini PENTING !!!
        ) array_struct
    FROM skill_table
)
SELECT
    array_struct[1].skill,
    array_struct[2],
    array_struct[3]
FROM skills_array_struct;

--MAP tapi jarang dipake
--Beda dengan ARRAY, MAP tidak berurutan, dan perlu key=>values
WITH skill_map AS(
    SELECT MAP{'skills':'python', 'type':'programming'} AS skill_type
)
SELECT 
    skill_type
FROM skill_map;

--mISAL Kita ingin mengambil values nya
WITH skill_map AS(
    SELECT MAP{'skills':'python', 'type':'programming'} AS skill_type
)
SELECT 
    skill_type['skills'],
    skill_type['type']
FROM skill_map;

--JSON
SELECT
    '{"skill":"python", "type":"programming"}'::JSON;

WITH raw_skill_json AS(
    SELECT
        '{"skill":"python", "type":"programming"}'::JSON AS skill_json
)
SELECT --kita ingin mengubah ke STRUCT
    STRUCT_PACK(
        skill := json_extract_string(skill_json, '$.skill'),
        type := json_extract_string(skill_json, '$.type')
    ) AS struct_from_json
FROM raw_skill_json;

--JSON to Array of Structs
WITH raw_json AS(
    SELECT
        '[
        {"skills":"python", "types":"programming"},
        {"skills":"sql", "types":"query_language"},
        {"skills":"r", "types":"programming"}
        ]'::JSON AS skills_json
)
SELECT 
    ARRAY_AGG(
        STRUCT_PACK(
            skill := json_extract_string(e.value, '$.skills'),
            type := json_extract_string(e.value, '$.types')
        )
    ORDER BY json_extract_string(e.value, '$.skills')
    ) AS skills
FROM
    raw_json, json_each(skills_json) AS e;


-- Array - Final Ex
-- Build a flat skill table for co worker to access job titles, salary info, skills in one table
CREATE OR REPLACE TEMP TABLE job_skills_array AS
SELECT --kalo mau lihat isinya, mulai dari run query SELECT aja
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array --dibuat jadi array
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;

--FRom the persepctive data analyst, analyze the median salary per skill
--kedua, buat CTE
WITH flat_skills AS(
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_array) AS skill --Pertama kita unnest dulu skill nya
    FROM
        job_skills_array
)
SELECT
    skill,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill
HAVING median_salary IS NOT NULL 
ORDER BY median_salary DESC
LIMIT 50;



-- Array of Struct - Final Ex
-- Build a flat skill table for co worker to access job titles, salary info, skills in one table

CREATE OR REPLACE TEMP TABLE job_skills_array_struct AS
SELECT 
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
        STRUCT_PACK(
            skill_type := sd.type,
            skill_name := sd.skills
        )
    ) AS skills_required
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;

--FRom the persepctive data analyst, analyze the median salary per skill
WITH flat_skills AS(
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_required).skill_type AS skill_type,
        UNNEST(skills_required).skill_name AS skill_name
    FROM
        job_skills_array_struct
)
SELECT
    skill_name,
    skill_type,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill_name, skill_type
HAVING median_salary IS NOT NULL 
ORDER BY median_salary DESC
LIMIT 50;