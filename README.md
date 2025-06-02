# Amazon-Sales-Analysis-with-SQL


## Problem Statement:

The goal of this project is to analyze Amazon’s sales data to understand the various factors influencing overall performance. By studying sales patterns across different dimensions such as customer behavior and product categories, we aim to identify key trends and generate actionable insights for business users. These insights will help Amazon make informed decisions to optimize operations, improve product offerings, and increase profitability.

## Data:

This dataset contains sales transactions from three different branches of Amazon, respectively located in Mandalay, Yangon and Naypyitaw. The data contains 17 columns and 1000 rows:

### Column	Description:
| **Column**                | **Description**                         | **Data Type**  |
| ------------------------- | --------------------------------------- | -------------- |
| invoice\_id               | Invoice of the sales made               | VARCHAR(30)    |
| branch                    | Branch at which sales were made         | VARCHAR(5)     |
| city                      | The location of the branch              | VARCHAR(30)    |
| customer\_type            | The type of the customer                | VARCHAR(30)    |
| gender                    | Gender of the customer making purchase  | VARCHAR(10)    |
| product\_line             | Product line of the product sold        | VARCHAR(100)   |
| unit\_price               | The price of each product               | DECIMAL(10, 2) |
| quantity                  | The amount of the product sold          | INT            |
| VAT                       | The amount of tax on the purchase       | FLOAT(6, 4)    |
| total                     | The total cost of the purchase          | DECIMAL(10, 2) |
| date                      | The date on which the purchase was made | DATE           |
| time                      | The time at which the purchase was made | TIMESTAMP      |
| payment\_method           | The total amount paid                   | DECIMAL(10, 2) |
| cogs                      | Cost Of Goods sold                      | DECIMAL(10, 2) |
| gross\_margin\_percentage | Gross margin percentage                 | FLOAT(11, 9)   |
| gross\_income             | Gross Income                            | DECIMAL(10, 2) |
| rating                    | Rating                                  | FLOAT(2, 1)    |


## 1.Data Wrangling:
This is the first step where inspection of data is done to make sure NULL values and missing values are detected and data replacement methods are used to replace missing or NULL values.

### 1.1 Build a database
The project starts by creating a database named `project`.
```sql
create database project;
```
### 1.2 Create a table and insert the data.
A table named amazon is created to store the sales data. The table structure includes columns which are mentioned above.
```sql

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
```

### 1.3 NULL value check
In table amazon, check for any null values in the dataset and delete records with missing data.
**Checking null values:** Retrieve all rows from the amazon table where any column contains NULL values using the IS NULL condition.
```sql
SELECT * FROM amazon
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
```

**Deleting null values:** Remove all rows from the amazon table where any column contains NULL values by using the DELETE command combined with the IS NULL condition for each relevant column.

```sql
delete FROM amazon
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
```

## 2. Feature Engineering:
This process allows us to create new columns by deriving them from existing data, helping to enhance the dataset for deeper analysis.

### 2.1 Add Time of Day Column
A new column named timeofday is added to categorize sales into Morning, Afternoon, and Evening. This helps in identifying which part of the day records the highest number of sales.

```sql
alter table amazon
add column timeofday varchar(20);

UPDATE amazon
SET timeofday = CASE
    WHEN TIME(time) BETWEEN '10:00:00' AND '12:59:59' THEN 'Morning'
    WHEN TIME(time) BETWEEN '13:00:00' AND '16:59:59' THEN 'Afternoon'
    WHEN TIME(time) BETWEEN '17:00:00' AND '20:59:59' THEN 'Evening'
    ELSE 'Other'
END;
```

### 2.2 Add Day Name Column
A new column named dayname is created to extract the day of the week (e.g., Mon, Tue, Wed, Thu, Fri) on which each transaction occurred. This helps determine which day of the week each branch experiences the highest customer activity.

```sql
alter table amazon
add column dayname varchar(15);

update amazon
set dayname=dayname(date);
```

