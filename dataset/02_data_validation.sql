SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM sellers;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM order_payments;

SELECT * FROM customers LIMIT 10;
SELECT * FROM order_items LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM order_payments LIMIT 10;

#Are there any duplicate customers ?
SELECT customer_id, Count(*) FROM customers GROUP BY customer_id HAVING count(*)>1;







