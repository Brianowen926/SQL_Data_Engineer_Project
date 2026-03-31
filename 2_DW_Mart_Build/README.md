# Data Warehouse & Mart Build: Production ETL Pipeline

An end-to-end data engineering pipeline that transforms raw CSV files form Google Cloud Storage into a normalized star schema data warehouse, then builds analytical data marts.
![Data Pipeline Architecture](../resources/1_2_Project2_Data_Pipeline.png)

## Summary
- **Pipeline Scope:** Built a complete **ETL pipeline** from raw CSVs to star schema warehouse to analytical marts
- **Data modeling:** Designed a **star schema** with fact tables, dimensions, and bridge tables for many-to-many realtionships
- **ETL development:** Implemented **extract, transform, load** processes with idempotent operations and data quality checks
- **Mart architecture:** Created **specialized data marts** (clat, skills, priority) with additive measures and incremental update patterns

## Problem & Context

**Challenge:** Data teams need a single source of truth system - a data warehouse- to enable consistent, reliable analysis across the organization. Additionally, specialized data marts are required to optimize resources by pre-aggregating data for specific business use cases, reducing query complexity and improving performance for common analytical patterns.

**Solution:** End-to-end ETL pipeline that extracts CSVs from cloud storage, normalizes them into a star schema warehouse (separating facts from dimensions) and creates specialized data marts optimized for specific use cases (flat queries, skill demand analysis. priority role tracking)

## Pipeline Architecture
![Data Pipeline Architecture](../resources/1_2_Project2_Data_Pipeline.png)
The pipeline transforms job postings CSVs from Google Cloud Storage into a normalized star schema data warehouse, then builds specialized analytical data marts. BI tools (Excel, Power BI, Tableau, Pyhon) consume from both the warehouse and marts.

## Data Warehouse
The data warehouse implements a star scehama with 'company_dim', 'job_postings_fact', 'skills_job_dim' tables.

![Data Warehouse schema](../resources/1_2_Data_Warehouse.png)

**SQL Files:**
- [01_create_tables_dw.sql](../2_DW_Mart_Build/01_create_tables_dw.sql) - Defines star schema with 4 core tables
- [02_load_schema_dw.sql](../2_DW_Mart_Build/02_load_schema_dw.sql) - Extracts CSVs from GCS and loads into warehouse tables

- **Purpose:** Star schema serving as single source of truth for analytical queries
- **Grain:** One row per job posting in the fact table ('job_postings_fact')

## Flat Mart
Denormalized table with all dimensions for ad-hoc queries.
![flat mart schema](../resources/1_2_Flat_Mart.png)

- **SQL File:** ['03_create_flat_mart.sql'](../2_DW_Mart_Build/03_create_flat_mart.sql) - Builds denormalized table with all dimensions joined
- **Purpose:** Denormalized table for quick ad-hoc queries
- **Grain:** One row per job posting with all dimensions joined

## Skills Mart
Time-series skill demand analysis with additive measures.
![Skills mart schema](../resources/1_2_Skills_Mart.png)

- **SQL File:** ['04_create_skills_mart.sql'](../2_DW_Mart_Build/04_create_skills_mart.sql) - Builds time-series skill demand mart
- **Purpose:** Time-series analysis of skill demand over time with additive measures
- **Grain:** 'skill_id + month_star_date + job_title_short'
- **Key Features:** All measures are additive (counts/sums) for safe re-aggregation

## Priority Mart
Priority role tracking with incremental updates using MERGE operations.
![Priority mart schema](../resources/1_2_Priority_Mart.png)

- **SQL File:** ['05_create_priority_mart.sql'](../2_DW_Mart_Build/05_create_priority_mart.sql) - Initial build of priority roles and jobs snapshot
['06_update_priority_mart.sql'](../2_DW_Mart_Build/06_update_priority_mart.sql) - Incremental update using MERGE (upsert pattern)
- **Purpose:** Track priority roles and job snapshots with incremental update capabilities
- **Grain:** One row per job posting with priority level assignment
- **Key Features:** MERGE operations for incremental updates - demonstrates production - ready upsert patterns (INSERT, UPDATE, DELETE in single statement)

## Data Engineering Skills Demonstrated

### ETL Pipeline Development
- Extract: Direct CSV loading from Google Cloud Storage using DuckDB
- Transform: Data normalization, type conversion ('CAST', 'DATE_TRUNCT'), and quality filtering
- Load: Idempotent table creation with 'DROP_TABLE IF EXISTS' pattern
- Incremental Updates: Merge operations for upsert patterns (INSERT, UPDATE, DELETE in single statement)
- Orchestration: Master SQL script ('build_dw_marts.sql') for automated pipeline execution

### Dimensional Modeling
- Star Schema Design: Fact table ('job_postings_fact') with dimension tables ('company_dim, skills_dim')
- Bridge Tables: Many-tomany relationship handling ('skills_job_dim, bridge_company_location, bridge_job_title')
- Grain Definition: Proper fact table granularity (skill+month, company+title+location+month)
- Additive Measures: Counts and sums that can be safely re-aggregated at any level
- Surrogate Keys: Sequential ID generation using CTEs with self-joins (optional company_mart build only)

## SQL Advanced Techniques
- **DDL Operations:** 'CREATE TABLE', 'DROP TABLE', 'CREATE SCHEMA' for schema management
- **DML Operations:** 'INSERT INTO ... SELECT' with explicit column mapping from CSV sources
- **MERGE Operations:** incremental updates using 'MERGE INTO' with 'WHEN MATCHED', 'WHEN NOT MATCHED', and 'WHEN NOT MATCHED BY SOURCE' clauses for production-ready upsert patterns
- **CTEs:** Common Table Expression for complex transformations and boolean flag conversions
- **Date Functions:** 'DATE_TRUNC('month')', 'EXTRACT(quarter)' for temporal dimension creation
- **String Functions:** 'STRING_AGG' for concatenation, 'REPLACE' for data cleaning
- **Boolean Logic:** 'CASE WHEN' conversions for aggregating flags (remote, health insurance, no degree)

## Data Quality & Production Practices
- **Indempotency:** All scripts safely rerunable without side effects
- **Data Validation:** Verification queries at each pipeline step to ensure data integrity
- **Type Safety:** Proper data type definitions ('VARCHAR', 'INTEGER', 'DOUBLE', 'BOOLEAN', 'TIMESTAMP')
- **Schema Organization:** Separete schemas ('flat_mart, skills_mart, priority_mart, company_mart') for logical separation
- **Error Handling:** Structured script execution wih clear error messages and progress reporting