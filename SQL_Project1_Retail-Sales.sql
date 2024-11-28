-- Change the data type of the column
BEGIN TRANSACTION;

ALTER TABLE RetailSales
ALTER COLUMN transactions_id INT NOT NULL;

ALTER TABLE RetailSales
ALTER COLUMN customer_id INT;

ALTER TABLE RetailSales
ALTER COLUMN gender varchar(15);

ALTER TABLE RetailSales
ALTER COLUMN age int;

ALTER TABLE RetailSales
ALTER COLUMN category varchar(15);

ALTER TABLE RetailSales
ALTER COLUMN quantiy int;

COMMIT TRANSACTION;

-- Add the primary key constraint
ALTER TABLE RetailSales
ADD CONSTRAINT PK_RetailSales PRIMARY KEY (transactions_id);

-- check data type
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'RetailSales' AND COLUMN_NAME = 'sale_date';

-- change sale_date datatype from datetime to date
ALTER TABLE RetailSales
ALTER COLUMN sale_date date;


-- change sale_time datatype from datetime to time(0). time(0) will only include hour, minutes, and seconds
ALTER TABLE RetailSales
ALTER COLUMN sale_time TIME(0);

-- select top n
SELECT TOP 10 * FROM RetailSales

-- count number of rows
SELECT count(*) FROM RetailSales



--- 1. DATA CLEANING ---

-- check null values
SELECT * FROM retailsales
WHERE transactions_id IS NULL 
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR age IS NULL
	OR category IS NULL
	OR quantiy IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL

-- Delete null values
DELETE FROM retailsales
WHERE transactions_id IS NULL 
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR age IS NULL
	OR category IS NULL
	OR quantiy IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL


--- 2. DATA EXPLORATION ---

-- How many sales do we have?
SELECT COUNT(*) AS total_sale FROM retailsales

-- How many customers do we have ?
SELECT COUNT(DISTINCT customer_id) AS total_sale FROM retailsales

-- What categories do we have?
SELECT DISTINCT category FROM retailsales


--- 3. DATA ANALYSIS & BUSINESS KEY PROBLEMS ---

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- ANSWERS
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retailsales
where sale_date='2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * from retailsales
where category='Clothing' AND 
quantiy >= 4 AND 
FORMAT(sale_date, 'MM-yyyy') = '11-2022';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select 
	category,
	sum(total_sale) as net_sale, 
	count(*) as total_orders 
from retailsales
group by category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select 
	ROUND(AVG(CAST(age as FLOAT)),2) as avg_age -- age datatype is int
from retailsales
where category ='beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retailsales
where total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category, gender, count(*) as total_transactions
from retailsales
group by category, gender

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select 
	year,
	month,
	avg_sale
from 
(
SELECT 
	YEAR(sale_date) AS year,
	MONTH(sale_date) AS month,
	ROUND(AVG(total_sale),2) as avg_sale,
	RANK() over(partition by YEAR(sale_date) order by avg(total_sale) desc) as rank
from retailsales
group by YEAR(sale_date), MONTH(sale_date)
) as t1
where rank = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select top 5 
	customer_id, 
	sum(total_sale) as total_sale_sum
from retailsales
group by customer_id
order by sum(total_sale) desc

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category,
	count(distinct customer_id) as num_of_customers
from retailsales
group by category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sale
as
(
SELECT *,
	CASE
		WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
		WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
from retailsales
)
select
	shift,
	count(*) as total_orders
from hourly_sale
group by shift


-- END OF PROJECT