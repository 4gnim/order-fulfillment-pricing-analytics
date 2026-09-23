USE order-fulfillment-pricing-analytics;

-- 1. CHECK ORDER DETAIL MULTIPLICITY

SELECT
    OrderID,
    COUNT(*) AS detail_rows
FROM OrderDetails
GROUP BY OrderID
ORDER BY detail_rows DESC;


-- 2. BASIC ORDER STATUS ANALYSIS

SELECT
    OrderStatus,
    COUNT(*) AS detail_rows,
    COUNT(DISTINCT OrderID) AS unique_orders,
    SUM(OrderItemQuantity) AS total_units,
    SUM(OrderItemQuantity * PerUnitPrice) AS order_value
FROM OrderDetails
GROUP BY OrderStatus
ORDER BY order_value DESC;


-- 3. JOIN ORDER + CUSTOMER + ORDER DETAILS + PRODUCT

SELECT
    o.OrderID,
    o.OrderDate,
    c.CustomerID,
    c.CustomerName,
    od.ProductID,
    p.ProductName,
    p.CategoryName,
    od.OrderItemQuantity,
    od.PerUnitPrice,
    p.ProductStandardCost,
    od.OrderStatus
FROM Orders o
JOIN Customer c
    ON o.CustomerID = c.CustomerID
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
JOIN Product p
    ON od.ProductID = p.ProductID
LIMIT 20;


-- 4. ANALYTICAL VIEW

DROP VIEW IF EXISTS vw_order_analytics;

CREATE VIEW vw_order_analytics AS
SELECT
    o.OrderID AS order_id,
    o.OrderDate AS order_date,

    c.CustomerID AS customer_id,
    c.CustomerName AS customer_name,
    c.CustomerCreditLimit AS customer_credit_limit,

    od.OrderDetailsID AS order_detail_id,
    od.ProductID AS product_id,
    od.OrderItemQuantity AS quantity,
    od.PerUnitPrice AS unit_price,
    od.OrderStatus AS order_status,

    p.ProductName AS product_name,
    p.CategoryName AS category,
    p.ProductStandardCost AS standard_cost,
    p.ProductListPrice AS list_price,

    od.OrderItemQuantity * od.PerUnitPrice AS revenue,

    od.OrderItemQuantity * p.ProductStandardCost AS estimated_cost,

    od.OrderItemQuantity *
        (od.PerUnitPrice - p.ProductStandardCost) AS gross_profit,

    od.OrderItemQuantity *
        (p.ProductListPrice - p.ProductStandardCost) AS list_price_profit

FROM Orders o
JOIN Customer c
    ON o.CustomerID = c.CustomerID
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
JOIN Product p
    ON od.ProductID = p.ProductID;


-- Validate Analytical of View

SELECT *
FROM vw_order_analytics
LIMIT 10;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT product_id) AS unique_products
FROM vw_order_analytics;


-- First KPI

SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT product_id) AS total_products,
    SUM(quantity) AS total_units,
    SUM(revenue) AS total_revenue,
    SUM(gross_profit) AS total_gross_profit,
    SUM(gross_profit) / NULLIF(SUM(revenue), 0) AS gross_margin
FROM vw_order_analytics; 


-- Sales/Order Status

SELECT
    order_status,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_units,
    SUM(revenue) AS total_revenue,
    SUM(gross_profit) AS total_gross_profit
FROM vw_order_analytics
GROUP BY order_status
ORDER BY total_revenue DESC;


-- Customer Analysis

SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_units,
    SUM(revenue) AS total_revenue,
    SUM(gross_profit) AS total_gross_profit
FROM vw_order_analytics
GROUP BY
    customer_id,
    customer_name
ORDER BY total_revenue DESC
LIMIT 10;


-- Product Analysis

SELECT
    product_id,
    product_name,
    category,
    SUM(quantity) AS total_units,
    SUM(revenue) AS total_revenue,
    SUM(gross_profit) AS total_gross_profit,
    SUM(gross_profit) / NULLIF(SUM(revenue), 0) AS gross_margin
FROM vw_order_analytics
GROUP BY
    product_id,
    product_name,
    category
ORDER BY total_revenue DESC
LIMIT 10;


-- Category Analysis
SELECT
    category,
    SUM(quantity) AS total_units,
    SUM(revenue) AS total_revenue,
    SUM(gross_profit) AS total_gross_profit,
    SUM(gross_profit) / NULLIF(SUM(revenue), 0) AS gross_margin
FROM vw_order_analytics
GROUP BY category
ORDER BY total_revenue DESC;


-- Time Trend

SELECT
    YEAR(order_date) AS order_year,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_units,
    SUM(revenue) AS total_revenue,
    SUM(gross_profit) AS total_gross_profit
FROM vw_order_analytics
GROUP BY YEAR(order_date)
ORDER BY order_year;

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month_period,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(revenue) AS total_revenue,
    SUM(gross_profit) AS total_gross_profit
FROM vw_order_analytics
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month_period;


-- Customer Credit Limit vs Revenue