### 2.3 Add Month Name Column
A new column named monthname is added to extract the month (e.g., Jan, Feb, Mar) of each transaction. This helps analyze which month of the year generated the most sales and profit.

```sql
alter table amazon
add column monthname varchar(15);

update amazon
set monthname=monthname(date);
```

## 3. Exploratory Data Analysis (EDA)
1. Exploratory Data Analysis is performed to gain insights from the dataset and to address the problem statement and business questions outlined in this project.
2. The main objective is to analyze sales patterns across different branches, product lines, and customer segments in order to identify key factors that drive revenue and profit.
3. This analysis will help the business make data-driven decisions related to sales strategies, customer targeting, and inventory planning.

**1. What is the count of distinct cities in the dataset?**
```sql
select count(distinct city) as distinct_city from amazon;
```

**2. For each branch, what is the corresponding city?**
```sql
select distinct branch,city from amazon
order by branch asc;
```

**3. What is the count of distinct product lines in the dataset?**
```sql
select count(distinct product_line) as DistinctProductLine from amazon;
```

**4. Which payment method occurs most frequently?**
```sql
select payment_type,count(payment_type) as CountofPaymentType from amazon
group by payment_type
order by countofpaymenttype desc
limit 1;
```

**5. Which product line has the highest sales?**
```sql
select product_line,count(*) as sales from amazon
group by product_line
order by sales desc ;
```

**6. How much revenue is generated each month?**
```sql
select monthname,sum(total) as revenue from amazon 
group by monthname;
```

**7. In which month did the cost of goods sold reach its peak?**
```sql
select monthname,sum(cogs) as sold from amazon
group by monthname
order by sold desc
limit 1;
```

**8. Which product line generated the highest revenue?**
```sql
select product_line,sum(total) as revenue from amazon
group by product_line
order by revenue desc limit 1;
```

**9. In which city was the highest revenue recorded?**
```sql
select city,sum(total) as revenue from amazon
group by city
order by revenue desc limit 1;
```

**10. Which product line incurred the highest Value Added Tax?**
```sql
select product_line,sum(vat) as highestVAT
from amazon
group by product_line
order by highestVAT desc limit 1;
```

**11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."**
```sql
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
```

**12. Identify the branch that exceeded the average number of products sold.**
```sql
 with branch_sales as 
                 (select branch, count(quantity) as quantity_sold from amazon 
                  group by branch),
                  
 avg_branch_sales as 
                 (select avg(quantity_sold) as avg_quantity_sold 
                  from branch_sales)
				
select branch, quantity_sold 
from branch_sales, avg_branch_sales
where quantity_sold>avg_quantity_sold;
```

**13. Which product line is most frequently associated with each gender?**
```sql
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
```

**14. Calculate the average rating for each product line.**
```sql
select product_line, avg(rating)
from amazon
group by product_line;
```

**15. Count the sales occurrences for each time of day on every weekday**
```sql
SELECT dayname, timeofday, COUNT(*) AS total_transactions
FROM amazon
WHERE dayname NOT IN ('Saturday', 'Sunday')
GROUP BY dayname, timeofday
order by dayname,timeofday;
```

**16. Identify the customer type contributing the highest revenue.**
```sql
select customer_type, sum(total) as revenue 
from amazon 
group by customer_type
order by revenue desc
limit 1;
```

**17. Determine the city with the highest VAT percentage.**
```sql
select city, max(round((vat/total),2)) as max_vat
from amazon
group by city
order by max_vat 
limit 1;
```

**18. Identify the customer type with the highest VAT payments.**
```sql
select customer_type, sum(vat) as vat_payments
from amazon
group by customer_type 
order by vat_payments desc
limit 1;
```

**19. What is the count of distinct customer types in the dataset?**
```sql
select count(distinct customer_type) as types_of_customers
from amazon;
```

