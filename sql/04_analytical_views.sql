USE order-fulfillment-pricing-analytics;

DROP VIEW IF EXISTS vw_shipped_analytics;

CREATE VIEW vw_shipped_analytics AS
SELECT
    *
FROM vw_order_analytics
WHERE order_status = 'Shipped';

SELECT COUNT(*) AS shipped_rows
FROM vw_shipped_analytics;


-- Create KPI Final 

SELECT
    COUNT(DISTINCT order_id) AS shipped_orders,
    COUNT(DISTINCT customer_id) AS shipped_customers,
    COUNT(DISTINCT product_id) AS shipped_products,
    SUM(quantity) AS shipped_units,
    SUM(revenue) AS shipped_revenue,
    SUM(gross_profit) AS shipped_gross_profit,
    SUM(gross_profit) / NULLIF(SUM(revenue), 0) AS shipped_margin,
    AVG(unit_price / NULLIF(list_price, 0)) AS avg_price_realization
FROM vw_shipped_analytics;


-- Status Overview

SELECT
    order_status,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS units,
    SUM(revenue) AS order_value
FROM vw_order_analytics
GROUP BY order_status
ORDER BY orders DESC;


-- Annual fulfillment trends

SELECT
    YEAR(order_date) AS order_year,
    order_status,
    COUNT(DISTINCT order_id) AS orders
FROM vw_order_analytics
GROUP BY
    YEAR(order_date),
    order_status
ORDER BY
    order_year,
    order_status;


-- Category profitability

SELECT
    category,
    SUM(quantity) AS units,
    SUM(revenue) AS revenue,
    SUM(gross_profit) AS gross_profit,
    SUM(gross_profit) / NULLIF(SUM(revenue), 0) AS gross_margin,
    AVG(unit_price / NULLIF(list_price, 0)) AS avg_price_realization
FROM vw_shipped_analytics
GROUP BY category
ORDER BY revenue DESC;


-- Products that need to review

SELECT
    product_id,
    product_name,
    category,
    SUM(quantity) AS units,
    SUM(revenue) AS revenue,
    SUM(gross_profit) AS gross_profit,
    SUM(gross_profit) / NULLIF(SUM(revenue), 0) AS gross_margin,
    AVG(unit_price / NULLIF(list_price, 0)) AS avg_price_realization
FROM vw_shipped_analytics
GROUP BY
    product_id,
    product_name,
    category
HAVING SUM(revenue) > 10000
ORDER BY gross_margin ASC
LIMIT 10;