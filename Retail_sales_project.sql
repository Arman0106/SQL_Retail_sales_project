--sql retail sales analysis

--create table name retail_sales

create table retail_sales
(
  transactions_id	INT PRIMARY KEY,
  sale_date DATE,	
  sale_time TIME,
  customer_id INT,
  gender VARCHAR(10),
  age INT, 
  category VARCHAR(15),
  quantiy INT,
  price_per_unit FLOAT,
  cogs FLOAT,
  total_sale FLOAT
)
select * from retail_sales

--DATA CLEANING

select * from retail_sales
where transactions_id is null
      or 
	  sale_date is null
	  or 
	  sale_time is null
	  or 
	  customer_id is null
	  or 
	  gender is null
	  or 
	  age is null
	  or 
	  category is null
	  or
	  quantiy is null
	  or
	  price_per_unit is null
	  or 
	  cogs is null
	  or
	  total_sale is null
 
DELETE FROM retail_sales
WHERE 
	transactions_id is null
      or 
	  sale_date is null
	  or 
	  sale_time is null
	  or 
	  customer_id is null
	  or 
	  gender is null
	  or 
	  age is null
	  or 
	  category is null
	  or
	  quantiy is null
	  or
	  price_per_unit is null
	  or 
	  cogs is null
	  or
	  total_sale is null


--DATA EXPLORATION

--How many sales we have?

select count(*) as Total_count from retail_sales

--How many unique customer we have?

select count(distinct customer_id) as customer_count
from retail_sales

--how many unique categories we have

select distinct category 
from retail_sales

--DATA ANALYSIS & BUSNIESS KEY PROBLEM AND ANSWER

--Write a SQL query to retrieve all columns for sales made on '2022-11-05'

select * 
from
	retail_sales
where 
	sale_date ='2022-11-05'
	
--Write a SQL query to retrieve all transactions where the category is
--'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select *
from 
	retail_sales
where
	category = 'Clothing'
	and
	quantity = 4
	and
	datename(month,sale_date) = 'December'
	and
	datepart(year,sale_date) = 2023


--Write a SQL query to calculate the total sales (total_sale) for each category.

select 
	category,
	sum(total_sale) as Total_sale_per_category
from
	retail_sales
group by category

--Write a SQL query to find the average age of 
--customers who purchased items from the 'Beauty' category.

select
	category,
	avg(age) as AVG_AGE
from 
	retail_sales
where 
	category = 'Beauty'
group by 
	category

--Write a SQL query to find all transactions where the total_sale is greater than 1000.

select *
from
	retail_sales
where
	total_sale > 1000

--Write a SQL query to find the total number of transactions (transaction_id) 
--made by each gender in each category.

select
	category,
	gender,
	count(*) as Total_transaction
from	
	retail_sales
group by 
	category,
	gender
	
--Write a SQL query to calculate the average sale for each month. 
--Find out best selling month in each year

with TopSales as
(
select
	year(sale_date) as Years,
	month(sale_date) as Months,
	avg(total_sale) as Total_Sales,
	dense_rank() over(partition by year(sale_date) order by avg(total_sale) desc) as Rank
from 
	retail_sales
group by 
	year(sale_date),
	month(sale_date)
	
)
select 
	Years,
	Months,
	Total_Sales,
	Rank
from
	TopSales
where
	Rank = 1
order by
	Years,
	Total_Sales desc

--Write a SQL query to find the top 5 customers based on the highest total sales.

select top 5
	customer_id,
	sum(total_sale) as TotalSale
from	
	retail_sales
group by 
	customer_id
order by 
	sum(total_sale) desc

--Write a SQL query to find the number of unique customers who purchased items from each category

select
	category,
	count(distinct customer_id) as TotalCustomers
from
	retail_sales
group by 
	category
order by
	category

--Write a query to get sales by gender

select 
	gender,
	sum(total_sale) as Sale_by_gender
from 
	retail_sales
group by 
	gender
order by
	sum(total_sale) desc

