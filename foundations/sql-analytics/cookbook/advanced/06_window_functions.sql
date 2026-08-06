/*
=========================================================
File: 06_window_functions.sql
Objective:
Demonstrate how to use SQL window functions for analytics:
- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- SUM() OVER()
- AVG() OVER()
- LAG()
- LEAD()
Window functions help compare rows without collapsing
the result set like a GROUP BY query.
=========================================================
*/

---------------------------------------------------------
-- 1. Rank customers by total revenue
-- ROW_NUMBER assigns a unique sequential rank
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
    total_revenue,
    ROW_NUMBER() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM customer_revenue
ORDER BY revenue_rank;

---------------------------------------------------------
-- 2. Rank products by revenue within each category
-- RANK allows ties and may skip rank numbers
---------------------------------------------------------
WITH product_revenue AS (
    SELECT
        cat.category_name,
        p.product_id,
        p.product_name,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM categories cat
    JOIN products p
        ON cat.category_id = p.category_id
    JOIN order_items oi
        ON p.product_id = oi.product_id
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.status = 'completed'
    GROUP BY cat.category_name, p.product_id, p.product_name
)
SELECT
    category_name,
    product_id,
    product_name,
    total_revenue,
    RANK() OVER (
        PARTITION BY category_name
        ORDER BY total_revenue DESC
    ) AS revenue_rank_in_category
FROM product_revenue
ORDER BY category_name, revenue_rank_in_category, product_name;

---------------------------------------------------------
-- 3. Dense rank customers by number of orders
-- DENSE_RANK does not skip rank numbers when ties exist
---------------------------------------------------------
WITH customer_orders AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT
    customer_id,
    first_name,
    last_name,
    total_orders,
    DENSE_RANK() OVER (ORDER BY total_orders DESC) AS order_rank
FROM customer_orders
ORDER BY order_rank, customer_id;

---------------------------------------------------------
-- 4. Compute running monthly revenue
-- SUM() OVER helps calculate cumulative revenue over time
---------------------------------------------------------
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_date)::date AS order_month,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY DATE_TRUNC('month', o.order_date)
)
SELECT
    order_month,
    revenue,
    SUM(revenue) OVER (
        ORDER BY order_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM monthly_revenue
ORDER BY order_month;

---------------------------------------------------------
-- 5. Compare each product price to the average price
-- within its category
---------------------------------------------------------
SELECT
    cat.category_name,
    p.product_id,
    p.product_name,
    p.unit_price,
    ROUND(
        AVG(p.unit_price) OVER (PARTITION BY cat.category_name),
        2
    ) AS avg_category_price,
    ROUND(
        p.unit_price
        - AVG(p.unit_price) OVER (PARTITION BY cat.category_name),
        2
    ) AS difference_vs_category_avg
FROM products p
JOIN categories cat
    ON p.category_id = cat.category_id
ORDER BY cat.category_name, p.unit_price DESC;

---------------------------------------------------------
-- 6. Show previous month revenue using LAG()
---------------------------------------------------------
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_date)::date AS order_month,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY DATE_TRUNC('month', o.order_date)
)
SELECT
    order_month,
    revenue,
    LAG(revenue) OVER (ORDER BY order_month) AS previous_month_revenue,
    revenue - LAG(revenue) OVER (ORDER BY order_month) AS revenue_change
FROM monthly_revenue
ORDER BY order_month;

---------------------------------------------------------
-- 7. Show next month revenue using LEAD()
---------------------------------------------------------
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_date)::date AS order_month,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY DATE_TRUNC('month', o.order_date)
)
SELECT
    order_month,
    revenue,
    LEAD(revenue) OVER (ORDER BY order_month) AS next_month_revenue
FROM monthly_revenue
ORDER BY order_month;

---------------------------------------------------------
-- 8. Identify the first order of each customer
-- ROW_NUMBER helps isolate one row per customer
---------------------------------------------------------
WITH customer_orders AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_date,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id
            ORDER BY o.order_date
        ) AS order_sequence
    FROM orders o
)
SELECT
    order_id,
    customer_id,
    order_date
FROM customer_orders
WHERE order_sequence = 1
ORDER BY customer_id;

---------------------------------------------------------
-- 9. Rank orders by value for each customer
---------------------------------------------------------
WITH order_totals AS (
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.order_id, o.customer_id
)
SELECT
    order_id,
    customer_id,
    order_total,
    RANK() OVER (
        PARTITION BY customer_id
        ORDER BY order_total DESC
    ) AS order_rank_for_customer
FROM order_totals
ORDER BY customer_id, order_rank_for_customer, order_id;

---------------------------------------------------------
-- 10. Compare each order total to the average order total
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
    order_id,
    order_total,
    ROUND(AVG(order_total) OVER (), 2) AS average_order_total,
    ROUND(order_total - AVG(order_total) OVER (), 2) AS difference_vs_average
FROM order_totals
ORDER BY order_total DESC;