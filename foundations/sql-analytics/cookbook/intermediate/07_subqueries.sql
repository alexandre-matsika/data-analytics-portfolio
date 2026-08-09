/*
=========================================================
File: 07_subqueries.sql

Objective:
Demonstrate how to use SQL subqueries for analytics:
- Scalar subqueries
- Subqueries in WHERE
- Subqueries in FROM
- Correlated subqueries
- IN
- EXISTS
- NOT EXISTS

Subqueries help compare records to aggregated values,
filter data dynamically, and answer business questions
without creating permanent intermediate tables.
=========================================================
*/

---------------------------------------------------------
-- 1. Find products priced above the average product price
--
-- Business Question:
-- Which products are more expensive than the overall
-- average product price?
--
-- SQL Concept:
-- Scalar subquery in the WHERE clause
---------------------------------------------------------
SELECT
    product_id,
    product_name,
    unit_price
FROM products
WHERE unit_price > (
    SELECT AVG(unit_price)
    FROM products
)
ORDER BY unit_price DESC;

---------------------------------------------------------
-- 2. Find orders above the average order value
--
-- Business Question:
-- Which orders generate more revenue than the average
-- completed order?
--
-- SQL Concept:
-- Subquery in the FROM clause
---------------------------------------------------------
SELECT
    order_id,
    order_total
FROM (
    SELECT
        o.order_id,
        SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY o.order_id
) order_totals
WHERE order_total > (
    SELECT AVG(order_total)
    FROM (
        SELECT
            SUM(oi.quantity * oi.unit_price) AS order_total
        FROM orders o
        JOIN order_items oi
            ON o.order_id = oi.order_id
        WHERE o.status = 'completed'
        GROUP BY o.order_id
    ) average_order_values
)
ORDER BY order_total DESC;

---------------------------------------------------------
-- 3. Find customers whose revenue is above the average
-- customer revenue
--
-- Business Question:
-- Which customers generate more revenue than the average
-- completed-order customer?
--
-- SQL Concept:
-- Subquery in the HAVING clause
---------------------------------------------------------
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(oi.quantity * oi.unit_price) > (
    SELECT AVG(customer_revenue)
    FROM (
        SELECT
            SUM(oi.quantity * oi.unit_price) AS customer_revenue
        FROM orders o
        JOIN order_items oi
            ON o.order_id = oi.order_id
        WHERE o.status = 'completed'
        GROUP BY o.customer_id
    ) customer_totals
)
ORDER BY total_revenue DESC;

---------------------------------------------------------
-- 4. Find customers who placed more orders than the
-- average customer
--
-- Business Question:
-- Which customers order more frequently than average?
--
-- SQL Concept:
-- Subquery with aggregation and HAVING
---------------------------------------------------------
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(order_count)
    FROM (
        SELECT
            COUNT(order_id) AS order_count
        FROM orders
        GROUP BY customer_id
    ) customer_order_counts
)
ORDER BY total_orders DESC;

---------------------------------------------------------
-- 5. Find products that have never been ordered
--
-- Business Question:
-- Which products have no sales activity?
--
-- SQL Concept:
-- NOT EXISTS correlated subquery
---------------------------------------------------------
SELECT
    p.product_id,
    p.product_name,
    p.unit_price
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.product_id = p.product_id
)
ORDER BY p.product_name;

---------------------------------------------------------
-- 6. Find customers who have placed at least one
-- completed order
--
-- Business Question:
-- Which customers have successfully completed a purchase?
--
-- SQL Concept:
-- EXISTS correlated subquery
---------------------------------------------------------
SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.status = 'completed'
)
ORDER BY c.customer_id;

---------------------------------------------------------
-- 7. Find customers who have never placed an order
--
-- Business Question:
-- Which registered customers have no purchasing activity?
--
-- SQL Concept:
-- NOT EXISTS correlated subquery
---------------------------------------------------------
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.signup_date
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
)
ORDER BY c.signup_date;

---------------------------------------------------------
-- 8. Find the most expensive product in each category
--
-- Business Question:
-- Which product has the highest price in each category?
--
-- SQL Concept:
-- Correlated scalar subquery
---------------------------------------------------------
SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    p.unit_price
FROM products p
WHERE p.unit_price = (
    SELECT MAX(p2.unit_price)
    FROM products p2
    WHERE p2.category_id = p.category_id
)
ORDER BY p.category_id, p.product_name;

---------------------------------------------------------
-- 9. Find the latest order for each customer
--
-- Business Question:
-- What is the most recent order placed by each customer?
--
-- SQL Concept:
-- Correlated scalar subquery
---------------------------------------------------------
SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.status
FROM orders o
WHERE o.order_date = (
    SELECT MAX(o2.order_date)
    FROM orders o2
    WHERE o2.customer_id = o.customer_id
)
ORDER BY o.customer_id;

---------------------------------------------------------
-- 10. Find categories with above-average revenue
--
-- Business Question:
-- Which product categories generate more revenue than
-- the average category?
--
-- SQL Concept:
-- Nested subquery with aggregation
---------------------------------------------------------
SELECT
    category_name,
    category_revenue
FROM (
    SELECT
        cat.category_name,
        SUM(oi.quantity * oi.unit_price) AS category_revenue
    FROM categories cat
    JOIN products p
        ON cat.category_id = p.category_id
    JOIN order_items oi
        ON p.product_id = oi.product_id
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.status = 'completed'
    GROUP BY cat.category_name
) category_totals
WHERE category_revenue > (
    SELECT AVG(category_revenue)
    FROM (
        SELECT
            SUM(oi.quantity * oi.unit_price) AS category_revenue
        FROM categories cat
        JOIN products p
            ON cat.category_id = p.category_id
        JOIN order_items oi
            ON p.product_id = oi.product_id
        JOIN orders o
            ON oi.order_id = o.order_id
        WHERE o.status = 'completed'
        GROUP BY cat.category_name
    ) average_category_revenue
)
ORDER BY category_revenue DESC;