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
## Find the top 3 product categories by number of orders.
SELECT
    p.product_category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_orders DESC
LIMIT 3;

## Which product category has the highest average product price?
SELECT
    p.product_category_name,
    AVG(oi.price) AS average_product_price
FROM products p
JOIN order_items oi
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY average_product_price DESC
LIMIT 1;

## Find the top 3 customers by number of distinct products purchased.
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT oi.product_id) AS distinct_products
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY customer_unique_id
ORDER BY distinct_products DESC
LIMIT 3;

##For each product category, find the total revenue and the average product price.
SELECT
    p.product_category_name,
    SUM(oi.price) AS total_revenue,
    AVG(oi.price) AS average_price
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name;

## Find the top 3 customers by total number of items purchased.
SELECT
    c.customer_unique_id,
    COUNT(oi.order_item_id) AS total_items_purchased
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.customer_unique_id
ORDER BY total_items_purchased DESC
LIMIT 3;
## Find the average number of items purchased per order.
SELECT
    AVG(temp.total_items) AS avg_items_per_order
FROM (
    SELECT
        o.order_id,
        COUNT(oi.order_item_id) AS total_items
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.order_id
) AS temp;
## Find the top 3 product categories by total number of items sold.
SELECT
    p.product_category_name,
    COUNT(oi.order_item_id) AS total_items_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_items_sold DESC
LIMIT 3;

## Find the top 3 customers who spent the most on a single order.
SELECT
    c.customer_unique_id,
    o.order_id,
    SUM(oi.price) AS order_total
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.customer_unique_id, o.order_id
ORDER BY order_total DESC
LIMIT 3;
## Find customers who have purchased from more than 3 different product categories.
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT p.product_category_name) AS total_categories
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT p.product_category_name) > 3;
## Find the month with the highest total sales revenue.
SELECT
    SUM(oi.price) AS total_revenue,
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY month
ORDER BY total_revenue DESC
LIMIT 1;
## Find the customer who has placed orders across the highest number of different months.
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')) AS different_months
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
ORDER BY different_months DESC
LIMIT 1;

## Find the average order value for each customer and the
##top 3 customers with the highest average order value.
SELECT
    temp.customer_unique_id,
    AVG(temp.order_total) AS avg_order_value
FROM (
    SELECT
        o.order_id,
        c.customer_unique_id,
        SUM(oi.price) AS order_total
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.order_id, c.customer_unique_id
) AS temp
GROUP BY temp.customer_unique_id
ORDER BY avg_order_value DESC
LIMIT 3;
## Find customers whose total spending is greater than the average spending of all customers.
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
        ON oi.order_id = o.order_id
    GROUP BY c.customer_unique_id
) AS temp
WHERE temp.total_spending > (
    SELECT
        AVG(avg_temp.total_spending)
    FROM (
        SELECT
            c.customer_unique_id,
            SUM(oi.price) AS total_spending
        FROM customers c
        JOIN orders o
            ON c.customer_id = o.customer_id
        JOIN order_items oi
            ON oi.order_id = o.order_id
        GROUP BY c.customer_unique_id
    ) AS avg_temp
);
## Find the percentage of total revenue contributed by each product category.
SELECT
    temp.product_category_name,
    temp.category_revenue,
    total.total_revenue,
    temp.category_revenue / total.total_revenue * 100 AS percentage_revenue
FROM (
    SELECT
        p.product_category_name,
        SUM(oi.price) AS category_revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY p.product_category_name
) AS temp
CROSS JOIN (
    SELECT
        SUM(oi.price) AS total_revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
) AS total;

##Classify customers based on their total spending:
#High Value → spending > ₹10,000
#Medium Value → spending between ₹5,000 and ₹10,000
#Low Value → spending < ₹5,000
SELECT
    temp.customer_unique_id,
    temp.total_spending,
    CASE
        WHEN temp.total_spending > 10000 THEN 'High Value'
        WHEN temp.total_spending >= 5000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
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
) AS temp;
# For each order, classify it based on its total value:
#Large → order value > ₹5,000
#Medium → ₹2,000–₹5,000
#Small → < ₹2,000

SELECT
    temp.order_id,
    temp.order_total,
    CASE
        WHEN temp.order_total > 5000 THEN 'Large'
        WHEN temp.order_total >= 2000 THEN 'Medium'
        ELSE 'Small'
    END AS order_category