--Write a SQL query to create each shift and number of orders 
--(Example Morning <12, Afternoon Between 12 & 17, Evening >17)

with SalesPeriod as
(
select *, 
	case
		when datepart(hour,sale_time) between 6 and 11 then 'Morning'
		when datepart(hour,sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as Shifts
from
	retail_sales
)
select Shifts,
	count(*) as Shift_vise_Sales
from 
	SalesPeriod
group by 
	Shifts

--Write a query to find the top 3 total sales for each customer along by their age.

select top 3
	age,
	sum(total_sale) as TotalSale
from 
	retail_sales
group by 
	age
order by 
	sum(total_sale) desc

--Write a query to find the highest total sales on each day

select 
	day(sale_date) as date,
	max(total_sale) as highestSale
from 
	retail_sales
group by 
	day(Sale_date)


--Write a query to find the total sales for each month in a given year

select 
	year(sale_date) as Year,
	datename(month,sale_date) as month,
	sum(total_sale) as MonthlySales
from
	retail_sales
group by 
	year(sale_date),
	datename(month,sale_date)
order by 
	year(sale_date)

--write  a query to get percentage sale increase or decrease from previous year

with Sales as
(
select
	year(sale_date) as [Year],
	sum(total_sale) as TotalSale
from 
	retail_sales
group by
	year(sale_date)
)
select
	[Year],
	TotalSale,
	lag(TotalSale) over(order by [Year]) as Prev_sale,
	round((TotalSale - lag(TotalSale) over(order by [Year]))/TotalSale*100,2) as PercantageSale
from 
	Sales
	
--Write a query to calculate the profit for each transaction.

select 
	transactions_id,
	sale_date,
	sale_time,
	customer_id,
	round(total_sale - (quantity*cogs),2) as Profit
from 
	retail_sales

--Write a query to find the total sales by customer age group (e.g., 18-25, 26-35, 36-45). 
--Group the customers into age ranges and calculate the total sales for each group

select
	case
		when age between 18 and 25 then '18-25'
		when age between 26 and 35 then '26-35'
		when age between 36 and 45 then '36-45'
		when age between 46 and 55 then '46-55'
		else '55+' 
	end as AgewiseSale,
	sum(total_sale) as TotalSale
from
	retail_sales
group by 
	case
		when age between 18 and 25 then '18-25'
		when age between 26 and 35 then '26-35'
		when age between 36 and 45 then '36-45'
		when age between 46 and 55 then '46-55'
		else '55+' 
	end 
order by 
	sum(total_sale) desc

--Write a query to find the first and last sale in each year.

WITH SalesRank AS
(
    SELECT
        sale_date,
        total_sale,
        YEAR(sale_date) AS SaleYear,
        FIRST_VALUE(sale_date) OVER (PARTITION BY YEAR(sale_date) ORDER BY sale_date ASC) AS FirstSale,
        LAST_VALUE(sale_date) OVER (PARTITION BY YEAR(sale_date) ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastSale
    FROM
        retail_sales
)
SELECT
    SaleYear,
    MIN(FirstSale) AS FirstSaleDate,
    MAX(LastSale) AS LastSaleDate
FROM
    SalesRank
GROUP BY
    SaleYear
ORDER BY
    SaleYear;

--Write a query to calculate the difference in total sales between consecutive sale.

select
	sale_date,
	total_sale,
	total_sale - lag(total_sale) over(order by sale_date) as diff_sales
from	
	retail_sales
order by 
	sale_date

--Write a query to rank products (by category) based on the total quantity sold (quantity).
select 
	category,
	sum(quantity)as total,
	rank() over(order by sum(quantity) desc) as rank
from
	retail_sales
group by 
	category

--Write a query to find the second-highest total sale for each customer. 

with sales as
(
select
	customer_id,
	total_sale,
	dense_rank() over(partition by total_sale order by sum(total_sale)) as rank
from
	retail_sales
group by
	customer_id,total_sale
)
select *
from	
	sales
where 
	rank = 2









