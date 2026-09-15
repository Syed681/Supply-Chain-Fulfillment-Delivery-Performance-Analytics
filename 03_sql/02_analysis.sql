-- ============================================================
-- Supply Chain Fulfillment & Delivery Performance Analytics
-- 02_analysis.sql
-- ============================================================

USE supply_chain_analytics;


-- ============================================================
-- NOTES
-- ============================================================
--
-- Dataset grain:
-- One row = one order item / line item.
--
-- AOV:
-- SUM(sales) / COUNT(DISTINCT order_id)
--
-- Shipping variance:
-- Actual shipping days - scheduled shipping days
--
-- SLA breach:
-- shipping_variance_days > 0
--
-- late_delivery_risk is the original dataset field.
-- sla_breach_flag is our calculated field.
--
-- order_profit_per_order varies across line items in many
-- orders, so SUM(order_profit_per_order) is treated as an
-- aggregated profit field.
--
-- ============================================================


-- ============================================================
-- 1. OVERALL KPIs
-- ============================================================

SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT order_item_id) AS total_order_items,
    COUNT(DISTINCT customer_id) AS total_customers,

    ROUND(SUM(sales), 2) AS total_sales,

    SUM(order_item_quantity) AS total_quantity,

    ROUND(
        SUM(sales) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value,

    ROUND(
        SUM(sales) / SUM(order_item_quantity),
        2
    ) AS average_sales_per_unit,

    ROUND(
        AVG(shipping_variance_days),
        2
    ) AS avg_shipping_variance_days,

    ROUND(
        AVG(sla_breach_flag) * 100,
        2
    ) AS sla_breach_percentage

FROM supply_chain_data;


-- ============================================================
-- 2. DELIVERY STATUS & SLA PERFORMANCE
-- ============================================================

SELECT
    delivery_status,

    COUNT(*) AS order_items,

    ROUND(
        AVG(shipping_variance_days),
        2
    ) AS avg_shipping_variance_days,

    ROUND(
        AVG(sla_breach_flag) * 100,
        2
    ) AS sla_breach_percentage

FROM supply_chain_data

GROUP BY delivery_status

ORDER BY sla_breach_percentage DESC;


-- ============================================================
-- 3. SHIPPING MODE PERFORMANCE
-- ============================================================

SELECT
    shipping_mode,

    COUNT(*) AS order_items,

    ROUND(
        AVG(days_for_shipping_real),
        2
    ) AS avg_actual_shipping_days,

    ROUND(
        AVG(days_for_shipment_scheduled),
        2
    ) AS avg_scheduled_shipping_days,

    ROUND(
        AVG(shipping_variance_days),
        2
    ) AS avg_shipping_variance_days,

    ROUND(
        AVG(sla_breach_flag) * 100,
        2
    ) AS sla_breach_percentage

FROM supply_chain_data

GROUP BY shipping_mode

ORDER BY sla_breach_percentage DESC;


-- ============================================================
-- 4. SHIPPING MODE & COMMERCIAL PERFORMANCE
-- ============================================================

SELECT
    shipping_mode,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        SUM(sales),
        2
    ) AS total_sales,

    ROUND(
        SUM(order_profit_per_order),
        2
    ) AS aggregated_profit,

    ROUND(
        AVG(order_profit_per_order),
        2
    ) AS avg_profit_per_order_item,

    ROUND(
        AVG(sla_breach_flag) * 100,
        2
    ) AS sla_breach_percentage

FROM supply_chain_data

GROUP BY shipping_mode

ORDER BY aggregated_profit DESC;


-- ============================================================
-- 5. CATEGORY PERFORMANCE
-- ============================================================

SELECT
    category_name,

    COUNT(DISTINCT order_id) AS total_orders,

    SUM(order_item_quantity) AS total_quantity,

    ROUND(
        SUM(sales),
        2
    ) AS total_sales,

    ROUND(
        SUM(order_profit_per_order),
        2
    ) AS aggregated_profit,

    ROUND(
        AVG(sla_breach_flag) * 100,
        2
    ) AS sla_breach_percentage

FROM supply_chain_data

GROUP BY category_name

ORDER BY total_sales DESC;


-- ============================================================
-- 6. MARKET PERFORMANCE
-- ============================================================

SELECT
    market,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        SUM(sales),
        2
    ) AS total_sales,

    ROUND(
        SUM(order_profit_per_order),
        2
    ) AS aggregated_profit,

    ROUND(
        AVG(shipping_variance_days),
        2
    ) AS avg_shipping_variance_days,

    ROUND(
        AVG(sla_breach_flag) * 100,
        2
    ) AS sla_breach_percentage

FROM supply_chain_data

GROUP BY market

ORDER BY sla_breach_percentage DESC;


-- ============================================================
-- 7. ORDER REGION PERFORMANCE
-- ============================================================

SELECT
    order_region,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        SUM(sales),
        2
    ) AS total_sales,

    ROUND(
        SUM(order_profit_per_order),
        2
    ) AS aggregated_profit,

    ROUND(
        AVG(shipping_variance_days),
        2
    ) AS avg_shipping_variance_days,

    ROUND(
        AVG(sla_breach_flag) * 100,
        2
    ) AS sla_breach_percentage

FROM supply_chain_data

GROUP BY order_region

ORDER BY sla_breach_percentage DESC;


-- ============================================================
-- 8. CUSTOMER SEGMENT PERFORMANCE
-- ============================================================

SELECT
    customer_segment,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        SUM(sales),
        2
    ) AS total_sales,

    ROUND(
        AVG(shipping_variance_days),
        2
    ) AS avg_shipping_variance_days,

    ROUND(
        AVG(sla_breach_flag) * 100,
        2
    ) AS sla_breach_percentage