**20. What is the count of distinct payment methods in the dataset?**
```sql
select count(distinct payment_type) as types_of_payments
from amazon;
```

**21. Which customer type occurs most frequently?**
```sql
select customer_type, count(*) as frequency
from amazon
group by customer_type
order by frequency desc
limit 1;
```

**22. Identify the customer type with the highest purchase frequency.**
```sql
SELECT customer_type, COUNT(*) AS purchase_frequency
FROM amazon
GROUP BY customer_type
ORDER BY purchase_frequency DESC
LIMIT 1;
```

**23. Determine the predominant gender among customers**
```sql
SELECT gender, COUNT(*) AS dominant_gender
FROM amazon
GROUP BY gender
ORDER BY dominant_gender DESC
LIMIT 1;
```

**24. Examine the distribution of genders within each branch.**
```sql
select branch, gender, count(*) as number_of_sales
from amazon
group by branch, gender
```

**25. Identify the time of day when customers provide the most ratings.**
```sql
select timeofday, count(rating) as rating_count
from amazon
group by timeofday
order by rating_count desc
limit 1;
```

**26. Determine the time of day with the highest customer ratings for each branch.**
```sql
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
```

**27. Identify the day of the week with the highest average ratings.**
```sql
select dayname, avg(rating) as avg_rating
from amazon
group by dayname
order by avg_rating desc
limit 1;
```

**28. Determine the day of the week with the highest average ratings for each branch.**
```sql
with cte as (
select branch, dayname, avg(rating) as avg_rating,
row_number() over (partition by branch order by avg(rating) desc) as rn
from amazon
group by branch, dayname
)
select branch, dayname, avg_rating
from cte
where rn=1;
```
## Insights:
### Product lines:
1. There are a total of six product lines in the dataset:  
   i) **Health and Beauty** 
   ii) **Electronic Accessories**  
   iii) **Home and Lifestyle**  
   iv) **Sports and Travel**  
   v) **Food and Beverages**  
   vi) **Fashion Accessories**  

2. The **Food and Beverages** product line generated the highest revenue overall.  
3. The **Health and Beauty** product line recorded the lowest revenue and sales volume.  
4. The **Fashion Accessories** category had the highest number of sales.  
5. Among male customers, the **Health and Beauty** category generated the most revenue, while for female customers, the **Sports and Travel** category topped in revenue.

### **Sales Analysis**

1. The **highest revenue** was recorded in **January**. <br>
2. **February** had the **lowest overall revenue**. <br>
3. **Naypyitaw** emerged as the **top-performing branch** in terms of revenue. <br>
4. **Mandalay** reported the **lowest sales figures** among all branches. <br>
5. **Member customers** contributed **significantly more revenue** compared to normal customers. <br>
6. **Female customers** generated **more revenue** than male customers. <br>
7. **Saturday evenings** showed the **peak in sales activity**.  <br>
8. **E-wallets** were the **most frequently used** payment method. <br>

### **Customer & Time-Based Analysis**

1. **Member customers** and **female shoppers** contributed the highest share of revenue. <br>
2. Among all cities, **Naypyitaw** had the highest earnings, while **Mandalay** had the lowest. <br>
3. **Branch A** saw its highest revenue on **Sundays**, whereas **Branches B and C** peaked on **Saturdays**.  <br>
4. **Afternoons** were the peak time for **Branch B**, while **Branches A and C** had the highest activity during **evenings**.  <br>
5. The **combination of Saturday evenings** and **E-wallet payments** marked the highest sales frequency.  <br>

### **Customer Rating Insights**

1. **Member customers** consistently yielded **higher revenue**.  <br>
2. **Customer ratings** were highest on **Saturdays** for **Branches B and C**, and on **Sundays** for **Branch A**.  <br>
3. **Afternoons** saw the most ratings for **Branches A and C**, while **evenings** were dominant for **Branch B**. <br>
4. **Male customers** were more active in **Branches A and B**, whereas **females** dominated **Branch C**.  <br>
