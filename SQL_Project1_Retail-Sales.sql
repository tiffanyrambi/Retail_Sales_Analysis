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

-- change sale_date datatype from datetime to date
ALTER TABLE RetailSales
ALTER COLUMN sale_date date;

-- change sale_time datatype from datetime to time(0). time(0) will only include hour, minutes, and seconds
ALTER TABLE RetailSales
ALTER COLUMN sale_time TIME(0);


--- 1. DATA CLEANING ---

-- check null values
SELECT * FROM RetailSales
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
DELETE FROM RetailSales
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
SELECT COUNT(*) AS total_sale FROM RetailSales

-- How many customers do we have ?
SELECT COUNT(DISTINCT customer_id) AS total_sale FROM RetailSales

-- What categories do we have?
SELECT DISTINCT category FROM RetailSales


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
SELECT * FROM RetailSales
WHERE sale_date='2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT * FROM RetailSales
WHERE category='Clothing' AND 
quantiy >= 4 AND 
FORMAT(sale_date, 'MM-yyyy') = '11-2022';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category,
	SUM(total_sale) AS net_sale, 
	COUNT(*) AS total_orders 
FROM RetailSales
GROUP BY category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
	ROUND(AVG(CAST(age AS FLOAT)),2) AS avg_age -- age datatype is int
FROM RetailSales
WHERE category ='beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM RetailSales
WHERE total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
	category, 
	gender, 
	COUNT(*) AS total_transactions
FROM RetailSales
GROUP BY category, gender

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
	year,
	month,
	avg_sale
FROM 
(
SELECT 
	YEAR(sale_date) AS year,
	MONTH(sale_date) AS month,
	ROUND(AVG(total_sale),2) AS avg_sale,
	RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM RetailSales
GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE rank = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT TOP 5 
	customer_id, 
	SUM(total_sale) AS total_sale_sum
FROM RetailSales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category,
	COUNT(DISTINCT customer_id) AS num_of_customers
FROM RetailSales
GROUP BY category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
		WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM RetailSales
)
SELECT
	shift,
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift


-- END OF PROJECT