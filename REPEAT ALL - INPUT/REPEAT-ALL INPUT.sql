USE Academy
GO

--TASK-1

INSERT INTO Customers(CustomerId,FirstName, LastName, Email) VALUES
(1, N'Stefan', N'Cloud', N'stefan1337@gmail.com'),
(2, N'Stefan2', N'Cloud2', N'stefan1337@gmail.com2'),
(3, N'Stefan3', N'Cloud3', N'stefan1337@gmail.com3'),
(4, N'Stefan4', N'Cloud4', N'stefan1337@gmail.com4'),
(5, N'Stefan5', N'Cloud5', N'stefan1337@gmail.com5');

SELECT * FROM Customers

UPDATE Customers SET Email =  N'stefan1337@gmail.com1'
WHERE CustomerId = 1;

DELETE FROM Customers 
WHERE CustomerId = 5;

SELECT LastName FROM Customers

INSERT INTO Customers(CustomerId,FirstName, LastName, Email) VALUES
(6, N'Cloud1', N'Stefan1', N'cloud1337@gmail.com1'),
(7, N'Cloud2', N'Stefan2', N'cloud1337@gmail.com2');



--TASK-2

INSERT INTO Orders(OrderId, CustomerId, OrderDate, TotalAmount) VALUES
(1, 1 , '2023', 5),
(2, 2 , '2021', 6),
(3, 3 , '2022', 7),
(4, 4 , '2024', 8),
(5, 5 , '2025', 9);

SELECT * FROM Orders

UPDATE Orders SET TotalAmount = 550
WHERE OrderId = 2;

DELETE FROM Orders 
WHERE OrderId = 3;

SELECT * FROM Orders 
WHERE CustomerId = 1

SELECT * FROM Orders 
WHERE OrderDate = '2023'



--TASK-3

INSERT INTO Products (ProductID, ProductName, Price) VALUES
(1, 'Product A', 19.99),
(2, 'Product B', 29.99),
(3, 'Product C', 15.49),
(4, 'Product D', 59.99),
(5, 'Product E', 219.99);

SELECT * FROM Products

UPDATE Products SET Price = 520
WHERE ProductId = 1;


DELETE FROM Products
WHERE ProductId = 4;

SELECT * FROM Products
WHERE Price > 100;

SELECT * FROM Products
WHERE Price <= 50;


--TASK-4

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, Price) VALUES
(1, 1, 1, 2, 19.99), 
(2, 2, 2, 1, 29.99), 
(3, 3, 3, 3, 15.49), 
(4, 4, 4, 2, 49.99), 
(5, 5, 5, 1, 19.99);  

SELECT * FROM OrderDetails

UPDATE OrderDetails SET Quantity = 15
WHERE OrderDetailID = 1;


DELETE OrderDetails 
WHERE OrderDetailID = 2;

SELECT
    od.OrderDetailID,
    p.ProductName,
    od.Quantity,
    od.Price,
    (od.Quantity * od.Price) AS TotalPrice
FROM
    OrderDetails od
JOIN
    Products p ON od.ProductID = p.ProductID
WHERE
    od.OrderID = 1;


SELECT o.OrderID
FROM OrderDetails od
JOIN Orders o ON od.OrderID = o.OrderID
WHERE od.ProductID = 2;


--TASK-5

SELECT
	o.OrderID,
	c.FirstName + ' ' + c.LastName AS FullName,
	o.OrderDate,
	o.TotalAmount
FROM
	Orders o
INNER JOIN
	Customers c ON o.CustomerID = c.CustomerID;


SELECT 
	c.FirstName + ' ' + c.LastName AS FullName,
	p.ProductName,
	od.Quantity
FROM 
	OrderDetails od
INNER JOIN 
	Orders o ON od.OrderID = o.OrderID
INNER JOIN 
	Customers c ON o.CustomerId = c.CustomerId
INNER JOIN 
	Products p ON od.ProductID = p.ProductID


SELECT 
     o.OrderID,
	 o.OrderDate,
	 o.TotalAmount,
	 c.FirstName + ' ' + c.LastName AS FullName
FROM 
	Orders o
LEFT JOIN 
	Customers c ON o.CustomerId = c.CustomerId;


SELECT 
	o.OrderId,
	p.ProductName,
	od.Quantity,
	od.Price
FROM 
	OrderDetails od
INNER JOIN 
	Orders o ON od.OrderID = o.OrderID
INNER JOIN 
	Products p ON od.ProductID = p.ProductID;


SELECT	
    c.CustomerId,
	c.FirstName + ' ' + c.LastName AS FullName,
	o.OrderID,
	o.OrderDate,
	o.TotalAmount
FROM	
	Customers c
LEFT JOIN 
	Orders o ON c.CustomerID = o.CustomerID;


SELECT 
	p.ProductName,
	o.OrderId,
	o.OrderDate,
	o.TotalAmount
FROM
	Products p
RIGHT JOIN 
	OrderDetails od ON p.ProductID = od.ProductID
RIGHT JOIN
	Orders o ON od.OrderID = o.OrderID;


SELECT
    o.OrderID,        
    o.OrderDate,      
    o.TotalAmount,     
    p.ProductName      
FROM
    Orders o
