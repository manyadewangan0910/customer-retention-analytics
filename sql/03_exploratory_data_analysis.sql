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
## Which customer states have the highest order cancellation rate?
SELECT
    c.customer_state,
    SUM(
        CASE
            WHEN o.order_status = 'canceled' THEN 1
            ELSE 0
        END
    ) / COUNT(o.order_id) * 100 AS cancellation_rate
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY cancellation_rate DESC;

## Which payment method is used most frequently?
SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS total_orders
FROM order_payments
GROUP BY payment_type
ORDER BY total_orders DESC
LIMIT 1;

## Which payment method generated the highest total payment value?
SELECT
    payment_type,
    SUM(payment_value) AS total_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY total_payment_value DESC
LIMIT 1;

## Which product category has the highest average product price?
SELECT
    p.product_category_name,
    AVG(oi.price) AS avg_price
FROM products p
JOIN order_items oi
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY avg_price DESC
LIMIT 1;

## Which product category has the highest number of products sold?
SELECT
    p.product_category_name,
    COUNT(oi.product_id) AS products_sold
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY products_sold DESC
LIMIT 1;

## Which seller generated the highest total revenue?
SELECT
    seller_id,
    SUM(price) AS total_revenue
FROM order_items
GROUP BY seller_id
ORDER BY total_revenue DESC
LIMIT 1;

## Which seller has the highest number of orders?
SELECT
    seller_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM order_items
GROUP BY seller_id
ORDER BY total_orders DESC
LIMIT 1;

## Which customer state has the highest average order value (AOV)?
SELECT
    c.customer_state,
    SUM(oi.price) / COUNT(DISTINCT o.order_id) AS AOV
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY AOV DESC
LIMIT 1;

## How many customers placed more than one order?
SELECT COUNT(*) AS total_repeat_customers
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
    HAVING total_orders > 1
) AS repeat_customers;
## What percentage of customers are repeat customers?
	SELECT
    rpt.total_repeat_customers,
    total.total_unique_customers,
    (rpt.total_repeat_customers / total.total_unique_customers) * 100
        AS repeat_customer_rate
FROM
(
    SELECT COUNT(*) AS total_repeat_customers
    FROM (
        SELECT
            c.customer_unique_id,
            COUNT(o.order_id) AS total_orders
        FROM customers c
        JOIN orders o
            ON c.customer_id = o.customer_id
        GROUP BY c.customer_unique_id
        HAVING total_orders > 1
    ) AS repeat_list
) AS rpt
CROSS JOIN
(
    SELECT COUNT(DISTINCT customer_unique_id) AS total_unique_customers
    FROM customers
) AS total;

## Which order status has the highest number of orders?
SELECT
    order_status,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC
LIMIT 1;

##Which customer state has the highest number of canceled orders?
SELECT
    customer_state,
    SUM(
        CASE
            WHEN order_status = 'canceled' THEN 1
            ELSE 0
        END
    ) AS cancelled_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY customer_state
ORDER BY cancelled_orders DESC
LIMIT 1;

## Which customer state has the highest number of unique customers?
SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers
GROUP BY customer_state
ORDER BY unique_customers DESC
LIMIT 1;
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

## Which seller generated the highest total revenue?

SELECT
    seller_id,
    SUM(price) AS total_revenue
FROM order_items
GROUP BY seller_id
ORDER BY total_revenue DESC
LIMIT 1;

##Which seller received the highest number of orders?
SELECT
    seller_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM order_items
GROUP BY seller_id
ORDER BY total_orders DESC
LIMIT 1;

## Which product category has the highest number of products sold?
SELECT
    p.product_category_name,
    COUNT(oi.product_id) AS products_sold
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY products_sold DESC
LIMIT 1;
## Which product category has the highest average selling price?
SELECT
    p.product_category_name,
    AVG(oi.price) AS avg_price
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY avg_price DESC
LIMIT 1;
## Which payment type is used for the highest number of orders?
SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS total_orders
FROM order_payments
GROUP BY payment_type
ORDER BY total_orders DESC
LIMIT 1;

## Which payment type generates the highest total payment value?
SELECT
    payment_type,
    SUM(payment_value) AS total_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY total_payment_value DESC
LIMIT 1;
## How many customers placed 1 order, 2 orders, 3 orders, etc.?
SELECT
    total_orders,
    COUNT(*) AS number_of_customers
FROM (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
) AS customer_orders
GROUP BY total_orders
ORDER BY total_orders;

##Which month had the highest number of orders?
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY month
ORDER BY total_orders DESC
LIMIT 1;
## How many orders were placed in each month?
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;
## What is the average order value (AOV) for each month?
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    SUM(oi.price) / COUNT(DISTINCT o.order_id) AS AOV
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

