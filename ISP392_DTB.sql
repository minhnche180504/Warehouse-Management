<<<<<<< HEAD
USE master;
GO

-- Drop database if exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Warehouse')
BEGIN
    ALTER DATABASE Warehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Warehouse;
END
GO


-- Create database
CREATE DATABASE Warehouse;
GO
USE Warehouse;
GO

-- Drop tables if they exist (in reverse dependency order)
DROP TABLE IF EXISTS 
    Discount_Usage_Log,
    Special_Discount_Request,
    Alert_History,
    Reorder_Alert,
    StockCheckReportItem, 
    StockCheckReport,
    Stock_Adjustment,
    Stock_Adjustment_Reason,
    Sales_Order_Item,
    Sales_Order,
    Purchase_Order_Item,
    Purchase_Order,
    RFQ_Item,
    Request_For_Quotation,
    Import_Request_Detail,
    Import_Request,
    Transfer_Order_Item,
    Transfer_Order,
    Inventory_Transfer_Item,
    Inventory_Transfer,
    Inventory_Transaction,
    Inventory,
    ProductAttribute,
    Product,
    Unit,
    Supplier_Rating,
    Supplier,
    Customer,
    Purchase_Request_Item,
    Purchase_Request,
    Discount_Code,
    Quotation_Item,
    Quotation,
    Product_Supplier,
    AuthorizeMap,
    [User],
    Warehouse,
    [Role];


-- 1. Role
CREATE TABLE [Role] (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL
);

-- 2. Warehouse
CREATE TABLE Warehouse (
    warehouse_id INT IDENTITY(1,1) PRIMARY KEY,
    warehouse_name NVARCHAR(100) UNIQUE NOT NULL,
    address NVARCHAR(255),
    region NVARCHAR(50),
    manager_id INT, -- FK to [User], added later
    status VARCHAR(50),
    created_at DATETIME DEFAULT GETDATE()
);

-- 3. User\

CREATE TABLE [User] (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    role_id INT NOT NULL,
    gender VARCHAR(10),
    address VARCHAR(255),
    email VARCHAR(100),
    date_of_birth DATE,
    profile_pic VARCHAR(255),
    status VARCHAR(10) NOT NULL DEFAULT 'Active',
    warehouse_id INT NULL,
    CONSTRAINT FK_User_Role FOREIGN KEY (role_id) REFERENCES [Role](role_id),
    CONSTRAINT CK_User_Status CHECK (status IN ('Active', 'Deactive'))
);

CREATE INDEX IX_User_Status ON [User](status);
CREATE INDEX IX_User_Username_Status ON [User](username, status);

-- Add FK to Warehouse.manager_id after User exists
ALTER TABLE Warehouse
ADD CONSTRAINT FK_Warehouse_Manager FOREIGN KEY (manager_id) REFERENCES [User](user_id);

-- Add FK from User to Warehouse
ALTER TABLE [User]
ADD CONSTRAINT FK_User_Warehouse FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id);

-- 4. Customer
CREATE TABLE Customer (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_name NVARCHAR(100) NOT NULL,
    address NVARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(100),
    is_delete TINYINT DEFAULT 0
);
-- 5. Supplier
CREATE TABLE Supplier (
    supplier_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(100),
    contact_person VARCHAR(100),
    date_created DATETIME DEFAULT GETDATE(),
    last_updated DATETIME,
    is_delete TINYINT
);
select * from Supplier

-- 6. Supplier_Rating
CREATE TABLE Supplier_Rating (
    rating_id INT IDENTITY(1,1) PRIMARY KEY,
    supplier_id INT NOT NULL,
    user_id INT NOT NULL,
    delivery_score INT,
    quality_score INT,
    service_score INT,
    price_score INT,
    comment NVARCHAR(1000),
    rating_date DATETIME,
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id),
    FOREIGN KEY (user_id) REFERENCES [User](user_id)
);

-- 7. Unit
CREATE TABLE Unit (
    unit_id INT IDENTITY(1,1) PRIMARY KEY,
    unit_name VARCHAR(50) NOT NULL UNIQUE,
    unit_code VARCHAR(10) NOT NULL UNIQUE,
    description VARCHAR(255),
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    last_updated DATETIME
);

-- 8. Product
CREATE TABLE Product (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    unit_id INT,
    price DECIMAL(15,2),
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id),
    FOREIGN KEY (unit_id) REFERENCES Unit(unit_id)
);

-- 9. ProductAttribute
CREATE TABLE ProductAttribute (
    attribute_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    attribute_name VARCHAR(50) NOT NULL,
    attribute_value NVARCHAR(MAX) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    last_updated DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE CASCADE
);

CREATE INDEX IX_ProductAttribute_ProductId ON ProductAttribute(product_id);
CREATE INDEX IX_ProductAttribute_Name_Product ON ProductAttribute(attribute_name, product_id);

-- 10. Inventory
CREATE TABLE Inventory (
    inventory_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    quantity INT DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    UNIQUE (product_id, warehouse_id)
);

-- 11. Inventory_Transaction
CREATE TABLE Inventory_Transaction (
    transaction_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    quantity INT NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    related_id INT,
    created_by INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (created_by) REFERENCES [User](user_id)
);

