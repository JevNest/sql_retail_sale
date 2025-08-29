-- create table
create table retail_sales(
		transactions_id	int primary key,
		sale_date date,	
		sale_time time,	
		customer_id	int,
		gender	text,
		age	int,
		category varchar,	
		quantiy	int,
		price_per_unit int,	
		cogs float,	
		total_sale int
);

select * from retail_sales limit 10;

select count(*) from retail_sales;

select * from retail_sales
where sale_date is null;

--Data Cleaning--
select * from retail_sales
where 
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
	total_sale is null;

delete from retail_sales
where
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
	total_sale is null;


------ Data Exploration -------

-- How many sales we have?
select count(*) from retail_sales;
--

-- How many unique customers we have?
select count(distinct customer_id) as total_sale from retail_sales;
--

-- How many unique category we have?
select count(distinct category) as total_category from retail_sales;
select distinct category from retail_sales;

-- Data Analysis & Business key problems and answers

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales
where 
	sale_date = '2022-11-05';


-- 2.Write SQL query to retrieve all transactions where the category is 'Clothing' and 
--   the quantity sold is more than 10 in the month of Nov-2022
select * from retail_sales
where 
	category = 'Clothing' 
	and quantiy >= 4 
	and To_char(sale_date,'YYYY-MM') = '2022-11';


-- 3.Write a sql query to calculate the total sles(total_sale) for each category
select 
	category,
	sum(total_sale) as Net_sale,
	count(*) as total_orders
from retail_sales
group by 1;


-- 4. write a sql query to find the average age of customers who purchased items form the 'Beauty' category
select round(avg(age),2) as Average_age from retail_sales
where
	category = 'Beauty';


-- 5.write a sql query to find all transactions where the total_sale is greater than 1000
select * from retail_sales
where
	total_sale > 1000;


-- 6.Write a sql query to find the total no of transactions(transaction_id) made by each gender in each category.
select 
	category,
	gender,
	count(*) as total_trans
from retail_sales
group by category,
		 gender
order by 1;

-- 7.write a sql query to calculate the average sale for each month. Find out best selling month in each year
select
	year,
	month,
	avg_sale
from(
select 
	extract (YEAR from sale_date) as year,
	extract (MONTH from sale_date) as month,
	avg(total_sale) as avg_sale,
	rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales
group by 1,2
) as t1
where rank = 1


-- 8. Write a sql query to find the top 5 customers based on highest total sale
select  customer_id,
	sum(total_sale) as total_sales
from retail_sales 
group by 1
order by 2 desc 
limit 5;

--9. write a sql query to find the no of unique customers who purchased items from each category
select 
	category,
	count(distinct customer_id) as unique_customers
from retail_sales
group by 1
	

--10. write a sql query to create each shift and number of orders(Example: morning <=12, Afternoon between 12 & 17
--    evening >17)
with session_sales
as
(
select *,
	case
		when extract (Hour from sale_time) < 12 then 'Morning'
		when extract (Hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales
)
select shift,count(*) as total_orders from session_sales
group by shift

-------------------------------------------------------------
 