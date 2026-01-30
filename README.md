# udemy-sql-analysis
SQL data cleaning and analysis project on Udemy courses dataset
# Udemy SQL Analysis Project

## 📌 Project Overview
This project analyzes Udemy course data using SQL to understand course popularity, pricing patterns, subscriber trends, and content performance across different subjects and levels.

The focus of this project is on **data cleaning, transformation, and analytical querying** using real-world messy data.

---

## 📂 Dataset
- Source: Kaggle – Udemy Courses Dataset
- Records include:
  - Course title, subject, level
  - Price (free vs paid)
  - Number of subscribers, reviews, and lectures
  - Course duration and published date

---

## 🛠 Tools & Skills Used
- SQL Server (SSMS)
- SQL concepts:
  - Data cleaning & standardization
  - CAST / CASE statements
  - Common Table Expressions (CTEs)
  - Window functions (`ROW_NUMBER`)
  - Aggregations (`COUNT`, `SUM`, `AVG`)
  - Grouping and filtering

---

## 🧹 Data Cleaning Steps
- Standardized course levels (Beginner / Intermediate / Advanced)
- Converted numeric columns to correct data types
- Handled free vs paid course pricing
- Removed records with missing subscriber data
- Created a cleaned dataset separate from raw data

---

## 📊 Business Questions Answered
- How many courses are available on Udemy?
- Which subjects have the highest number of subscribers?
- Do paid courses attract more subscribers than free courses?
- Which course level performs best on average?
- What are the top 5 courses per subject by subscribers?
- Which subjects show the highest average engagement?

---

## 📁 Project Files
- `udemy_sql_analysis.sql` – SQL queries for cleaning and analysis
- `README.md` – Project documentation

---

## 📌 Key Takeaways
- Beginner-level courses tend to attract higher average subscribers
- Certain subjects consistently dominate subscriber engagement
- Free courses drive volume, while paid courses show pricing patterns worth exploring

---

## 👩‍💻 Author
Suja  
Aspiring Data Analyst
