/*
=========================================================
File: 10_data_quality_checks.sql

Objective:
Demonstrate common SQL data quality checks used before
performing business analysis.

Concepts covered:
- NULL detection
- Duplicate detection
- Invalid values
- Referential integrity
- Date consistency
- Price consistency
- Orphan records
- Data completeness

These checks help ensure that analytical results are based
on reliable and consistent data.
=========================================================
*/


---------------------------------------------------------
-- 1. Find customers with missing critical information
--
-- Business Question:
-- Are there customers with incomplete identity or
-- contact information?
--
-- SQL Concept:
-- NULL and empty string checks
---------------------------------------------------------
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    country
FROM customers
WHERE first_name IS NULL
   OR TRIM(first_name) = ''
   OR last_name IS NULL
   OR TRIM(last_name) = ''
   OR email IS NULL
   OR TRIM(email) = ''
   OR country IS NULL
   OR TRIM(country) = '';

---------------------------------------------------------
-- 2. Find potential duplicate customers
--
-- Business Question:
-- Are there customer records that may represent the
-- same person?
--
-- SQL Concept:
-- GROUP BY + HAVING
---------------------------------------------------------
SELECT
    first_name,
    last_name,
    country,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY
    first_name,
    last_name,
    country
HAVING COUNT(*) > 1;


---------------------------------------------------------
-- 3. Find products with invalid prices
--
-- Business Question:
-- Are there products with zero or negative selling prices?
--
-- SQL Concept:
-- Validation rule
---------------------------------------------------------
SELECT
    product_id,
    product_name,
    unit_price
FROM products
WHERE unit_price <= 0;


---------------------------------------------------------
-- 4. Find products with cost greater than selling price
--
-- Business Question:
-- Are there products that may generate a negative gross
-- margin?
--
-- SQL Concept:
-- Column comparison
---------------------------------------------------------
SELECT
    product_id,
    product_name,
    unit_price,
    cost_price
FROM products
WHERE cost_price > unit_price;


---------------------------------------------------------
-- 5. Find order items with invalid quantities
--
-- Business Question:
-- Are there order lines with zero or negative quantities?
--
-- SQL Concept:
-- Validation rule
---------------------------------------------------------
SELECT
    order_item_id,
    order_id,
    product_id,
    quantity
FROM order_items
WHERE quantity <= 0;


---------------------------------------------------------
-- 6. Find orders referencing missing customers
--
-- Business Question:
-- Are there orders linked to customer IDs that do not
-- exist in the customers table?
--
-- SQL Concept:
-- Referential integrity check with LEFT JOIN
---------------------------------------------------------
SELECT
    o.order_id,
    o.customer_id
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


---------------------------------------------------------
-- 7. Find order items referencing missing products
--
-- Business Question:
-- Are there order items linked to products that do not
-- exist in the products table?
--
-- SQL Concept:
-- Referential integrity check with LEFT JOIN
---------------------------------------------------------
SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


---------------------------------------------------------
-- 8. Find order items referencing missing orders
--
-- Business Question:
-- Are there order items linked to orders that do not
-- exist?
--
-- SQL Concept:
-- Orphan record detection
---------------------------------------------------------
SELECT
    oi.order_item_id,
    oi.order_id
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


---------------------------------------------------------
-- 9. Find orders dated before customer signup
--
-- Business Question:
-- Are there orders recorded before the customer actually
-- registered?
--
-- SQL Concept:
-- Date consistency check
---------------------------------------------------------
SELECT
    o.order_id,
    o.customer_id,
    c.signup_date,
    o.order_date
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.order_date < c.signup_date;


---------------------------------------------------------
-- 10. Compare stored order item price with product price
--
-- Business Question:
-- Are there order lines where the charged price differs
-- from the current product price and requires investigation?
--
-- SQL Concept:
-- Cross-table consistency check
---------------------------------------------------------
SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    oi.unit_price AS charged_price,
    p.unit_price AS current_product_price
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
WHERE oi.unit_price <> p.unit_price;


---------------------------------------------------------
-- 11. Find completed orders with no payment
--
-- Business Question:
-- Are there completed orders without a corresponding
-- payment record?
--
-- SQL Concept:
-- NOT EXISTS
---------------------------------------------------------
SELECT
    o.order_id,
    o.customer_id,
    o.order_date
FROM orders o
WHERE o.status = 'completed'
  AND NOT EXISTS (
      SELECT 1
      FROM payments p
      WHERE p.order_id = o.order_id
  );


---------------------------------------------------------
-- 12. Find payments for non-completed orders
--
-- Business Question:
-- Are there payments associated with pending or cancelled
-- orders?
--
-- SQL Concept:
-- JOIN + business rule validation
---------------------------------------------------------
SELECT
    p.payment_id,
    p.order_id,
    o.status,
    p.amount
FROM payments p
JOIN orders o
    ON p.order_id = o.order_id
WHERE o.status <> 'completed';


---------------------------------------------------------
-- 13. Find payments with invalid amounts
--
-- Business Question:
-- Are there payments with zero or negative amounts?
--
-- SQL Concept:
-- Validation rule
---------------------------------------------------------
SELECT
    payment_id,
    order_id,
    amount
FROM payments
WHERE amount <= 0;


---------------------------------------------------------
-- 14. Compare payment amount with calculated order value
--
-- Business Question:
-- Does the payment amount match the calculated value of
-- the completed order?
--
-- SQL Concept:
-- CTE + aggregation + consistency check
---------------------------------------------------------
WITH order_totals AS (
    SELECT
        o.order_id,
        SUM(oi.quantity * oi.unit_price) AS calculated_order_total
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY o.order_id
),
payment_totals AS (
    SELECT
        order_id,
        SUM(amount) AS total_paid
    FROM payments
    GROUP BY order_id
)
SELECT
    ot.order_id,
    ot.calculated_order_total,
    pt.total_paid,
    ot.calculated_order_total - pt.total_paid AS difference
FROM order_totals ot
JOIN payment_totals pt
    ON ot.order_id = pt.order_id
WHERE ot.calculated_order_total <> pt.total_paid
ORDER BY ABS(ot.calculated_order_total - pt.total_paid) DESC;