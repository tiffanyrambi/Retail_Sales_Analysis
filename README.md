# Retail Sales Analysis SQL Project
Using Microsoft SQL Server

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `Retail_Sales_Analysis`

The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. 

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Retail_Sales_Analysis`.
- **Import Data**: Import the data `Retail_Sales_Analysis.xlsx` to `Retail_Sales_Analysis` databases, which will automatically convert the excel dataset to a table. Rename the table to `RetailSales`
- **Adjust Data & Add Primary Key**: 

```sql
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

ALTER TABLE RetailSales
ADD CONSTRAINT PK_RetailSales PRIMARY KEY (transactions_id);

ALTER TABLE RetailSales
ALTER COLUMN sale_date date;

ALTER TABLE RetailSales
ALTER COLUMN sale_time TIME(0);

COMMIT TRANSACTION;
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) AS total_sale FROM RetailSales

SELECT COUNT(DISTINCT customer_id) AS total_customers FROM RetailSales

SELECT DISTINCT category FROM RetailSales;

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
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT * FROM RetailSales
WHERE sale_date='2022-11-05'
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT * FROM RetailSales
WHERE
  category='Clothing' AND 
  quantiy >= 4 AND 
  FORMAT(sale_date, 'MM-yyyy') = '11-2022';
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
	category,
	SUM(total_sale) AS net_sale, 
	COUNT(*) AS total_orders 
FROM RetailSales
GROUP BY category
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT 
	ROUND(AVG(CAST(age AS FLOAT)),2) AS avg_age
FROM RetailSales
WHERE category = 'beauty'
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM RetailSales
WHERE total_sale > 1000
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT
  category,
  gender,
  COUNT(*) AS total_transactions
FROM RetailSales
GROUP BY category, gender
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT TOP 5 
	customer_id, 
	SUM(total_sale) AS total_sale_sum
FROM RetailSales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT
  category,
	COUNT(DISTINCT customer_id) AS num_of_customers
FROM RetailSales
GROUP BY category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.
