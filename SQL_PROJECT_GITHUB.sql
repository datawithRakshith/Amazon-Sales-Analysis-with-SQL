-- 1.DATA WRANGLING

-- Amazon sales analysis
-- 1.1 Build a database
create database project;

-- 1.2  Create a table and insert the data
-- create TABLE

drop table if exists amazon;
create table amazon
(
invoiceid VARCHAR(30) primary key,
branch VARCHAR(5),
city varchar(30),
customer_type varchar(30),
gender varchar(10),
productline varchar(100),
unitprice decimal(10,2),
quantity int,
vat FLOAT(6, 4),
total decimal(10, 2),
date date,
time timestamp,
paymentmethod decimal(10,2),
cogs decimal(10,2),
grossmarginpercentage float(11,9),
grossincome decimal(10,2),
rating float(2,1)
);
 
-- 1.3 select columns with null values in them and delete them

select * from amazon;
select count(*) from amazon;
select * from amazon where invoice_id is null;
select * from amazon where city is null;


-- checking null values

SELECT * FROM retail_sales
WHERE 
    invoice_id IS NULL
    OR branch IS NULL
    OR city IS NULL
    OR customer_type IS NULL
    OR gender IS NULL
    OR product_line IS NULL
    OR unit_price IS NULL
    OR quantity IS NULL
    OR VAT IS NULL
    OR total IS NULL
    OR date IS NULL
    OR time IS NULL
    OR payment_method IS NULL
    OR cogs IS NULL
    OR gross_margin_percentage IS NULL
    OR gross_income IS NULL
    OR rating IS NULL;
    
    
-- deleting null values 

delete FROM retail_sales
WHERE 
    invoice_id IS NULL
    OR branch IS NULL
    OR city IS NULL
    OR customer_type IS NULL
    OR gender IS NULL
    OR product_line IS NULL
    OR unit_price IS NULL
    OR quantity IS NULL
    OR VAT IS NULL
    OR total IS NULL
    OR date IS NULL
    OR time IS NULL
    OR payment_method IS NULL
    OR cogs IS NULL
    OR gross_margin_percentage IS NULL
    OR gross_income IS NULL
    OR rating IS NULL;


-- 2.Feature Engineering
-- Adding Columns   
   
-- 2.1 TimeOfDay
----- creation of column
   
alter table amazon
add column timeofday varchar(20);

UPDATE amazon
SET timeofday = CASE
    WHEN TIME(time) BETWEEN '10:00:00' AND '12:59:59' THEN 'Morning'
    WHEN TIME(time) BETWEEN '13:00:00' AND '16:59:59' THEN 'Afternoon'
    WHEN TIME(time) BETWEEN '17:00:00' AND '20:59:59' THEN 'Evening'
    ELSE 'Other'
END;


-- 2.2 DayName
----- creation of column
alter table amazon
add column dayname varchar(15);

update amazon
set dayname=dayname(date);
  
   
-- 2.3 MonthName
----- creation of column
alter table amazon
add column monthname varchar(15);

update amazon
set monthname=monthname(date);

---------------------------------------------------------
--- 3. EDA-- Exploratory Data Analysis


desc amazon;

-- 1. What is the count of distinct cities in the dataset?
select count(distinct city) as distinct_city from amazon;

-- 2. For each branch, what is the corresponding city?
select distinct branch,city from amazon
order by branch asc;

-- 3. What is the count of distinct product lines in the dataset?
select count(distinct product_line) as DistinctProductLine from amazon;

-- 4. Which payment method occurs most frequently?
select payment_type,count(payment_type) as CountofPaymentType from amazon
group by payment_type
order by countofpaymenttype desc
limit 1;

-- 5. Which product line has the highest sales?
select product_line,count(*) as sales from amazon
group by product_line
order by sales desc ;

-- 6. How much revenue is generated each month?
select monthname,sum(total) as revenue from amazon 
group by monthname;

-- 7. In which month did the cost of goods sold reach its peak?
select monthname,sum(cogs) as sold from amazon
group by monthname
order by sold desc
limit 1;

-- 8. Which product line generated the highest revenue?
select product_line,sum(total) as revenue from amazon
group by product_line
order by revenue desc limit 1;

-- 9. In which city was the highest revenue recorded?
select city,sum(total) as revenue from amazon
group by city
order by revenue desc limit 1;

-- 10. Which product line incurred the highest Value Added Tax?
select product_line,sum(vat) as highestVAT
from amazon
group by product_line
order by highestVAT desc limit 1;

