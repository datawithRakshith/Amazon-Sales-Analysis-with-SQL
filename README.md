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

### 1.3 Select columns with null values in them. Delete them as it leads to inaccurate results.