FROM supply_chain_data

GROUP BY customer_segment

ORDER BY sla_breach_percentage DESC;


-- ============================================================
-- 9. MONTHLY SALES & FULFILLMENT TREND
-- ============================================================

SELECT
    DATE_FORMAT(
        order_date,
        '%Y-%m'
    ) AS order_month,

    COUNT(DISTINCT order_id) AS total_orders,

    SUM(order_item_quantity) AS total_quantity,

    ROUND(
        SUM(sales),
        2
    ) AS total_sales,

    ROUND(
        AVG(shipping_variance_days),
        2
    ) AS avg_shipping_variance_days,

    ROUND(
        AVG(sla_breach_flag) * 100,
        2
    ) AS sla_breach_percentage

FROM supply_chain_data

GROUP BY DATE_FORMAT(
    order_date,
    '%Y-%m'
)

ORDER BY order_month;


-- ============================================================
-- 10. CHECK PROFIT FIELD
-- ============================================================

SELECT
    COUNT(*) AS orders_with_multiple_profit_values

FROM (
    SELECT
        order_id

    FROM supply_chain_data

    GROUP BY order_id

    HAVING COUNT(
        DISTINCT order_profit_per_order
    ) > 1

) AS profit_check;


-- ============================================================
-- 11. TOP PRODUCTS BY SALES
-- ============================================================

SELECT
    product_name,

    COUNT(DISTINCT order_id) AS total_orders,

    SUM(order_item_quantity) AS total_quantity,

    ROUND(
        SUM(sales),
        2
    ) AS total_sales,

    ROUND(
        AVG(sla_breach_flag) * 100,
        2
    ) AS sla_breach_percentage

FROM supply_chain_data

GROUP BY product_name

ORDER BY total_sales DESC

LIMIT 10;


-- ============================================================
-- 12. TOP PRODUCTS BY QUANTITY
-- ============================================================

SELECT
    product_name,

    SUM(order_item_quantity) AS total_quantity,

    ROUND(
        SUM(sales),
        2
    ) AS total_sales,

    ROUND(
        SUM(sales) / SUM(order_item_quantity),
        2
    ) AS sales_per_unit,

    ROUND(
        AVG(sla_breach_flag) * 100,
        2
    ) AS sla_breach_percentage

FROM supply_chain_data

GROUP BY product_name

ORDER BY total_quantity DESC

LIMIT 10;


-- ============================================================
-- 13. MONTH-OVER-MONTH SALES GROWTH
-- ============================================================

WITH monthly_sales AS (

    SELECT
        DATE_FORMAT(
            order_date,
            '%Y-%m'
        ) AS order_month,

        SUM(sales) AS total_sales

    FROM supply_chain_data

    GROUP BY DATE_FORMAT(
        order_date,
        '%Y-%m'
    )
),

sales_with_previous_month AS (

    SELECT
        order_month,

        total_sales,

        LAG(total_sales) OVER (
            ORDER BY order_month
        ) AS previous_month_sales

    FROM monthly_sales
)

SELECT
    order_month,

    ROUND(
        total_sales,
        2
    ) AS total_sales,

    ROUND(
        previous_month_sales,
        2
    ) AS previous_month_sales,

    ROUND(
        (
            total_sales - previous_month_sales
        )
        / previous_month_sales * 100,
        2
    ) AS mom_growth_percentage

FROM sales_with_previous_month

ORDER BY order_month;


-- ============================================================
-- 14. TOP PRODUCTS & SALES CONTRIBUTION
-- ============================================================

SELECT
    product_name,

    ROUND(
        SUM(sales),
        2
    ) AS total_sales,

    ROUND(
        SUM(sales)
        /
        (
            SELECT SUM(sales)
            FROM supply_chain_data
        )
        * 100,
        2
    ) AS sales_contribution_percentage

FROM supply_chain_data

GROUP BY product_name

ORDER BY total_sales DESC

LIMIT 10;


-- ============================================================
-- 15. REGION × SHIPPING MODE
-- ============================================================

SELECT
    order_region,

    shipping_mode,

    COUNT(*) AS order_items,

    ROUND(
        AVG(shipping_variance_days),
        2
    ) AS avg_shipping_variance_days,

    ROUND(
        AVG(sla_breach_flag) * 100,
        2
    ) AS sla_breach_percentage

FROM supply_chain_data

GROUP BY
    order_region,
    shipping_mode

ORDER BY sla_breach_percentage DESC;


-- ============================================================
-- 16. SLA BREACH CONTRIBUTION BY SHIPPING MODE
-- ============================================================

SELECT
    shipping_mode,

    COUNT(*) AS total_order_items,

    SUM(sla_breach_flag) AS late_order_items,

    ROUND(
        SUM(sla_breach_flag)
        / COUNT(*) * 100,
        2
    ) AS sla_breach_percentage,

    ROUND(
        SUM(sla_breach_flag)
        /
        (
            SELECT SUM(sla_breach_flag)
            FROM supply_chain_data
        )
        * 100,
        2
    ) AS contribution_to_total_breaches_percentage

FROM supply_chain_data

GROUP BY shipping_mode

ORDER BY late_order_items DESC;


-- ============================================================
-- 17. SALES ASSOCIATED WITH SLA-BREACHED ITEMS
-- ============================================================

SELECT
    product_name,

    SUM(order_item_quantity) AS late_quantity,

    ROUND(
        SUM(sales),
        2
    ) AS late_sales,

    COUNT(*) AS late_order_items,

    ROUND(
        AVG(shipping_variance_days),
        2
    ) AS avg_shipping_variance_days

FROM supply_chain_data

WHERE sla_breach_flag = 1

GROUP BY product_name

ORDER BY late_sales DESC

LIMIT 10;
