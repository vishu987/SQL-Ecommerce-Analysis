-- ============================================================
-- 04: Funnel & Payment Analysis
-- Author: Vishwajeet Soni
-- ============================================================

-- Q1. Payment Method Distribution
SELECT
    method,
    COUNT(*)                                              AS transactions,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2)   AS pct_share,
    SUM(amount)                                           AS total_amount
FROM payments
WHERE status = 'success'
GROUP BY method
ORDER BY transactions DESC;

-- Q2. Payment Failure Rate by Method
SELECT
    method,
    COUNT(*)                                                   AS total_attempts,
    SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END)         AS failures,
    ROUND(
        SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS failure_rate_pct
FROM payments
GROUP BY method
ORDER BY failure_rate_pct DESC;

-- Q3. Order Status Funnel
SELECT
    status,
    COUNT(*)                                               AS orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2)    AS pct
FROM orders
GROUP BY status
ORDER BY
    FIELD(status,'pending','confirmed','shipped','delivered','cancelled','returned');

-- Q4. Revenue Lost to Cancellations & Returns
SELECT
    status,
    COUNT(*)          AS orders,
    SUM(total_amount) AS revenue_lost
FROM orders
WHERE status IN ('cancelled','returned')
GROUP BY status;

-- Q5. Average Days to Delivery (order_date → payment_date as proxy)
SELECT
    ROUND(AVG(DATEDIFF(p.payment_date, o.order_date)), 1) AS avg_days_to_payment
FROM orders o
JOIN payments p ON o.order_id = p.order_id
WHERE o.status = 'delivered'
  AND p.status = 'success';
