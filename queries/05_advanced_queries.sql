-- ============================================================
-- 05: Advanced SQL — Window Functions, CTEs, Subqueries
-- Author: Vishwajeet Soni
-- ============================================================

-- Q1. Running Total of Revenue by Month
SELECT
    DATE_FORMAT(order_date,'%Y-%m')      AS month,
    SUM(total_amount)                    AS monthly_revenue,
    SUM(SUM(total_amount))
        OVER (ORDER BY DATE_FORMAT(order_date,'%Y-%m')
              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
                                         AS running_total
FROM orders
WHERE status NOT IN ('cancelled','returned')
GROUP BY month
ORDER BY month;

-- Q2. Month-over-Month (MoM) Revenue Growth using LAG()
WITH monthly AS (
    SELECT
        DATE_FORMAT(order_date,'%Y-%m') AS month,
        SUM(total_amount)               AS revenue
    FROM orders
    WHERE status NOT IN ('cancelled','returned')
    GROUP BY month
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month)  AS prev_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month))
        / NULLIF(LAG(revenue) OVER (ORDER BY month), 0) * 100, 2
    )                                   AS mom_growth_pct
FROM monthly
ORDER BY month;

-- Q3. Customer Cohort Analysis (by signup month)
WITH cohort AS (
    SELECT
        c.customer_id,
        DATE_FORMAT(c.created_at,'%Y-%m')   AS cohort_month,
        DATE_FORMAT(o.order_date,'%Y-%m')   AS order_month
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.status NOT IN ('cancelled','returned')
)
SELECT
    cohort_month,
    order_month,
    COUNT(DISTINCT customer_id) AS active_customers
FROM cohort
GROUP BY cohort_month, order_month
ORDER BY cohort_month, order_month;

-- Q4. Top Product per Category (using RANK)
WITH ranked AS (
    SELECT
        cat.category_name,
        p.product_name,
        ROUND(SUM(oi.quantity * oi.unit_price),2) AS revenue,
        RANK() OVER (
            PARTITION BY cat.category_name
            ORDER BY SUM(oi.quantity * oi.unit_price) DESC
        ) AS rnk
    FROM order_items oi
    JOIN products p     ON oi.product_id = p.product_id
    JOIN categories cat ON p.category_id = cat.category_id
    JOIN orders o       ON oi.order_id = o.order_id
    WHERE o.status NOT IN ('cancelled','returned')
    GROUP BY cat.category_name, p.product_name
)
SELECT category_name, product_name, revenue
FROM ranked
WHERE rnk = 1
ORDER BY revenue DESC;

-- Q5. Customers Who Ordered in Consecutive Months
WITH monthly_orders AS (
    SELECT
        customer_id,
        DATE_FORMAT(order_date,'%Y-%m')           AS order_month,
        LAG(DATE_FORMAT(order_date,'%Y-%m'))
            OVER (PARTITION BY customer_id
                  ORDER BY order_date)            AS prev_order_month
    FROM orders
    WHERE status NOT IN ('cancelled','returned')
)
SELECT DISTINCT customer_id
FROM monthly_orders
WHERE order_month = DATE_FORMAT(
          DATE_ADD(STR_TO_DATE(CONCAT(prev_order_month,'-01'),'%Y-%m-%d'),
                   INTERVAL 1 MONTH), '%Y-%m');

-- Q6. Percentile Buckets for Order Value (NTILE)
SELECT
    order_id,
    total_amount,
    NTILE(4) OVER (ORDER BY total_amount DESC) AS quartile
FROM orders
WHERE status NOT IN ('cancelled','returned')
ORDER BY total_amount DESC;
