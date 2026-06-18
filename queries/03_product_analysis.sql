-- ============================================================
-- 03: Product Analysis
-- Author: Vishwajeet Soni
-- ============================================================

-- Q1. Top 10 Best-Selling Products by Revenue
SELECT
    p.product_id,
    p.product_name,
    cat.category_name,
    SUM(oi.quantity)                          AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS revenue
FROM order_items oi
JOIN products p   ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
JOIN orders o     ON oi.order_id = o.order_id
WHERE o.status NOT IN ('cancelled','returned')
GROUP BY p.product_id, p.product_name, cat.category_name
ORDER BY revenue DESC
LIMIT 10;

-- Q2. Category-Wise Revenue Share
SELECT
    cat.category_name,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS revenue,
    ROUND(
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)) * 100.0
        / SUM(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100))) OVER(), 2
    ) AS revenue_pct
FROM order_items oi
JOIN products p     ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
JOIN orders o       ON oi.order_id = o.order_id
WHERE o.status NOT IN ('cancelled','returned')
GROUP BY cat.category_name
ORDER BY revenue DESC;

-- Q3. Profit Margin by Product
SELECT
    p.product_name,
    p.price,
    p.cost_price,
    ROUND(p.price - p.cost_price, 2)              AS gross_profit,
    ROUND((p.price - p.cost_price) / p.price * 100, 2) AS margin_pct
FROM products p
ORDER BY margin_pct DESC;

-- Q4. Low Stock Alert (stock < 100 units)
SELECT
    product_id,
    product_name,
    stock_qty
FROM products
WHERE stock_qty < 100
ORDER BY stock_qty ASC;

-- Q5. Products Never Ordered (Dead Inventory)
SELECT
    p.product_id,
    p.product_name,
    p.stock_qty
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- Q6. Product Rank by Revenue (Window Function)
SELECT
    p.product_name,
    cat.category_name,
    ROUND(SUM(oi.quantity * oi.unit_price),2) AS revenue,
    RANK() OVER (PARTITION BY cat.category_name
                 ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS rank_in_category
FROM order_items oi
JOIN products p     ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
JOIN orders o       ON oi.order_id = o.order_id
WHERE o.status NOT IN ('cancelled','returned')
GROUP BY p.product_name, cat.category_name;