FROM (
    SELECT
        o.order_id,
        SUM(oi.price) AS order_total
    FROM orders o
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY o.order_id
) AS temp;

## Find the top 3 customers based on their total spending, and
##classify them as High / Medium / Low value.
SELECT
    temp.customer_unique_id,
    temp.total_spending,
    CASE
        WHEN temp.total_spending >= 10000 THEN 'HIGH VALUE'
        WHEN temp.total_spending >= 5000 THEN 'MEDIUM VALUE'
        ELSE 'LOW VALUE'
    END AS customer_category
FROM (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS total_spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY c.customer_unique_id
) AS temp
ORDER BY temp.total_spending DESC
LIMIT 3;

## Find the top 3 customers who have placed the highest number of orders.
SELECT
    c.customer_unique_id,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
ORDER BY total_orders DESC
LIMIT 3;

## Find the most recent order placed by each customer.
WITH ranked_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp DESC
        ) AS order_rank
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
)

SELECT
    customer_unique_id,
    order_id,
    order_purchase_timestamp
FROM ranked_orders
WHERE order_rank = 1;

## For each customer, rank their orders by purchase date, with the most recent order getting rank 1.
SELECT
    c.customer_unique_id,
    o.order_id,
    o.order_purchase_timestamp,
    ROW_NUMBER() OVER (
        PARTITION BY c.customer_unique_id
        ORDER BY o.order_purchase_timestamp DESC
    ) AS order_rank
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id;
## Take ALL customers and rank them together based on their spending.
WITH customer_spending AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS total_spending
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
)

SELECT
    customer_unique_id,
    total_spending,
    RANK() OVER (
        ORDER BY total_spending DESC
    ) AS spending_rank
FROM customer_spending;

##Rank customers based on their total spending, from highest to lowest.
WITH customer_spending AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS total_spending
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
),

customer_ranking AS (
    SELECT
        customer_unique_id,
        total_spending,
        RANK() OVER (
            ORDER BY total_spending DESC
        ) AS spending_rank
    FROM customer_spending
)

SELECT
    customer_unique_id,
    total_spending,
    spending_rank
FROM customer_ranking
WHERE spending_rank <= 3;

## Rank customers by total spending using DENSE_RANK() and identify the top 3 spending levels.
WITH customer_spending AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS total_spending
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
),

customer_ranking AS (
    SELECT
        customer_unique_id,
        total_spending,
        DENSE_RANK() OVER (
            ORDER BY total_spending DESC
        ) AS spending_rank
    FROM customer_spending
)

SELECT
    customer_unique_id,
    total_spending,
    spending_rank
FROM customer_ranking
WHERE spending_rank <= 3;
## For each customer, find the previous order date and calculate the number of days between
##the current order and previous order.
WITH customer_previous AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp,
        LAG(o.order_purchase_timestamp) OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS previous_order_date
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
)

SELECT
    customer_unique_id,
    order_id,
    order_purchase_timestamp,
    previous_order_date,
    DATEDIFF(
        order_purchase_timestamp,
        previous_order_date
    ) AS days_between_orders
FROM customer_previous;

## For each customer, show every order and their running total spending in chronological order.
WITH customer_order AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp,
        SUM(oi.price) AS order_total
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp
)

SELECT
    customer_unique_id,
    order_id,
    order_purchase_timestamp,
    order_total,
    SUM(order_total) OVER (
        PARTITION BY customer_unique_id
        ORDER BY order_purchase_timestamp
    ) AS running_total
FROM customer_order;
## For each customer, show every order along with the customer's average order value (AOV).
WITH customer_order AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        SUM(oi.price) AS order_total
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY
        c.customer_unique_id,
        o.order_id
)

SELECT
    customer_unique_id,
    order_id,
    order_total,
    AVG(order_total) OVER (
        PARTITION BY customer_unique_id
    ) AS avg_order_value
FROM customer_order;
## For each customer, show every order along with the customer's total spending.

WITH customer_order AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        SUM(oi.price) AS order_total
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY
        c.customer_unique_id,
        o.order_id
)

SELECT
    customer_unique_id,
    order_id,
    order_total,
    SUM(order_total) OVER (
        PARTITION BY customer_unique_id
    ) AS total_customer_spending
FROM customer_order;

## Take ALL customers and rank them together based on their spending.

