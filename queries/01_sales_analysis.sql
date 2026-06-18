-- ============================================================
-- 01: Sales Analysis
-- Author: Vishwajeet Soni
-- ============================================================

-- Q1. Total Revenue (delivered orders only)
SELECT
    SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'delivered';

-- Q2. Monthly Revenue Trend
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(order_id)                  AS total_orders,
    SUM(total_amount)                AS monthly_revenue,
    ROUND(AVG(total_amount), 2)      AS avg_order_value
FROM orders
WHERE status NOT IN ('cancelled', 'returned')
GROUP BY month
ORDER BY month;

-- Q3. Revenue by State
SELECT
    state,
    COUNT(order_id)        AS orders,
    SUM(total_amount)      AS revenue,
    ROUND(AVG(total_amount),2) AS aov
FROM orders
WHERE status NOT IN ('cancelled','returned')
GROUP BY state
ORDER BY revenue DESC;

-- Q4. Day-of-Week Sales Pattern
SELECT
    DAYNAME(order_date)    AS day_name,
    COUNT(order_id)        AS orders,
    SUM(total_amount)      AS revenue
FROM orders
WHERE status NOT IN ('cancelled','returned')
GROUP BY DAYOFWEEK(order_date), day_name
ORDER BY DAYOFWEEK(order_date);

-- Q5. Cancellation & Return Rate
SELECT
    status,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM orders
GROUP BY status
ORDER BY count DESC;

-- Q6. Average Order Value (AOV) Overall
SELECT
    ROUND(SUM(total_amount) / COUNT(order_id), 2) AS aov
FROM orders
WHERE status NOT IN ('cancelled','returned');
