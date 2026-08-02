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

