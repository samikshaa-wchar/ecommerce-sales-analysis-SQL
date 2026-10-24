CREATE DATABASE ecommerce_analytics;

USE ecommerce_analytics;
SELECT DATABASE();

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
    order_status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);
 show tables;
 
 INSERT INTO customers VALUES
(1, 'Aarav Sharma', 'Pune', '2026-01-05'),
(2, 'Priya Patil', 'Mumbai', '2026-01-10'),
(3, 'Rohan Deshmukh', 'Pune', '2026-01-15'),
(4, 'Sneha Kulkarni', 'Nashik', '2026-02-01'),
(5, 'Neha Joshi', 'Mumbai', '2026-02-10'),
(6, 'Aditya More', 'Nagpur', '2026-02-15'),
(7, 'Pooja Shinde', 'Pune', '2026-03-01'),
(8, 'Karan Shah', 'Nashik', '2026-03-05'),
(9, 'Isha Mehta', 'Mumbai', '2026-03-10'),
(10, 'Rahul Pawar', 'Aurangabad', '2026-03-15');

INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 55000),
(102, 'Smartphone', 'Electronics', 25000),
(103, 'Headphones', 'Accessories', 2000),
(104, 'Office Chair', 'Furniture', 7500),
(105, 'Study Table', 'Furniture', 6000),
(106, 'Smartwatch', 'Electronics', 5000),
(107, 'Keyboard', 'Accessories', 1500),
(108, 'Monitor', 'Electronics', 12000),
(109, 'Backpack', 'Accessories', 1800),
(110, 'Desk Lamp', 'Furniture', 1200);

INSERT INTO orders VALUES
(1001, 1, 101, 1, '2026-01-10', 'Delivered'),
(1002, 2, 102, 2, '2026-01-12', 'Delivered'),
(1003, 3, 103, 3, '2026-01-15', 'Delivered'),
(1004, 1, 106, 1, '2026-01-20', 'Delivered'),
(1005, 4, 104, 2, '2026-02-02', 'Delivered'),
(1006, 5, 105, 1, '2026-02-05', 'Delivered'),
(1007, 6, 108, 1, '2026-02-10', 'Cancelled'),
(1008, 2, 101, 1, '2026-02-15', 'Delivered'),
(1009, 7, 107, 2, '2026-03-01', 'Delivered'),
(1010, 8, 109, 3, '2026-03-04', 'Delivered'),
(1011, 9, 102, 1, '2026-03-08', 'Delivered'),
(1012, 10, 110, 2, '2026-03-12', 'Delivered'),
(1013, 3, 108, 1, '2026-03-15', 'Delivered'),
(1014, 5, 103, 2, '2026-03-18', 'Returned'),
(1015, 1, 102, 1, '2026-03-20', 'Delivered'),
(1016, 7, 106, 2, '2026-03-22', 'Delivered'),
(1017, 2, 104, 1, '2026-03-25', 'Delivered'),
(1018, 9, 107, 3, '2026-03-27', 'Delivered'),
(1019, 4, 105, 1, '2026-03-28', 'Delivered'),
(1020, 6, 103, 2, '2026-03-30', 'Delivered');

--  Display all products with their prices and categories.
SELECT product_name, price, category
FROM products;

-- find total numbers of custommers
select count(*) as total_customer
from customers;

-- find total numbers of orders
select count(*) as total_orders
from orders;

-- display all orders with status delievered
select * from orders
where order_status="delivered";

-- Calculate total revenue from delivered orders.
SELECT SUM(p.price * o.quantity) AS total_revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id
WHERE o.order_status = 'Delivered';

-- Find the total quantity sold for each product.
SELECT p.product_name,
       SUM(o.quantity) AS total_quantity_sold
FROM orders o
JOIN products p
ON o.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_name;

-- Identify the top 3 products by revenue.
SELECT p.product_name,
       SUM(p.price * o.quantity) AS total_revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 3;

-- Calculate total revenue for each month.
SELECT MONTH(o.order_date) AS month_number,
       SUM(p.price * o.quantity) AS monthly_revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY MONTH(o.order_date)
ORDER BY month_number;

-- Find customers who have placed more than one delivered order.
SELECT c.customer_name,
       COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 1;

-- Find the customer who generated the highest revenue from delivered orders.
SELECT c.customer_name,
       SUM(p.price * o.quantity) AS total_revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN products p
ON o.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_revenue DESC
LIMIT 1;

-- Find the best-performing product category based on revenue
SELECT p.category,
       SUM(p.price * o.quantity) AS total_revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
ORDER BY total_revenue DESC
LIMIT 1;

-- Calculate the percentage of orders that were cancelled.
SELECT
    ROUND(
        SUM(CASE WHEN order_status = 'Cancelled'
                 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS cancelled_order_percentage
FROM orders;

-- Find the top 5 customers by total spending.
SELECT
    c.customer_name,
    c.city,
    SUM(p.price * o.quantity) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN products p
    ON o.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY total_spending DESC
LIMIT 5;

-- Calculate revenue by city.
SELECT
    c.city,
    SUM(p.price * o.quantity) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN products p
    ON o.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY c.city
ORDER BY total_revenue DESC;

-- Find products that have never been ordered.
SELECT
    p.product_name,
    p.category
FROM products p
LEFT JOIN orders o
    ON p.product_id = o.product_id
WHERE o.order_id IS NULL;

-- Calculate the average order value
SELECT
    ROUND(AVG(order_value), 2) AS average_order_value
FROM (
    SELECT
        o.order_id,
        SUM(p.price * o.quantity) AS order_value
    FROM orders o
    JOIN products p
        ON o.product_id = p.product_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.order_id
) AS order_summary;

-- Compare delivered, cancelled and returned orders.
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;