
# Udemy SQL Analysis Project

##  Project Overview
This project analyzes Udemy course data using SQL to identify trends in course popularity, pricing patterns, and subscriber engagement.
SQL queries were written to clean, transform, and analyze data to support data-driven insights.

---

## Dataset
- Source: Kaggle – Udemy Courses Dataset
- Public dataset used for educational and portfolio purposes
- Records include:
  - Course title, subject, level
  - Price (free vs paid)
  - Number of subscribers, reviews, and lectures
  - Course duration and published date

---


##  Tools & Skills Used
- SQL Server (SSMS)
- SQL concepts:
  - Data cleaning & standardization
  - CAST / CASE statements
  - Common Table Expressions (CTEs)
  - Window functions (`ROW_NUMBER`)
  - Aggregations (`COUNT`, `SUM`, `AVG`)
  - Grouping and filtering

---

##  Data Cleaning Steps
- Standardized course levels (Beginner / Intermediate / Advanced)
- Converted numeric columns to correct data types
- Handled free vs paid course pricing
- Removed records with missing subscriber data
- Created a cleaned dataset separate from raw data

---

##  Business Questions Answered
- How many courses are available on Udemy?
- Which subjects have the highest number of subscribers?
- Do paid courses attract more subscribers than free courses?
- Which course level performs best on average?
- What are the top 5 courses per subject by subscribers?
- Which subjects show the highest average engagement?

---
## Key Analyses Performed

- Course popularity analysis by subject
- Free vs paid course comparison
- Subscriber engagement analysis
- Course ranking using window functions
- Data aggregation using GROUP BY
- Data cleaning and transformation using CASE and CAST
---
## Sample SQL Queries
### 1. Data Cleaning and Transformation

This query standardizes course levels, converts data types, handles missing values, and creates a cleaned dataset for reliable analysis.

```sql
WITH cleaned_courses AS (
    SELECT
        course_id,
        course_title,
        subject,

        -- Standardize course levels
        CASE 
            WHEN LOWER(level) LIKE 'beginner%' THEN 'Beginner'
            WHEN LOWER(level) LIKE 'intermediate%' THEN 'Intermediate'
            WHEN LOWER(level) LIKE 'advanced%' THEN 'Advanced'
            ELSE 'Unknown'
        END AS level_cleaned,

        is_paid,

        -- Convert price to numeric format
        CASE 
            WHEN is_paid = 1 THEN CAST(price AS DECIMAL(10,2))
            ELSE 0
        END AS price_cleaned,

        -- Convert numeric fields to integers
        CAST(num_subscribers AS INT) AS num_subscribers_cleaned,
        CAST(num_reviews AS INT) AS num_reviews_cleaned,
        CAST(num_lectures AS INT) AS num_lectures_cleaned,

        -- Convert timestamp to date
        CAST(published_timestamp AS DATE) AS published_date

    FROM Udemy_Courses
    WHERE num_subscribers IS NOT NULL
)

SELECT *
INTO cleaned_courses_table
FROM cleaned_courses;
```
### 2. Subject Popularity Analysis

This query identifies the most popular course subjects by calculating the number of courses and total subscribers for each subject.

```sql
SELECT 
    subject,
    COUNT(*) AS course_count,
    SUM(num_subscribers_cleaned) AS total_subscribers,
    AVG(num_subscribers_cleaned) AS avg_subscribers
FROM cleaned_courses_table
GROUP BY subject
ORDER BY total_subscribers DESC;
```
### 3. Free vs Paid Course Analysis

This query compares free and paid courses to understand pricing patterns and subscriber distribution.

```sql
SELECT 
    is_paid,
    COUNT(*) AS course_count,
    AVG(price_cleaned) AS avg_paid_price,
    SUM(num_subscribers_cleaned) AS total_subscribers
FROM cleaned_courses_table
GROUP BY is_paid;
```
### 4. Top 5 Courses per Subject (Ranking)

This query ranks courses within each subject using a window function to identify the top-performing courses based on subscriber count.

```sql
WITH ranked_courses AS (
    SELECT
        subject,
        course_title,
        level_cleaned AS level,
        price_cleaned AS price,
        num_subscribers_cleaned AS num_subscribers,

        ROW_NUMBER() OVER (
            PARTITION BY subject
            ORDER BY num_subscribers_cleaned DESC
        ) AS subject_rank

    FROM cleaned_courses_table
)

SELECT *
FROM ranked_courses
WHERE subject_rank <= 5
ORDER BY subject, subject_rank;
```
---

## Project Files

- [udemy_sql_analysis.sql](udemy_sql_analysis.sql) – SQL queries for cleaning and analysis
- [README.md](README.md) – Project documentation

---

## How to Run

1. Import the dataset into SQL Server
2. Execute the SQL script [udemy_sql_analysis.sql](udemy_sql_analysis.sql)
3. Review query outputs for analysis results
   
---

##  Key Takeaways
- Beginner-level courses tend to attract higher average subscribers
- Technology-related subjects consistently dominate subscriber engagement
- Free courses drive higher enrollment volume, while paid courses create revenue opportunities

---

## Author
Suja  
Data Analyst | SQL | Power BI | Data Visualization  
Open to Remote Opportunities