WITH customer_spending AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS total_spending
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
)

SELECT
    customer_unique_id,
    total_spending,
    RANK() OVER (
        ORDER BY total_spending DESC
    ) AS spending_rank
FROM customer_spending;

## Rank customers by total spending using DENSE_RANK() and identify the top 3 spending levels.
WITH customer_spending AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS total_spending
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
),

customer_ranking AS (
    SELECT
        customer_unique_id,
        total_spending,
        DENSE_RANK() OVER (
            ORDER BY total_spending DESC
        ) AS spending_rank
    FROM customer_spending
)

SELECT
    customer_unique_id,
    total_spending,
    spending_rank
FROM customer_ranking
WHERE spending_rank <= 3;

## For each customer, find their next order date.
WITH customer_next AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
)

SELECT
    customer_unique_id,
    order_id,
    order_purchase_timestamp,
    LEAD(order_purchase_timestamp) OVER (
        PARTITION BY customer_unique_id
        ORDER BY order_purchase_timestamp
    ) AS next_order_date
FROM customer_next;

## Find the top 2 highest-value orders for each customer.
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        SUM(oi.price) AS order_total
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_unique_id,
        o.order_id
),

customer_rank AS (
    SELECT
        customer_unique_id,
        order_id,
        order_total,
        ROW_NUMBER() OVER (
            PARTITION BY customer_unique_id
            ORDER BY order_total DESC
        ) AS order_rank
    FROM customer_orders
)

SELECT
    customer_unique_id,
    order_id,
    order_total,
    order_rank
FROM customer_rank
WHERE order_rank <= 2;

## Find all customers whose total spending is greater than the average spending of all customers.
WITH customer_spending AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS total_spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY c.customer_unique_id
),

average_spending AS (
    SELECT
        AVG(total_spending) AS avg_cust_spending
    FROM customer_spending
)

SELECT
    cs.customer_unique_id,
    cs.total_spending
FROM customer_spending cs
CROSS JOIN average_spending av
WHERE cs.total_spending > av.avg_cust_spending;

## Find all customers whose total spending is equal to maximum spending of all customers.
WITH total_order AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        SUM(oi.price) AS order_total
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY
        c.customer_unique_id,
        o.order_id
)

SELECT
    customer_unique_id,
    order_id,
    order_total
FROM total_order
WHERE order_total = (
    SELECT MAX(order_total)
    FROM total_order
);
# Find customers who have placed more than 3 orders.
SELECT
c.customer_unique_id,
COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) > 3;

#Find all customers who have placed at least one order.
SELECT
    c.customer_unique_id
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
# Find customers who have NEVER placed an order.
SELECT
    c.customer_unique_id
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
#Find customers who have NOT placed any order in the last 6 months.
SELECT
    c.customer_unique_id
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.order_purchase_timestamp >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
);
##

WITH customer_order AS (
    SELECT
        c.customer_unique_id,
        o.order_purchase_timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp DESC
        ) AS ranking
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
)
## Find customers who placed an order in the last 6 months but have NOT placed another order after that.
WITH customer_order AS (
    SELECT
        c.customer_unique_id,
        o.order_purchase_timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp DESC
        ) AS ranking
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
)
SELECT
    customer_unique_id,
    order_purchase_timestamp,
    ranking
FROM customer_order
WHERE ranking = 1
  AND order_purchase_timestamp >= DATE_SUB(NOW(), INTERVAL 6 MONTH);

## find the customers who ordered in last 6 months but did not order in the 6 months before that

Select c.customer_unique_id from customers c 
where EXISTS ( select 1 from orders o where c.customer_id=o.customer_id 
AND o.order_purchase_timestamp >= date_sub(NOW(), INTERVAL 6 MONTH))
AND NOT EXISTS ( select 1 from orders o where c.customer_id=o.customer_id
AND o.order_purchase_timestamp>= DATE_SUB(NOW(), INTERVAL 12 MONTH)
AND o.order_purchase_timestamp< DATE_SUB(NOW(), INTERVAL 6 MONTH));

##Find all orders placed in the year 2018.
select o.order_id , o.order_purchase_timestamp from orders o
 where DATE_FORMAT(o.order_purchase_timestamp, '%Y')='2018';
 
 # Find the number of orders placed in each month of 2018.
 SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(order_id) AS total_orders