INNER JOIN
    OrderDetails od ON o.OrderID = od.OrderID     
INNER JOIN
    Products p ON od.ProductID = p.ProductID; 


SELECT 
	c.FirstName + ' ' + c.LastName AS FullName,
	o.OrderId,
	p.ProductName,
	od.Price,
	od.Quantity,
	(od.Quantity * od.Price) AS TotalPrice
FROM
	Customers c
INNER JOIN
	Orders o ON c.CustomerID = o.CustomerID
INNER JOIN
	OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN
	Products p ON od.ProductID = p.ProductID;



SELECT 
	c.FirstName + ' ' + c.LastName AS FullName 
FROM 
	Customers c
WHERE 
	c.CustomerId IN (
		SELECT
			o.CustomerId
		FROM
			Orders o
		WHERE 
			o.TotalAmount > 500 
	);


SELECT
	p.ProductName
FROM
	Products p
WHERE 
	p.ProductID IN (
		SELECT 
			od.ProductID
		FROM 
			OrderDetails od
		GROUP BY
			od.ProductID
		HAVING
			COUNT(od.OrderID) > 10
	);


SELECT 
	c.CustomerId,
	c.FirstName + ' ' + c.LastName AS FullName,
	(SELECT SUM(o.TotalAmount)
	FROM Orders o
	WHERE o.CustomerID = c.CustomerId) AS TotalOrdersAmount
FROM 
	Customers c;



SELECT 
	p.ProductName,
	p.Price
FROM 
	Products p
WHERE 
	p.Price > (
		SELECT AVG(Price)
		FROM Products
	);



SELECT 
	o.OrderId,
	o.OrderDate,
	o.TotalAmount,
	c.CustomerId,
	c.FirstName + ' ' + c.LastName AS FullName,
	p.ProductName,
	od.Quantity,
	od.Price,
	(od.Quantity * od.Price) AS TotalPrice
FROM 
	Orders o
JOIN
	Customers c ON o.CustomerID = c.CustomerID
JOIN
	OrderDetails od ON o.OrderId = od.OrderID
JOIN
	Products p ON od.ProductID = p.ProductID;



SELECT 
	c.CustomerId,
	c.FirstName + ' ' + c.LastName AS FullName,
	o.OrderId,
	o.OrderDate,
	p.ProductName,
	od.Quantity,
	od.Price,
	(od.Quantity * od.Price) AS TotalPrice
FROM
	Customers c
JOIN 
	Orders o ON c.CustomerID = o.CustomerID
JOIN 
	OrderDetails od ON o.OrderID = od.OrderID
JOIN 
	Products p ON od.ProductID = p.ProductID



SELECT 
	c.CustomerId,
	c.FirstName + ' ' + c.LastName AS FullName,
	o.OrderID,
	o.OrderDate,
	p.ProductName,
	od.Quantity,
	od.Price,
	(od.Quantity * od.Price) AS TotalPrice,
	(SELECT SUM(od2.Quantity * od2.Price) 
	 FROM OrderDetails od2
	 WHERE od2.OrderID = o.OrderId) AS TotalOrderPrice
FROM
	Customers c
JOIN 
	Orders o ON c.CustomerId = o.CustomerId
JOIN
	OrderDetails od ON o.OrderID = od.OrderID
JOIN
	Products p ON od.ProductID = p.ProductID
ORDER BY
	o.OrderID, c.CustomerId;
	

--TASK-6

SELECT 
	o.OrderID,
	o.OrderDate,
	SUM(od.Quantity * od.Price) AS TotalOrderPrice
FROM 
	Orders o
JOIN 
	OrderDetails od ON o.OrderID = od.OrderID
GROUP BY
	o.OrderID, o.OrderDate
HAVING 
	SUM(od.Quantity * od.Price) > 1000
ORDER BY 
	TotalOrderPrice DESC;


SELECT 
	c.CustomerId,
	c.FirstName + ' ' + c.LastName AS FullName,
	o.OrderID,
	o.OrderDate,
	o.TotalAmount
FROM
	Customers c
JOIN 
	Orders o ON c.CustomerID = o.CustomerID
WHERE 
	o.TotalAmount > (SELECT AVG(TotalAmount) FROM Orders)
ORDER BY 
	o.TotalAmount DESC


SELECT 
    c.CustomerId,
    c.FirstName + ' ' + c.LastName AS FullName,
    COUNT(o.OrderID) AS OrderCount
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerId = o.CustomerId
GROUP BY 
    c.CustomerId, c.FirstName, c.LastName
ORDER BY 
    OrderCount DESC;



SELECT 
    od.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS TotalQuantity
FROM 
    OrderDetails od
JOIN 
    Products p ON od.ProductID = p.ProductID
GROUP BY 
    od.ProductID, p.ProductName
HAVING 
    SUM(od.Quantity) > 3
ORDER BY 
    TotalQuantity DESC;



SELECT 
    c.CustomerId,
    c.FirstName + ' ' + c.LastName AS FullName,
    o.OrderID,
    SUM(od.Quantity) AS TotalItemsOrdered
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerId = o.CustomerId
JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
GROUP BY 
    c.CustomerId, c.FirstName, c.LastName, o.OrderID
ORDER BY 
    o.OrderID, c.CustomerId;


