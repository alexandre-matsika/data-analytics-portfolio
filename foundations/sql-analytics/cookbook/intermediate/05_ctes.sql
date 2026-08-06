/*
=========================================================
File: 05_ctes.sql
Objective:
Demonstrate how to use CTEs (Common Table Expressions)
to make SQL queries more readable and maintainable.
=========================================================
*/

---------------------------------------------------------
-- 1. Revenue by order using a CTE
---------------------------------------------------------
WITH order_revenue AS (
    SELECT
        oi.order_id,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM order_items oi
    GROUP BY oi.order_id
)
SELECT
    order_id,
    revenue
FROM order_revenue
ORDER BY revenue DESC;

---------------------------------------------------------
-- 2. Top customers by revenue
---------------------------------------------------------
WITH customer_revenue AS (
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
)
SELECT
    customer_id,
    first_name,
    last_name,
    total_revenue
FROM customer_revenue
ORDER BY total_revenue DESC;

---------------------------------------------------------
-- 3. Monthly revenue compared to average monthly revenue
---------------------------------------------------------
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_date)::date AS month,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY DATE_TRUNC('month', o.order_date)
),
average_revenue AS (
    SELECT
        AVG(revenue) AS avg_monthly_revenue
    FROM monthly_revenue
)
SELECT
    mr.month,
    mr.revenue,
    ROUND(ar.avg_monthly_revenue, 2) AS avg_monthly_revenue,
    ROUND(mr.revenue - ar.avg_monthly_revenue, 2) AS deviation_from_average
FROM monthly_revenue mr
CROSS JOIN average_revenue ar
ORDER BY mr.month;

---------------------------------------------------------
-- 4. Best-selling products by quantity
---------------------------------------------------------
WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS total_quantity_sold
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.status = 'completed'
    GROUP BY p.product_id, p.product_name
)
SELECT
    product_id,
    product_name,
    total_quantity_sold
FROM product_sales
ORDER BY total_quantity_sold DESC, product_name;

---------------------------------------------------------
-- 5. Calculate average order value
---------------------------------------------------------
WITH order_totals AS (
    SELECT
        o.order_id,
        SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY o.order_id
)
SELECT
    ROUND(AVG(order_total), 2) AS average_order_value
FROM order_totals;

---------------------------------------------------------
-- 6. Orders above average order value
---------------------------------------------------------
WITH order_totals AS (
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY o.order_id, o.customer_id
),
average_order_value AS (
    SELECT
        AVG(order_total) AS avg_order_total
    FROM order_totals
)
SELECT
    ot.order_id,
    ot.customer_id,
    ot.order_total,
    ROUND(aov.avg_order_total, 2) AS avg_order_total
FROM order_totals ot
CROSS JOIN average_order_value aov
WHERE ot.order_total > aov.avg_order_total
ORDER BY ot.order_total DESC;

---------------------------------------------------------
-- 7. Revenue by category with an intermediate calculation
---------------------------------------------------------
WITH category_revenue AS (
    SELECT
        cat.category_name,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM categories cat
    JOIN products p
        ON cat.category_id = p.category_id
    JOIN order_items oi
        ON p.product_id = oi.product_id
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.status = 'completed'
    GROUP BY cat.category_name
)
SELECT
    category_name,
    revenue
FROM category_revenue
ORDER BY revenue DESC;

---------------------------------------------------------
-- 8. Identify repeat customers
-- Here: customers with at least 2 orders
---------------------------------------------------------
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_orders
FROM customer_orders
WHERE total_orders >= 2
ORDER BY total_orders DESC, customer_id;