FROM orders
WHERE DATE_FORMAT(order_purchase_timestamp, '%Y') = '2018'
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY month;


## find the no of orders placed on each day of the week (mon,tues)
select count(order_id) as total_orders, DAYNAME(order_purchase_timestamp) as weekday
from orders group by DAYNAME(order_purchase_timestamp) order by total_orders;

## find the avg no of days betwn a customer's concesutive orders
WITH cte AS (
    SELECT
        c.customer_unique_id,
        o.order_purchase_timestamp,
        LAG(o.order_purchase_timestamp) OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS previous_date
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
)

SELECT
    AVG(temp.days_between_orders) AS average_of_orders
FROM (
    SELECT
        customer_unique_id,
        order_purchase_timestamp,
        DATEDIFF(
            order_purchase_timestamp,
            previous_date
        ) AS days_between_orders
    FROM cte
) AS temp;

## Find all customers who have placed an order, but whose order_delivered_customer_date is NULL.
select c.customer_unique_id, o.order_id, o.order_delivered_customer_date from customers c 
join orders o on c.customer_id=o.customer_id where o.order_delivered_customer_date IS NULL; 

## find all customers who have never placed an order.
select c.customer_unique_id from customers c join orders o on c.customer_id=o.customer_id
where o.order_id IS NULL;

# Find the top 5 customers by total revenue generated.
SELECT
    c.customer_unique_id,
    SUM(oi.price) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.customer_unique_id
ORDER BY revenue DESC
LIMIT 5;
## Find the average number of orders placed per customer.

WITH order_total AS (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    AVG(total_orders) AS average_orders
FROM order_total;
## Find each customer's total revenue and calculate what percentage of the company's total revenue that customer contributed.
WITH customer_revenue AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY c.customer_unique_id
),

company_total_revenue AS (
    SELECT
        SUM(oi.price) AS total_company_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
)

SELECT
    cr.customer_unique_id,
    cr.total_revenue,
    cr.total_revenue / ctr.total_company_revenue * 100
        AS revenue_contribution_percentage
FROM customer_revenue cr
CROSS JOIN company_total_revenue ctr;

## Find the number of unique customers in each state, and show the states with the highest number of customers first.
SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;

## Q12. Find the total revenue generated by each customer state and sort the states from highest to lowest revenue.
SELECT
    c.customer_state,
    SUM(oi.price) AS total_revenue
FROM orders o
JOIN customers c
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;
## Find the average order value (AOV) for each customer state.
SELECT
    c.customer_state,
    SUM(oi.price) / COUNT(DISTINCT o.order_id) AS aov
FROM orders o
JOIN customers c
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.customer_state
ORDER BY aov DESC;

## Find each customer state's total revenue, number of orders, and average order value — all in the same query.
SELECT
    c.customer_state,
    SUM(oi.price) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.price) / COUNT(DISTINCT o.order_id) AS aov
FROM orders o
JOIN customers c
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.customer_state
ORDER BY aov DESC;


## find repeat customer rate per customer state
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        c.customer_state,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id,
        c.customer_state
),

repeat_customers AS (
    SELECT
        customer_state,
        COUNT(*) AS repeat_customers
    FROM customer_orders
    WHERE total_orders > 1
    GROUP BY customer_state
),

total_customers AS (
    SELECT
        customer_state,
        COUNT(*) AS total_customers
    FROM customer_orders
    GROUP BY customer_state
)

SELECT
    t.customer_state,
    t.total_customers,
    r.repeat_customers,
    r.repeat_customers * 100.0 / t.total_customers
        AS repeat_customer_rate
FROM total_customers t
LEFT JOIN repeat_customers r
    ON t.customer_state = r.customer_state
ORDER BY repeat_customer_rate DESC;

# Find the percentage of customers who have placed exactly one order.
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
),

one_customer AS (
    SELECT
        COUNT(*) AS one_order_customers
    FROM customer_orders
    WHERE total_orders = 1
),

total_customers AS (
    SELECT
        COUNT(*) AS total_customers
    FROM customer_orders
)

SELECT
    o.one_order_customers,
    t.total_customers,
    o.one_order_customers * 100.0 / t.total_customers
        AS one_order_customer_rate
FROM one_customer o
CROSS JOIN total_customers t;
##  Find the percentage of customers who placed 2 or more orders.
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
),

