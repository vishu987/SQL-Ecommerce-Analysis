# 🛒 SQL E-Commerce Database Analysis

> **Author:** Vishwajeet Soni | Data & AI Professional | Delhi, India  
> **Tools:** SQL (MySQL / PostgreSQL compatible) | Business Intelligence

A structured SQL project covering real-world e-commerce business questions — from sales performance and customer segmentation to product analysis and funnel metrics.

---

## 📁 Project Structure

```
SQL-Ecommerce-Analysis/
├── schema/
│   └── ecommerce_schema.sql       # Database schema & sample data
├── queries/
│   ├── 01_sales_analysis.sql      # Revenue, orders, trends
│   ├── 02_customer_analysis.sql   # Segmentation, LTV, retention
│   ├── 03_product_analysis.sql    # Top products, category performance
│   ├── 04_funnel_analysis.sql     # Cart abandonment, conversion
│   └── 05_advanced_queries.sql    # Window functions, CTEs, subqueries
└── README.md
```

---

## 🗄️ Database Schema

| Table | Description |
|---|---|
| `customers` | Customer master data |
| `orders` | Order headers with status & dates |
| `order_items` | Line items per order |
| `products` | Product catalog |
| `categories` | Product categories |
| `payments` | Payment transactions |

---

## 📊 Business Questions Answered

### Sales Analysis
- Monthly & yearly revenue trends
- Average Order Value (AOV)
- Revenue by region / city
- Day-of-week sales patterns

### Customer Analysis
- Customer Lifetime Value (CLV)
- RFM Segmentation (Recency, Frequency, Monetary)
- New vs returning customer ratio
- Churn identification

### Product Analysis
- Top 10 best-selling products
- Category-wise revenue share
- Low-stock / dead inventory
- Cross-sell pairs (frequently bought together)

### Funnel Analysis
- Cart abandonment rate
- Order conversion rate
- Payment failure analysis

### Advanced SQL
- Running totals with Window Functions
- Year-over-Year (YoY) growth using LAG()
- Cohort analysis with CTEs
- Rank-based product leaderboard

---

## ⚙️ How to Run

```sql
-- Step 1: Create schema and load sample data
SOURCE schema/ecommerce_schema.sql;

-- Step 2: Run any query file
SOURCE queries/01_sales_analysis.sql;
```

Compatible with **MySQL 8+** and **PostgreSQL 13+**.

---

## 👤 Author

**Vishwajeet Soni**  
MA Economics, Delhi University | IIT-K Certified Data Analyst  
[GitHub](https://github.com/vishu987)
