USE order-fulfillment-pricing-analytics;


-- Validate amount of Rows

SELECT 'Customer' AS table_name, COUNT(*) AS row_count FROM Customer
UNION ALL
SELECT 'Employee', COUNT(*) FROM Employee
UNION ALL
SELECT 'OrderDetails', COUNT(*) FROM OrderDetails
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'Product', COUNT(*) FROM Product
UNION ALL
SELECT 'Region', COUNT(*) FROM Region
UNION ALL
SELECT 'Warehouse', COUNT(*) FROM Warehouse;


-- Validate Relation in MySQL

SELECT COUNT(*) AS orphan_orders
FROM Orders o
LEFT JOIN Customer c
    ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;

SELECT COUNT(*) AS orphan_order_details
FROM OrderDetails od
LEFT JOIN Orders o
    ON od.OrderID = o.OrderID
WHERE o.OrderID IS NULL;

SELECT COUNT(*) AS orphan_products
FROM OrderDetails od
LEFT JOIN Product p
    ON od.ProductID = p.ProductID
WHERE p.ProductID IS NULL;

SELECT COUNT(*) AS orphan_warehouse
FROM Employee e
LEFT JOIN Warehouse w
    ON e.WarehouseID = w.WarehouseID
WHERE w.WarehouseID IS NULL;

SELECT COUNT(*) AS orphan_region
FROM Warehouse w
LEFT JOIN Region r
    ON w.RegionID = r.RegionID
WHERE r.RegionID IS NULL;