multiple_customer AS (
    SELECT
        COUNT(*) AS multiple_order_customers
    FROM customer_orders
    WHERE total_orders >= 2
),

total_customers AS (
    SELECT
        COUNT(*) AS total_customers
    FROM customer_orders
)

SELECT
    m.multiple_order_customers,
    t.total_customers,
    m.multiple_order_customers * 100.0 / t.total_customers
        AS multiple_order_customer_rate
FROM multiple_customer m
CROSS JOIN total_customers t;
## Find the number of customers who placed at least one order in the last 18 months.
SELECT
    COUNT(DISTINCT c.customer_unique_id) AS total_customers
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_purchase_timestamp >= DATE_SUB(NOW(), INTERVAL 18 MONTH);
## Find the customer ID, customer name, and order date for customers who placed an order in the last 18 months.
SELECT
    c.customer_unique_id,
    o.order_purchase_timestamp
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_purchase_timestamp >= DATE_SUB(NOW(), INTERVAL 18 MONTH);

# Q25: Find the number of customers whose first-ever order was placed in 2018. Try this one yourself.
WITH first_orders AS (
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_order_date
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS total_customers
FROM first_orders
WHERE first_order_date >= '2018-01-01'
  AND first_order_date < '2019-01-01';


# Find the number of customers who placed their first-ever order in 2017 and then placed at least one more order after that.
WITH first_orders AS (
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_order_date,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS retained_customers
FROM first_orders
WHERE first_order_date >= '2017-01-01'
  AND first_order_date < '2018-01-01'
  AND total_orders > 1;
  
## Find the retention rate of customers whose first-ever order was placed in 2017.
WITH first_orders AS (
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_order_date,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    t.retained_customers,
    r.total_customers,
    t.retained_customers * 100.0 / r.total_customers
        AS retention_rate
FROM
(
    SELECT
        COUNT(*) AS retained_customers
    FROM first_orders
    WHERE first_order_date >= '2017-01-01'
      AND first_order_date < '2018-01-01'
      AND total_orders > 1
) AS t
CROSS JOIN
(
    SELECT
        COUNT(*) AS total_customers
    FROM first_orders
    WHERE first_order_date >= '2017-01-01'
      AND first_order_date < '2018-01-01'
) AS r;
## What percentage of 2017 first-order customers placed at least one additional order within 6 months?
WITH first_orders AS (
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_order_date
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    t.retained_customers,
    r.total_customers,
    t.retained_customers * 100.0 / r.total_customers
        AS retention_rate
FROM
(
    SELECT
        COUNT(DISTINCT f.customer_unique_id) AS retained_customers
    FROM first_orders f
    JOIN customers c
        ON c.customer_unique_id = f.customer_unique_id
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE f.first_order_date >= '2017-01-01'
      AND f.first_order_date < '2018-01-01'
      AND o.order_purchase_timestamp > f.first_order_date
      AND o.order_purchase_timestamp <=
          DATE_ADD(f.first_order_date, INTERVAL 6 MONTH)
) AS t
CROSS JOIN
(
    SELECT
        COUNT(*) AS total_customers
    FROM first_orders
    WHERE first_order_date >= '2017-01-01'
      AND first_order_date < '2018-01-01'
) AS r;

## Revenue analysis
## Find the total revenue generated in each month, along with the month and year, and sort it chronologically.
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    SUM(oi.price) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY month;
## Calculate the monthly revenue and the percentage change in revenue compared with the previous month.
WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
        SUM(oi.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
),

revenue_with_previous AS (
    SELECT
        month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (
            ORDER BY month
        ) AS previous_month_revenue
    FROM monthly_revenue
)

SELECT
    month,
    monthly_revenue,
    previous_month_revenue,
    (monthly_revenue - previous_month_revenue)
        * 100.0 / previous_month_revenue AS mom_growth
FROM revenue_with_previous
ORDER BY month;
# Find the percentage contribution of each product category to total company revenue.
WITH revenue_product AS (
    SELECT
        p.product_category_name,
        SUM(oi.price) AS total_revenue
    FROM products p
    JOIN order_items oi
        ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
),

revenue_total AS (
    SELECT
        SUM(total_revenue) AS company_revenue
    FROM revenue_product
)

SELECT
    r.product_category_name,
    r.total_revenue,
    r.total_revenue * 100.0 / t.company_revenue
        AS revenue_contribution_percentage
FROM revenue_product r
CROSS JOIN revenue_total t
ORDER BY revenue_contribution_percentage DESC;

## Find the total revenue generated by each product category, and return the top 5 categories by revenue.
SELECT
    p.product_category_name,
    SUM(oi.price) AS total_revenue
FROM products p
JOIN order_items oi
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 5;

## Find the latest order date for each customer.

SELECT
    c.customer_unique_id,
    MAX(o.order_purchase_timestamp) AS latest_order
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id;

#Find each customer's previous order date and calculate the number of days between their current order and previous order.
WITH previous_order AS (
    SELECT
        c.customer_unique_id,
        o.order_purchase_timestamp,
        LAG(o.order_purchase_timestamp) OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS previous_order_date
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
)
SELECT
    customer_unique_id,
    order_purchase_timestamp,
    previous_order_date,
    DATEDIFF(
        order_purchase_timestamp,
        previous_order_date
    ) AS days_between_orders
FROM previous_order;

## Find customers who have both: more than 2 orders, total revenue greater than ₹1,000
SELECT
    c.customer_unique_id,
    COUNT(o.order_id) AS total_orders,
    SUM(oi.price) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) > 2
   AND SUM(oi.price) > 1000;
   
## Find how much total revenue came from one-time customers versus repeat customers.

WITH customer_level AS (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS total_orders,
        SUM(oi.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY c.customer_unique_id
)
SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-time'
        WHEN total_orders > 1 THEN 'Repeat'
    END AS customer_type,
    SUM(total_revenue) AS total_revenue
FROM customer_level
GROUP BY customer_type;

# What percentage of the company's total revenue comes from repeat customers?

WITH customer_level AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS total_revenue,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(o.order_id) > 1
),
company_revenue AS (
    SELECT
        SUM(oi.price) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON oi.order_id = o.order_id
)
SELECT
    SUM(r.total_revenue) * 100.0 / t.total_revenue
        AS repeat_revenue_percentage
FROM customer_level r
CROSS JOIN company_revenue t;

## Find the Average Order Value (AOV) for each customer.

WITH customer_revenue AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        SUM(oi.price) AS order_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id, o.order_id
)
SELECT
    customer_unique_id,
    AVG(order_revenue) AS aov
FROM customer_revenue
GROUP BY customer_unique_id;
##Find the number of days since each customer's latest order.
WITH cte AS (
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp) AS latest_order
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    customer_unique_id,
    latest_order,
    DATEDIFF(CURDATE(), latest_order) AS no_of_days
FROM cte;

## Find customers whose latest order was more than 180 days ago.
WITH cte AS (
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp) AS latest_order
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    customer_unique_id,
    latest_order,
    DATEDIFF(CURDATE(), latest_order) AS no_of_days
FROM cte
WHERE DATEDIFF(CURDATE(), latest_order) > 180;
## Find customers who were inactive for more than 180 days after their previous order but then placed another order.
WITH cte AS (
    SELECT
        c.customer_unique_id,
        o.order_purchase_timestamp,
        LAG(o.order_purchase_timestamp) OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS previous_order
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
)
SELECT
    customer_unique_id,
    order_purchase_timestamp AS current_order,
    previous_order,
    DATEDIFF(order_purchase_timestamp, previous_order) AS days_inactive
FROM cte
WHERE DATEDIFF(order_purchase_timestamp, previous_order) > 180;

## Calculate the total revenue generated by each customer and rank customers from highest to lowest revenue.
WITH customer_revenue AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY c.customer_unique_id
)
SELECT
    customer_unique_id,
    total_revenue,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM customer_revenue;
## Return only the top 3 revenue-ranked customers.
WITH customer_revenue AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY c.customer_unique_id
),
customer_ranking AS (
    SELECT
        customer_unique_id,
        total_revenue,
        RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank
    FROM customer_revenue
)
SELECT
    customer_unique_id,
    total_revenue,
    revenue_rank
