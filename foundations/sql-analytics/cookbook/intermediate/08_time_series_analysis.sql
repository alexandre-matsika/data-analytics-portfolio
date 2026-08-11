/*
=========================================================
File: 08_time_series_analysis.sql

Objective:
Demonstrate how to analyze business metrics over time
using SQL.

Concepts covered:
- DATE_TRUNC()
- EXTRACT()
- Monthly aggregations
- Running totals
- LAG()
- Month-over-month growth
- Moving averages
- Time-based comparisons

Time series analysis helps identify trends, changes,
growth patterns, and business performance over time.
=========================================================
*/


---------------------------------------------------------
-- 1. Monthly revenue
--
-- Business Question:
-- How does completed-order revenue evolve month by month?
--
-- SQL Concept:
-- DATE_TRUNC() + GROUP BY
---------------------------------------------------------
SELECT
    DATE_TRUNC('month', o.order_date)::date AS order_month,
    SUM(oi.quantity * oi.unit_price) AS monthly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY order_month;


---------------------------------------------------------
-- 2. Monthly number of completed orders
--
-- Business Question:
-- How many completed orders are placed each month?
--
-- SQL Concept:
-- Monthly aggregation with COUNT()
---------------------------------------------------------
SELECT
    DATE_TRUNC('month', order_date)::date AS order_month,
    COUNT(order_id) AS total_orders
FROM orders
WHERE status = 'completed'
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY order_month;


---------------------------------------------------------
-- 3. Monthly number of active customers
--
-- Business Question:
-- How many unique customers purchase each month?
--
-- SQL Concept:
-- COUNT(DISTINCT ...)
---------------------------------------------------------
SELECT
    DATE_TRUNC('month', order_date)::date AS order_month,
    COUNT(DISTINCT customer_id) AS active_customers
FROM orders
WHERE status = 'completed'
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY order_month;


---------------------------------------------------------
-- 4. Average order value by month
--
-- Business Question:
-- How does the average value of completed orders evolve
-- over time?
--
-- SQL Concept:
-- CTE + monthly aggregation
---------------------------------------------------------
WITH order_totals AS (
    SELECT
        o.order_id,
        o.order_date,
        SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY o.order_id, o.order_date
)
SELECT
    DATE_TRUNC('month', order_date)::date AS order_month,
    ROUND(AVG(order_total), 2) AS average_order_value
FROM order_totals
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY order_month;


---------------------------------------------------------
-- 5. Cumulative revenue over time
--
-- Business Question:
-- How does total revenue accumulate month after month?
--
-- SQL Concept:
-- SUM() as a window function
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
-- 6. Revenue change compared with the previous month
--
-- Business Question:
-- How much did revenue increase or decrease compared
-- with the previous month?
--
-- SQL Concept:
-- LAG()
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
    LAG(revenue) OVER (
        ORDER BY order_month
    ) AS previous_month_revenue,
    revenue
        - LAG(revenue) OVER (ORDER BY order_month)
        AS revenue_change
FROM monthly_revenue
ORDER BY order_month;


---------------------------------------------------------
-- 7. Month-over-month revenue growth rate
--
-- Business Question:
-- What is the monthly percentage growth or decline
-- in revenue?
--
-- SQL Concept:
-- LAG() + percentage calculation
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
),
revenue_comparison AS (
    SELECT
        order_month,
        revenue,
        LAG(revenue) OVER (
            ORDER BY order_month
        ) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    order_month,
    revenue,
    previous_month_revenue,
    ROUND(
        (
            (revenue - previous_month_revenue)
            / NULLIF(previous_month_revenue, 0)
        ) * 100,
        2
    ) AS month_over_month_growth_pct
FROM revenue_comparison
ORDER BY order_month;


---------------------------------------------------------
-- 8. Three-month moving average of revenue
--
-- Business Question:
-- What is the short-term revenue trend after smoothing
-- monthly fluctuations?
--
-- SQL Concept:
-- Moving average with a window frame
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
    ROUND(
        AVG(revenue) OVER (
            ORDER BY order_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS three_month_moving_average
FROM monthly_revenue
ORDER BY order_month;


---------------------------------------------------------
-- 9. Revenue by year and month
--
-- Business Question:
-- How can revenue be broken down by calendar year
-- and month?
--
-- SQL Concept:
-- EXTRACT()
---------------------------------------------------------
SELECT
    EXTRACT(YEAR FROM o.order_date) AS order_year,
    EXTRACT(MONTH FROM o.order_date) AS order_month,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY
    EXTRACT(YEAR FROM o.order_date),
    EXTRACT(MONTH FROM o.order_date)
ORDER BY order_year, order_month;


---------------------------------------------------------
-- 10. Monthly revenue by product category
--
-- Business Question:
-- How does the revenue generated by each product
-- category evolve over time?
--
-- SQL Concept:
-- Time aggregation + multi-table JOIN + GROUP BY
---------------------------------------------------------
SELECT
    DATE_TRUNC('month', o.order_date)::date AS order_month,
    cat.category_name,
    SUM(oi.quantity * oi.unit_price) AS category_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
JOIN categories cat
    ON p.category_id = cat.category_id
WHERE o.status = 'completed'
GROUP BY
    DATE_TRUNC('month', o.order_date),
    cat.category_name
ORDER BY order_month, category_revenue DESC;