-- 11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
WITH product_line_sales AS (
    SELECT product_line, SUM(total) AS total_sales
    FROM amazon
    GROUP BY product_line
), 
avg_sales AS (
    SELECT AVG(total_sales) AS avg_total_sales 
    FROM product_line_sales
) 
SELECT
    product_line_sales.product_line, 
    product_line_sales.total_sales, 
    CASE 
        WHEN product_line_sales.total_sales > avg_sales.avg_total_sales THEN 'Good'
        ELSE 'Bad' 
    END AS sales_performance 
FROM product_line_sales, avg_sales;

-- 12. Identify the branch that exceeded the average number of products sold.

 with branch_sales as 
                 (select branch, count(quantity) as quantity_sold from amazon 
                  group by branch),
                  
 avg_branch_sales as 
                 (select avg(quantity_sold) as avg_quantity_sold 
                  from branch_sales)
				
select branch, quantity_sold 
from branch_sales, avg_branch_sales
where quantity_sold>avg_quantity_sold;

-- 13. Which product line is most frequently associated with each gender?

with gender_product_quantity as (
select gender, product_line, count(*) as total_count
from amazon
group by gender, product_line
),

gender_Product_rank as (
select *, 
row_number() over(partition by gender order by total_count) as rn
from gender_product_quantity
)

select gender, product_line, total_count
from gender_Product_rank
where rn=1;

-- 14. Calculate the average rating for each product line.
select product_line, avg(rating)
from amazon
group by product_line;

-- 15. Count the sales occurrences for each time of day on every weekday

SELECT dayname, timeofday, COUNT(*) AS total_transactions
FROM amazon
WHERE dayname NOT IN ('Saturday', 'Sunday')
GROUP BY dayname, timeofday
order by dayname,timeofday;

select monthname, sum(total) from amazon group by monthname order by sum(total) desc;
-- 16. Identify the customer type contributing the highest revenue.
select customer_type, sum(total) as revenue 
from amazon 
group by customer_type
order by revenue desc
limit 1;

-- 17. Determine the city with the highest VAT percentage.
select city, max(round((vat/total),2)) as max_vat
from amazon
group by city
order by max_vat 
limit 1;

-- 18. Identify the customer type with the highest VAT payments.
select customer_type, sum(vat) as vat_payments
from amazon
group by customer_type 
order by vat_payments desc
limit 1;

-- 19. What is the count of distinct customer types in the dataset?
select count(distinct customer_type) as types_of_customers
from amazon;

-- 20. What is the count of distinct payment methods in the dataset?
select count(distinct payment_type) as types_of_payments
from amazon;

-- 21. Which customer type occurs most frequently?
select customer_type, count(*) as frequency
from amazon
group by customer_type
order by frequency desc
limit 1;

-- 22. Identify the customer type with the highest purchase frequency.
SELECT customer_type, COUNT(*) AS purchase_frequency
FROM amazon
GROUP BY customer_type
ORDER BY purchase_frequency DESC
LIMIT 1;

-- 23. Determine the predominant gender among customers
SELECT gender, COUNT(*) AS dominant_gender
FROM amazon
GROUP BY gender
ORDER BY dominant_gender DESC
LIMIT 1;

-- 24. Examine the distribution of genders within each branch.
select branch, gender, count(*) as number_of_sales
from amazon
group by branch, gender
order by branch, gender desc;

-- 25. Identify the time of day when customers provide the most ratings.
select timeofday, count(rating) as rating_count
from amazon
group by timeofday
order by rating_count desc
limit 1;

-- 26. Determine the time of day with the highest customer ratings for each branch.
WITH cte AS (
    SELECT 
        branch,
        timeofday,
        avg(rating) AS avg_rating,
        ROW_NUMBER() OVER (PARTITION BY branch ORDER BY avg(rating) DESC) AS rn
    FROM amazon
    GROUP BY branch, timeofday
)
SELECT branch, timeofday, avg_rating
FROM cte
WHERE rn = 1;

-- 27. Identify the day of the week with the highest average ratings.
select dayname, avg(rating) as avg_rating
from amazon
group by dayname
order by avg_rating desc
limit 1;

-- 28. Determine the day of the week with the highest average ratings for each branch.

with cte as (
select branch, dayname, avg(rating) as avg_rating,
row_number() over (partition by branch order by avg(rating) desc) as rn
from amazon
group by branch, dayname
)
select branch, dayname, avg_rating
from cte
where rn=1;