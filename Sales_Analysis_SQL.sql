/*Project Overview
Project Title: Shop Sales Analysis
Database: sql_projject_4

This project is designed to demonstrate SQL skilld and techniques typically used by data analysis to explore, clean, and analysis shop sales data. The project involves seeting up a retail sales database, perfoming exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their jounery in data analysis and want to build a solid foundation in SQL.
Objectives
1. Set up a shop sales Database: Create and populate a retail sales database with the provided sales data.
2. Data Cleaning: Identify and remove any  records with missing or null values.
3. Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the database.
4. Business analysis: Use SQL to answer specific business questions and derive insights from the sales data
Project Structure
1. Project Setup 
•	Database Creation: The project starts by creating a database named sql_project_4.
•	Table Creation: A table named shop_sales is create to store the sales data. The table structure includes columns for transation ID, sales date, sale time, customer id, gender, age, product_category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount. */
create database sql_project4;
CREATE TABLE shope_sales (
    transation_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(7),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
/* 2. Data Exploration and Cleaning
* Record count: Determine the total number of records in the dataset.
* Customer Count: Find out the total number of customer
* Category Count: Identify all unique product caterogies in the dataset.
* Null Value Check: Check for all or any null values in the dataset and delete records with missing values. */
SELECT 
    *
FROM
    shope_sales
LIMIT 10;

SELECT 
    COUNT(*)
FROM
    shope_sales;
SELECT 
    *
FROM
    shope_sales
WHERE
    transation_id IS NULL
        OR sale_date IS NULL
        OR sale_time IS NULL
        OR customer_id IS NULL
        OR gender IS NULL
        OR age IS NULL
        OR category IS NULL
        OR quantity IS NULL
        OR price_per_unit IS NULL
        OR cogs IS NULL
        OR total_sale IS NULL;
    
SELECT 
    *
FROM
    shope_sales
WHERE
    quantity IS NOT NULL;

# how many sales we have ;
SELECT 
    COUNT(*) AS total_sale
FROM
    shope_sales;

/* 3. Data analysis & findings
The following SQL queries were devloped to answer spcific business questions: */

# how many uniuque vustomer we have
SELECT 
    COUNT(DISTINCT customer_id) AS unique_customer
FROM
    shope_sales;

# how many uniuque catagory we have ?
SELECT DISTINCT
    category AS Unique_category
FROM
    shope_sales;

-- WAQ to retrive all columns for sales made on '2022-11-05'
SELECT 
    *
FROM
    shope_sales
WHERE
    sale_date = '2022-11-05';

-- WAQ to retrive all data where the category is 'clothing' and the quantity sold more than 10 in month nov 2022
SELECT 
    *
FROM
    shope_sales
WHERE
    category = 'clothing'
        AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
        AND quantity >= 4;

-- WAQ to retrive total sales of each category
SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM
    shope_sales
GROUP BY category;

-- WAQ to find the avarege age of customers who purchesd items from the 'Beauty' category
SELECT 
    category, ROUND(AVG(age), 2) AS avarage_age
FROM
    shope_sales
WHERE
    category = 'Beauty';

-- WAQ to find all transations where the total_sales is gater than 1000.
SELECT 
    *
FROM
    shope_sales
WHERE
    total_sale >= 1000;

-- WAQ to find out the total number of transation made by each gender in each country
SELECT 
    category, gender, COUNT(*) AS total_trans
FROM
    shope_sales
GROUP BY 1 , 2;

-- WAQ to calculate the avarage sale for each month. find out best selling month in each year
select year, month,avg_sales
from(
select 
	YEAR (sale_date) as year, 
    month(sale_date)as month,
    round(avg(total_sale),2) as avg_sales,
    RANK() over(partition by YEAR (sale_date) order by avg(total_sale) desc) as best_sale
from shope_sales
group by 1,2
)as t1
where best_sale = 1;

-- WAQ to find out the top 5 customers based on the highest total sales
SELECT 
    customer_id, SUM(total_sale)
FROM
    shope_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- WAQ to find out the who purchesd items each category
SELECT 
    category, COUNT(DISTINCT customer_id) AS distinct_customer
FROM
    shope_sales
GROUP BY 1;

-- WAQ to create each shift and number of orders for example morning <12oclock, afternoon 12 & 17o clock, other than evening
with shift_wise_sale
as
(
select *,
	case
		when hour(sale_time) < 12 then 'Morning'
        when hour(sale_time) between 12 and 17 then 'Afternoon'
        else 'Evening'
	end as shift
from shope_sales
)
select shift,count(*) as total_orders from shift_wise_sale
group by shift;