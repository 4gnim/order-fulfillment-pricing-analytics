USE order-fulfillment-pricing-analytics;

-- 1. CUSTOMER

CREATE TABLE IF NOT EXISTS Customer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(255) NOT NULL,
    CustomerEmail VARCHAR(255) NOT NULL,
    CustomerPhone VARCHAR(30),
    CustomerAddress VARCHAR(500),
    CustomerCreditLimit DECIMAL(12,2)
) ENGINE=InnoDB;


-- 2. REGION

CREATE TABLE IF NOT EXISTS Region (
    RegionID INT PRIMARY KEY,
    RegionName VARCHAR(100) NOT NULL,
    CountryName VARCHAR(150) NOT NULL,
    State VARCHAR(150),
    City VARCHAR(150),
    PostalCode VARCHAR(20)
) ENGINE=InnoDB;


-- 3. WAREHOUSE

CREATE TABLE IF NOT EXISTS Warehouse (
    WarehouseID INT PRIMARY KEY,
    WarehouseName VARCHAR(255) NOT NULL,
    WarehouseAddress VARCHAR(500),
    RegionID INT NOT NULL,

    CONSTRAINT fk_warehouse_region
        FOREIGN KEY (RegionID)
        REFERENCES Region(RegionID)
) ENGINE=InnoDB;


-- 4. EMPLOYEE

CREATE TABLE IF NOT EXISTS Employee (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(255) NOT NULL,
    EmployeeEmail VARCHAR(255) NOT NULL,
    EmployeePhone VARCHAR(30),
    EmployeeHireDate DATE,
    EmployeeJobTitle VARCHAR(255),
    WarehouseID INT NOT NULL,

    CONSTRAINT fk_employee_warehouse
        FOREIGN KEY (WarehouseID)
        REFERENCES Warehouse(WarehouseID)
) ENGINE=InnoDB;


-- 5. PRODUCT

CREATE TABLE IF NOT EXISTS Product (
    ProductID VARCHAR(50) PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    CategoryName VARCHAR(100) NOT NULL,
    ProductDescription TEXT,
    ProductStandardCost DECIMAL(12,2),
    ProductListPrice DECIMAL(12,2),
    Profit DECIMAL(12,2)
) ENGINE=InnoDB;


-- 6. ORDERS

CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE NOT NULL,
    CustomerID INT NOT NULL,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID)
) ENGINE=InnoDB;


-- 7. ORDER DETAILS

CREATE TABLE IF NOT EXISTS OrderDetails (
    OrderDetailsID INT PRIMARY KEY,
    ProductID VARCHAR(50) NOT NULL,
    OrderItemQuantity INT NOT NULL,
    PerUnitPrice DECIMAL(12,2) NOT NULL,
    OrderStatus VARCHAR(50) NOT NULL,
    OrderID INT NOT NULL,

    CONSTRAINT fk_orderdetails_product
        FOREIGN KEY (ProductID)
        REFERENCES Product(ProductID),

    CONSTRAINT fk_orderdetails_order
        FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID)
) ENGINE=InnoDB;