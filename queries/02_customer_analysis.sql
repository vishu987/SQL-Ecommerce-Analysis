-- ============================================================
-- 02: Customer Analysis
-- Author: Vishwajeet Soni
-- ============================================================

-- Q1. Total Customers & New Customers per Month
SELECT
    DATE_FORMAT(created_at, '%Y-%m') AS signup_month,
    COUNT(customer_id)               AS new_customers
FROM customers
GROUP BY signup_month
ORDER BY signup_month;

-- Q2. Top 5 Customers by Revenue
SELECT
    c.customer_id,
    c.full_name,
    c.city,
    COUNT(o.order_id)       AS total_orders,
    SUM(o.total_amount)     AS total_spent,
    ROUND(AVG(o.total_amount),2) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status NOT IN ('cancelled','returned')
GROUP BY c.customer_id, c.full_name, c.city
ORDER BY total_spent DESC
LIMIT 5;

-- Q3. RFM Segmentation (Recency, Frequency, Monetary)
WITH rfm_base AS (
    SELECT
        c.customer_id,
        c.full_name,
        DATEDIFF(CURDATE(), MAX(o.order_date))  AS recency_days,
        COUNT(o.order_id)                        AS frequency,
        SUM(o.total_amount)                      AS monetary
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.status NOT IN ('cancelled','returned')
    GROUP BY c.customer_id, c.full_name
)
SELECT
    customer_id,
    full_name,
    recency_days,
    frequency,
    monetary,
    CASE
        WHEN recency_days <= 30  AND frequency >= 2 AND monetary >= 10000 THEN 'Champions'
        WHEN recency_days <= 60  AND frequency >= 2                        THEN 'Loyal Customers'
        WHEN recency_days <= 90                                            THEN 'Potential Loyalists'
        WHEN recency_days > 180                                            THEN 'At Risk'
        ELSE 'Needs Attention'
    END AS rfm_segment
FROM rfm_base
ORDER BY monetary DESC;

-- Q4. Repeat vs One-Time Customers
SELECT
    CASE WHEN order_count = 1 THEN 'One-Time' ELSE 'Repeat' END AS customer_type,
    COUNT(*) AS customers
FROM (
    SELECT customer_id, COUNT(order_id) AS order_count
    FROM orders
    WHERE status NOT IN ('cancelled','returned')
    GROUP BY customer_id
) t
GROUP BY customer_type;

-- Q5. Customer Lifetime Value (simple CLV = total revenue per customer)
SELECT
    c.customer_id,
    c.full_name,
    ROUND(SUM(o.total_amount), 2)                    AS clv,
    DATEDIFF(CURDATE(), MIN(o.order_date))            AS customer_age_days,
    ROUND(SUM(o.total_amount) /
          NULLIF(DATEDIFF(CURDATE(), MIN(o.order_date)),0) * 365, 2) AS annual_clv
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status NOT IN ('cancelled','returned')
GROUP BY c.customer_id, c.full_name
ORDER BY clv DESC;
