# [TUTORIAL VIDEO](https://www.youtube.com/watch?v=UjhFbq4uU2Y) 

## Dalam kasus ini pake DUCKDB
cara running di GITBASH: duckdb md: [nama DB]

## EDA
Business analyst dan market analys adalah client dari DATA ENGINEER
![alt text](image-1.png)

Ketika kita ngerti end goal nya maka kita akan bisa memahami arsitektur untuk client kita

Di akhir video objektif nya adalah
![alt text](image-2.png)

## ERD
![alt text](image-3.png)


## GIT Setup **Kalo bingung bisa lihat di menit 5.30..**
### Kalo push file origin
1. git push . (kalo mau semua file) atau git push [nama file]
2. git commit -m "Infokan apa yg mau di push"
**_Setiap kali ada update ulangi langkah 1 dan 2_**
3. git status untuk lihat status nya apakah sudah di push

**FYI, bisa juga liat Source Control di panel paling kiri untuk lihat apa aja**
### Contoh command nya
![hahaha](image-4.png)

### Git pull
1. Buat repo di github
2. copass link nya
3. di terminal git remote add origin [link nya]
4. git push -u origin main (-u artinya upstream)
5. git fetch
6. git pull

**_Kalo misal edit code di GitHub nya langsung, di local tidak akan terupdate_**
**_Untuk update maka perlu git pull aja_**

### DDL & DML
![alt text](image.png)

### SOURCE TBL
![alt text](image-5.png)
A. CTAS:
- untuk membuat table 
- stored on disk
- snapshot at creation time
- fast reads
- source change & autoupdate

B. VIEW:
- stored query definition
- virtual table
- not data stored

C. TEMP TABLE
- Sssion scoped table
- Materialized data
- Seasoning scope
- aUTODELETE on disconnect

[Nek bingung ini file e](Lessons/1.22/1.22_DD_DML_pt2.sql)
![alt text](image-6.png)

-VIEW kalo butuh latest data untuk data
-CTAS kalo fast read, same result
-TEMP untuk testing debugging

#### **[File untuk pipeline](Lessons\1.24\1.24_priority_tables_snapshot.sql)**
Diagaram pipeline nya kayak gini
![alt text](image-8.png)

## Data Modeling
Kenapa Data Modeling penting?
- Untuk menyeragamkan design agar kita bisa akses data lebih cepat
- lebih mudah di analisa dan di aggregate
![alt text](image-7.png)

ERP 
- fungsi untuk run entire bisnis berfokus pada back office (include HR, operation, DATA)
cONTOH NYA KAYAK orcale

CRM (Customer Relationship Management)
- Fungsi untuk menumbuhkan revenue lebih ke front office

DATABASE ada 2 relationship: OLTP dan OLAP
![alt text](image-9.png)