FROM customer_ranking
WHERE revenue_rank <= 3;

## Top 3 WITH customer_revenue AS (
    SELECT
        c.customer_state,
        c.customer_unique_id,
        SUM(oi.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY
        c.customer_state,
        c.customer_unique_id
),
customer_ranking AS (
    SELECT
        customer_state,
        customer_unique_id,
        total_revenue,
        RANK() OVER (
            PARTITION BY customer_state
            ORDER BY total_revenue DESC
        ) AS revenue_ranking
    FROM customer_revenue
)
SELECT
    customer_state,
    customer_unique_id,
    total_revenue,
    revenue_ranking
FROM customer_ranking
WHERE revenue_ranking <= 3;
## Find the average number of orders placed by customers in each state.
WITH cte AS (
    SELECT
        c.customer_state,
        c.customer_unique_id,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_state,
        c.customer_unique_id
)
SELECT
    customer_state,
    AVG(total_orders) AS average_orders_per_customer
FROM cte
GROUP BY customer_state;
# Find the number of unique customers who placed at least one order in each month.
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(DISTINCT c.customer_unique_id) AS total_customers
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
GROUP BY month
ORDER BY month;
## For each month, find the number of unique repeat customers — customers who had placed an order before that month and also placed an order during that month.

WITH cte AS (
    SELECT
        c.customer_unique_id,
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
        o.order_purchase_timestamp,
        LAG(o.order_purchase_timestamp) OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS previous_order_date
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
)


