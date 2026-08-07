## 1. How many customers are registered?
Select count(*) as total_customers from customers;
## 2. How many orders have been placed?
Select count(*) as total_orders from orders;
## 3. How many products are available?
Select count(*) as total_products from products;
## 4. How many sellers are registered?
Select count(*) as total_sellers from sellers;
## 5. During which period were orders placed?
Select MIN(order_purchase_timestamp) as first_date, MAX(order_purchase_timestamp) as last_date from orders;

## 6. Which states have the highest number of customers?
Select customer_state, count(*) as total_customers from customers group by customer_state order by total_customers DESC; 
## top 10 states
Select customer_state, count(*) as total_customers from customers group by customer_state order by total_customers DESC LIMIT 15;
## 7. which city has highest number of customers?
SELECT customer_city, COUNT(*) AS total_customers FROM customers GROUP BY customer_city ORDER BY total_customers DESC LIMIT 10;
## How many unique cities do customers come from?
Select count(DISTINCT customer_city) as total_unique_city from customers ;
## Which seller has sold the most products?
Select seller_id, count(*) as total_products_sold from order_items group by seller_id order by total_products_sold; 

##Average payment value
Select AVG(payment_value) from order_payments;

## Which product category generates the highest revenue?
SELECT p.product_category_name, SUM(o.price) AS total_revenue FROM products AS p JOIN order_items AS o ON p.product_id = o.product_id GROUP BY p.product_category_name ORDER BY total_revenue DESC;

## Which seller generated the highest revenue?
Select seller_id, sum(price) as total_revenue from order_items group by seller_id order by total_revenue desc LIMIT 1;

## which customer spend the most money on the platform?
Select c.customer_unique_id, sum(op.payment_value) as total_payment from customers c JOIN orders o 
on c.customer_id=o.customer_id join order_payments op on o.order_id= op.order_id 
group by c.customer_unique_id order by total_payment desc limit 1;

## Which state generated the highest revenue?
Select c.customer_state, sum(op.price) as total_revenue from customers c
JOIN orders o on c.customer_id= o.customer_id JOIN order_items op on o.order_id=op.order_id
group by c.customer_state order by total_revenue desc LIMIT 1;

## Which month generated highest revenue?
Select sum(oi.price) as total_revenue, date_format(o.order_purchase_timestamp,"%y %m") from orders o
join order_items oi on o.order_id=oi.order_id group by date_format(o.order_purchase_timestamp,"%y %m") 
order by total_revenue desc LIMIT 1;

##Which product category generated the highest revenue in 2018?
SELECT p.product_category_name, SUM(oi.price) AS total_revenue
FROM orders o JOIN order_items oi ON o.order_id = oi.order_id JOIN products p 
ON oi.product_id = p.product_id WHERE YEAR(o.order_purchase_timestamp) = 2018
GROUP BY p.product_category_name ORDER BY total_revenue DESC LIMIT 1;

## Module 1- Order analysis
## How many orders are there for each order status?
SELECT
    order_status,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

## Business Insight:
-- Delivered orders account for the highest number of orders,
-- indicating that most customer orders were successfully fulfilled.

## How many orders were placed in each month?
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_month
ORDER BY order_month;

## Business Insight:
-- Order volume increased steadily from 2016 to 2018,
-- indicating growth in customer activity over time.
-- The highest number of orders was recorded in 2018.

## Which month has the highest number of orders?
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_month
ORDER BY order_month;
## Business Insight:
-- Order volume increased steadily during the analysis period.
-- The highest number of orders was recorded in 2018.
-- This indicates strong business growth over time.

##What is the monthly revenue trend?
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%M') AS order_month,
    SUM(oi.price) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY order_month
ORDER BY order_month ASC;

## Business Insight:
-- Monthly revenue generally increased over the analysis period.
-- The highest revenue was recorded in 2018.
-- This suggests strong growth in sales during that month.

## Which month generated the highest revenue?

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
    SUM(oi.price) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY order_month
ORDER BY total_revenue DESC
LIMIT 1;
## Business Insight:
-- 2017 recorded the highest revenue of 1010271.
-- This indicates that sales peaked during this month.

## Which product category generated the highest revenue?
SELECT
    p.product_category_name,
    SUM(oi.price) AS total_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 1;
## Highest-revenue product category: beleza_saude
## Revenue: 1258681.34

## Which customer state generated the highest revenue?
SELECT
    c.customer_state,
    SUM(oi.price) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 1;
## state- SP, total revenue - 5202955.05

## Which seller has the highest number of products sold?

SELECT
    seller_id,
    COUNT(product_id) AS total_products
FROM order_items
GROUP BY seller_id
ORDER BY total_products DESC
LIMIT 1;

##What is the average delivery time in days?

SELECT
    AVG(DATEDIFF(
        order_delivered_customer_date,
        order_purchase_timestamp
    )) AS average_delivery_days
FROM orders;


## Which customer state has the longest average delivery time?
SELECT
    c.customer_state,
    AVG(
        DATEDIFF(
            o.order_delivered_customer_date,
            o.order_purchase_timestamp
        )
    ) AS average_delivery_days
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY average_delivery_days DESC
LIMIT 1;











