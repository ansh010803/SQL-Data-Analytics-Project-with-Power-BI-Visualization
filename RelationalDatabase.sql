-- create Customer table 
CREATE TABLE [Customer] (
    CustomerID INT IDENTITY(1,1),
    CustomerName VARCHAR(200) NOT NULL,
    CustomerLocation VARCHAR(200) NOT NULL,
    CONSTRAINT PK_Customer PRIMARY KEY CLUSTERED (CustomerID ASC)
)
-- insert Customer data
INSERT INTO Customer (CustomerName, CustomerLocation)
SELECT DISTINCT Customer_Name, Customer_Location
FROM sales_staging;

-- create OrderStatus table 
CREATE TABLE [OrderStatus] (
    -- Clustered
    [OrderStatusID] INT IDENTITY(1,1) ,
    [Name] varchar(100)  NOT NULL ,
    CONSTRAINT [PK_OrderStatus] PRIMARY KEY CLUSTERED (
        [OrderStatusID] ASC
    ),
    CONSTRAINT [UK_OrderStatus_Name] UNIQUE (
        [Name]
    )
)
-- insert OrderStatus data
INSERT INTO OrderStatus (Name)
SELECT DISTINCT [Status] FROM sales_staging;

-- create PaymentMethod table
CREATE TABLE [PaymentMethod] (
    -- Clustered
    [PaymentMethodID] INT IDENTITY(1,1) ,
    [Name] varchar(100)  NOT NULL ,
    CONSTRAINT [PK_PaymentMethod] PRIMARY KEY CLUSTERED (
        [PaymentMethodID] ASC
    ),
    CONSTRAINT [UK_PaymentMethod_Name] UNIQUE (
        [Name]
    )
)
-- insert PaymentMethod data
INSERT INTO PaymentMethod (Name)
SELECT DISTINCT Payment_Method FROM sales_staging;

-- create Product table
CREATE TABLE [Product] (
    -- Clustered
    [ProductID] INT IDENTITY(1,1),
    -- Field documentation comment 3
    [ProductName] varchar(200)  NOT NULL ,
    [Category] varchar(200)  NOT NULL ,
    [Price] money  NOT NULL ,
    CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED (
        [ProductID] ASC
    ),
    CONSTRAINT [UK_Product_ProductName] UNIQUE (
        [ProductName]
    )
)
-- insert Product data
INSERT INTO [Product] ([ProductName], [Category], [Price])
SELECT DISTINCT [Product], Category, Price
FROM sales_staging;

-- create OrderLine table 
CREATE TABLE [OrderLine] (
    [OrderLineID] INT IDENTITY(1,1) ,
    [OrderID] varchar(100)  NOT NULL ,
    [ProductID] int  NOT NULL ,
    [Quantity] int  NOT NULL ,
    [TotalAmount] money  NOT NULL ,
    CONSTRAINT [PK_OrderLine] PRIMARY KEY CLUSTERED (
        [OrderLineID] ASC
    )
)
-- insert OrderLine data
INSERT INTO [OrderLine] ([OrderID], [ProductID], [Quantity], [TotalAmount])
SELECT DISTINCT
    o.[OrderID],
    p.[ProductID],
    s.[Quantity],
    s.[Total_Amount]
FROM sales_staging s
JOIN [Product] p ON s.[Product] = p.ProductName
JOIN [Order] o ON s.Order_ID = o.[OrderID];

-- create Order table 
CREATE TABLE [Order] (
    -- Clustered
    [OrderID] varchar(100) NOT NULL ,
    [OrderDate] date  NOT NULL ,
    [CustomerID] int  NOT NULL ,
    [PaymentMethodID] int  NOT NULL ,
    [OrderStatusID] int  NOT NULL ,
    CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED (
        [OrderID] ASC
    )
)
-- ForeignKey using Alter Table
ALTER TABLE [Order] WITH CHECK ADD CONSTRAINT [FK_Order_CustomerID] FOREIGN KEY([CustomerID])
REFERENCES [Customer] ([CustomerID])
ALTER TABLE [Order] CHECK CONSTRAINT [FK_Order_CustomerID]

ALTER TABLE [Order] WITH CHECK ADD CONSTRAINT [FK_Order_PaymentMethodID] FOREIGN KEY([PaymentMethodID])
REFERENCES [PaymentMethod] ([PaymentMethodID])
ALTER TABLE [Order] CHECK CONSTRAINT [FK_Order_PaymentMethodID]

ALTER TABLE [Order] WITH CHECK ADD CONSTRAINT [FK_Order_OrderStatusID] FOREIGN KEY([OrderStatusID])
REFERENCES [OrderStatus] ([OrderStatusID])
ALTER TABLE [Order] CHECK CONSTRAINT [FK_Order_OrderStatusID]
-- insert Order data
INSERT INTO [Order] (OrderID, OrderDate, CustomerID, PaymentMethodID, OrderStatusID)
SELECT DISTINCT
    s.Order_ID,
    s.[Date],
    c.CustomerID,
    p.PaymentMethodID,
    o.OrderStatusID
FROM sales_staging s
JOIN Customer c ON s.Customer_Name = c.CustomerName AND s.Customer_Location = c.CustomerLocation
JOIN PaymentMethod p ON s.Payment_Method = p.[Name]
JOIN OrderStatus o ON s.[Status] = o.[Name];