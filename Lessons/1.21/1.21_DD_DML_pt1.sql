--.read Lessons/1.21/1.21_DD_DML_pt1.sql

USE data_jobs; --ceritanya kita definisikan dulu pake databse apa
DROP DATABASE IF EXISTS jobs_mart;
CREATE DATABASE IF NOT EXISTS jobs_mart;
SHOW DATABASES;


--Contoh buat schema
SELECT *
FROM information_schema.schemata;
USE jobs_mart; --menggunakan DATABASE jobs_mart
CREATE SCHEMA IF NOT EXISTS staging;
--staging itu seperti sementara. Jadi di schema itu ada main yang utama
SELECT *
FROM information_schema.tables
WHERE table_catalog = 'jobs_mart';

DROP TABLE IF EXISTS main.preferred_roles;

--Contoh kita mamu membuat table baru di jobs_data
CREATE TABLE IF NOT EXISTS staging.preferred_roles(
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);

INSERT INTO staging.preferred_roles(role_id, role_name)
VALUES
(1, 'Data Engineer'),
(2, 'Senior Data Engineer'),
(3, 'Software Engineer');

SELECT *
FROM staging.preferred_roles;

--ALTER TABLE untuk add column
ALTER TABLE staging.preferred_roles
ADD COLUMN preferred_role BOOLEAN;

/*Bisa juga kalo mau DELETE table
ALTER TABLE staging.preferred_roles
DROP COLUMN preferred_role;*/

-- UPDATE
UPDATE staging.preferred_roles
SET preferred_role = FALSE
WHERE role_id = 3;

UPDATE staging.preferred_roles
SET preferred_role = TRUE
WHERE role_id = 1 OR role_id = 2;

--Misal kita ingin mengubah nama table
ALTER TABLE staging.preferred_roles
RENAME TO priority_roles; --tidak perlu definisi ulang staging

SELECT *
FROM staging.priority_roles;

--Misal kita mau RENAME nama column
ALTER TABLE staging.priority_roles
RENAME COLUMN preferred_role TO priority_lvl;

--Ceritnaya col priorty_lvl mau diubah jadi 1,2,3
--KITA MAU UBAH BOOLEAN JADI INTEGER
ALTER TABLE staging.priority_roles
ALTER COLUMN priority_lvl TYPE INTEGER;
UPDATE staging.priority_roles
SET priority_lvl = 3
WHERE role_id = 3;

SELECT *
FROM staging.priority_roles;