-- =============================
-- 1️⃣ Data Cleaning and Storage
-- =============================

-- We create a cleaned version of the dataset for analysis
-- Raw table (Udemy_Courses) is preserved
-- Cleaned table will be stored permanently
WITH cleaned_courses AS (
    SELECT
        course_id,
        course_title,
        subject,
        
        -- Standardize levels: Beginner, Intermediate, Advanced
        CASE 
            WHEN LOWER(level) LIKE 'beginner%' THEN 'Beginner'
            WHEN LOWER(level) LIKE 'intermediate%' THEN 'Intermediate'
            WHEN LOWER(level) LIKE 'advanced%' THEN 'Advanced'
            ELSE 'Unknown'
        END AS level_cleaned,
        
        is_paid,
        
        -- Price cleaning: Free courses = 0, Paid courses = decimal price
        CASE 
            WHEN is_paid = 1 THEN CAST(price AS DECIMAL(10,2))
            ELSE 0
        END AS price_cleaned,
        
        -- Subscribers / reviews / lectures cast to integers
        CAST(num_subscribers AS INT) AS num_subscribers_cleaned,
        CAST(num_reviews AS INT) AS num_reviews_cleaned,
        CAST(num_lectures AS INT) AS num_lectures_cleaned,
        
        -- Safe duration parsing (handles 'X hours' only)
        CASE 
            WHEN content_duration LIKE '%hours%' THEN CAST(REPLACE(content_duration, ' hours','') AS DECIMAL(5,2))
            ELSE NULL
        END AS duration_hours,
        
        -- Convert timestamp to proper date
        CAST(published_timestamp AS DATE) AS published_date
    FROM Udemy_Courses
    WHERE num_subscribers IS NOT NULL  -- exclude courses without subscriber info
)

-- Store into permanent table for repeated analysis
SELECT *
INTO cleaned_courses_table
FROM cleaned_courses;


-- =============================
-- 2️⃣ Business Metrics
-- =============================

-- 2.1 Total number of courses
SELECT COUNT(*) AS total_courses
FROM cleaned_courses_table;

-- 2.2 Subjects by popularity (total & average subscribers)
SELECT 
    subject,
    COUNT(*) AS course_count,
    SUM(num_subscribers_cleaned) AS total_subscribers,
    AVG(num_subscribers_cleaned) AS avg_subscribers
FROM cleaned_courses_table
GROUP BY subject
ORDER BY total_subscribers DESC;

-- 2.3 Free vs Paid courses
SELECT 
    is_paid,
    COUNT(*) AS course_count,
    AVG(price_cleaned) AS avg_paid_price,
    SUM(num_subscribers_cleaned) AS total_subscribers
FROM cleaned_courses_table
GROUP BY is_paid;

-- 2.4 Best level for subscribers
SELECT 
    level_cleaned AS level,
    COUNT(*) AS course_count,
    AVG(num_subscribers_cleaned) AS avg_subscribers,
    SUM(num_subscribers_cleaned) AS total_subscribers
FROM cleaned_courses_table
GROUP BY level_cleaned
ORDER BY avg_subscribers DESC;

-- 2.5 Top 10 most popular courses
SELECT TOP 10
    course_title,
    subject,
    level_cleaned AS level,
    price_cleaned AS price,
    num_subscribers_cleaned AS num_subscribers,
    num_reviews_cleaned AS num_reviews
FROM cleaned_courses_table
ORDER BY num_subscribers_cleaned DESC;


-- =============================
-- 3️⃣ Ranking: Top 5 courses per subject (CTE + ROW_NUMBER)
-- =============================

WITH ranked_courses AS (
    SELECT
        subject,
        course_title,
        level_cleaned AS level,
        price_cleaned AS price,
        num_subscribers_cleaned AS num_subscribers,
        -- SSMS-friendly ROW_NUMBER over partition by subject
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


-- =============================
-- 4️⃣ Optional: Subject engagement by average subscribers
-- =============================

WITH subject_engagement AS (
    SELECT
        subject,
        AVG(num_subscribers_cleaned) AS avg_subscribers
    FROM cleaned_courses_table
    GROUP BY subject
)
SELECT *
FROM subject_engagement
ORDER BY avg_subscribers DESC;
