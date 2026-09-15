-- ============================================================
-- Supply Chain Fulfillment & Delivery Performance Analytics
-- 01_database.sql
-- ============================================================

CREATE DATABASE IF NOT EXISTS supply_chain_analytics;

USE supply_chain_analytics;


-- ============================================================
-- CREATE TABLE
-- ============================================================

DROP TABLE IF EXISTS supply_chain_data;

CREATE TABLE supply_chain_data (
    payment_type VARCHAR(50),
    days_for_shipping_real INT,
    days_for_shipment_scheduled INT,
    delivery_status VARCHAR(50),
    late_delivery_risk INT,

    category_id INT,
    category_name VARCHAR(100),

    customer_city VARCHAR(100),
    customer_country VARCHAR(100),
    customer_first_name VARCHAR(100),
    customer_id INT,
    customer_last_name VARCHAR(100),
    customer_segment VARCHAR(100),
    customer_state VARCHAR(100),
    customer_street VARCHAR(255),
    customer_zipcode DOUBLE,

    department_id INT,
    department_name VARCHAR(100),

    latitude DOUBLE,
    longitude DOUBLE,
    market VARCHAR(100),

    order_city VARCHAR(100),
    order_country VARCHAR(100),
    order_date DATETIME,
    order_id INT,

    order_item_discount DOUBLE,
    order_item_discount_rate DOUBLE,
    order_item_id INT,
    order_item_profit_ratio DOUBLE,
    order_item_quantity INT,

    sales DOUBLE,
    order_item_total DOUBLE,
    order_profit_per_order DOUBLE,

    order_region VARCHAR(100),
    order_state VARCHAR(100),
    order_status VARCHAR(100),

    product_card_id INT,
    product_name VARCHAR(255),
    product_price DOUBLE,

    shipping_date DATETIME,
    shipping_mode VARCHAR(100),

    shipping_variance_days INT,
    sla_breach_flag INT
);


-- ============================================================
-- IMPORT CLEANED CSV
-- ============================================================

LOAD DATA LOCAL INFILE
'C:/Users/Syed Aleem/Personal Doc/Projects/Supply_Chain_Analytics/Output/dataco_cleaned.csv'
INTO TABLE supply_chain_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- ============================================================
-- VALIDATE IMPORT
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_item_id) AS unique_order_items,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT product_card_id) AS unique_products
FROM supply_chain_data;


-- Expected:
-- total_rows         = 180519
-- unique_order_items = 180519
-- unique_orders      = 65752
-- unique_customers   = 20652
-- unique_products    = 118


-- ============================================================
-- CHECK MISSING VALUES
-- ============================================================

SELECT
    SUM(customer_last_name IS NULL) AS missing_last_name,
    SUM(customer_zipcode IS NULL) AS missing_zipcode
FROM supply_chain_data;


-- ============================================================
-- CHECK DUPLICATE ORDER ITEMS
-- ============================================================

SELECT
    COUNT(*) AS duplicate_order_items
FROM (
    SELECT
        order_item_id
    FROM supply_chain_data
    GROUP BY order_item_id
    HAVING COUNT(*) > 1
) AS duplicate_check;
