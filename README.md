# 🛒 Retail Train Sales Data Analysis with SQL (PostgreSQL)

## 📖 Project Overview
This project demonstrates **end-to-end SQL analytics** on a retail sales dataset using **PostgreSQL**.  
The dataset contains **20,000+ rows** of sales transactions with features such as:  

- Date, Day of Week, Holiday Indicator  
- Category, Brand  
- Past Purchase Trends  
- Price, Discount, Competitor Price  
- Sales Quantity  

The goal is to answer **real-world business questions** using SQL — from **basic aggregations** to **advanced analytics** with window functions and correlation analysis.  

---

## 🎯 Objectives
- ✅ Compare holiday vs non-holiday sales performance  
- ✅ Identify the impact of discounts on sales quantity  
- ✅ Analyze competitor pricing vs our product pricing  
- ✅ Rank brands by revenue and sales performance  
- ✅ Detect sales trends using `LAG()` and moving averages  
- ✅ Explore correlation between price, discount, and sales  

---

## ⚡ SQL Concepts Covered
- Basic Queries → `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`  
- Aggregations → `SUM()`, `AVG()`, `MIN()`, `MAX()`  
- Conditional Logic → `CASE WHEN`  
- Window Functions → `RANK()`, `LAG()`, `LEAD()`, `OVER()`  
- Statistical Analysis → `CORR()` for correlation  
- Data Bucketing → price ranges, discount ranges, competitor comparison  

---

## 📊 Example Business Questions Answered
1. Do holidays increase sales across categories?  
2. How do discounts affect sales for each brand?  
3. Which brands perform best compared to competitors?  
4. What are the **top 3 days and price points** with the highest sales per brand?  
5. What is the % change in sales when discounts rise/fall?  
6. Which past purchase trend values are linked to higher sales?  

---

## 🛠️ Tech Stack
- **Database:** PostgreSQL  
- **Language:** SQL  
- **Dataset:** Synthetic retail sales data (20,000+ rows)  

---
-- 📊 Retail Train Sales Data Analysis with SQL (PostgreSQL)
-- Author: Golam Israil

-- ==========================================================
-- 1. Total Sales_Quantity for each Brand by Month & Day of Week
-- ==========================================================
SELECT 
  brand,
  EXTRACT(MONTH FROM date) AS month,
  TO_CHAR(date, 'Day') AS day_of_week,
  SUM(sales_quantity) AS brand_sales
FROM train_sales
GROUP BY brand, EXTRACT(MONTH FROM date), TO_CHAR(date, 'Day')
ORDER BY brand, month, day_of_week;

-- ==========================================================
-- 2. Brands with Highest & Lowest Sales_Quantity (Overall & Holidays)
-- ==========================================================
SELECT * 
FROM (
  SELECT brand,
         holiday_indicator,
         SUM(sales_quantity) AS total_sales,
         RANK() OVER (PARTITION BY holiday_indicator ORDER BY SUM(sales_quantity) DESC) AS highest_value,
         RANK() OVER (PARTITION BY holiday_indicator ORDER BY SUM(sales_quantity) ASC) AS lowest_value
  FROM train_sales
  GROUP BY brand, holiday_indicator
) ranked
WHERE highest_value = 1 OR lowest_value = 1
ORDER BY holiday_indicator, total_sales DESC;

-- ==========================================================
-- 3. Impact of Discount Percentage on Sales_Quantity (per Brand)
-- ==========================================================
SELECT 
    brand,
    CASE 
        WHEN discount < 10 THEN 'Low Discount'
        WHEN discount BETWEEN 10 AND 30 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS discount_level,
    ROUND(AVG(sales_quantity), 2) AS avg_sales
FROM train_sales
GROUP BY brand, discount_level
ORDER BY brand, discount_level;

-- ==========================================================
-- 4. Average Sales at Different Price & Discount Levels
-- ==========================================================
SELECT 
    CASE
        WHEN price < 100 THEN 'Low Price'
        WHEN price BETWEEN 100 AND 399 THEN 'Medium Price'
        ELSE 'High Price'
    END AS price_level,
    CASE
        WHEN discount < 10 THEN 'Low Discount'
        WHEN discount BETWEEN 10 AND 40 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS discount_level,
    ROUND(AVG(sales_quantity), 2) AS avg_sales
FROM train_sales
GROUP BY price_level, discount_level
ORDER BY price_level, discount_level;

-- ==========================================================
-- 5. Correlation between Competitor Price & Sales_Quantity
-- ==========================================================
SELECT  
    brand,
    ROUND(CORR(competitor_price, sales_quantity)::NUMERIC, 4) AS correlation_price
FROM train_sales
GROUP BY brand
ORDER BY correlation_price ASC;

-- ==========================================================
-- 6. Average Sales_Quantity & Total Sales Amount by Day of Week
-- ==========================================================
SELECT 
    day_of_week,
    ROUND(AVG(sales_quantity), 2) AS average_sales,
    SUM(price * sales_quantity) AS total_sales_amount
FROM train_sales
GROUP BY day_of_week
ORDER BY day_of_week;

-- ==========================================================
-- 7. Impact of Holidays on Sales & Discounts
-- ==========================================================
SELECT 
    holiday_indicator,
    ROUND(SUM(sales_quantity), 2) AS total_sales,
    ROUND(AVG(sales_quantity), 2) AS avg_sales,
    ROUND(AVG(discount)::NUMERIC, 2) AS avg_discount_used