SELECT
    month,
    COUNT(DISTINCT customer_unique_id) AS repeat_customers
FROM cte
WHERE previous_order_date IS NOT NULL
GROUP BY month
ORDER BY month;
## For each month, calculate the total revenue generated only by repeat customers.

WITH cte AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
        o.order_purchase_timestamp,
        LAG(o.order_purchase_timestamp) OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS previous_order_date
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
)

SELECT
    ct.month,
    SUM(oi.price) AS total_revenue
FROM order_items oi
JOIN cte ct
    ON ct.order_id = oi.order_id
WHERE ct.previous_order_date IS NOT NULL
GROUP BY ct.month
ORDER BY ct.month;


# For each month, calculate the revenue generated by new customers and the revenue generated by repeat customers.

WITH customer_first_order AS (
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_order_date
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,

    CASE
        WHEN o.order_purchase_timestamp = f.first_order_date
            THEN 'New'
        ELSE 'Repeat'
    END AS customer_type,

    SUM(oi.price) AS revenue

FROM customer_first_order f
JOIN customers c
    ON f.customer_unique_id = c.customer_unique_id
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id

GROUP BY
    month,
    customer_type;
#Find the total revenue generated by each customer, their number of orders, and their average order value (AOV). Then rank customers by total revenue.
WITH customer_level AS (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS total_orders,
        SUM(oi.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
)

SELECT
    customer_unique_id,
    total_orders,
    total_revenue,
    total_revenue / total_orders AS aov,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM customer_level;

# Identify customers who have placed at least 3 orders and generated more than 1,000 in revenue.
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.price) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) >= 3
   AND SUM(oi.price) > 1000;

# Find customers whose average number of days between consecutive orders is more than 30 days.
WITH customer_level AS (
    SELECT
        c.customer_unique_id,
        o.order_purchase_timestamp AS current_order_date,
        LAG(o.order_purchase_timestamp) OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS previous_order_date
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
),

difference_date AS (
    SELECT
        customer_unique_id,
        current_order_date,
        previous_order_date,
        DATEDIFF(
            current_order_date,
            previous_order_date
        ) AS days_between_orders
    FROM customer_level
    WHERE previous_order_date IS NOT NULL
)

SELECT
    customer_unique_id,
    AVG(days_between_orders) AS avg_days_between_orders
FROM difference_date
GROUP BY customer_unique_id;

# Find customers who made a new purchase after being inactive for more than 180 days, and calculate the revenue generated from those reactivation orders.

WITH cte AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp AS current_order_date,
        LAG(o.order_purchase_timestamp) OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS previous_order_date
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
),

date_difference AS (
    SELECT
        customer_unique_id,
        order_id,
        current_order_date,
        previous_order_date,
        DATEDIFF(
            current_order_date,
            previous_order_date
        ) AS days_inactive
    FROM cte
    WHERE DATEDIFF(
        current_order_date,
        previous_order_date
    ) > 180
)

SELECT
    df.customer_unique_id,
    df.order_id,
    df.current_order_date AS reactivation_date,
    df.days_inactive,
    SUM(oi.price) AS order_revenue
FROM date_difference df
JOIN order_items oi
    ON df.order_id = oi.order_id
GROUP BY
    df.customer_unique_id,
    df.order_id,
    df.current_order_date,
    df.days_inactive;
    






