SELECT
    o.OrderID,
    o.OrderDate,
    c.CustomerName,
    c.CustomerLocation,
    p.ProductName,
    p.Category,
    p.Price,
    ol.Quantity,
    ol.TotalAmount,
    pm.Name AS PaymentMethod,
    os.Name AS OrderStatus
FROM [Order] o
JOIN Customer c 
    ON o.CustomerID = c.CustomerID
JOIN PaymentMethod pm 
    ON o.PaymentMethodID = pm.PaymentMethodID
JOIN OrderStatus os 
    ON o.OrderStatusID = os.OrderStatusID
JOIN OrderLine ol 
    ON o.OrderID = ol.OrderID
JOIN Product p 
    ON ol.ProductID = p.ProductID;