SELECT
    customer_id,
    customer_name,
    customer_credit_limit,
    SUM(revenue) AS total_revenue,
    SUM(gross_profit) AS total_gross_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM vw_order_analytics
GROUP BY
    customer_id,
    customer_name,
    customer_credit_limit
ORDER BY total_revenue DESC;


-- Validation Important

SELECT
    product_id,
    product_name,
    list_price,
    unit_price,
    standard_cost,
    list_price - standard_cost AS list_price_profit,
    unit_price - standard_cost AS realized_unit_profit,
    unit_price / NULLIF(list_price, 0) AS price_realization_rate
FROM vw_order_analytics
LIMIT 20;

SELECT
    order_status,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_units,
    SUM(revenue) AS total_revenue,
    SUM(gross_profit) AS realized_gross_profit,
    SUM(gross_profit) / NULLIF(SUM(revenue), 0) AS realized_margin
FROM vw_order_analytics
GROUP BY order_status
ORDER BY total_revenue DESC;

SELECT
    COUNT(DISTINCT order_id) AS shipped_orders,
    SUM(quantity) AS shipped_units,
    SUM(revenue) AS shipped_revenue,
    SUM(gross_profit) AS shipped_gross_profit,
    SUM(gross_profit) / NULLIF(SUM(revenue), 0) AS shipped_margin
FROM vw_order_analytics
WHERE order_status = 'Shipped';


-- Overall Status

SELECT
    order_status,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_units,
    SUM(revenue) AS order_value,
    SUM(gross_profit) AS gross_profit,
    SUM(gross_profit) / NULLIF(SUM(revenue), 0) AS gross_margin
FROM vw_order_analytics
GROUP BY order_status
ORDER BY total_orders DESC;

-- Shipped KPI

SELECT
    COUNT(DISTINCT order_id) AS shipped_orders,
    SUM(quantity) AS shipped_units,
    SUM(revenue) AS shipped_revenue,
    SUM(gross_profit) AS shipped_gross_profit,
    SUM(gross_profit) / NULLIF(SUM(revenue), 0) AS shipped_margin
FROM vw_order_analytics
WHERE order_status = 'Shipped';

-- Cancellation & Pending rate

SELECT
    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT CASE
        WHEN order_status = 'Canceled' THEN order_id
    END) AS canceled_orders,

    COUNT(DISTINCT CASE
        WHEN order_status = 'Pending' THEN order_id
    END) AS pending_orders,

    COUNT(DISTINCT CASE
        WHEN order_status = 'Canceled' THEN order_id
    END)
    / COUNT(DISTINCT order_id) AS cancellation_rate,

    COUNT(DISTINCT CASE
        WHEN order_status = 'Pending' THEN order_id
    END)
    / COUNT(DISTINCT order_id) AS pending_rate

FROM vw_order_analytics;

-- Price realization by category

SELECT
    category,

    AVG(
        unit_price / NULLIF(list_price, 0)
    ) AS avg_price_realization,

    SUM(revenue) AS total_revenue,

    SUM(gross_profit) AS realized_gross_profit,

    SUM(gross_profit)
        / NULLIF(SUM(revenue), 0) AS realized_margin

FROM vw_order_analytics
WHERE order_status = 'Shipped'
GROUP BY category
ORDER BY avg_price_realization DESC;

-- The most problematic Products

SELECT
    product_id,
    product_name,
    category,

    SUM(quantity) AS units_sold,

    SUM(revenue) AS revenue,

    SUM(gross_profit) AS gross_profit,

    SUM(gross_profit)
        / NULLIF(SUM(revenue), 0) AS gross_margin,

    AVG(
        unit_price / NULLIF(list_price, 0)
    ) AS avg_price_realization

FROM vw_order_analytics
WHERE order_status = 'Shipped'
GROUP BY
    product_id,
    product_name,
    category

HAVING SUM(revenue) > 10000
ORDER BY gross_margin ASC
LIMIT 10;


-- Order status trends by year

SELECT
    YEAR(order_date) AS order_year,
    order_status,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(revenue) AS total_revenue
FROM vw_order_analytics
GROUP BY
    YEAR(order_date),
    order_status
ORDER BY
    order_year,
    order_status;


-- Price realization and margin per product

SELECT
    product_id,
    product_name,
    category,
    AVG(unit_price / NULLIF(list_price, 0)) AS avg_price_realization,
    AVG((unit_price - standard_cost) / NULLIF(unit_price, 0)) AS avg_unit_margin,
    SUM(revenue) AS total_revenue,
    SUM(gross_profit) AS realized_gross_profit
FROM vw_order_analytics
WHERE order_status = 'Shipped'
GROUP BY
    product_id,
    product_name,
    category
ORDER BY avg_price_realization ASC
LIMIT 15;


-- Customer credit limit vs order value

SELECT
    customer_id,
    customer_name,
    customer_credit_limit,
    revenue,
    gross_profit,
    revenue / NULLIF(customer_credit_limit, 0) AS revenue_to_credit_ratio
FROM vw_order_analytics
WHERE order_status = 'Shipped'
ORDER BY revenue_to_credit_ratio DESC
LIMIT 15;