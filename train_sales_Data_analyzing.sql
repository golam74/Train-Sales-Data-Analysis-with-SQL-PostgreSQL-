--What is the total Sales_Quantity for each Brand by month and day of week?
SELECT 
  brand,
  EXTRACT(MONTH FROM date) AS month,
  TO_CHAR(date, 'Day') AS day_of_week,
  SUM(sales_quantity) AS brand_sales
FROM train_sales
GROUP BY brand, EXTRACT(MONTH FROM date), TO_CHAR(date, 'Day');

--Which brands have the highest and lowest Sales_Quantity overall and on holidays?
select * from (select brand,holiday_indicator,
	sum(sales_quantity) as total_sales,
	rank() over (partition by holiday_indicator order by sum(sales_quantity) desc) as highest_value,
	rank() over (partition by holiday_indicator order by sum(sales_quantity) asc) as lowest_value
	from train_sales
	group by brand, holiday_indicator)total
	where highest_value = 1 or lowest_value = 1
	order by holiday_indicator,total_sales desc
--How does Discount percentage affect Sales_Quantity for each brand?
select * from train_sales

SELECT 
    Brand,
    CASE 
        WHEN Discount < 10 THEN 'Low Discount'
        WHEN Discount BETWEEN 10 AND 30 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS Discount_Level,
    ROUND(AVG(Sales_Quantity), 2) AS Avg_Sales
FROM train_sales
GROUP BY Brand, Discount_Level
ORDER BY Brand, Discount_Level;

--	What is the average Sales_Quantity sold at different Price and Discount levels?
select 
	case
		when price <100 then 'Low_price'
		when Price between 100 and 399 then 'Medium_Price'
		else  'High_Price'
		end as Price_level,
	case
		when discount <10 then 'Low_Discount'
		when discount between 10 and 40 then 'Medium_Discount'
		else 'High_Discount'
		end as Discount_level,
		round(avg(Sales_quantity),2) as avg_sales
		from train_sales
	group by price_level,discount_level
	order by price_level,discount_level

--What is the correlation between Competitor_Price and Sales_Quantity for each brand?
select  brand,
	round(corr(competitor_price,sales_quantity):: Numeric,4)  AS correlation_price
	from train_sales
	group by brand
	order by correlation_price asc;
--What are the average Sales_Quantity and total sales amount (Price × Sales_Quantity) by Day_of_Week?
select day_of_week,
	round(avg(sales_quantity),2) as average_sales ,
	sum(price * sales_Quantity ) as total_sales_amount
	from train_sales
	group by day_of_week

--How do Holiday_Indicators impact Sales_Quantity and discount usage?
select holiday_indicator,
	round(sum(sales_quantity),2) as total_salse,
	round(avg(sales_quantity),2) as avg_sales,
	round(avg(discount):: numeric,2) as avg_discount_use
	from train_sales
	group by holiday_indicator
	order by holiday_indicator
--What are the peak days for sales (Day_of_Week) and how do they compare to competitor pricing?
select day_of_week,
	round(sum(sales_quantity):: numeric,2 ) as Total_price,
	round(avg(competitor_price):: numeric,2) as avg_competitor_price
	from train_sales
	group by day_of_week
	order by day_of_week
--Which past purchase trend values are most associated with higher sales?
select brand,date,sales_quantity,
	lag(sales_quantity) over(partition by brand order by date) as pre_days_salase,
	(sales_quantity -LAG(sales_quantity) OVER (PARTITION BY brand ORDER BY date)) AS sales_change
	from train_sales
--What is the percentage change in sales when discounts are increased or decreased by 10%?
select date,brand,sales_quantity,
	lag(sales_quantity) over (partition by brand order by date) as Prev_sales,
	lag(discount) over(partition by brand order by date) as prev_discoutn,
	round(case
		when lag(sales_quantity)over (partition by brand order by date) is null
		or lag(sales_quantity)over (partition by brand order by date) =0 then null
		else (sales_quantity-lag(sales_quantity)over (partition by brand order by date):: numeric
		/lag(sales_quantity)over (partition by brand order by date)) * 100
		end ,2)as sales_Pct_change,
	round(case
		when lag(discount) over (partition by brand order by date) is null
		or lag (discount) over (partition by brand order by date) = 0 then null
		else (discount- lag (discount)over (partition by brand order by date) :: numeric
		/lag(discount) over (partition by brand order by date)) * 100
		end :: numeric,2) as discount_sale_pct_chang
		from train_sales
		order by brand,date
--How does the Sales_Quantity change when Competitor_Price drops below, equals, or rises above the current product price?
select brand,
	case
		when competitor_price < price then 'Competito_Cheper'
		when competitor_price  = price then 'Comptitor_Equl'
		else 'Comptitor_Expensive'
		end as comtitor_relational,
		round(avg(sales_Quantity),2) as avg_sales,
		sum(sales_quantity) as total_sales
		from train_sales
		group by brand,comtitor_relational
		order by brand,comtitor_relational
		
--For BrandA, what are the average, max, and min Sales_Quantity on holidays vs non-holidays?
select brand,holiday_indicator,
	round(avg(sales_quantity),2) as avg_sales,
	max(sales_quantity) as max_sales,
	min(sales_quantity) as max_sales
	from train_sales
	where brand = 'BrandA'
	group by holiday_indicator, brand
--What are the top 3 days and price points with highest sales for each brand?
select brand,date,price,total_sales
from(
	select
		brand,date,price,
			SUM(COALESCE(sales_quantity,0)) AS total_sales,
			rank()over (partition by brand order by sum(coalesce (sales_quantity,0)) desc) as sales_rank
			from train_sales
			group by brand,date,price)ranked
			where sales_rank <=1
			order by brand, sales_rank;
		