FROM train_sales
GROUP BY holiday_indicator
ORDER BY holiday_indicator;

-- ==========================================================
-- 8. Peak Sales Days vs Competitor Pricing
-- ==========================================================
SELECT 
    day_of_week,
    ROUND(SUM(sales_quantity)::NUMERIC, 2) AS total_sales,
    ROUND(AVG(competitor_price)::NUMERIC, 2) AS avg_competitor_price
FROM train_sales
GROUP BY day_of_week
ORDER BY total_sales DESC;

-- ==========================================================
-- 9. Past Purchase Trends (Sales Change using LAG)
-- ==========================================================
SELECT 
    brand,
    date,
    sales_quantity,
    LAG(sales_quantity) OVER(PARTITION BY brand ORDER BY date) AS prev_day_sales,
    (sales_quantity - LAG(sales_quantity) OVER (PARTITION BY brand ORDER BY date)) AS sales_change
FROM train_sales
ORDER BY brand, date;

-- ==========================================================
-- 10. Percentage Change in Sales vs Discount Change
-- ==========================================================
SELECT 
    date,
    brand,
    sales_quantity,
    LAG(sales_quantity) OVER (PARTITION BY brand ORDER BY date) AS prev_sales,
    LAG(discount) OVER (PARTITION BY brand ORDER BY date) AS prev_discount,
    ROUND(
        CASE
            WHEN LAG(sales_quantity) OVER (PARTITION BY brand ORDER BY date) IS NULL
              OR LAG(sales_quantity) OVER (PARTITION BY brand ORDER BY date) = 0 
            THEN NULL
            ELSE ( (sales_quantity - LAG(sales_quantity) OVER (PARTITION BY brand ORDER BY date))::NUMERIC 
                 / LAG(sales_quantity) OVER (PARTITION BY brand ORDER BY date) ) * 100
        END, 2
    ) AS sales_pct_change,
    ROUND(
        CASE
            WHEN LAG(discount) OVER (PARTITION BY brand ORDER BY date) IS NULL
              OR LAG(discount) OVER (PARTITION BY brand ORDER BY date) = 0 
            THEN NULL
            ELSE ( (discount - LAG(discount) OVER (PARTITION BY brand ORDER BY date))::NUMERIC 
                 / LAG(discount) OVER (PARTITION BY brand ORDER BY date) ) * 100
        END, 2
    ) AS discount_pct_change
FROM train_sales
ORDER BY brand, date;

-- ==========================================================
-- 11. Sales Impact of Competitor Pricing Relation
-- ==========================================================
SELECT 
    brand,
    CASE
        WHEN competitor_price < price THEN 'Competitor_Cheaper'
        WHEN competitor_price = price THEN 'Competitor_Equal'
        ELSE 'Competitor_Expensive'
    END AS competitor_relation,
    ROUND(AVG(sales_quantity), 2) AS avg_sales,
    SUM(sales_quantity) AS total_sales
FROM train_sales
GROUP BY brand, competitor_relation
ORDER BY brand, competitor_relation;

-- ==========================================================
-- 12. BrandA Holiday vs Non-Holiday Sales
-- ==========================================================
SELECT 
    brand,
    holiday_indicator,
    ROUND(AVG(sales_quantity), 2) AS avg_sales,
    MAX(sales_quantity) AS max_sales,
    MIN(sales_quantity) AS min_sales
FROM train_sales
WHERE brand = 'BrandA'
GROUP BY brand, holiday_indicator
ORDER BY holiday_indicator;

-- ==========================================================
-- 13. Top 3 Days & Price Points with Highest Sales per Brand
-- ==========================================================
SELECT 
    brand,
    date,
    price,
    total_sales
FROM (
    SELECT
        brand,
        date,
        price,
        SUM(COALESCE(sales_quantity, 0)) AS total_sales,
        RANK() OVER (PARTITION BY brand ORDER BY SUM(sales_quantity) DESC) AS sales_rank
    FROM train_sales
    GROUP BY brand, date, price
) ranked
WHERE sales_rank <= 3
ORDER BY brand, sales_rank;

---

## 📂 Repository Structure
- [`train_sales_Data_analyzing.sql`](./train_sales_Data_analyzing.sql) → SQL queries answering business questions  
- [`https://github.com/golam74/Train-Sales-Data-Analysis-with-SQL-PostgreSQL-/blob/main/Train.csv`](./Train.csv) → Dataset  

---

## 🚀 How to Run
1. Create a table `train_sales` in PostgreSQL and load the dataset (`Train.csv`).  
2. Open and run queries from [`train_sales_Data_analyzing.sql`](./train_sales_Data_analyzing.sql).  
3. Explore insights, modify queries, and extend analysis.  

---

## 🎓 Learning Outcomes
By completing this project, you will learn how to:  
- Write professional SQL queries for business analytics  
- Use advanced SQL functions for trend and correlation analysis  
- Apply SQL to **real-world retail problems**  
- Present insights in a clear, structured, professional format  

---

## 📌 Author
👤 **Golam Israil**  
_Data Analytics & Automation Enthusiast_  

---

⭐ If you find this project useful, don’t forget to **star the repository**!