## What percentage of total payment value comes from each payment type?
SELECT
    op.payment_type,
    SUM(op.payment_value) AS total_payment_value,
    SUM(op.payment_value) / MAX(total.grand_total) * 100 AS payment_share
FROM order_payments op
CROSS JOIN (
    SELECT SUM(payment_value) AS grand_total
    FROM order_payments
) AS total
GROUP BY op.payment_type
ORDER BY payment_share DESC;

## How does total payment value change month by month?
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    SUM(op.payment_value) AS total_payment_value
FROM orders o
JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY month
ORDER BY month;

##Which month had the highest percentage of repeat customers?
SELECT
    rpt.month,
    rpt.repeat_customers,
    total.total_customers,
    rpt.repeat_customers / total.total_customers * 100
        AS repeat_customer_rate

FROM
(
SELECT
    month,
    COUNT(DISTINCT customer_unique_id) AS repeat_customers
FROM (
    SELECT
        COUNT(o.order_id) AS total_orders,
        c.customer_unique_id,
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id, month
    HAVING COUNT(o.order_id) > 1
) AS repeat_list
GROUP BY month
) as rpt join 
(select count(DISTINCT c.customer_unique_id) as total_customers, 
DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') as month from 
customers c join orders o on c.customer_id=o.customer_id 
group by month) as total 

ON rpt.month = total.month

ORDER BY repeat_customer_rate DESC
LIMIT 1;

## Which month had the highest cancellation rate?

SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    SUM(
        CASE
            WHEN order_status = 'canceled' THEN 1
            ELSE 0
        END
    ) / COUNT(order_id) * 100 AS cancellation_rate
FROM orders
GROUP BY month
ORDER BY cancellation_rate DESC
LIMIT 1;

## what percentage of customers made another purchase with in 90 days of their first purchase?
SELECT
    rpt.repeat_90_days,
    total.total_unique_customers,
    rpt.repeat_90_days / total.total_unique_customers * 100 AS retention_rate
FROM
(
    SELECT
        COUNT(DISTINCT temp.customer_unique_id) AS repeat_90_days
    FROM
    (
        SELECT
            fp.customer_unique_id,
            fp.first_purchase,
            o.order_purchase_timestamp AS later_order,
            DATEDIFF(
                o.order_purchase_timestamp,
                fp.first_purchase
            ) AS days_after_first
        FROM
        (
            SELECT
                c.customer_unique_id,
                MIN(o.order_purchase_timestamp) AS first_purchase
            FROM orders o
            JOIN customers c
                ON o.customer_id = c.customer_id
            GROUP BY c.customer_unique_id
        ) AS fp
        JOIN customers c
            ON fp.customer_unique_id = c.customer_unique_id
        JOIN orders o
            ON c.customer_id = o.customer_id
        WHERE o.order_purchase_timestamp > fp.first_purchase
    ) AS temp
    WHERE temp.days_after_first <= 90
) AS rpt

CROSS JOIN

(
    SELECT
        COUNT(DISTINCT c.customer_unique_id) AS total_unique_customers
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
) AS total;
## Who are the top 3 customers by total product spending?
SELECT
    c.customer_unique_id,
    SUM(oi.price) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spending DESC
LIMIT 3;

## which month has highest AOV?
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    SUM(oi.price) AS total_value,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.price) / COUNT(o.order_id) AS AOV
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY month
ORDER BY AOV DESC
LIMIT 1;
##Which product category generated the highest revenue?
SELECT
    p.product_category_name,
    SUM(oi.price) AS revenue
FROM order_items AS oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 1;
## Find the month with the highest number of orders.
SELECT
    COUNT(order_id) AS total_orders,
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month
FROM orders
GROUP BY month
ORDER BY total_orders DESC
LIMIT 1;
## Find customers who placed orders in at least 3 different months.

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')) AS total_months
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')) >= 3;
## Find the customer who placed the most orders.
SELECT
    c.customer_unique_id,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
ORDER BY total_orders DESC
LIMIT 1;

## Find the average number of orders placed by a customer.
SELECT
    c.customer_unique_id,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
ORDER BY total_orders DESC
LIMIT 1;
## Find the average number of orders placed by a customer.

SELECT
    AVG(temp.total_orders) AS avg_orders_per_customer
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) AS temp;

# Find customers whose total spending is higher than the average customer spending.
SELECT
    temp.customer_unique_id,
    temp.total_spending
FROM (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS total_spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
) AS temp

WHERE temp.total_spending > (
    SELECT AVG(avg_temp.total_spending)
    FROM (
        SELECT
            c.customer_unique_id,
            SUM(oi.price) AS total_spending
        FROM customers c
        JOIN orders o
            ON c.customer_id = o.customer_id
        JOIN order_items oi
            ON o.order_id = oi.order_id
        GROUP BY c.customer_unique_id
    ) AS avg_temp
);







