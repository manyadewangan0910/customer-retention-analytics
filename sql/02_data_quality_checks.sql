use ecommerce_analytics;
# check total records
SELECT COUNT(*) FROM ecommerce_analytics.customers;
SELECT COUNT(*) FROM ecommerce_analytics.order_items;
SELECT COUNT(*) FROM ecommerce_analytics.order_payments;
SELECT COUNT(*) FROM ecommerce_analytics.products;
SELECT COUNT(*) FROM ecommerce_analytics.sellers;
 
 #check for duplicate primary keys
 
SELECT customer_id,
       COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
 
SHOW COLUMNS FROM customers;
# check null values
SELECT * from customers WHERE customer_id IS NULL; 
SELECT * from order_items WHERE order_id IS NULL; 
SELECT * from order_payments WHERE order_id IS NULL;
SELECT * from orders WHERE order_id IS NULL; 

#count null values
SELECT COUNT(*) as missing_values from customers where customer_id IS NULL;

#check blank values
SELECT * from orders WHERE order_id =' '; 
SELECT * from customers WHERE customer_city= ' '; 

#check invalid values
SELECT * FROM order_items where price<0;
to check  for negative values
SELECT * from order_payments WHERE payment_value<0;

#check for invalid dates

SELECT * FROM  orders WHERE order_delivered_customer_date < order_purchase_timestamp;
#check form future dates;
SELECT * FROM orders WHERE order_purchase_timestamp > NOW();


