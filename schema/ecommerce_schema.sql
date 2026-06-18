-- ============================================================
-- E-Commerce Database Schema
-- Author: Vishwajeet Soni
-- Compatible: MySQL 8+ / PostgreSQL 13+
-- ============================================================

-- Drop tables if exist (for clean re-run)
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;

-- 1. Customers
CREATE TABLE customers (
    customer_id   INT PRIMARY KEY AUTO_INCREMENT,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(150) UNIQUE NOT NULL,
    phone         VARCHAR(20),
    city          VARCHAR(80),
    state         VARCHAR(80),
    country       VARCHAR(60) DEFAULT 'India',
    created_at    DATE NOT NULL
);

-- 2. Categories
CREATE TABLE categories (
    category_id   INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(80) NOT NULL,
    parent_id     INT DEFAULT NULL
);

-- 3. Products
CREATE TABLE products (
    product_id    INT PRIMARY KEY AUTO_INCREMENT,
    product_name  VARCHAR(200) NOT NULL,
    category_id   INT,
    price         DECIMAL(10,2) NOT NULL,
    cost_price    DECIMAL(10,2),
    stock_qty     INT DEFAULT 0,
    created_at    DATE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- 4. Orders
CREATE TABLE orders (
    order_id      INT PRIMARY KEY AUTO_INCREMENT,
    customer_id   INT NOT NULL,
    order_date    DATE NOT NULL,
    status        ENUM('pending','confirmed','shipped','delivered','cancelled','returned') DEFAULT 'pending',
    city          VARCHAR(80),
    state         VARCHAR(80),
    total_amount  DECIMAL(12,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 5. Order Items
CREATE TABLE order_items (
    item_id       INT PRIMARY KEY AUTO_INCREMENT,
    order_id      INT NOT NULL,
    product_id    INT NOT NULL,
    quantity      INT NOT NULL DEFAULT 1,
    unit_price    DECIMAL(10,2) NOT NULL,
    discount_pct  DECIMAL(5,2)  DEFAULT 0.00,
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 6. Payments
CREATE TABLE payments (
    payment_id    INT PRIMARY KEY AUTO_INCREMENT,
    order_id      INT NOT NULL,
    payment_date  DATE,
    method        ENUM('UPI','Credit Card','Debit Card','Net Banking','COD','Wallet') NOT NULL,
    amount        DECIMAL(12,2) NOT NULL,
    status        ENUM('success','failed','pending','refunded') DEFAULT 'pending',
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- ============================================================
-- Sample Data
-- ============================================================

INSERT INTO customers (full_name, email, phone, city, state, country, created_at) VALUES
('Aarav Sharma',    'aarav.sharma@email.com',   '9810001001', 'Delhi',     'Delhi',         'India', '2023-01-15'),
('Priya Singh',     'priya.singh@email.com',    '9810001002', 'Mumbai',    'Maharashtra',   'India', '2023-02-20'),
('Rohit Verma',     'rohit.verma@email.com',    '9810001003', 'Bangalore', 'Karnataka',     'India', '2023-03-10'),
('Sneha Patel',     'sneha.patel@email.com',    '9810001004', 'Ahmedabad', 'Gujarat',       'India', '2023-04-05'),
('Karan Mehta',     'karan.mehta@email.com',    '9810001005', 'Jaipur',    'Rajasthan',     'India', '2023-05-18'),
('Neha Gupta',      'neha.gupta@email.com',     '9810001006', 'Hyderabad', 'Telangana',     'India', '2023-06-22'),
('Amit Kumar',      'amit.kumar@email.com',     '9810001007', 'Chennai',   'Tamil Nadu',    'India', '2023-07-30'),
('Pooja Joshi',     'pooja.joshi@email.com',    '9810001008', 'Pune',      'Maharashtra',   'India', '2023-08-14'),
('Vikas Yadav',     'vikas.yadav@email.com',    '9810001009', 'Lucknow',   'Uttar Pradesh', 'India', '2023-09-09'),
('Ritika Nair',     'ritika.nair@email.com',    '9810001010', 'Kochi',     'Kerala',        'India', '2023-10-01');

INSERT INTO categories (category_name, parent_id) VALUES
('Electronics',   NULL),
('Mobiles',       1),
('Laptops',       1),
('Fashion',       NULL),
('Men Clothing',  4),
('Women Clothing',4),
('Home & Kitchen',NULL),
('Appliances',    7),
('Books',         NULL),
('Sports',        NULL);

INSERT INTO products (product_name, category_id, price, cost_price, stock_qty, created_at) VALUES
('Samsung Galaxy S24',     2,  72999.00, 55000.00, 120, '2023-01-01'),
('iPhone 15',              2,  89999.00, 68000.00,  80, '2023-01-01'),
('Dell Inspiron 15',       3,  55999.00, 42000.00,  60, '2023-01-01'),
('HP Pavilion 14',         3,  49999.00, 38000.00,  45, '2023-01-01'),
('Men Casual T-Shirt',     5,    799.00,   300.00, 500, '2023-02-01'),
('Women Kurti Set',        6,   1299.00,   500.00, 350, '2023-02-01'),
('Prestige Pressure Cooker',8,  2499.00,  1200.00, 200, '2023-03-01'),
('Philips Air Fryer',      8,   7999.00,  5000.00,  90, '2023-03-01'),
('Atomic Habits (Book)',   9,    399.00,   150.00, 800, '2023-04-01'),
('Yoga Mat',              10,    999.00,   400.00, 300, '2023-04-01');

INSERT INTO orders (customer_id, order_date, status, city, state, total_amount) VALUES
(1,  '2024-01-10', 'delivered',  'Delhi',     'Delhi',         72999.00),
(2,  '2024-01-15', 'delivered',  'Mumbai',    'Maharashtra',   89999.00),
(3,  '2024-02-05', 'delivered',  'Bangalore', 'Karnataka',     55999.00),
(4,  '2024-02-20', 'shipped',    'Ahmedabad', 'Gujarat',        3598.00),
(5,  '2024-03-01', 'delivered',  'Jaipur',    'Rajasthan',      2499.00),
(6,  '2024-03-15', 'cancelled',  'Hyderabad', 'Telangana',     49999.00),
(7,  '2024-04-02', 'delivered',  'Chennai',   'Tamil Nadu',     7999.00),
(8,  '2024-04-18', 'delivered',  'Pune',      'Maharashtra',     399.00),
(9,  '2024-05-10', 'returned',   'Lucknow',   'Uttar Pradesh',  1299.00),
(10, '2024-05-25', 'delivered',  'Kochi',     'Kerala',          999.00),
(1,  '2024-06-03', 'delivered',  'Delhi',     'Delhi',           799.00),
(2,  '2024-06-20', 'delivered',  'Mumbai',    'Maharashtra',    2499.00),
(3,  '2024-07-08', 'shipped',    'Bangalore', 'Karnataka',     89999.00),
(5,  '2024-07-22', 'delivered',  'Jaipur',    'Rajasthan',       999.00),
(7,  '2024-08-05', 'delivered',  'Chennai',   'Tamil Nadu',      399.00);

INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_pct) VALUES
(1,  1, 1, 72999.00, 0.00),
(2,  2, 1, 89999.00, 0.00),
(3,  3, 1, 55999.00, 5.00),
(4,  5, 2,   799.00, 0.00),
(4,  6, 2,  1000.00, 0.00),
(5,  7, 1,  2499.00, 0.00),
(6,  4, 1, 49999.00, 0.00),
(7,  8, 1,  7999.00, 0.00),
(8,  9, 1,   399.00, 0.00),
(9,  6, 1,  1299.00, 0.00),
(10,10, 1,   999.00, 0.00),
(11, 5, 1,   799.00, 0.00),
(12, 7, 1,  2499.00, 0.00),
(13, 2, 1, 89999.00, 0.00),
(14,10, 1,   999.00, 0.00),
(15, 9, 1,   399.00, 0.00);

INSERT INTO payments (order_id, payment_date, method, amount, status) VALUES
(1,  '2024-01-10', 'Credit Card', 72999.00, 'success'),
(2,  '2024-01-15', 'UPI',         89999.00, 'success'),
(3,  '2024-02-05', 'Net Banking', 55999.00, 'success'),
(4,  '2024-02-20', 'UPI',          3598.00, 'success'),
(5,  '2024-03-01', 'COD',          2499.00, 'success'),
(6,  '2024-03-15', 'Debit Card',  49999.00, 'failed'),
(7,  '2024-04-02', 'UPI',          7999.00, 'success'),
(8,  '2024-04-18', 'Wallet',        399.00, 'success'),
(9,  '2024-05-10', 'COD',          1299.00, 'refunded'),
(10, '2024-05-25', 'UPI',           999.00, 'success'),
(11, '2024-06-03', 'UPI',           799.00, 'success'),
(12, '2024-06-20', 'Credit Card',  2499.00, 'success'),
(13, '2024-07-08', 'Net Banking', 89999.00, 'pending'),
(14, '2024-07-22', 'UPI',           999.00, 'success'),
(15, '2024-08-05', 'Wallet',        399.00, 'success');