-- 12. Purchase_Request
CREATE TABLE Purchase_Request (
    pr_id INT IDENTITY(1,1) PRIMARY KEY,
    pr_number VARCHAR(50) UNIQUE NOT NULL,
    requested_by INT NOT NULL,
    request_date DATETIME DEFAULT GETDATE(),
    warehouse_id INT NOT NULL,
    preferred_delivery_date DATE NULL,
    reason NVARCHAR(1000) NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    confirm_by INT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (requested_by) REFERENCES [User](user_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (confirm_by) REFERENCES [User](user_id)
);

-- 13. Purchase_Request_Item
CREATE TABLE Purchase_Request_Item (
    pr_item_id INT IDENTITY(1,1) PRIMARY KEY,
    pr_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    note NVARCHAR(255)
    FOREIGN KEY (pr_id) REFERENCES Purchase_Request(pr_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- 14. Reorder_Alert
CREATE TABLE Reorder_Alert (
    alert_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    warning_threshold INT NOT NULL,
    critical_threshold INT NOT NULL,
    triggered_date DATETIME DEFAULT GETDATE(),
    current_stock INT NOT NULL,
    is_active BIT DEFAULT 1,
    created_by INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    last_updated DATETIME DEFAULT GETDATE(),
    alert_start_date DATETIME DEFAULT GETDATE(),
    alert_expiry_date DATETIME NULL,
    alert_duration_days INT DEFAULT 30,
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (created_by) REFERENCES [User](user_id),
    UNIQUE (product_id, warehouse_id)
);

-- 15. Alert_History
CREATE TABLE Alert_History (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    alert_id INT NOT NULL,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    action_type VARCHAR(50) NOT NULL, -- 'CREATED', 'UPDATED', 'RESOLVED_BY_PURCHASE', 'EXPIRED', 'DEACTIVATED'
    alert_level VARCHAR(20) NOT NULL, -- 'WARNING', 'CRITICAL', 'OUT_OF_STOCK', 'STABLE'
    -- Thông tin ngưỡng tại thời điểm action
    warning_threshold INT NOT NULL,
    critical_threshold INT NOT NULL,
    stock_quantity INT NOT NULL,
    -- Thông tin thay đổi (cho action UPDATE)
    old_warning_threshold INT NULL,
    old_critical_threshold INT NULL,
    old_expiry_date DATETIME NULL,
    new_expiry_date DATETIME NULL,
    -- Thông tin giải quyết
    resolved_by_purchase_request_id INT NULL, -- ID của purchase request nếu được giải quyết
    resolved_by_user_id INT NULL, -- User thực hiện giải quyết
    -- Thông tin thời gian
    action_date DATETIME DEFAULT GETDATE(),
    alert_start_date DATETIME NULL,
    alert_expiry_date DATETIME NULL,
    -- Thông tin người thực hiện và ghi chú
    performed_by INT NOT NULL, -- User thực hiện action
    notes NVARCHAR(1000) NULL,
    system_generated BIT DEFAULT 0, -- Có phải do hệ thống tự động tạo không
    FOREIGN KEY (alert_id) REFERENCES Reorder_Alert(alert_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (resolved_by_purchase_request_id) REFERENCES Purchase_Request(pr_id),
    FOREIGN KEY (resolved_by_user_id) REFERENCES [User](user_id),
    FOREIGN KEY (performed_by) REFERENCES [User](user_id)
);

-- Tạo index cho performance
CREATE INDEX IX_AlertHistory_AlertId ON Alert_History(alert_id);
CREATE INDEX IX_AlertHistory_ActionType ON Alert_History(action_type);
CREATE INDEX IX_AlertHistory_ActionDate ON Alert_History(action_date);
CREATE INDEX IX_AlertHistory_Warehouse ON Alert_History(warehouse_id);

-- 16. Purchase_Order
CREATE TABLE Purchase_Order (
    po_id INT IDENTITY(1,1) PRIMARY KEY,
    supplier_id INT NOT NULL,
    user_id INT NOT NULL,
    [date] DATETIME NULL,
    status VARCHAR(50) NULL,
    expected_delivery_date DATE NULL,
    warehouse_id INT NULL,
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id),
    FOREIGN KEY (user_id) REFERENCES [User](user_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id)
);

-- 17. Purchase_Order_Item
CREATE TABLE Purchase_Order_Item (
    po_item_id INT IDENTITY(1,1) PRIMARY KEY,
    po_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (po_id) REFERENCES Purchase_Order(po_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- 18. Discount_Code
CREATE TABLE Discount_Code (
    discount_id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),
    discount_type VARCHAR(20) NOT NULL CHECK (discount_type IN ('PERCENTAGE', 'FIXED_AMOUNT')),
    discount_value DECIMAL(15,2) NOT NULL CHECK (discount_value > 0),
    min_order_amount DECIMAL(15,2) DEFAULT 0,
    max_discount_amount DECIMAL(15,2) NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    usage_limit INT DEFAULT NULL,
    used_count INT DEFAULT 0,
    is_active BIT DEFAULT 1,
    created_by INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (created_by) REFERENCES [User](user_id),
    CONSTRAINT CK_DateRange CHECK (end_date > start_date)
);

-- Index cho performance
CREATE INDEX IX_DiscountCode_Active_Date ON Discount_Code(is_active, start_date, end_date);
CREATE INDEX IX_DiscountCode_Code ON Discount_Code(code) WHERE is_active = 1;

-- 19. Special_Discount_Request
CREATE TABLE Special_Discount_Request (
    request_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    requested_by INT NOT NULL,
    discount_type VARCHAR(20) NOT NULL CHECK (discount_type IN ('PERCENTAGE', 'FIXED_AMOUNT')),
    discount_value DECIMAL(15,2) NOT NULL,
    reason NVARCHAR(500) NOT NULL,
    estimated_order_value DECIMAL(15,2),
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected')),
    approved_by INT NULL,
    approved_at DATETIME NULL,
    rejection_reason NVARCHAR(255) NULL,
    generated_code VARCHAR(20) NULL,
    expiry_date DATETIME NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (requested_by) REFERENCES [User](user_id),
    FOREIGN KEY (approved_by) REFERENCES [User](user_id)
);

-- 20. Sales_Order (Updated with discount fields)
CREATE TABLE Sales_Order (
    so_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    user_id INT NOT NULL,
    warehouse_id INT,
    [date] DATETIME DEFAULT GETDATE(),
    status VARCHAR(50),
    order_number VARCHAR(50) UNIQUE,
    total_amount DECIMAL(15,2) DEFAULT 0,
    total_before_discount DECIMAL(15,2) DEFAULT 0,
    discount_amount DECIMAL(15,2) DEFAULT 0,
    discount_code_id INT NULL,
    special_request_id INT NULL,
    delivery_date DATE,
    delivery_address NVARCHAR(255),
    notes NVARCHAR(500),
    cancellation_reason NVARCHAR(255),
    cancelled_by INT,
    cancelled_at DATETIME,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (user_id) REFERENCES [User](user_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (discount_code_id) REFERENCES Discount_Code(discount_id),
    FOREIGN KEY (special_request_id) REFERENCES Special_Discount_Request(request_id)
);

-- 21. Sales_Order_Item
CREATE TABLE Sales_Order_Item (
    so_item_id INT IDENTITY(1,1) PRIMARY KEY,
    so_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    selling_price DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (so_id) REFERENCES Sales_Order(so_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- 22. Discount_Usage_Log
CREATE TABLE Discount_Usage_Log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    discount_code_id INT NULL,
    special_request_id INT NULL,
    sales_order_id INT NOT NULL,
    customer_id INT NOT NULL,
    used_by INT NOT NULL,
    order_total DECIMAL(15,2) NOT NULL,
    discount_amount DECIMAL(15,2) NOT NULL,
    used_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (discount_code_id) REFERENCES Discount_Code(discount_id),
    FOREIGN KEY (special_request_id) REFERENCES Special_Discount_Request(request_id),
    FOREIGN KEY (sales_order_id) REFERENCES Sales_Order(so_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (used_by) REFERENCES [User](user_id)
);

-- 23. Stock_Adjustment_Reason
CREATE TABLE Stock_Adjustment_Reason (
    reason_id INT IDENTITY(1,1) PRIMARY KEY,
    description VARCHAR(255) NOT NULL
);

-- 24. Stock_Adjustment
CREATE TABLE Stock_Adjustment (
    adjustment_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    quantity_change INT NOT NULL,
    reason_id INT NOT NULL,
    user_id INT NOT NULL,
    [date] DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (reason_id) REFERENCES Stock_Adjustment_Reason(reason_id),
    FOREIGN KEY (user_id) REFERENCES [User](user_id)
);

-- 25. Import_Request
CREATE TABLE Import_Request (
    request_id INT IDENTITY(1,1) PRIMARY KEY,
    request_date DATETIME DEFAULT GETDATE(),
    created_by INT NOT NULL,
    reason NVARCHAR(500),
    status VARCHAR(50) DEFAULT 'Pending',
    rejection_reason NVARCHAR(255),
    FOREIGN KEY (created_by) REFERENCES [User](user_id)
);

-- 26. Import_Request_Detail
CREATE TABLE Import_Request_Detail (
    detail_id INT IDENTITY(1,1) PRIMARY KEY,
    request_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (request_id) REFERENCES Import_Request(request_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- 27. Inventory_Transfer
CREATE TABLE Inventory_Transfer (
    it_id INT IDENTITY(1,1) PRIMARY KEY,
    source_warehouse_id INT NOT NULL,
    destination_warehouse_id INT NOT NULL,
    [date] DATETIME DEFAULT GETDATE(),
    status VARCHAR(50),
    description NVARCHAR(255),
    created_by INT,
    import_request_id INT NULL,
    alert_id INT NULL,
    FOREIGN KEY (source_warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (destination_warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (created_by) REFERENCES [User](user_id),
    FOREIGN KEY (import_request_id) REFERENCES Import_Request(request_id),
    FOREIGN KEY (alert_id) REFERENCES Reorder_Alert(alert_id)
);

CREATE INDEX IX_InventoryTransfer_ImportRequestId ON Inventory_Transfer(import_request_id);
CREATE INDEX IX_InventoryTransfer_AlertId ON Inventory_Transfer(alert_id);

-- 28. Inventory_Transfer_Item
CREATE TABLE Inventory_Transfer_Item (
    it_item_id INT IDENTITY(1,1) PRIMARY KEY,
    it_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (it_id) REFERENCES Inventory_Transfer(it_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- 29. Transfer_Order
CREATE TABLE Transfer_Order (
    to_id INT IDENTITY(1,1) PRIMARY KEY,
    source_warehouse_id INT NOT NULL,
    destination_warehouse_id INT,
    document_ref_id INT,
    document_ref_type VARCHAR(50),
    transfer_type VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'draft',
    description NVARCHAR(255),
    approved_by INT,
    created_by INT NOT NULL,
    transfer_date DATETIME DEFAULT GETDATE(),
    created_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (source_warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (destination_warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (approved_by) REFERENCES [User](user_id),
    FOREIGN KEY (created_by) REFERENCES [User](user_id)
);

-- 30. Transfer_Order_Item
CREATE TABLE Transfer_Order_Item (
    to_item_id INT IDENTITY(1,1) PRIMARY KEY,
    to_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (to_id) REFERENCES Transfer_Order(to_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- 31. StockCheckReport
CREATE TABLE StockCheckReport (
    report_id INT IDENTITY(1,1) PRIMARY KEY,
    report_code VARCHAR(50) UNIQUE NOT NULL,
    warehouse_id INT NOT NULL,
    report_date DATE NOT NULL,
    created_by INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    status VARCHAR(50) NOT NULL DEFAULT 'Pending',
    notes NVARCHAR(MAX),
    approved_by INT,
    approved_at DATETIME,
    manager_notes NVARCHAR(MAX),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (created_by) REFERENCES [User](user_id),
    FOREIGN KEY (approved_by) REFERENCES [User](user_id)
);

-- 32. StockCheckReportItem
CREATE TABLE StockCheckReportItem (
    report_item_id INT IDENTITY(1,1) PRIMARY KEY,
    report_id INT NOT NULL,
    product_id INT NOT NULL,
    system_quantity INT NOT NULL,
    counted_quantity INT NOT NULL,
    discrepancy INT NOT NULL,
    reason NVARCHAR(255),
    FOREIGN KEY (report_id) REFERENCES StockCheckReport(report_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- 33. Request_For_Quotation
CREATE TABLE Request_For_Quotation (
    rfq_id INT IDENTITY(1,1) PRIMARY KEY,
    created_by INT NOT NULL,
    request_date DATETIME NULL,
    status VARCHAR(50) NULL,
    notes NVARCHAR(500) NULL,
    supplier_id INT NOT NULL,
    description NVARCHAR(500) NULL,
    warehouse_id INT NULL,
    expected_delivery_date DATE NULL,
    FOREIGN KEY (created_by) REFERENCES [User](user_id),
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id)
);

-- 34. RFQ_Item
CREATE TABLE RFQ_Item (
    rfq_item_id INT IDENTITY(1,1) PRIMARY KEY,
    rfq_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (rfq_id) REFERENCES Request_For_Quotation(rfq_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- 35. Quotation
CREATE TABLE Quotation (
    quotation_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    valid_until DATETIME,
    total_amount DECIMAL(15,2) DEFAULT 0,
    notes NVARCHAR(500),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (user_id) REFERENCES [User](user_id)
);

-- 36. Quotation_Item
CREATE TABLE Quotation_Item (
    quotation_item_id INT IDENTITY(1,1) PRIMARY KEY,
    quotation_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    total_price DECIMAL(15,2) NULL,
    FOREIGN KEY (quotation_id) REFERENCES Quotation(quotation_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- 37. Product_Supplier
CREATE TABLE Product_Supplier (
    product_id INT NOT NULL,
    supplier_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (product_id, supplier_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id)
);

-- 38. AuthorizeMap
CREATE TABLE AuthorizeMap (
    id INT IDENTITY(1,1) PRIMARY KEY,
    path NVARCHAR(255) NULL,
    [user] VARCHAR(255) NULL
);

GO

-- =============================================================================
-- MOCK DATA - INSERT STATEMENTS
-- =============================================================================

-- 1. Role
INSERT INTO [Role] (role_name) VALUES
(N'Admin'),
(N'Warehouse Manager'),
(N'Sales Staff'),
(N'Warehouse Staff'),
(N'Purchase Staff');

-- 2. Warehouse (Fixed: Added manager_id for all rows)
SET IDENTITY_INSERT Warehouse ON;
INSERT INTO Warehouse (warehouse_id, warehouse_name, address, region, manager_id, status, created_at) VALUES
(1, N'Kho Hà Nội', N'123 Đường Láng, Đống Đa, Hà Nội', N'Miền Bắc', NULL, 'Active', GETDATE()),
(2, N'Kho Hồ Chí Minh', N'456 Cách Mạng Tháng 8, Quận 3, TP.HCM', N'Miền Nam', NULL, 'Active', GETDATE()),
(3, N'Kho Đà Nẵng', N'789 Trần Phú, Hải Châu, Đà Nẵng', N'Miền Trung', NULL, 'Active', GETDATE()),
(4, N'Kho Cần Thơ', N'101 Mậu Thân, Ninh Kiều, Cần Thơ', N'Miền Nam', NULL, 'Active', GETDATE()),
(5, N'Kho Hải Phòng', N'202 Lê Hồng Phong, Ngô Quyền, Hải Phòng', N'Miền Bắc', NULL, 'Active', GETDATE()),
(0, N'Kho Trung Chuyển', N'Transshipment Center', N'Toàn quốc', NULL, 'Active', GETDATE());
SET IDENTITY_INSERT Warehouse OFF;

-- Reset identity seed for Warehouse
DECLARE @MaxId INT;
SELECT @MaxId = MAX(warehouse_id) FROM Warehouse WHERE warehouse_id > 0;
IF @MaxId IS NOT NULL
    DBCC CHECKIDENT('Warehouse', RESEED, @MaxId);

-- 3. User
INSERT INTO [User] (username, password, first_name, last_name, role_id, gender, address, email, date_of_birth, profile_pic, status, warehouse_id) VALUES
----
--Kho Hà Nội warehouse id = 1
('managerHN1', '123456', N'Nguyễn Văn', N'Quang', 2, 'Male', N'123 Đường Láng, Hà Nội', 'managerHN1@example.com', '1990-01-01', 'manager.png', 'Active', 1),
('salesHN1', '123456', N'Trần Thị', N'Hương', 3, 'Female', N'456 Đường Láng, Hà Nội', 'salesHN1@example.com', '1995-02-15', 'sales.png', 'Active', 1),
('purchaseHN1', '123456', N'Phạm Minh', N'Đức', 5, 'Male', N'789 Đường Láng, Hà Nội', 'purchaseHN1@example.com', '1993-03-20', 'purchase.png', 'Active', 1),
('staffHN1', '123456', N'Lê Thị', N'Lan', 4, 'Female', N'101 Đường Láng, Hà Nội', 'staffHN1@example.com', '1997-04-10', 'staff.png', 'Active', 1),
--Kho Hồ Chí Minh warehouse id = 2
('managerHCM1', '123456', N'Ngô Văn', N'Hoàng', 2, 'Male', N'123 CMT8, TP.HCM', 'managerHCM1@example.com', '1991-05-05', 'manager.png', 'Active', 2),
('salesHCM1', '123456', N'Võ Thị', N'Mai', 3, 'Female', N'456 CMT8, TP.HCM', 'salesHCM1@example.com', '1994-06-12', 'sales.png', 'Active', 2),
('purchaseHCM1', '123456', N'Đỗ Minh', N'Thắng', 5, 'Male', N'789 CMT8, TP.HCM', 'purchaseHCM1@example.com', '1992-07-18', 'purchase.png', 'Active', 2),
('staffHCM1', '123456', N'Phan Thị', N'Bích', 4, 'Female', N'101 CMT8, TP.HCM', 'staffHCM1@example.com', '1996-08-25', 'staff.png', 'Active', 2),
--Kho Đà Nẵng warehouse id = 3
('managerDN1', '123456', N'Hoàng Văn', N'Phúc', 2, 'Male', N'123 Trần Phú, Đà Nẵng', 'managerDN1@example.com', '1990-09-01', 'manager.png', 'Active', 3),
('salesDN1', '123456', N'Nguyễn Thị', N'Yến', 3, 'Female', N'456 Trần Phú, Đà Nẵng', 'salesDN1@example.com', '1995-10-15', 'sales.png', 'Active', 3),
('purchaseDN1', '123456', N'Vũ Minh', N'Triều', 5, 'Male', N'789 Trần Phú, Đà Nẵng', 'purchaseDN1@example.com', '1993-11-20', 'purchase.png', 'Active', 3),
('staffDN1', '123456', N'Bùi Thị', N'Nhung', 4, 'Female', N'101 Trần Phú, Đà Nẵng', 'staffDN1@example.com', '1997-12-10', 'staff.png', 'Active', 3),
--Kho Cần Thơ warehouse id = 4
('managerCT1', '123456', N'Phạm Văn', N'Kiên', 2, 'Male', N'123 Mậu Thân, Cần Thơ', 'managerCT1@example.com', '1991-01-05', 'manager.png', 'Active', 4),
('salesCT1', '123456', N'Nguyễn Thị', N'Quỳnh', 3, 'Female', N'456 Mậu Thân, Cần Thơ', 'salesCT1@example.com', '1994-02-12', 'sales.png', 'Active', 4),
('purchaseCT1', '123456', N'Lê Minh', N'Tuấn', 5, 'Male', N'789 Mậu Thân, Cần Thơ', 'purchaseCT1@example.com', '1992-03-18', 'purchase.png', 'Active', 4),
('staffCT1', '123456', N'Trần Thị', N'Vân', 4, 'Female', N'101 Mậu Thân, Cần Thơ', 'staffCT1@example.com', '1996-04-25', 'staff.png', 'Active', 4),
--Kho Hải Phòng warehouse id = 5
('managerHP1', '123456', N'Đặng Văn', N'Bình', 2, 'Male', N'123 Lê Hồng Phong, Hải Phòng', 'managerHP1@example.com', '1990-05-01', 'manager.png', 'Active', 5),
('salesHP1', '123456', N'Phạm Thị', N'Ngọc', 3, 'Female', N'456 Lê Hồng Phong, Hải Phòng', 'salesHP1@example.com', '1995-06-15', 'sales.png', 'Active', 5),
('purchaseHP1', '123456', N'Nguyễn Minh', N'Quân', 5, 'Male', N'789 Lê Hồng Phong, Hải Phòng', 'purchaseHP1@example.com', '1993-07-20', 'purchase.png', 'Active', 5),
('staffHP1', '123456', N'Lê Thị', N'Thảo', 4, 'Female', N'101 Lê Hồng Phong, Hải Phòng', 'staffHP1@example.com', '1997-08-10', 'staff.png', 'Active', 5),
('admin01', 'admin123', N'Nguyễn Văn', N'Admin', 1, 'Male', N'123 Admin St, Hanoi', 'admin@example.com', '1990-01-01', 'admin.png', 'Active', NULL);

-- Update manager_id for Warehouse
UPDATE Warehouse
SET manager_id = (SELECT user_id FROM [User] WHERE username = 'managerHN1') WHERE warehouse_id = 1;
UPDATE Warehouse
SET manager_id = (SELECT user_id FROM [User] WHERE username = 'managerHCM1') WHERE warehouse_id = 2;
UPDATE Warehouse
SET manager_id = (SELECT user_id FROM [User] WHERE username = 'managerDN1') WHERE warehouse_id = 3;
UPDATE Warehouse
SET manager_id = (SELECT user_id FROM [User] WHERE username = 'managerCT1') WHERE warehouse_id = 4;
UPDATE Warehouse
SET manager_id = (SELECT user_id FROM [User] WHERE username = 'managerHP1') WHERE warehouse_id = 5;

-- 4. Unit
INSERT INTO Unit (unit_name, unit_code, description, is_active) VALUES 
('Pieces', 'pcs', N'Đơn vị đếm từng sản phẩm riêng lẻ', 1),
('Kilograms', 'kg', N'Đơn vị đo khối lượng theo kilôgam', 1),
('Meters', 'm', N'Đơn vị đo chiều dài theo mét', 1),
('Liters', 'l', N'Đơn vị đo thể tích theo lít', 1),
('Boxes', 'box', N'Đóng gói theo hộp tiêu chuẩn', 1),
('Pairs', 'pair', N'Bộ gồm hai sản phẩm giống nhau', 1),
('Cartons', 'ctn', N'Đóng gói theo thùng carton tiêu chuẩn', 1),
('Rolls', 'roll', N'Sản phẩm dạng cuộn', 1);

-- 5. Supplier
INSERT INTO Supplier (name, address, phone, email, contact_person, date_created, is_delete) VALUES
('VinaTech Supplies', N'123 Trần Hưng Đạo, Hà Nội', '0901234567', 'contact@vinatech.com', 'Trần Văn Tech', GETDATE(), 0),
('Hanoi Electronics', N'456 Lê Lợi, Hà Nội', '0912345678', 'sales@hanoielec.com', 'Nguyễn Văn Điện', GETDATE(), 0),
('Saigon Furniture', N'789 Nguyễn Huệ, TP.HCM', '0923456789', 'info@saigonfurn.com', 'Lê Thị Nội Thất', GETDATE(), 0),
('Danang Food Supply', N'101 Trần Phú, Đà Nẵng', '0934567890', 'order@danangfood.com', 'Phạm Thị Thực Phẩm', GETDATE(), 0),
('Green Farm Produce', N'202 Lê Duẩn, Huế', '0945678901', 'green@farmfresh.com', 'Hoàng Văn Nông', GETDATE(), 0);

INSERT INTO Product_Supplier (product_id, supplier_id, created_at)
SELECT p.product_id, s.supplier_id, GETDATE()
FROM Product p
CROSS JOIN Supplier s;

-- 6. Customer
INSERT INTO Customer (customer_name, address, phone, email, is_delete) VALUES
(N'Công ty TNHH ABC', N'123 Lê Lai, Quận 1, TP.HCM', '0901122334', 'contact@abc.com', 0),
(N'Cửa hàng điện tử XYZ', N'456 Nguyễn Trãi, Hà Nội', '0912233445', 'store@xyz.com', 0),
(N'Nhà hàng Phố Biển', N'789 Trần Phú, Nha Trang', '0923344556', 'seacity@restaurant.com', 0),
(N'Trường THPT Quốc Tế', N'101 Nam Kỳ Khởi Nghĩa, Đà Nẵng', '0934455667', 'info@international.edu.vn', 0),
(N'Bệnh viện Đa khoa MN', N'202 Lê Lợi, Cần Thơ', '0945566778', 'hospital@mn.com', 0);

-- 7. Product
INSERT INTO Product (code, name, description, unit_id, price, supplier_id) VALUES
('LP001', 'Laptop Acer Nitro 5', N'Gaming laptop với hiệu suất mạnh mẽ', 1, 18500000, 2),
('LP002', 'Laptop Dell XPS 13', N'Ultrabook cao cấp cho doanh nhân', 1, 25000000, 2),
('LP003', 'Laptop HP Pavilion', N'Laptop đa năng cho sinh viên và văn phòng', 1, 15000000, 2),
('LP004', 'Laptop Asus ROG Strix', N'Gaming laptop chuyên nghiệp', 1, 29000000, 1),
('LP005', 'Laptop Lenovo ThinkPad', N'Laptop doanh nhân bền bỉ', 1, 22000000, 1),
('LP006', 'Laptop MSI GF65', N'Gaming laptop tầm trung', 1, 19500000, 2),
('LP007', 'Laptop Apple MacBook Air', N'Laptop mỏng nhẹ cao cấp', 1, 28000000, 3),
('LP008', 'Laptop Surface Pro', N'Laptop lai máy tính bảng', 1, 24000000, 3),
('LP009', 'Laptop LG Gram', N'Laptop siêu nhẹ pin trâu', 1, 21500000, 1),
('LP010', 'Laptop Huawei MateBook', N'Laptop văn phòng thiết kế đẹp', 1, 17500000, 2);

-- 8. ProductAttribute
INSERT INTO ProductAttribute (product_id, attribute_name, attribute_value) VALUES
(1, 'CPU', 'Intel Core i5-11400H'),
(1, 'RAM', '8GB DDR4'),
(1, 'GPU', 'NVIDIA GeForce GTX 1650'),
(1, 'Storage', '512GB SSD'),
(1, 'Screen', '15.6" FHD 144Hz'),
(2, 'CPU', 'Intel Core i7-1165G7'),
(2, 'RAM', '16GB LPDDR4x'),
(2, 'GPU', 'Intel Iris Xe Graphics'),
(2, 'Storage', '512GB NVMe SSD'),
(2, 'Screen', '13.4" FHD+ Touch'),
(3, 'CPU', 'AMD Ryzen 5 5600H'),
(3, 'RAM', '8GB DDR4'),
(3, 'GPU', 'AMD Radeon Graphics'),
(3, 'Storage', '256GB SSD'),
(3, 'Screen', '15.6" FHD'),
(4, 'CPU', 'Intel Core i7-12700H'),
(4, 'RAM', '16GB DDR5'),
(4, 'GPU', 'NVIDIA RTX 3070'),
(4, 'Storage', '1TB NVMe SSD'),
(4, 'Screen', '15.6" QHD 165Hz'),
(5, 'CPU', 'Intel Core i5-1135G7'),
(5, 'RAM', '16GB DDR4'),
(5, 'GPU', 'Intel Iris Xe Graphics'),
(5, 'Storage', '512GB SSD'),
(5, 'Screen', '14" FHD IPS');

-- 9. Inventory
INSERT INTO Inventory (product_id, warehouse_id, quantity) VALUES
(1, 1, 150),
(2, 1, 120),
(3, 1, 200),
(5, 1, 180),
(7, 1, 90),
(10, 1, 160),
(1, 2, 130),
(2, 2, 100),
(4, 2, 80),
(5, 2, 140),
(8, 2, 110),
(3, 3, 170),
(4, 3, 70),
(6, 3, 120),
(9, 3, 135),
(1, 5, 95),
(2, 5, 85),
(6, 5, 110),
(7, 5, 75),
(9, 5, 105);

-- 10. Stock_Adjustment_Reason
INSERT INTO Stock_Adjustment_Reason (description) VALUES
('Sản phẩm bị hư hỏng'),
('Sản phẩm bị mất cắp'),
('Sai số kiểm kê'),
('Sản phẩm quá hạn'),
('Điều chỉnh nội bộ');

-- 11. Discount_Code
INSERT INTO Discount_Code (code, name, description, discount_type, discount_value, min_order_amount, max_discount_amount, start_date, end_date, usage_limit, created_by) VALUES
('SUMMER2025', 'Summer Sale 2025', N'Giảm giá mùa hè', 'PERCENTAGE', 15.00, 500000, 200000, '2025-06-01', '2025-08-31', 1000, 1),
('NEWCUSTOMER', 'New Customer Discount', N'Giảm giá khách hàng mới', 'PERCENTAGE', 10.00, 0, 100000, '2025-01-01', '2025-12-31', NULL, 1),
('FIXED50K', 'Fixed 50K Discount', N'Giảm cố định 50k', 'FIXED_AMOUNT', 50000, 200000, NULL, '2025-01-01', '2025-12-31', 500, 1),
('BLACKFRIDAY', 'Black Friday Special', N'Khuyến mãi Black Friday', 'PERCENTAGE', 25.00, 1000000, 500000, '2025-11-20', '2025-11-30', 200, 1),
('WELCOME10', 'Welcome New Customers', N'Chào mừng khách hàng mới', 'PERCENTAGE', 10.00, 100000, 50000, '2025-01-01', '2025-12-31', NULL, 1);

-- 12. Special_Discount_Request
INSERT INTO Special_Discount_Request (customer_id, requested_by, discount_type, discount_value, reason, estimated_order_value, status, approved_by, approved_at, generated_code, expiry_date) VALUES
(1, 2, 'PERCENTAGE', 20.00, N'Khách hàng VIP đặt hàng số lượng lớn', 100000000, 'Approved', 1, GETDATE(), 'VIP20-ABC', DATEADD(day, 30, GETDATE())),
(2, 6, 'FIXED_AMOUNT', 300000, N'Khách hàng lâu năm yêu cầu giảm giá đặc biệt', 5000000, 'Pending', NULL, NULL, NULL, NULL),
(3, 10, 'PERCENTAGE', 15.00, N'Đơn hàng lớn cho nhà hàng', 15000000, 'Rejected', 5, DATEADD(day, -1, GETDATE()), NULL, NULL);

-- 13. Purchase_Order
INSERT INTO Purchase_Order (supplier_id, user_id, [date], status) VALUES
(1, 5, DATEADD(day, -15, GETDATE()), 'Completed'),
(2, 5, DATEADD(day, -10, GETDATE()), 'Completed'),
(3, 5, DATEADD(day, -5, GETDATE()), 'Pending'),
(2, 5, DATEADD(day, -3, GETDATE()), 'Pending'),
(1, 5, DATEADD(day, -1, GETDATE()), 'Pending');

-- For user_id 3
INSERT INTO Purchase_Order (supplier_id, user_id, [date], status, expected_delivery_date, warehouse_id) VALUES
(1, 3, '2025-07-09 10:00:00', 'Completed', '2025-07-14', 1),
(2, 3, '2025-07-14 10:00:00', 'Completed', '2025-07-20', 1),
(3, 3, '2025-07-19 10:00:00', 'Completed',   '2025-07-25', 1),
(2, 3, '2025-07-21 10:00:00', 'Completed',   '2025-07-28', 1),
(1, 3, '2025-07-23 10:00:00', 'Completed',   '2025-07-30', 1);

-- For user_id 7
INSERT INTO Purchase_Order (supplier_id, user_id, [date], status, expected_delivery_date, warehouse_id) VALUES
(1, 7, '2025-07-09 10:00:00', 'Completed', '2025-07-14', 2),
(2, 7, '2025-07-14 10:00:00', 'Completed', '2025-07-20', 2),
(3, 7, '2025-07-19 10:00:00', 'Completed',   '2025-07-25', 2),
(2, 7, '2025-07-21 10:00:00', 'Completed',   '2025-07-28', 2),
(1, 7, '2025-07-23 10:00:00', 'Completed',   '2025-07-30', 2);

INSERT INTO Supplier_Rating (supplier_id, user_id, delivery_score, quality_score, service_score, price_score, comment, rating_date)
VALUES
-- Ratings by user_id 3
(2, 3, 7, 6, 8, 9, N'Affordable pricing but quality was average.', '2025-07-10 14:05:00'),
(4, 3, 8, 9, 8, 7, N'Consistent supplier. Satisfied overall.', '2025-07-18 09:40:00'),
(5, 3, 9, 8, 9, 8, N'Great service and timely delivery.', '2025-07-22 13:30:00'),

-- Ratings by user_id 7
(2, 7, 6, 5, 6, 6, N'Some delays in delivery and quality issues.', '2025-07-03 12:15:00'),
(3, 7, 10, 9, 10, 8, N'Excellent supplier. Will use again.', '2025-07-12 11:50:00'),
(5, 7, 8, 8, 7, 9, N'Good value and responsive support.', '2025-07-21 16:30:00');

-- 14. Purchase_Order_Item
INSERT INTO Purchase_Order_Item (po_id, product_id, quantity, unit_price) VALUES
(1, 1, 10, 16000000),
(1, 4, 5, 25000000),
(2, 2, 8, 22000000),
(2, 3, 15, 13000000),
(3, 5, 10, 19000000),
(3, 7, 5, 25000000),
(4, 6, 10, 17000000),
(4, 9, 5, 19000000),
(5, 8, 8, 21000000),
(5, 10, 12, 15000000),
(6, 1, 10, 16000000),
(6, 4, 5, 25000000),
(7, 2, 8, 22000000),
(7, 3, 15, 13000000),
(8, 5, 10, 19000000),
(8, 7, 5, 25000000),
(9, 6, 10, 17000000),
(9, 9, 5, 19000000),
(10, 8, 8, 21000000),
(10, 10, 12, 15000000);


-- 15. Sales_Order
INSERT INTO Sales_Order (customer_id, user_id, warehouse_id, [date], status, order_number, total_amount, total_before_discount, discount_amount, discount_code_id, delivery_date, delivery_address, notes) VALUES
(1, 5, 1, DATEADD(day, -1, GETDATE()), 'Order', 'SO-2025001', 92500000, 92500000, 0, NULL, DATEADD(day, 3, GETDATE()), N'123 Lê Lai, Quận 1, TP.HCM', N'Đơn hàng laptop gaming cho văn phòng'),
(2, 5, 2, DATEADD(day, -2, GETDATE()), 'Order', 'SO-2025002', 72900000, 81000000, 8100000, 2, DATEADD(day, 5, GETDATE()), N'456 Nguyễn Trãi, Hà Nội', N'Laptop doanh nhân cao cấp - Áp dụng NEWCUSTOMER'),
(3, 5, 1, DATEADD(day, -3, GETDATE()), 'Order', 'SO-2025003', 124000000, 124000000, 0, NULL, DATEADD(day, 7, GETDATE()), N'789 Trần Phú, Nha Trang', N'Đơn hàng laptop đa năng cho học sinh'),
(4, 5, 3, DATEADD(day, -5, GETDATE()), 'Delivery', 'SO-2025004', 58000000, 58000000, 0, NULL, DATEADD(day, 2, GETDATE()), N'101 Nam Kỳ Khởi Nghĩa, Đà Nẵng', N'Giao hàng express cho trường học'),
(5, 5, 2, DATEADD(day, -6, GETDATE()), 'Delivery', 'SO-2025005', 41000000, 91000000, 50000, 3, DATEADD(day, 1, GETDATE()), N'202 Lê Lợi, Cần Thơ', N'Laptop cho bệnh viện - ưu tiên - Áp dụng FIXED50K'),
(1, 5, 1, DATEADD(day, -7, GETDATE()), 'Delivery', 'SO-2025006', 177500000, 177500000, 0, NULL, GETDATE(), N'123 Lê Lai, Quận 1, TP.HCM', N'Đơn hàng lớn - giao theo lịch hẹn'),
(2, 5, 2, DATEADD(day, -12, GETDATE()), 'Completed', 'SO-2025007', 69000000, 69000000, 0, NULL, DATEADD(day, -8, GETDATE()), N'456 Nguyễn Trãi, Hà Nội', N'Đã giao thành công - khách hàng hài lòng'),
(3, 5, 3, DATEADD(day, -15, GETDATE()), 'Completed', 'SO-2025008', 95000000, 95000000, 0, NULL, DATEADD(day, -12, GETDATE()), N'789 Trần Phú, Nha Trang', N'Giao cho nhà hàng - thanh toán đầy đủ'),
(4, 5, 1, DATEADD(day, -18, GETDATE()), 'Completed', 'SO-2025009', 162000000, 162000000, 0, NULL, DATEADD(day, -15, GETDATE()), N'101 Nam Kỳ Khởi Nghĩa, Đà Nẵng', N'Đơn hàng cho trường quốc tế - đã nghiệm thu'),
(5, 5, 2, DATEADD(day, -20, GETDATE()), 'Completed', 'SO-2025010', 94500000, 94500000, 0, NULL, DATEADD(day, -17, GETDATE()), N'202 Lê Lợi, Cần Thơ', N'Thiết bị y tế - bảo hành 3 năm');

-- 16. Sales_Order_Item
INSERT INTO Sales_Order_Item (so_id, product_id, quantity, unit_price, selling_price) VALUES
(1, 1, 3, 18500000, 20500000),
(1, 4, 1, 29000000, 32000000),
(1, 9, 2, 21500000, 24000000),
(2, 2, 3, 25000000, 27000000),
(3, 3, 4, 15000000, 16000000),
(3, 5, 2, 22000000, 24000000),
(3, 10, 2, 17500000, 18000000),
(4, 3, 2, 15000000, 16500000),
(4, 8, 1, 24000000, 25000000),
(5, 1, 2, 18500000, 20000000),
(5, 9, 1, 21500000, 23000000),
(5, 5, 1, 22000000, 23000000),
(5, 8, 1, 24000000, 25000000),
(6, 7, 3, 28000000, 30500000),
(6, 2, 2, 25000000, 27000000),
(6, 4, 1, 29000000, 32000000),
(7, 3, 3, 15000000, 16000000),
(7, 6, 1, 19500000, 21000000),
(8, 4, 1, 29000000, 31000000),
(8, 1, 2, 18500000, 20000000),
(8, 5, 1, 22000000, 24000000),
(9, 7, 2, 28000000, 30000000),
(9, 2, 2, 25000000, 27000000),
(9, 9, 1, 21500000, 23000000),
(9, 8, 1, 24000000, 25000000),
(10, 1, 1, 18500000, 19500000),
(10, 3, 2, 15000000, 16000000),
(10, 8, 1, 24000000, 25000000),
(10, 10, 1, 17500000, 18000000),
(10, 6, 1, 19500000, 21000000);

-- 17. Discount_Usage_Log
INSERT INTO Discount_Usage_Log (discount_code_id, sales_order_id, customer_id, used_by, order_total, discount_amount, used_at) VALUES
(2, 2, 2, 5, 81000000, 8100000, DATEADD(day, -2, GETDATE())),
(3, 5, 5, 5, 91000000, 50000, DATEADD(day, -6, GETDATE()));

-- 18. Inventory_Transfer
INSERT INTO Inventory_Transfer (source_warehouse_id, destination_warehouse_id, [date], status, description, created_by) VALUES
(1, 2, DATEADD(day, -10, GETDATE()), 'Completed', N'Chuyển hàng định kỳ tháng 6', 2),
(2, 3, DATEADD(day, -7, GETDATE()), 'Completed', N'Bổ sung hàng cho kho miền Trung', 2),
(3, 1, DATEADD(day, -5, GETDATE()), 'Processing', N'Chuyển sản phẩm bán chậm về kho chính', 4),
(1, 3, DATEADD(day, -2, GETDATE()), 'Pending', N'Chuyển hàng mới về kho Đà Nẵng', 2),
(2, 5, DATEADD(day, -1, GETDATE()), 'Pending', N'Bổ sung hàng cho kho Hải Phòng', 4);

-- 19. Inventory_Transfer_Item
INSERT INTO Inventory_Transfer_Item (it_id, product_id, quantity) VALUES
(1, 1, 10),
(1, 3, 15),
(2, 4, 5),
(2, 6, 10),
(3, 7, 5),
(3, 9, 8),
(4, 2, 10),
(4, 5, 7),
(5, 8, 6),
(5, 10, 9);

-- 20. StockCheckReport
INSERT INTO StockCheckReport (report_code, warehouse_id, report_date, created_by, status, notes, approved_by, approved_at, manager_notes) VALUES
('SCR-001', 1, DATEADD(day, -15, GETDATE()), 4, 'Completed', N'Kiểm kê định kỳ kho Hà Nội', 2, DATEADD(day, -14, GETDATE()), N'Đã xử lý chênh lệch'),
('SCR-002', 2, DATEADD(day, -10, GETDATE()), 4, 'Pending', N'Kiểm kê kho HCM - Phát hiện thiếu hàng', NULL, NULL, NULL),
('SCR-003', 3, DATEADD(day, -5, GETDATE()), 2, 'Approved', N'Kiểm kê kho Đà Nẵng - Số liệu khớp', 2, DATEADD(day, -4, GETDATE()), N'Không có vấn đề');

-- 21. StockCheckReportItem
INSERT INTO StockCheckReportItem (report_id, product_id, system_quantity, counted_quantity, discrepancy, reason) VALUES
(1, 1, 150, 148, -2, N'Hỏng 2 sản phẩm'),
(1, 2, 120, 120, 0, N'Khớp số liệu'),
(2, 4, 80, 79, -1, N'Nghi ngờ mất cắp'),
(2, 5, 140, 139, -1, N'Thất thoát không rõ lý do'),
(3, 6, 120, 120, 0, N'Số liệu chính xác');

-- 22. Stock_Adjustment
INSERT INTO Stock_Adjustment (product_id, warehouse_id, quantity_change, reason_id, user_id, [date]) VALUES
(1, 1, -2, 1, 2, DATEADD(day, -14, GETDATE())),
(4, 2, -1, 1, 2, DATEADD(day, -9, GETDATE())),
(6, 3, -2, 2, 4, DATEADD(day, -7, GETDATE())),
(2, 1, 1, 3, 2, DATEADD(day, -5, GETDATE())),
(5, 2, -1, 4, 4, DATEADD(day, -3, GETDATE()));

-- 23. Inventory_Transaction
INSERT INTO Inventory_Transaction (product_id, warehouse_id, quantity, transaction_type, related_id, created_by, created_at) VALUES
(1, 1, 10, 'import', 1, 5, DATEADD(day, -15, GETDATE())),
(4, 1, 5, 'import', 1, 5, DATEADD(day, -15, GETDATE())),
(2, 1, 8, 'import', 2, 5, DATEADD(day, -10, GETDATE())),
(3, 1, 15, 'import', 2, 5, DATEADD(day, -10, GETDATE())),
(1, 1, -3, 'export', 1, 5, DATEADD(day, -12, GETDATE())),
(4, 1, -1, 'export', 1, 5, DATEADD(day, -12, GETDATE())),
(5, 1, -1, 'export', 1, 5, DATEADD(day, -12, GETDATE())),
(2, 1, -3, 'export', 2, 5, DATEADD(day, -8, GETDATE())),
(1, 1, -10, 'transfer', 1, 2, DATEADD(day, -10, GETDATE())),
(1, 2, 10, 'transfer', 1, 2, DATEADD(day, -10, GETDATE())),
(3, 1, -15, 'transfer', 1, 2, DATEADD(day, -10, GETDATE())),
(3, 2, 15, 'transfer', 1, 2, DATEADD(day, -10, GETDATE())),
(1, 1, -2, 'adjust', 1, 2, DATEADD(day, -14, GETDATE())),
(4, 2, -1, 'adjust', 2, 2, DATEADD(day, -9, GETDATE())),
(6, 3, -2, 'adjust', 3, 4, DATEADD(day, -7, GETDATE()));

-- 26. Reorder_Alert
INSERT INTO Reorder_Alert (product_id, warehouse_id, warning_threshold, critical_threshold, current_stock, created_by, alert_start_date, alert_expiry_date, alert_duration_days) VALUES
(1, 1, 100, 50, 150, 2, DATEADD(day, -5, GETDATE()), DATEADD(day, 25, GETDATE()), 30),
(2, 2, 80, 40, 100, 5, DATEADD(day, -3, GETDATE()), DATEADD(day, 27, GETDATE()), 30),
(3, 3, 120, 60, 170, 4, DATEADD(day, -2, GETDATE()), DATEADD(day, 28, GETDATE()), 30),
(4, 2, 60, 30, 80, 5, DATEADD(day, -4, GETDATE()), DATEADD(day, 26, GETDATE()), 30),
(5, 1, 100, 50, 180, 2, DATEADD(day, -1, GETDATE()), DATEADD(day, 29, GETDATE()), 30),
(6, 3, 80, 40, 120, 4, DATEADD(day, -6, GETDATE()), DATEADD(day, 24, GETDATE()), 30),
(7, 1, 60, 30, 90, 2, DATEADD(day, -7, GETDATE()), DATEADD(day, 23, GETDATE()), 30),
(8, 2, 80, 40, 110, 5, DATEADD(day, -8, GETDATE()), DATEADD(day, 22, GETDATE()), 30),
(9, 3, 100, 50, 135, 4, DATEADD(day, -9, GETDATE()), DATEADD(day, 21, GETDATE()), 30),
(10, 1, 100, 50, 160, 2, DATEADD(day, -10, GETDATE()), DATEADD(day, 20, GETDATE()), 30);

-- Update current_stock for Reorder_Alert
UPDATE ra 
SET current_stock = ISNULL(i.quantity, 0)
FROM Reorder_Alert ra
LEFT JOIN Inventory i ON ra.product_id = i.product_id AND ra.warehouse_id = i.warehouse_id;

-- 28. Import_Request
INSERT INTO Import_Request (request_date, created_by, reason, status) VALUES
(GETDATE(), 5, N'Bổ sung hàng tồn kho thấp', 'Pending'),
(DATEADD(day, -2, GETDATE()), 5, N'Chuẩn bị cho mùa cao điểm', 'Approved');

-- 29. Import_Request_Detail
INSERT INTO Import_Request_Detail (request_id, product_id, quantity) VALUES
(1, 4, 20),
(1, 7, 15),
(2, 6, 25),
(2, 8, 10);

-- 30. Product_Supplier
INSERT INTO Product_Supplier (product_id, supplier_id, created_at) VALUES
(1, 1, GETDATE()),
(1, 2, GETDATE()),
(1, 3, GETDATE()),
(1, 4, GETDATE()),
(1, 5, GETDATE()),
(2, 1, GETDATE()),
(2, 2, GETDATE()),
(2, 3, GETDATE()),
(2, 4, GETDATE()),
(2, 5, GETDATE()),
(3, 1, GETDATE()),
(3, 2, GETDATE()),
(3, 3, GETDATE()),
(3, 4, GETDATE()),
(3, 5, GETDATE()),
(4, 1, GETDATE()),
(4, 2, GETDATE()),
(4, 3, GETDATE()),
(4, 4, GETDATE()),
(4, 5, GETDATE()),
(5, 1, GETDATE()),
(5, 2, GETDATE()),
(5, 3, GETDATE()),
(5, 4, GETDATE()),
(5, 5, GETDATE()),
(6, 1, GETDATE()),
(6, 2, GETDATE()),
(6, 3, GETDATE()),
(6, 4, GETDATE()),
(6, 5, GETDATE()),
(7, 1, GETDATE()),
(7, 2, GETDATE()),
(7, 3, GETDATE()),
(7, 4, GETDATE()),
(7, 5, GETDATE()),
(8, 1, GETDATE()),
(8, 2, GETDATE()),
(8, 3, GETDATE()),
(8, 4, GETDATE()),
(8, 5, GETDATE()),
(9, 1, GETDATE()),
(9, 2, GETDATE()),
(9, 3, GETDATE()),
(9, 4, GETDATE()),
(9, 5, GETDATE()),
(10, 1, GETDATE()),
(10, 2, GETDATE()),
(10, 3, GETDATE()),
(10, 4, GETDATE()),
(10, 5, GETDATE());

-- 31. Transfer_Order
INSERT INTO Transfer_Order (source_warehouse_id, destination_warehouse_id, transfer_type, status, description, created_by, transfer_date) VALUES
(1, 2, 'Internal', 'completed', N'Chuyển hàng định kỳ', 4, DATEADD(day, -10, GETDATE())),
(2, 3, 'Internal', 'pending', N'Bổ sung hàng cho kho miền Trung', 8, DATEADD(day, -3, GETDATE())),
(3, 1, 'Internal', 'draft', N'Chuyển sản phẩm bán chậm', 12, DATEADD(day, -1, GETDATE()));

-- 32. Transfer_Order_Item
INSERT INTO Transfer_Order_Item (to_id, product_id, quantity) VALUES
(1, 1, 15),
(1, 3, 20),
(2, 4, 8),
(2, 6, 12),
(3, 7, 10),
(3, 9, 15);

-- 33. Request_For_Quotation
INSERT INTO Request_For_Quotation (created_by, request_date, status, notes, supplier_id, description, warehouse_id, expected_delivery_date) VALUES
(3, DATEADD(day, -5, GETDATE()), 'Pending', N'Yêu cầu báo giá laptop gaming', 1, N'Báo giá cho laptop gaming cao cấp', 1, DATEADD(day, 15, GETDATE())),
(7, DATEADD(day, -3, GETDATE()), 'Sent', N'Báo giá laptop văn phòng', 2, N'Laptop cho doanh nghiệp', 2, DATEADD(day, 20, GETDATE())),
(11, DATEADD(day, -1, GETDATE()), 'Draft', N'Yêu cầu báo giá cho MacBook', 3, N'MacBook cho thiết kế', 3, DATEADD(day, 25, GETDATE()));

-- 34. RFQ_Item
INSERT INTO RFQ_Item (rfq_id, product_id, quantity) VALUES
(1, 1, 50),
(1, 4, 30),
(2, 2, 40),
(2, 5, 25),
(3, 7, 20),
(3, 8, 15);

-- 35. Quotation
INSERT INTO Quotation (customer_id, user_id, created_at, valid_until, total_amount, notes) VALUES
(1, 2, DATEADD(day, -10, GETDATE()), DATEADD(day, 20, GETDATE()), 185000000, N'Báo giá laptop gaming cho văn phòng'),
(2, 6, DATEADD(day, -7, GETDATE()), DATEADD(day, 23, GETDATE()), 135000000, N'Báo giá laptop doanh nhân'),
(3, 10, DATEADD(day, -3, GETDATE()), DATEADD(day, 27, GETDATE()), 98000000, N'Báo giá laptop cho nhà hàng');

-- 36. Quotation_Item
INSERT INTO Quotation_Item (quotation_id, product_id, quantity, unit_price, total_price) VALUES
(1, 1, 5, 20500000, 102500000),
(1, 4, 2, 32000000, 64000000),
(1, 9, 1, 24000000, 24000000),
(2, 2, 3, 27000000, 81000000),
(2, 5, 2, 24000000, 48000000),
(3, 3, 4, 16000000, 64000000),
(3, 10, 2, 18000000, 36000000);


ALTER TABLE [dbo].[Import_Request]
ADD [order_type] varchar(50) NULL;

-- =============================================================================
-- AUTHORIZATION MAP - PERMISSIONS
-- =============================================================================

INSERT INTO AuthorizeMap (path, [user]) VALUES
('/manager/low-stock-alerts', 'Warehouse Manager'),
('/manager/low-stock-config', 'Warehouse Manager'),
('/manager/alert-history', 'Warehouse Manager'),
('/manager/alert/create', 'Warehouse Manager'),
('/manager/alert/update', 'Warehouse Manager'),
('/manager/alert/delete', 'Warehouse Manager'),
('/manager/alert/cleanup-expired', 'Warehouse Manager'),
('/sale/createCustomer', 'Sales Staff'),
('/sale/customerDetail', 'Sales Staff'),
('/sale/deleteCustomer', 'Sales Staff'),
('/sale/listCustomer', 'Sales Staff'),
('/sale/updateCustomer', 'Sales Staff'),
('/sale/createCustomerQuote', 'Sales Staff'),
('/sale/customerQuoteDetail', 'Sales Staff'),
('/sale/listCustomerQuote', 'Sales Staff'),
('/sale/requestImport', 'Sales Staff'),
('/sale/importRequestEdit', 'Sales Staff'),
('/sale/importRequestList', 'Sales Staff'),
('/sale/importRequestViewDetail', 'Sales Staff'),
('/manager/inventory-report', 'Warehouse Manager'),
('/manager/create-inventory-transfer', 'Warehouse Manager'),
('/manager/list-inventory-transfer', 'Warehouse Manager'),
('/manager/view-inventory-transfer', 'Warehouse Manager'),
('/admin/create-product', 'admin'),
('/admin/delete-product', 'admin'),
('/admin/edit-product', 'admin'),
('/admin/list-product', 'admin'),
('/purchase/purchase-order', 'Purchase Staff'),
('/purchase/supplier-rating', 'Purchase Staff'),
('/sale/create-sales-order', 'Sales Staff'),
('/sale/edit-sales-order', 'Sales Staff'),
('/sale/get-products-by-warehouse', 'Sales Staff'),
('/sale/sales-report', 'Sales Staff'),
('/sale/view-sales-order-detail', 'Sales Staff'),
('/sale/view-sales-order-list', 'Sales Staff'),
('/manager/approveImportRequest', 'Warehouse Manager'),
('/manager/approve-sales-order', 'Warehouse Manager'),
('/manager/manage-sale-order', 'Warehouse Manager'),
('/manager/stock-level', 'Warehouse Manager'),
('/manager/stock-request', 'Warehouse Manager'),
('/manager/process-import-request', 'Warehouse Manager'),
('/manager/reject-sales-order', 'Warehouse Manager'),
('/manager/stock-adjustment-detail', 'Warehouse Manager'),
('/manager/create-stock-check-report', 'Warehouse Manager'),
('/manager/list-stock-check-reports', 'Warehouse Manager'),
('/manager/manage-stock-check-report', 'Warehouse Manager'),
('/purchase/manage-supplier', 'Purchase Staff'),
('/purchase/purchase-request-view', 'Purchase Staff'),
('/purchase/purchase-request-view?action=list', 'Purchase Staff'),
('/purchase/purchase-request-view?action=view', 'Purchase Staff'),
('/manager/purchase-request', 'Warehouse Manager'),
('/manager/purchase-request?action=create', 'Warehouse Manager'),
('/manager/purchase-request?action=list', 'Warehouse Manager'),
('/manager/purchase-request?action=view', 'Warehouse Manager'),
('/manager/purchase-request?action=edit', 'Warehouse Manager'),
('/manager/purchase-request?action=approve', 'Warehouse Manager'),
('/manager/purchase-request?action=reject', 'Warehouse Manager'),
('/manager/purchase-request?action=delete', 'Warehouse Manager'),
('/staff/complete-transfer-order', 'Warehouse Staff'),
('/staff/create-transfer-order', 'Warehouse Staff'),
('/staff/delete-transfer-order', 'Warehouse Staff'),
('/staff/edit-transfer-order', 'Warehouse Staff'),
('/staff/list-transfer-order', 'Warehouse Staff'),
('/staff/view-transfer-order', 'Warehouse Staff'),
('/admin/create-unit', 'admin, Warehouse Staff'),
('/admin/delete-unit', 'admin'),
('/admin/edit-unit', 'admin'),
('/admin/list-unit', 'admin'),
('/admin/restore-unit', 'admin'),
('/admin/users', 'admin'),
('/admin/add', 'admin'),
('/admin/user-deactivate', 'admin'),
('/admin/user-activate', 'admin'),
('/admin/UserProfile', 'admin'),
('/manager/UserProfile', 'Warehouse Manager'),
('/sale/UserProfile', 'Sales Staff'),
('/staff/UserProfile', 'Warehouse Staff'),
('/purchase/UserProfile', 'Purchase Staff'),
('/admin/admindashboard', 'admin, Warehouse Manager'),
('/manager/manager-dashboard', 'Warehouse Manager, Warehouse Staff, Purchase Staff'),
('/purchase/purchase-dashboard', 'Purchase Staff'),
('/purchase/rfq', 'Purchase Staff'),
('/staff/warehouse-staff-dashboard', 'Warehouse Staff'),
('/forgotpass', 'all user'),
('/login', 'all user, guest'),
('/logout', 'all user'),
('/register', 'guest'),
('/changePassword', 'all user'),
('/staff/inventory-detail', 'Warehouse Staff'),
('/staff/inventory-list', 'Warehouse Staff'),
('/staff/inventory-ws-overview', 'Warehouse Staff'),
('/staff/ws-warehouse-inventory', 'Warehouse Staff'),
-- Discount Code Permissions
('/manager/discount-codes', 'Warehouse Manager'),
('/manager/create-discount-code', 'Warehouse Manager'),
('/manager/edit-discount-code', 'Warehouse Manager'),
('/manager/delete-discount-code', 'Warehouse Manager'),
('/manager/special-discount-requests', 'Warehouse Manager'),
('/manager/approve-special-discount', 'Warehouse Manager'),
('/manager/reject-special-discount', 'Warehouse Manager'),
('/sale/available-discount-codes', 'Sales Staff'),
('/sale/validate-discount-code', 'Sales Staff'),
('/sale/apply-discount-to-order', 'Sales Staff'),
('/sale/request-special-discount', 'Sales Staff'),
('/sale/my-special-requests', 'Sales Staff');
USE ISP392_DTB;
GO

INSERT INTO [User] 
(username, password, first_name, last_name, role_id, gender, address, email, date_of_birth, profile_pic, status, warehouse_id)
VALUES
('minhnc', 'Minh9504', N'Nguyen Cong', N'Minh', 2, 'Male', N'Hanoi', 'minhnc@gmail.com', '2004-05-19', 'profile.png', 'Active', 1);


select *from User
=======
/* SET SCHEMA 'master' */;
GO

-- SQLINES DEMO *** exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Warehouse')
BEGIN
    ALTER DATABASE Warehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Warehouse;
END
GO


-- Cr... SQLINES DEMO ***
CREATE DATABASE Warehouse;
GO
/* SET SCHEMA 'Warehouse' */;
GO

-- SQLINES DEMO *** ey exist (in reverse dependency order)
DROP TABLE IF EXISTS 
    Discount_Usage_Log,
    Special_Discount_Request,
    Alert_History,
    Reorder_Alert,
    StockCheckReportItem, 
    StockCheckReport,
    Stock_Adjustment,
    Stock_Adjustment_Reason,
    Sales_Order_Item,
    Sales_Order,
    Purchase_Order_Item,
    Purchase_Order,
    RFQ_Item,
    Request_For_Quotation,
    Import_Request_Detail,
    Import_Request,
    Transfer_Order_Item,
    Transfer_Order,
    Inventory_Transfer_Item,
    Inventory_Transfer,
    Inventory_Transaction,
    Inventory,
    ProductAttribute,
    Product,
    Unit,
    Supplier_Rating,
    Supplier,
    Customer,
    Purchase_Request_Item,
    Purchase_Request,
    Discount_Code,
    Quotation_Item,
    Quotation,
    Product_Supplier,
    AuthorizeMap,
    [User],
    Warehouse,
    [Role];


-- 1.... SQLINES DEMO ***
-- SQLINES FOR EVALUATION USE ONLY (14 DAYS)
CREATE TABLE [Role] (
    role_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL
);

-- 2.... SQLINES DEMO ***
CREATE TABLE Warehouse (
    warehouse_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    warehouse_name VARCHAR(100) UNIQUE NOT NULL,
    address VARCHAR(255),
    region VARCHAR(50),
    manager_id INT, -- SQLINES DEMO *** ed later
    status VARCHAR(50),
    created_at TIMESTAMP(0) DEFAULT NOW()
);

-- 3.... SQLINES DEMO ***

CREATE TABLE [User] (
    user_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role_id INT NOT NULL,
    gender VARCHAR(10),
    address VARCHAR(255),
    email VARCHAR(100),
    date_of_birth DATE,
    profile_pic VARCHAR(255),
    status VARCHAR(10) NOT NULL DEFAULT 'Active',
    warehouse_id INT NULL,
    CONSTRAINT FK_User_Role FOREIGN KEY (role_id) REFERENCES [Role](role_id),
    CONSTRAINT CK_User_Status CHECK (status IN ('Active', 'Deactive'))
);

CREATE INDEX IX_User_Status ON [User](status);
CREATE INDEX IX_User_Username_Status ON [User](username, status);

-- SQLINES DEMO *** se.manager_id after User exists
ALTER TABLE Warehouse
ADD CONSTRAINT FK_Warehouse_Manager FOREIGN KEY (manager_id) REFERENCES [User](user_id);

-- SQLINES DEMO *** to Warehouse
ALTER TABLE [User]
ADD CONSTRAINT FK_User_Warehouse FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id);

-- 4.... SQLINES DEMO ***
CREATE TABLE Customer (
    customer_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(100),
    is_delete SMALLINT DEFAULT 0
);
-- 5.... SQLINES DEMO ***
CREATE TABLE Supplier (
    supplier_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(100),
    contact_person VARCHAR(100),
    date_created TIMESTAMP(0) DEFAULT NOW(),
    last_updated TIMESTAMP(0),
    is_delete SMALLINT
);
select * from Supplier

-- 6.... SQLINES DEMO ***
CREATE TABLE Supplier_Rating (
    rating_id INT IDENTITY(1,1) PRIMARY KEY,
    supplier_id INT NOT NULL,
    user_id INT NOT NULL,
    delivery_score INT,
    quality_score INT,
    service_score INT,
    price_score INT,
    comment NVARCHAR(1000),
    rating_date DATETIME,
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id),
    FOREIGN KEY (user_id) REFERENCES [User](user_id)
);

-- 7.... SQLINES DEMO ***
CREATE TABLE Unit (
    unit_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    unit_name VARCHAR(50) NOT NULL UNIQUE,
    unit_code VARCHAR(10) NOT NULL UNIQUE,
    description VARCHAR(255),
    is_active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP(0) DEFAULT NOW(),
    last_updated TIMESTAMP(0)
);

-- 8.... SQLINES DEMO ***
CREATE TABLE Product (
    product_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    unit_id INT,
    price DECIMAL(15,2),
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id),
    FOREIGN KEY (unit_id) REFERENCES Unit(unit_id)
);

-- 9.... SQLINES DEMO ***
CREATE TABLE ProductAttribute (
    attribute_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    product_id INT NOT NULL,
    attribute_name VARCHAR(50) NOT NULL,
    attribute_value TEXT NOT NULL,
    created_at TIMESTAMP(0) DEFAULT NOW(),
    last_updated TIMESTAMP(0) DEFAULT NOW(),
    FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE CASCADE
);

CREATE INDEX IX_ProductAttribute_ProductId ON ProductAttribute(product_id);
CREATE INDEX IX_ProductAttribute_Name_Product ON ProductAttribute(attribute_name, product_id);

-- 10... SQLINES DEMO ***
CREATE TABLE Inventory (
    inventory_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    quantity INT DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    UNIQUE (product_id, warehouse_id)
);

-- SQLINES DEMO *** nsaction
CREATE TABLE Inventory_Transaction (
    transaction_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    quantity INT NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    related_id INT,
    created_by INT,
    created_at TIMESTAMP(0) DEFAULT NOW(),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (created_by) REFERENCES [User](user_id)
);

-- SQLINES DEMO *** est
CREATE TABLE Purchase_Request (
    pr_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    pr_number VARCHAR(50) UNIQUE NOT NULL,
    requested_by INT NOT NULL,
    request_date TIMESTAMP(0) DEFAULT NOW(),
    warehouse_id INT NOT NULL,
    preferred_delivery_date DATE NULL,
    reason VARCHAR(1000) NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    confirm_by INT NULL,
    created_at TIMESTAMP(0) DEFAULT NOW(),
    FOREIGN KEY (requested_by) REFERENCES [User](user_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (confirm_by) REFERENCES [User](user_id)
);

-- SQLINES DEMO *** est_Item
CREATE TABLE Purchase_Request_Item (
    pr_item_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    pr_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    note VARCHAR(255)
    FOREIGN KEY (pr_id) REFERENCES Purchase_Request(pr_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- 14... SQLINES DEMO ***
CREATE TABLE Reorder_Alert (
    alert_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    warning_threshold INT NOT NULL,
    critical_threshold INT NOT NULL,
    triggered_date TIMESTAMP(0) DEFAULT NOW(),
    current_stock INT NOT NULL,
    is_active BOOLEAN DEFAULT 1,
    created_by INT NOT NULL,
    created_at TIMESTAMP(0) DEFAULT NOW(),
    last_updated TIMESTAMP(0) DEFAULT NOW(),
    alert_start_date TIMESTAMP(0) DEFAULT NOW(),
    alert_expiry_date TIMESTAMP(0) NULL,
    alert_duration_days INT DEFAULT 30,
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (created_by) REFERENCES [User](user_id),
    UNIQUE (product_id, warehouse_id)
);

-- 15... SQLINES DEMO ***
CREATE TABLE Alert_History (
    history_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    alert_id INT NOT NULL,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    action_type VARCHAR(50) NOT NULL, -- SQLINES DEMO *** ED', 'RESOLVED_BY_PURCHASE', 'EXPIRED', 'DEACTIVATED'
    alert_level VARCHAR(20) NOT NULL, -- SQLINES DEMO *** CAL', 'OUT_OF_STOCK', 'STABLE'
    -- SQLINES DEMO *** tại thời điểm action
    warning_threshold INT NOT NULL,
    critical_threshold INT NOT NULL,
    stock_quantity INT NOT NULL,
    -- SQLINES DEMO *** i (cho action UPDATE)
    old_warning_threshold INT NULL,
    old_critical_threshold INT NULL,
    old_expiry_date TIMESTAMP(0) NULL,
    new_expiry_date TIMESTAMP(0) NULL,
    -- SQLINES DEMO *** yết
    resolved_by_purchase_request_id INT NULL, -- SQLINES DEMO *** equest nếu được giải quyết
    resolved_by_user_id INT NULL, -- SQLINES DEMO *** ải quyết
    -- Th... SQLINES DEMO ***
    action_date TIMESTAMP(0) DEFAULT NOW(),
    alert_start_date TIMESTAMP(0) NULL,
    alert_expiry_date TIMESTAMP(0) NULL,
    -- SQLINES DEMO *** hực hiện và ghi chú
    performed_by INT NOT NULL, -- SQLINES DEMO *** tion
    notes VARCHAR(1000) NULL,
    system_generated BOOLEAN DEFAULT 0, -- SQLINES DEMO *** ng tự động tạo không
    FOREIGN KEY (alert_id) REFERENCES Reorder_Alert(alert_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (resolved_by_purchase_request_id) REFERENCES Purchase_Request(pr_id),
    FOREIGN KEY (resolved_by_user_id) REFERENCES [User](user_id),
    FOREIGN KEY (performed_by) REFERENCES [User](user_id)
);

-- SQLINES DEMO *** formance
CREATE INDEX IX_AlertHistory_AlertId ON Alert_History(alert_id);
CREATE INDEX IX_AlertHistory_ActionType ON Alert_History(action_type);
CREATE INDEX IX_AlertHistory_ActionDate ON Alert_History(action_date);
CREATE INDEX IX_AlertHistory_Warehouse ON Alert_History(warehouse_id);

-- 16... SQLINES DEMO ***
CREATE TABLE Purchase_Order (
    po_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    supplier_id INT NOT NULL,
    user_id INT NOT NULL,
    [date] TIMESTAMP(0) NULL,
    status VARCHAR(50) NULL,
    expected_delivery_date DATE NULL,
    warehouse_id INT NULL,
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id),
    FOREIGN KEY (user_id) REFERENCES [User](user_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id)
);

-- SQLINES DEMO *** r_Item
CREATE TABLE Purchase_Order_Item (
    po_item_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    po_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (po_id) REFERENCES Purchase_Order(po_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- 18... SQLINES DEMO ***
CREATE TABLE Discount_Code (
    discount_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    discount_type VARCHAR(20) NOT NULL CHECK (discount_type IN ('PERCENTAGE', 'FIXED_AMOUNT')),
    discount_value DECIMAL(15,2) NOT NULL CHECK (discount_value > 0),
    min_order_amount DECIMAL(15,2) DEFAULT 0,
    max_discount_amount DECIMAL(15,2) NULL,
    start_date TIMESTAMP(0) NOT NULL,
    end_date TIMESTAMP(0) NOT NULL,
    usage_limit INT DEFAULT NULL,
    used_count INT DEFAULT 0,
    is_active BOOLEAN DEFAULT 1,
    created_by INT NOT NULL,
    created_at TIMESTAMP(0) DEFAULT NOW(),
    updated_at TIMESTAMP(0) DEFAULT NOW(),
    FOREIGN KEY (created_by) REFERENCES [User](user_id),
    CONSTRAINT CK_DateRange CHECK (end_date > start_date)
);

-- SQLINES DEMO *** ance
CREATE INDEX IX_DiscountCode_Active_Date ON Discount_Code(is_active, start_date, end_date);
CREATE INDEX IX_DiscountCode_Code ON Discount_Code(code) WHERE is_active = 1;

-- SQLINES DEMO *** unt_Request
CREATE TABLE Special_Discount_Request (
    request_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    customer_id INT NOT NULL,
    requested_by INT NOT NULL,
    discount_type VARCHAR(20) NOT NULL CHECK (discount_type IN ('PERCENTAGE', 'FIXED_AMOUNT')),
    discount_value DECIMAL(15,2) NOT NULL,
    reason VARCHAR(500) NOT NULL,
    estimated_order_value DECIMAL(15,2),
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected')),
    approved_by INT NULL,
    approved_at TIMESTAMP(0) NULL,
    rejection_reason VARCHAR(255) NULL,
    generated_code VARCHAR(20) NULL,
    expiry_date TIMESTAMP(0) NULL,
    created_at TIMESTAMP(0) DEFAULT NOW(),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (requested_by) REFERENCES [User](user_id),
    FOREIGN KEY (approved_by) REFERENCES [User](user_id)
);

-- SQLINES DEMO *** Updated with discount fields)
CREATE TABLE Sales_Order (
    so_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    customer_id INT NOT NULL,
    user_id INT NOT NULL,
    warehouse_id INT,
    [date] TIMESTAMP(0) DEFAULT NOW(),
    status VARCHAR(50),
    order_number VARCHAR(50) UNIQUE,
    total_amount DECIMAL(15,2) DEFAULT 0,
    total_before_discount DECIMAL(15,2) DEFAULT 0,
    discount_amount DECIMAL(15,2) DEFAULT 0,
    discount_code_id INT NULL,
    special_request_id INT NULL,
    delivery_date DATE,
    delivery_address VARCHAR(255),
    notes VARCHAR(500),
    cancellation_reason VARCHAR(255),
    cancelled_by INT,
    cancelled_at TIMESTAMP(0),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (user_id) REFERENCES [User](user_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (discount_code_id) REFERENCES Discount_Code(discount_id),
    FOREIGN KEY (special_request_id) REFERENCES Special_Discount_Request(request_id)
);

-- SQLINES DEMO *** tem
CREATE TABLE Sales_Order_Item (
    so_item_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    so_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    selling_price DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (so_id) REFERENCES Sales_Order(so_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- SQLINES DEMO *** e_Log
CREATE TABLE Discount_Usage_Log (
    log_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    discount_code_id INT NULL,
    special_request_id INT NULL,
    sales_order_id INT NOT NULL,
    customer_id INT NOT NULL,
    used_by INT NOT NULL,
    order_total DECIMAL(15,2) NOT NULL,
    discount_amount DECIMAL(15,2) NOT NULL,
    used_at TIMESTAMP(0) DEFAULT NOW(),
    FOREIGN KEY (discount_code_id) REFERENCES Discount_Code(discount_id),
    FOREIGN KEY (special_request_id) REFERENCES Special_Discount_Request(request_id),
    FOREIGN KEY (sales_order_id) REFERENCES Sales_Order(so_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (used_by) REFERENCES [User](user_id)
);

-- SQLINES DEMO *** ent_Reason
CREATE TABLE Stock_Adjustment_Reason (
    reason_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    description VARCHAR(255) NOT NULL
);

-- SQLINES DEMO *** ent
CREATE TABLE Stock_Adjustment (
    adjustment_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    quantity_change INT NOT NULL,
    reason_id INT NOT NULL,
    user_id INT NOT NULL,
    [date] TIMESTAMP(0) DEFAULT NOW(),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (reason_id) REFERENCES Stock_Adjustment_Reason(reason_id),
    FOREIGN KEY (user_id) REFERENCES [User](user_id)
);

-- 25... SQLINES DEMO ***
CREATE TABLE Import_Request (
    request_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    request_date TIMESTAMP(0) DEFAULT NOW(),
    created_by INT NOT NULL,
    reason VARCHAR(500),
    status VARCHAR(50) DEFAULT 'Pending',
    rejection_reason VARCHAR(255),
    FOREIGN KEY (created_by) REFERENCES [User](user_id)
);

-- SQLINES DEMO *** t_Detail
CREATE TABLE Import_Request_Detail (
    detail_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    request_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (request_id) REFERENCES Import_Request(request_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- SQLINES DEMO *** nsfer
CREATE TABLE Inventory_Transfer (
    it_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    source_warehouse_id INT NOT NULL,
    destination_warehouse_id INT NOT NULL,
    [date] TIMESTAMP(0) DEFAULT NOW(),
    status VARCHAR(50),
    description VARCHAR(255),
    created_by INT,
    import_request_id INT NULL,
    alert_id INT NULL,
    FOREIGN KEY (source_warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (destination_warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (created_by) REFERENCES [User](user_id),
    FOREIGN KEY (import_request_id) REFERENCES Import_Request(request_id),
    FOREIGN KEY (alert_id) REFERENCES Reorder_Alert(alert_id)
);

CREATE INDEX IX_InventoryTransfer_ImportRequestId ON Inventory_Transfer(import_request_id);
CREATE INDEX IX_InventoryTransfer_AlertId ON Inventory_Transfer(alert_id);

-- SQLINES DEMO *** nsfer_Item
CREATE TABLE Inventory_Transfer_Item (
    it_item_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    it_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (it_id) REFERENCES Inventory_Transfer(it_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- 29... SQLINES DEMO ***
CREATE TABLE Transfer_Order (
    to_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    source_warehouse_id INT NOT NULL,
    destination_warehouse_id INT,
    document_ref_id INT,
    document_ref_type VARCHAR(50),
    transfer_type VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'draft',
    description VARCHAR(255),
    approved_by INT,
    created_by INT NOT NULL,
    transfer_date TIMESTAMP(0) DEFAULT NOW(),
    created_date TIMESTAMP(0) DEFAULT NOW(),
    FOREIGN KEY (source_warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (destination_warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (approved_by) REFERENCES [User](user_id),
    FOREIGN KEY (created_by) REFERENCES [User](user_id)
);

-- SQLINES DEMO *** r_Item
CREATE TABLE Transfer_Order_Item (
    to_item_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    to_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (to_id) REFERENCES Transfer_Order(to_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- SQLINES DEMO *** ort
CREATE TABLE StockCheckReport (
    report_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    report_code VARCHAR(50) UNIQUE NOT NULL,
    warehouse_id INT NOT NULL,
    report_date DATE NOT NULL,
    created_by INT NOT NULL,
    created_at TIMESTAMP(0) DEFAULT NOW(),
    status VARCHAR(50) NOT NULL DEFAULT 'Pending',
    notes TEXT,
    approved_by INT,
    approved_at TIMESTAMP(0),
    manager_notes TEXT,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (created_by) REFERENCES [User](user_id),
    FOREIGN KEY (approved_by) REFERENCES [User](user_id)
);

-- SQLINES DEMO *** ortItem
CREATE TABLE StockCheckReportItem (
    report_item_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    report_id INT NOT NULL,
    product_id INT NOT NULL,
    system_quantity INT NOT NULL,
    counted_quantity INT NOT NULL,
    discrepancy INT NOT NULL,
    reason VARCHAR(255),
    FOREIGN KEY (report_id) REFERENCES StockCheckReport(report_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- SQLINES DEMO *** uotation
CREATE TABLE Request_For_Quotation (
    rfq_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    created_by INT NOT NULL,
    request_date TIMESTAMP(0) NULL,
    status VARCHAR(50) NULL,
    notes VARCHAR(500) NULL,
    supplier_id INT NOT NULL,
    description VARCHAR(500) NULL,
    warehouse_id INT NULL,
    expected_delivery_date DATE NULL,
    FOREIGN KEY (created_by) REFERENCES [User](user_id),
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id)
);

-- 34... SQLINES DEMO ***
CREATE TABLE RFQ_Item (
    rfq_item_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    rfq_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (rfq_id) REFERENCES Request_For_Quotation(rfq_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- 35... SQLINES DEMO ***
CREATE TABLE Quotation (
    quotation_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    customer_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP(0) DEFAULT NOW(),
    valid_until TIMESTAMP(0),
    total_amount DECIMAL(15,2) DEFAULT 0,
    notes VARCHAR(500),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (user_id) REFERENCES [User](user_id)
);

-- 36... SQLINES DEMO ***
CREATE TABLE Quotation_Item (
    quotation_item_id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    quotation_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    total_price DECIMAL(15,2) NULL,
    FOREIGN KEY (quotation_id) REFERENCES Quotation(quotation_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- SQLINES DEMO *** ier
CREATE TABLE Product_Supplier (
    product_id INT NOT NULL,
    supplier_id INT NOT NULL,
    created_at TIMESTAMP(0) DEFAULT NOW(),
    PRIMARY KEY (product_id, supplier_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id)
);

-- 38... SQLINES DEMO ***
CREATE TABLE AuthorizeMap (
    id INT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    path VARCHAR(255) NULL,
    [user] VARCHAR(255) NULL
);

GO

-- SQLINES DEMO *** ============================================================
-- SQLINES DEMO *** T STATEMENTS
-- SQLINES DEMO *** ============================================================

-- 1.... SQLINES DEMO ***
INSERT INTO [Role] (role_name) VALUES
(N'Admin'),
(N'Warehouse Manager'),
(N'Sales Staff'),
(N'Warehouse Staff'),
(N'Purchase Staff');

-- SQLINES DEMO *** ed: Added manager_id for all rows)
SET IDENTITY_INSERT Warehouse ON;
INSERT INTO Warehouse (warehouse_id, warehouse_name, address, region, manager_id, status, created_at) VALUES
(1, N'Kho Hà Nội', N'123 Đường Láng, Đống Đa, Hà Nội', N'Miền Bắc', NULL, 'Active', NOW()),
(2, N'Kho Hồ Chí Minh', N'456 Cách Mạng Tháng 8, Quận 3, TP.HCM', N'Miền Nam', NULL, 'Active', NOW()),
(3, N'Kho Đà Nẵng', N'789 Trần Phú, Hải Châu, Đà Nẵng', N'Miền Trung', NULL, 'Active', NOW()),
(4, N'Kho Cần Thơ', N'101 Mậu Thân, Ninh Kiều, Cần Thơ', N'Miền Nam', NULL, 'Active', NOW()),
(5, N'Kho Hải Phòng', N'202 Lê Hồng Phong, Ngô Quyền, Hải Phòng', N'Miền Bắc', NULL, 'Active', NOW()),
(0, N'Kho Trung Chuyển', N'Transshipment Center', N'Toàn quốc', NULL, 'Active', NOW());
SET IDENTITY_INSERT Warehouse OFF;

-- SQLINES DEMO *** ed for Warehouse
 @MaxId INT;
SELECT @MaxId = MAX(warehouse_id) FROM Warehouse WHERE warehouse_id > 0;
IF @MaxId IS NOT NULL
    DBCC CHECKIDENT('Warehouse', RESEED, @MaxId);

-- 3.... SQLINES DEMO ***
INSERT INTO [User] (username, password, first_name, last_name, role_id, gender, address, email, date_of_birth, profile_pic, status, warehouse_id) VALUES
----
-- SQLINES DEMO *** se id = 1
('managerHN1', '123456', N'Nguyễn Văn', N'Quang', 2, 'Male', N'123 Đường Láng, Hà Nội', 'managerHN1@example.com', '1990-01-01', 'manager.png', 'Active', 1),
('salesHN1', '123456', N'Trần Thị', N'Hương', 3, 'Female', N'456 Đường Láng, Hà Nội', 'salesHN1@example.com', '1995-02-15', 'sales.png', 'Active', 1),
('purchaseHN1', '123456', N'Phạm Minh', N'Đức', 5, 'Male', N'789 Đường Láng, Hà Nội', 'purchaseHN1@example.com', '1993-03-20', 'purchase.png', 'Active', 1),
('staffHN1', '123456', N'Lê Thị', N'Lan', 4, 'Female', N'101 Đường Láng, Hà Nội', 'staffHN1@example.com', '1997-04-10', 'staff.png', 'Active', 1),
-- SQLINES DEMO *** rehouse id = 2
('managerHCM1', '123456', N'Ngô Văn', N'Hoàng', 2, 'Male', N'123 CMT8, TP.HCM', 'managerHCM1@example.com', '1991-05-05', 'manager.png', 'Active', 2),
('salesHCM1', '123456', N'Võ Thị', N'Mai', 3, 'Female', N'456 CMT8, TP.HCM', 'salesHCM1@example.com', '1994-06-12', 'sales.png', 'Active', 2),
('purchaseHCM1', '123456', N'Đỗ Minh', N'Thắng', 5, 'Male', N'789 CMT8, TP.HCM', 'purchaseHCM1@example.com', '1992-07-18', 'purchase.png', 'Active', 2),
('staffHCM1', '123456', N'Phan Thị', N'Bích', 4, 'Female', N'101 CMT8, TP.HCM', 'staffHCM1@example.com', '1996-08-25', 'staff.png', 'Active', 2),
-- SQLINES DEMO *** use id = 3
('managerDN1', '123456', N'Hoàng Văn', N'Phúc', 2, 'Male', N'123 Trần Phú, Đà Nẵng', 'managerDN1@example.com', '1990-09-01', 'manager.png', 'Active', 3),
('salesDN1', '123456', N'Nguyễn Thị', N'Yến', 3, 'Female', N'456 Trần Phú, Đà Nẵng', 'salesDN1@example.com', '1995-10-15', 'sales.png', 'Active', 3),
('purchaseDN1', '123456', N'Vũ Minh', N'Triều', 5, 'Male', N'789 Trần Phú, Đà Nẵng', 'purchaseDN1@example.com', '1993-11-20', 'purchase.png', 'Active', 3),
('staffDN1', '123456', N'Bùi Thị', N'Nhung', 4, 'Female', N'101 Trần Phú, Đà Nẵng', 'staffDN1@example.com', '1997-12-10', 'staff.png', 'Active', 3),
-- SQLINES DEMO *** use id = 4
('managerCT1', '123456', N'Phạm Văn', N'Kiên', 2, 'Male', N'123 Mậu Thân, Cần Thơ', 'managerCT1@example.com', '1991-01-05', 'manager.png', 'Active', 4),
('salesCT1', '123456', N'Nguyễn Thị', N'Quỳnh', 3, 'Female', N'456 Mậu Thân, Cần Thơ', 'salesCT1@example.com', '1994-02-12', 'sales.png', 'Active', 4),
('purchaseCT1', '123456', N'Lê Minh', N'Tuấn', 5, 'Male', N'789 Mậu Thân, Cần Thơ', 'purchaseCT1@example.com', '1992-03-18', 'purchase.png', 'Active', 4),
('staffCT1', '123456', N'Trần Thị', N'Vân', 4, 'Female', N'101 Mậu Thân, Cần Thơ', 'staffCT1@example.com', '1996-04-25', 'staff.png', 'Active', 4),
-- SQLINES DEMO *** house id = 5
('managerHP1', '123456', N'Đặng Văn', N'Bình', 2, 'Male', N'123 Lê Hồng Phong, Hải Phòng', 'managerHP1@example.com', '1990-05-01', 'manager.png', 'Active', 5),
('salesHP1', '123456', N'Phạm Thị', N'Ngọc', 3, 'Female', N'456 Lê Hồng Phong, Hải Phòng', 'salesHP1@example.com', '1995-06-15', 'sales.png', 'Active', 5),
('purchaseHP1', '123456', N'Nguyễn Minh', N'Quân', 5, 'Male', N'789 Lê Hồng Phong, Hải Phòng', 'purchaseHP1@example.com', '1993-07-20', 'purchase.png', 'Active', 5),
('staffHP1', '123456', N'Lê Thị', N'Thảo', 4, 'Female', N'101 Lê Hồng Phong, Hải Phòng', 'staffHP1@example.com', '1997-08-10', 'staff.png', 'Active', 5),
('admin01', 'admin123', N'Nguyễn Văn', N'Admin', 1, 'Male', N'123 Admin St, Hanoi', 'admin@example.com', '1990-01-01', 'admin.png', 'Active', NULL);

-- SQLINES DEMO ***  for Warehouse
UPDATE Warehouse
SET manager_id = (SELECT user_id FROM [User] WHERE username = 'managerHN1') WHERE warehouse_id = 1;
UPDATE Warehouse
SET manager_id = (SELECT user_id FROM [User] WHERE username = 'managerHCM1') WHERE warehouse_id = 2;
UPDATE Warehouse
SET manager_id = (SELECT user_id FROM [User] WHERE username = 'managerDN1') WHERE warehouse_id = 3;
UPDATE Warehouse
SET manager_id = (SELECT user_id FROM [User] WHERE username = 'managerCT1') WHERE warehouse_id = 4;
UPDATE Warehouse
SET manager_id = (SELECT user_id FROM [User] WHERE username = 'managerHP1') WHERE warehouse_id = 5;

-- 4.... SQLINES DEMO ***
INSERT INTO Unit (unit_name, unit_code, description, is_active) VALUES 
('Pieces', 'pcs', N'Đơn vị đếm từng sản phẩm riêng lẻ', 1),
('Kilograms', 'kg', N'Đơn vị đo khối lượng theo kilôgam', 1),
('Meters', 'm', N'Đơn vị đo chiều dài theo mét', 1),
('Liters', 'l', N'Đơn vị đo thể tích theo lít', 1),
('Boxes', 'box', N'Đóng gói theo hộp tiêu chuẩn', 1),
('Pairs', 'pair', N'Bộ gồm hai sản phẩm giống nhau', 1),
('Cartons', 'ctn', N'Đóng gói theo thùng carton tiêu chuẩn', 1),
('Rolls', 'roll', N'Sản phẩm dạng cuộn', 1);

-- 5.... SQLINES DEMO ***
INSERT INTO Supplier (name, address, phone, email, contact_person, date_created, is_delete) VALUES
('VinaTech Supplies', N'123 Trần Hưng Đạo, Hà Nội', '0901234567', 'contact@vinatech.com', 'Trần Văn Tech', NOW(), 0),
('Hanoi Electronics', N'456 Lê Lợi, Hà Nội', '0912345678', 'sales@hanoielec.com', 'Nguyễn Văn Điện', NOW(), 0),
('Saigon Furniture', N'789 Nguyễn Huệ, TP.HCM', '0923456789', 'info@saigonfurn.com', 'Lê Thị Nội Thất', NOW(), 0),
('Danang Food Supply', N'101 Trần Phú, Đà Nẵng', '0934567890', 'order@danangfood.com', 'Phạm Thị Thực Phẩm', NOW(), 0),
('Green Farm Produce', N'202 Lê Duẩn, Huế', '0945678901', 'green@farmfresh.com', 'Hoàng Văn Nông', NOW(), 0);

INSERT INTO Product_Supplier (product_id, supplier_id, created_at)
SELECT p.product_id, s.supplier_id, NOW()
FROM Product p
CROSS JOIN Supplier s;

-- 6.... SQLINES DEMO ***
INSERT INTO Customer (customer_name, address, phone, email, is_delete) VALUES
(N'Công ty TNHH ABC', N'123 Lê Lai, Quận 1, TP.HCM', '0901122334', 'contact@abc.com', 0),
(N'Cửa hàng điện tử XYZ', N'456 Nguyễn Trãi, Hà Nội', '0912233445', 'store@xyz.com', 0),
(N'Nhà hàng Phố Biển', N'789 Trần Phú, Nha Trang', '0923344556', 'seacity@restaurant.com', 0),
(N'Trường THPT Quốc Tế', N'101 Nam Kỳ Khởi Nghĩa, Đà Nẵng', '0934455667', 'info@international.edu.vn', 0),
(N'Bệnh viện Đa khoa MN', N'202 Lê Lợi, Cần Thơ', '0945566778', 'hospital@mn.com', 0);

-- 7.... SQLINES DEMO ***
INSERT INTO Product (code, name, description, unit_id, price, supplier_id) VALUES
('LP001', 'Laptop Acer Nitro 5', N'Gaming laptop với hiệu suất mạnh mẽ', 1, 18500000, 2),
('LP002', 'Laptop Dell XPS 13', N'Ultrabook cao cấp cho doanh nhân', 1, 25000000, 2),
('LP003', 'Laptop HP Pavilion', N'Laptop đa năng cho sinh viên và văn phòng', 1, 15000000, 2),
('LP004', 'Laptop Asus ROG Strix', N'Gaming laptop chuyên nghiệp', 1, 29000000, 1),
('LP005', 'Laptop Lenovo ThinkPad', N'Laptop doanh nhân bền bỉ', 1, 22000000, 1),
('LP006', 'Laptop MSI GF65', N'Gaming laptop tầm trung', 1, 19500000, 2),
('LP007', 'Laptop Apple MacBook Air', N'Laptop mỏng nhẹ cao cấp', 1, 28000000, 3),
('LP008', 'Laptop Surface Pro', N'Laptop lai máy tính bảng', 1, 24000000, 3),
('LP009', 'Laptop LG Gram', N'Laptop siêu nhẹ pin trâu', 1, 21500000, 1),
('LP010', 'Laptop Huawei MateBook', N'Laptop văn phòng thiết kế đẹp', 1, 17500000, 2);

-- 8.... SQLINES DEMO ***
INSERT INTO ProductAttribute (product_id, attribute_name, attribute_value) VALUES
(1, 'CPU', 'Intel Core i5-11400H'),
(1, 'RAM', '8GB DDR4'),
(1, 'GPU', 'NVIDIA GeForce GTX 1650'),
(1, 'Storage', '512GB SSD'),
(1, 'Screen', '15.6" FHD 144Hz'),
(2, 'CPU', 'Intel Core i7-1165G7'),
(2, 'RAM', '16GB LPDDR4x'),
(2, 'GPU', 'Intel Iris Xe Graphics'),
(2, 'Storage', '512GB NVMe SSD'),
(2, 'Screen', '13.4" FHD+ Touch'),
(3, 'CPU', 'AMD Ryzen 5 5600H'),
(3, 'RAM', '8GB DDR4'),
(3, 'GPU', 'AMD Radeon Graphics'),
(3, 'Storage', '256GB SSD'),
(3, 'Screen', '15.6" FHD'),
(4, 'CPU', 'Intel Core i7-12700H'),
(4, 'RAM', '16GB DDR5'),
(4, 'GPU', 'NVIDIA RTX 3070'),
(4, 'Storage', '1TB NVMe SSD'),
(4, 'Screen', '15.6" QHD 165Hz'),
(5, 'CPU', 'Intel Core i5-1135G7'),
(5, 'RAM', '16GB DDR4'),
(5, 'GPU', 'Intel Iris Xe Graphics'),
(5, 'Storage', '512GB SSD'),
(5, 'Screen', '14" FHD IPS');

-- 9.... SQLINES DEMO ***
INSERT INTO Inventory (product_id, warehouse_id, quantity) VALUES
(1, 1, 150),
(2, 1, 120),
(3, 1, 200),
(5, 1, 180),
(7, 1, 90),
(10, 1, 160),
(1, 2, 130),
(2, 2, 100),
(4, 2, 80),
(5, 2, 140),
(8, 2, 110),
(3, 3, 170),
(4, 3, 70),
(6, 3, 120),
(9, 3, 135),
(1, 5, 95),
(2, 5, 85),
(6, 5, 110),
(7, 5, 75),
(9, 5, 105);

-- SQLINES DEMO *** ent_Reason
INSERT INTO Stock_Adjustment_Reason (description) VALUES
('Sản phẩm bị hư hỏng'),
('Sản phẩm bị mất cắp'),
('Sai số kiểm kê'),
('Sản phẩm quá hạn'),
('Điều chỉnh nội bộ');

-- 11... SQLINES DEMO ***
INSERT INTO Discount_Code (code, name, description, discount_type, discount_value, min_order_amount, max_discount_amount, start_date, end_date, usage_limit, created_by) VALUES
('SUMMER2025', 'Summer Sale 2025', N'Giảm giá mùa hè', 'PERCENTAGE', 15.00, 500000, 200000, '2025-06-01', '2025-08-31', 1000, 1),
('NEWCUSTOMER', 'New Customer Discount', N'Giảm giá khách hàng mới', 'PERCENTAGE', 10.00, 0, 100000, '2025-01-01', '2025-12-31', NULL, 1),
('FIXED50K', 'Fixed 50K Discount', N'Giảm cố định 50k', 'FIXED_AMOUNT', 50000, 200000, NULL, '2025-01-01', '2025-12-31', 500, 1),
('BLACKFRIDAY', 'Black Friday Special', N'Khuyến mãi Black Friday', 'PERCENTAGE', 25.00, 1000000, 500000, '2025-11-20', '2025-11-30', 200, 1),
('WELCOME10', 'Welcome New Customers', N'Chào mừng khách hàng mới', 'PERCENTAGE', 10.00, 100000, 50000, '2025-01-01', '2025-12-31', NULL, 1);

-- SQLINES DEMO *** unt_Request
INSERT INTO Special_Discount_Request (customer_id, requested_by, discount_type, discount_value, reason, estimated_order_value, status, approved_by, approved_at, generated_code, expiry_date) VALUES
(1, 2, 'PERCENTAGE', 20.00, N'Khách hàng VIP đặt hàng số lượng lớn', 100000000, 'Approved', 1, NOW(), 'VIP20-ABC', INTERVAL '30 day' + NOW()),
(2, 6, 'FIXED_AMOUNT', 300000, N'Khách hàng lâu năm yêu cầu giảm giá đặc biệt', 5000000, 'Pending', NULL, NULL, NULL, NULL),
(3, 10, 'PERCENTAGE', 15.00, N'Đơn hàng lớn cho nhà hàng', 15000000, 'Rejected', 5, INTERVAL '-1 day' + NOW(), NULL, NULL);

-- 13... SQLINES DEMO ***
INSERT INTO Purchase_Order (supplier_id, user_id, [date], status) VALUES
(1, 5, INTERVAL '-15 day' + NOW(), 'Completed'),
(2, 5, INTERVAL '-10 day' + NOW(), 'Completed'),
(3, 5, INTERVAL '-5 day' + NOW(), 'Pending'),
(2, 5, INTERVAL '-3 day' + NOW(), 'Pending'),
(1, 5, INTERVAL '-1 day' + NOW(), 'Pending');

-- Fo... SQLINES DEMO ***
INSERT INTO Purchase_Order (supplier_id, user_id, [date], status, expected_delivery_date, warehouse_id) VALUES
(1, 3, '2025-07-09 10:00:00', 'Completed', '2025-07-14', 1),
(2, 3, '2025-07-14 10:00:00', 'Completed', '2025-07-20', 1),
(3, 3, '2025-07-19 10:00:00', 'Completed',   '2025-07-25', 1),
(2, 3, '2025-07-21 10:00:00', 'Completed',   '2025-07-28', 1),
(1, 3, '2025-07-23 10:00:00', 'Completed',   '2025-07-30', 1);

-- Fo... SQLINES DEMO ***
INSERT INTO Purchase_Order (supplier_id, user_id, [date], status, expected_delivery_date, warehouse_id) VALUES
(1, 7, '2025-07-09 10:00:00', 'Completed', '2025-07-14', 2),
(2, 7, '2025-07-14 10:00:00', 'Completed', '2025-07-20', 2),
(3, 7, '2025-07-19 10:00:00', 'Completed',   '2025-07-25', 2),
(2, 7, '2025-07-21 10:00:00', 'Completed',   '2025-07-28', 2),
(1, 7, '2025-07-23 10:00:00', 'Completed',   '2025-07-30', 2);

INSERT INTO Supplier_Rating (supplier_id, user_id, delivery_score, quality_score, service_score, price_score, comment, rating_date)
VALUES
-- SQLINES DEMO *** d 3
(2, 3, 7, 6, 8, 9, N'Affordable pricing but quality was average.', '2025-07-10 14:05:00'),
(4, 3, 8, 9, 8, 7, N'Consistent supplier. Satisfied overall.', '2025-07-18 09:40:00'),
(5, 3, 9, 8, 9, 8, N'Great service and timely delivery.', '2025-07-22 13:30:00'),

-- SQLINES DEMO *** d 7
(2, 7, 6, 5, 6, 6, N'Some delays in delivery and quality issues.', '2025-07-03 12:15:00'),
(3, 7, 10, 9, 10, 8, N'Excellent supplier. Will use again.', '2025-07-12 11:50:00'),
(5, 7, 8, 8, 7, 9, N'Good value and responsive support.', '2025-07-21 16:30:00');

-- SQLINES DEMO *** r_Item
INSERT INTO Purchase_Order_Item (po_id, product_id, quantity, unit_price) VALUES
(1, 1, 10, 16000000),
(1, 4, 5, 25000000),
(2, 2, 8, 22000000),
(2, 3, 15, 13000000),
(3, 5, 10, 19000000),
(3, 7, 5, 25000000),
(4, 6, 10, 17000000),
(4, 9, 5, 19000000),
(5, 8, 8, 21000000),
(5, 10, 12, 15000000),
(6, 1, 10, 16000000),
(6, 4, 5, 25000000),
(7, 2, 8, 22000000),
(7, 3, 15, 13000000),
(8, 5, 10, 19000000),
(8, 7, 5, 25000000),
(9, 6, 10, 17000000),
(9, 9, 5, 19000000),
(10, 8, 8, 21000000),
(10, 10, 12, 15000000);


-- 15... SQLINES DEMO ***
INSERT INTO Sales_Order (customer_id, user_id, warehouse_id, [date], status, order_number, total_amount, total_before_discount, discount_amount, discount_code_id, delivery_date, delivery_address, notes) VALUES
(1, 5, 1, INTERVAL '-1 day' + NOW(), 'Order', 'SO-2025001', 92500000, 92500000, 0, NULL, INTERVAL '3 day' + NOW(), N'123 Lê Lai, Quận 1, TP.HCM', N'Đơn hàng laptop gaming cho văn phòng'),
(2, 5, 2, INTERVAL '-2 day' + NOW(), 'Order', 'SO-2025002', 72900000, 81000000, 8100000, 2, INTERVAL '5 day' + NOW(), N'456 Nguyễn Trãi, Hà Nội', N'Laptop doanh nhân cao cấp - Áp dụng NEWCUSTOMER'),
(3, 5, 1, INTERVAL '-3 day' + NOW(), 'Order', 'SO-2025003', 124000000, 124000000, 0, NULL, INTERVAL '7 day' + NOW(), N'789 Trần Phú, Nha Trang', N'Đơn hàng laptop đa năng cho học sinh'),
(4, 5, 3, INTERVAL '-5 day' + NOW(), 'Delivery', 'SO-2025004', 58000000, 58000000, 0, NULL, INTERVAL '2 day' + NOW(), N'101 Nam Kỳ Khởi Nghĩa, Đà Nẵng', N'Giao hàng express cho trường học'),
(5, 5, 2, INTERVAL '-6 day' + NOW(), 'Delivery', 'SO-2025005', 41000000, 91000000, 50000, 3, INTERVAL '1 day' + NOW(), N'202 Lê Lợi, Cần Thơ', N'Laptop cho bệnh viện - ưu tiên - Áp dụng FIXED50K'),
(1, 5, 1, INTERVAL '-7 day' + NOW(), 'Delivery', 'SO-2025006', 177500000, 177500000, 0, NULL, NOW(), N'123 Lê Lai, Quận 1, TP.HCM', N'Đơn hàng lớn - giao theo lịch hẹn'),
(2, 5, 2, INTERVAL '-12 day' + NOW(), 'Completed', 'SO-2025007', 69000000, 69000000, 0, NULL, INTERVAL '-8 day' + NOW(), N'456 Nguyễn Trãi, Hà Nội', N'Đã giao thành công - khách hàng hài lòng'),
(3, 5, 3, INTERVAL '-15 day' + NOW(), 'Completed', 'SO-2025008', 95000000, 95000000, 0, NULL, INTERVAL '-12 day' + NOW(), N'789 Trần Phú, Nha Trang', N'Giao cho nhà hàng - thanh toán đầy đủ'),
(4, 5, 1, INTERVAL '-18 day' + NOW(), 'Completed', 'SO-2025009', 162000000, 162000000, 0, NULL, INTERVAL '-15 day' + NOW(), N'101 Nam Kỳ Khởi Nghĩa, Đà Nẵng', N'Đơn hàng cho trường quốc tế - đã nghiệm thu'),
(5, 5, 2, INTERVAL '-20 day' + NOW(), 'Completed', 'SO-2025010', 94500000, 94500000, 0, NULL, INTERVAL '-17 day' + NOW(), N'202 Lê Lợi, Cần Thơ', N'Thiết bị y tế - bảo hành 3 năm');

-- SQLINES DEMO *** tem
INSERT INTO Sales_Order_Item (so_id, product_id, quantity, unit_price, selling_price) VALUES
(1, 1, 3, 18500000, 20500000),
(1, 4, 1, 29000000, 32000000),
(1, 9, 2, 21500000, 24000000),
(2, 2, 3, 25000000, 27000000),
(3, 3, 4, 15000000, 16000000),
(3, 5, 2, 22000000, 24000000),
(3, 10, 2, 17500000, 18000000),
(4, 3, 2, 15000000, 16500000),
(4, 8, 1, 24000000, 25000000),
(5, 1, 2, 18500000, 20000000),
(5, 9, 1, 21500000, 23000000),
(5, 5, 1, 22000000, 23000000),
(5, 8, 1, 24000000, 25000000),
(6, 7, 3, 28000000, 30500000),
(6, 2, 2, 25000000, 27000000),
(6, 4, 1, 29000000, 32000000),
(7, 3, 3, 15000000, 16000000),
(7, 6, 1, 19500000, 21000000),
(8, 4, 1, 29000000, 31000000),
(8, 1, 2, 18500000, 20000000),
(8, 5, 1, 22000000, 24000000),
(9, 7, 2, 28000000, 30000000),
(9, 2, 2, 25000000, 27000000),
(9, 9, 1, 21500000, 23000000),
(9, 8, 1, 24000000, 25000000),
(10, 1, 1, 18500000, 19500000),
(10, 3, 2, 15000000, 16000000),
(10, 8, 1, 24000000, 25000000),
(10, 10, 1, 17500000, 18000000),
(10, 6, 1, 19500000, 21000000);

-- SQLINES DEMO *** e_Log
INSERT INTO Discount_Usage_Log (discount_code_id, sales_order_id, customer_id, used_by, order_total, discount_amount, used_at) VALUES
(2, 2, 2, 5, 81000000, 8100000, INTERVAL '-2 day' + NOW()),
(3, 5, 5, 5, 91000000, 50000, INTERVAL '-6 day' + NOW());

-- SQLINES DEMO *** nsfer
INSERT INTO Inventory_Transfer (source_warehouse_id, destination_warehouse_id, [date], status, description, created_by) VALUES
(1, 2, INTERVAL '-10 day' + NOW(), 'Completed', N'Chuyển hàng định kỳ tháng 6', 2),
(2, 3, INTERVAL '-7 day' + NOW(), 'Completed', N'Bổ sung hàng cho kho miền Trung', 2),
(3, 1, INTERVAL '-5 day' + NOW(), 'Processing', N'Chuyển sản phẩm bán chậm về kho chính', 4),
(1, 3, INTERVAL '-2 day' + NOW(), 'Pending', N'Chuyển hàng mới về kho Đà Nẵng', 2),
(2, 5, INTERVAL '-1 day' + NOW(), 'Pending', N'Bổ sung hàng cho kho Hải Phòng', 4);

-- SQLINES DEMO *** nsfer_Item
INSERT INTO Inventory_Transfer_Item (it_id, product_id, quantity) VALUES
(1, 1, 10),
(1, 3, 15),
(2, 4, 5),
(2, 6, 10),
(3, 7, 5),
(3, 9, 8),
(4, 2, 10),
(4, 5, 7),
(5, 8, 6),
(5, 10, 9);

-- SQLINES DEMO *** ort
INSERT INTO StockCheckReport (report_code, warehouse_id, report_date, created_by, status, notes, approved_by, approved_at, manager_notes) VALUES
('SCR-001', 1, INTERVAL '-15 day' + NOW(), 4, 'Completed', N'Kiểm kê định kỳ kho Hà Nội', 2, INTERVAL '-14 day' + NOW(), N'Đã xử lý chênh lệch'),
('SCR-002', 2, INTERVAL '-10 day' + NOW(), 4, 'Pending', N'Kiểm kê kho HCM - Phát hiện thiếu hàng', NULL, NULL, NULL),
('SCR-003', 3, INTERVAL '-5 day' + NOW(), 2, 'Approved', N'Kiểm kê kho Đà Nẵng - Số liệu khớp', 2, INTERVAL '-4 day' + NOW(), N'Không có vấn đề');

-- SQLINES DEMO *** ortItem
INSERT INTO StockCheckReportItem (report_id, product_id, system_quantity, counted_quantity, discrepancy, reason) VALUES
(1, 1, 150, 148, -2, N'Hỏng 2 sản phẩm'),
(1, 2, 120, 120, 0, N'Khớp số liệu'),
(2, 4, 80, 79, -1, N'Nghi ngờ mất cắp'),
(2, 5, 140, 139, -1, N'Thất thoát không rõ lý do'),
(3, 6, 120, 120, 0, N'Số liệu chính xác');

-- SQLINES DEMO *** ent
INSERT INTO Stock_Adjustment (product_id, warehouse_id, quantity_change, reason_id, user_id, [date]) VALUES
(1, 1, -2, 1, 2, INTERVAL '-14 day' + NOW()),
(4, 2, -1, 1, 2, INTERVAL '-9 day' + NOW()),
(6, 3, -2, 2, 4, INTERVAL '-7 day' + NOW()),
(2, 1, 1, 3, 2, INTERVAL '-5 day' + NOW()),
(5, 2, -1, 4, 4, INTERVAL '-3 day' + NOW());

-- SQLINES DEMO *** nsaction
INSERT INTO Inventory_Transaction (product_id, warehouse_id, quantity, transaction_type, related_id, created_by, created_at) VALUES
(1, 1, 10, 'import', 1, 5, INTERVAL '-15 day' + NOW()),
(4, 1, 5, 'import', 1, 5, INTERVAL '-15 day' + NOW()),
(2, 1, 8, 'import', 2, 5, INTERVAL '-10 day' + NOW()),
(3, 1, 15, 'import', 2, 5, INTERVAL '-10 day' + NOW()),
(1, 1, -3, 'export', 1, 5, INTERVAL '-12 day' + NOW()),
(4, 1, -1, 'export', 1, 5, INTERVAL '-12 day' + NOW()),
(5, 1, -1, 'export', 1, 5, INTERVAL '-12 day' + NOW()),
(2, 1, -3, 'export', 2, 5, INTERVAL '-8 day' + NOW()),
(1, 1, -10, 'transfer', 1, 2, INTERVAL '-10 day' + NOW()),
(1, 2, 10, 'transfer', 1, 2, INTERVAL '-10 day' + NOW()),
(3, 1, -15, 'transfer', 1, 2, INTERVAL '-10 day' + NOW()),
(3, 2, 15, 'transfer', 1, 2, INTERVAL '-10 day' + NOW()),
(1, 1, -2, 'adjust', 1, 2, INTERVAL '-14 day' + NOW()),
(4, 2, -1, 'adjust', 2, 2, INTERVAL '-9 day' + NOW()),
(6, 3, -2, 'adjust', 3, 4, INTERVAL '-7 day' + NOW());

-- 26... SQLINES DEMO ***
INSERT INTO Reorder_Alert (product_id, warehouse_id, warning_threshold, critical_threshold, current_stock, created_by, alert_start_date, alert_expiry_date, alert_duration_days) VALUES
(1, 1, 100, 50, 150, 2, INTERVAL '-5 day' + NOW(), INTERVAL '25 day' + NOW(), 30),
(2, 2, 80, 40, 100, 5, INTERVAL '-3 day' + NOW(), INTERVAL '27 day' + NOW(), 30),
(3, 3, 120, 60, 170, 4, INTERVAL '-2 day' + NOW(), INTERVAL '28 day' + NOW(), 30),
(4, 2, 60, 30, 80, 5, INTERVAL '-4 day' + NOW(), INTERVAL '26 day' + NOW(), 30),
(5, 1, 100, 50, 180, 2, INTERVAL '-1 day' + NOW(), INTERVAL '29 day' + NOW(), 30),
(6, 3, 80, 40, 120, 4, INTERVAL '-6 day' + NOW(), INTERVAL '24 day' + NOW(), 30),
(7, 1, 60, 30, 90, 2, INTERVAL '-7 day' + NOW(), INTERVAL '23 day' + NOW(), 30),
(8, 2, 80, 40, 110, 5, INTERVAL '-8 day' + NOW(), INTERVAL '22 day' + NOW(), 30),
(9, 3, 100, 50, 135, 4, INTERVAL '-9 day' + NOW(), INTERVAL '21 day' + NOW(), 30),
(10, 1, 100, 50, 160, 2, INTERVAL '-10 day' + NOW(), INTERVAL '20 day' + NOW(), 30);

-- SQLINES DEMO *** ock for Reorder_Alert
UPDATE ra 
SET current_stock = COALESCE(i.quantity, 0)
FROM Reorder_Alert ra
LEFT JOIN Inventory i ON ra.product_id = i.product_id AND ra.warehouse_id = i.warehouse_id;

-- 28... SQLINES DEMO ***
INSERT INTO Import_Request (request_date, created_by, reason, status) VALUES
(NOW(), 5, N'Bổ sung hàng tồn kho thấp', 'Pending'),
(INTERVAL '-2 day' + NOW(), 5, N'Chuẩn bị cho mùa cao điểm', 'Approved');

-- SQLINES DEMO *** t_Detail
INSERT INTO Import_Request_Detail (request_id, product_id, quantity) VALUES
(1, 4, 20),
(1, 7, 15),
(2, 6, 25),
(2, 8, 10);

-- SQLINES DEMO *** ier
INSERT INTO Product_Supplier (product_id, supplier_id, created_at) VALUES
(1, 1, NOW()),
(1, 2, NOW()),
(1, 3, NOW()),
(1, 4, NOW()),
(1, 5, NOW()),
(2, 1, NOW()),
(2, 2, NOW()),
(2, 3, NOW()),
(2, 4, NOW()),
(2, 5, NOW()),
(3, 1, NOW()),
(3, 2, NOW()),
(3, 3, NOW()),
(3, 4, NOW()),
(3, 5, NOW()),
(4, 1, NOW()),
(4, 2, NOW()),
(4, 3, NOW()),
(4, 4, NOW()),
(4, 5, NOW()),
(5, 1, NOW()),
(5, 2, NOW()),
(5, 3, NOW()),
(5, 4, NOW()),
(5, 5, NOW()),
(6, 1, NOW()),
(6, 2, NOW()),
(6, 3, NOW()),
(6, 4, NOW()),
(6, 5, NOW()),
(7, 1, NOW()),
(7, 2, NOW()),
(7, 3, NOW()),
(7, 4, NOW()),
(7, 5, NOW()),
(8, 1, NOW()),
(8, 2, NOW()),
(8, 3, NOW()),
(8, 4, NOW()),
(8, 5, NOW()),
(9, 1, NOW()),
(9, 2, NOW()),
(9, 3, NOW()),
(9, 4, NOW()),
(9, 5, NOW()),
(10, 1, NOW()),
(10, 2, NOW()),
(10, 3, NOW()),
(10, 4, NOW()),
(10, 5, NOW());

-- 31... SQLINES DEMO ***
INSERT INTO Transfer_Order (source_warehouse_id, destination_warehouse_id, transfer_type, status, description, created_by, transfer_date) VALUES
(1, 2, 'Internal', 'completed', N'Chuyển hàng định kỳ', 4, INTERVAL '-10 day' + NOW()),
(2, 3, 'Internal', 'pending', N'Bổ sung hàng cho kho miền Trung', 8, INTERVAL '-3 day' + NOW()),
(3, 1, 'Internal', 'draft', N'Chuyển sản phẩm bán chậm', 12, INTERVAL '-1 day' + NOW());

-- SQLINES DEMO *** r_Item
INSERT INTO Transfer_Order_Item (to_id, product_id, quantity) VALUES
(1, 1, 15),
(1, 3, 20),
(2, 4, 8),
(2, 6, 12),
(3, 7, 10),
(3, 9, 15);

-- SQLINES DEMO *** uotation
INSERT INTO Request_For_Quotation (created_by, request_date, status, notes, supplier_id, description, warehouse_id, expected_delivery_date) VALUES
(3, INTERVAL '-5 day' + NOW(), 'Pending', N'Yêu cầu báo giá laptop gaming', 1, N'Báo giá cho laptop gaming cao cấp', 1, INTERVAL '15 day' + NOW()),
(7, INTERVAL '-3 day' + NOW(), 'Sent', N'Báo giá laptop văn phòng', 2, N'Laptop cho doanh nghiệp', 2, INTERVAL '20 day' + NOW()),
(11, INTERVAL '-1 day' + NOW(), 'Draft', N'Yêu cầu báo giá cho MacBook', 3, N'MacBook cho thiết kế', 3, INTERVAL '25 day' + NOW());

-- 34... SQLINES DEMO ***
INSERT INTO RFQ_Item (rfq_id, product_id, quantity) VALUES
(1, 1, 50),
(1, 4, 30),
(2, 2, 40),
(2, 5, 25),
(3, 7, 20),
(3, 8, 15);

-- 35... SQLINES DEMO ***
INSERT INTO Quotation (customer_id, user_id, created_at, valid_until, total_amount, notes) VALUES
(1, 2, INTERVAL '-10 day' + NOW(), INTERVAL '20 day' + NOW(), 185000000, N'Báo giá laptop gaming cho văn phòng'),
(2, 6, INTERVAL '-7 day' + NOW(), INTERVAL '23 day' + NOW(), 135000000, N'Báo giá laptop doanh nhân'),
(3, 10, INTERVAL '-3 day' + NOW(), INTERVAL '27 day' + NOW(), 98000000, N'Báo giá laptop cho nhà hàng');

-- 36... SQLINES DEMO ***
INSERT INTO Quotation_Item (quotation_id, product_id, quantity, unit_price, total_price) VALUES
(1, 1, 5, 20500000, 102500000),
(1, 4, 2, 32000000, 64000000),
(1, 9, 1, 24000000, 24000000),
(2, 2, 3, 27000000, 81000000),
(2, 5, 2, 24000000, 48000000),
(3, 3, 4, 16000000, 64000000),
(3, 10, 2, 18000000, 36000000);


ALTER TABLE [dbo].[Import_Request]
ADD [order_type] varchar(50) NULL;

-- SQLINES DEMO *** ============================================================
-- SQLINES DEMO ***  - PERMISSIONS
-- SQLINES DEMO *** ============================================================

INSERT INTO AuthorizeMap (path, [user]) VALUES
('/manager/low-stock-alerts', 'Warehouse Manager'),
('/manager/low-stock-config', 'Warehouse Manager'),
('/manager/alert-history', 'Warehouse Manager'),
('/manager/alert/create', 'Warehouse Manager'),
('/manager/alert/update', 'Warehouse Manager'),
('/manager/alert/delete', 'Warehouse Manager'),
('/manager/alert/cleanup-expired', 'Warehouse Manager'),
('/sale/createCustomer', 'Sales Staff'),
('/sale/customerDetail', 'Sales Staff'),
('/sale/deleteCustomer', 'Sales Staff'),
('/sale/listCustomer', 'Sales Staff'),
('/sale/updateCustomer', 'Sales Staff'),
('/sale/createCustomerQuote', 'Sales Staff'),
('/sale/customerQuoteDetail', 'Sales Staff'),
('/sale/listCustomerQuote', 'Sales Staff'),
('/sale/requestImport', 'Sales Staff'),
('/sale/importRequestEdit', 'Sales Staff'),
('/sale/importRequestList', 'Sales Staff'),
('/sale/importRequestViewDetail', 'Sales Staff'),
('/manager/inventory-report', 'Warehouse Manager'),
('/manager/create-inventory-transfer', 'Warehouse Manager'),
('/manager/list-inventory-transfer', 'Warehouse Manager'),
('/manager/view-inventory-transfer', 'Warehouse Manager'),
('/admin/create-product', 'admin'),
('/admin/delete-product', 'admin'),
('/admin/edit-product', 'admin'),
('/admin/list-product', 'admin'),
('/purchase/purchase-order', 'Purchase Staff'),
('/purchase/supplier-rating', 'Purchase Staff'),
('/sale/create-sales-order', 'Sales Staff'),
('/sale/edit-sales-order', 'Sales Staff'),
('/sale/get-products-by-warehouse', 'Sales Staff'),
('/sale/sales-report', 'Sales Staff'),
('/sale/view-sales-order-detail', 'Sales Staff'),
('/sale/view-sales-order-list', 'Sales Staff'),
('/manager/approveImportRequest', 'Warehouse Manager'),
('/manager/approve-sales-order', 'Warehouse Manager'),
('/manager/manage-sale-order', 'Warehouse Manager'),
('/manager/stock-level', 'Warehouse Manager'),
('/manager/stock-request', 'Warehouse Manager'),
('/manager/process-import-request', 'Warehouse Manager'),
('/manager/reject-sales-order', 'Warehouse Manager'),
('/manager/stock-adjustment-detail', 'Warehouse Manager'),
('/manager/create-stock-check-report', 'Warehouse Manager'),
('/manager/list-stock-check-reports', 'Warehouse Manager'),
('/manager/manage-stock-check-report', 'Warehouse Manager'),
('/purchase/manage-supplier', 'Purchase Staff'),
('/purchase/purchase-request-view', 'Purchase Staff'),
('/purchase/purchase-request-view?action=list', 'Purchase Staff'),
('/purchase/purchase-request-view?action=view', 'Purchase Staff'),
('/manager/purchase-request', 'Warehouse Manager'),
('/manager/purchase-request?action=create', 'Warehouse Manager'),
('/manager/purchase-request?action=list', 'Warehouse Manager'),
('/manager/purchase-request?action=view', 'Warehouse Manager'),
('/manager/purchase-request?action=edit', 'Warehouse Manager'),
('/manager/purchase-request?action=approve', 'Warehouse Manager'),
('/manager/purchase-request?action=reject', 'Warehouse Manager'),
('/manager/purchase-request?action=delete', 'Warehouse Manager'),
('/staff/complete-transfer-order', 'Warehouse Staff'),
('/staff/create-transfer-order', 'Warehouse Staff'),
('/staff/delete-transfer-order', 'Warehouse Staff'),
('/staff/edit-transfer-order', 'Warehouse Staff'),
('/staff/list-transfer-order', 'Warehouse Staff'),
('/staff/view-transfer-order', 'Warehouse Staff'),
('/admin/create-unit', 'admin, Warehouse Staff'),
('/admin/delete-unit', 'admin'),
('/admin/edit-unit', 'admin'),
('/admin/list-unit', 'admin'),
('/admin/restore-unit', 'admin'),
('/admin/users', 'admin'),
('/admin/add', 'admin'),
('/admin/user-deactivate', 'admin'),
('/admin/user-activate', 'admin'),
('/admin/UserProfile', 'admin'),
('/manager/UserProfile', 'Warehouse Manager'),
('/sale/UserProfile', 'Sales Staff'),
('/staff/UserProfile', 'Warehouse Staff'),
('/purchase/UserProfile', 'Purchase Staff'),
('/admin/admindashboard', 'admin, Warehouse Manager'),
('/manager/manager-dashboard', 'Warehouse Manager, Warehouse Staff, Purchase Staff'),
('/purchase/purchase-dashboard', 'Purchase Staff'),
('/purchase/rfq', 'Purchase Staff'),
('/staff/warehouse-staff-dashboard', 'Warehouse Staff'),
('/forgotpass', 'all user'),
('/login', 'all user, guest'),
('/logout', 'all user'),
('/register', 'guest'),
('/changePassword', 'all user'),
('/staff/inventory-detail', 'Warehouse Staff'),
('/staff/inventory-list', 'Warehouse Staff'),
('/staff/inventory-ws-overview', 'Warehouse Staff'),
('/staff/ws-warehouse-inventory', 'Warehouse Staff'),
-- SQLINES DEMO *** missions
('/manager/discount-codes', 'Warehouse Manager'),
('/manager/create-discount-code', 'Warehouse Manager'),
('/manager/edit-discount-code', 'Warehouse Manager'),
('/manager/delete-discount-code', 'Warehouse Manager'),
('/manager/special-discount-requests', 'Warehouse Manager'),
('/manager/approve-special-discount', 'Warehouse Manager'),
('/manager/reject-special-discount', 'Warehouse Manager'),
('/sale/available-discount-codes', 'Sales Staff'),
('/sale/validate-discount-code', 'Sales Staff'),
('/sale/apply-discount-to-order', 'Sales Staff'),
('/sale/request-special-discount', 'Sales Staff'),
('/sale/my-special-requests', 'Sales Staff');
/* SET SCHEMA 'ISP392_DTB' */;
GO

INSERT INTO [User] 
(username, password, first_name, last_name, role_id, gender, address, email, date_of_birth, profile_pic, status, warehouse_id)
VALUES
('minhnc', 'Minh9504', N'Nguyen Cong', N'Minh', 2, 'Male', N'Hanoi', 'minhnc@gmail.com', '2004-05-19', 'profile.png', 'Active', 1);


select *from "User"
>>>>>>> c84872d (Initial commit - add Warehouse Management project)
