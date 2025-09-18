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

## 📂 Repository Structure
- [`train_sales_Data_analyzing.sql`](./train_sales_Data_analyzing.sql) → SQL queries answering business questions  
- [`Train.csv`](./Train.csv) → Dataset  

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
