--Automasi proses script
--Jadi gak perlu run file 01 dan 02

-- Step 1: DW - Create star schema tables
.read 01_create_tables_dw.sql

-- Step 2: DW - Load data from CSV into tables
.read 02_load_schema_dw.sql

/*
ntuk jalankan script ini (PASTIKAN SUDAH DI DIRECTOry yang benar)
duckdb dw_mart.duckdb -c ".read build_dw_marts.sql"
*/