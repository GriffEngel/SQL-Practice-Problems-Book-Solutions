-- problem 1
SELECT * FROM shippers

-- problem 2
SELECT CategoryName, Description
FROM Categories

-- problem 3
SELECT FirstName, LastName, HireDate
FROM Employees
WHERE Title = 'Sales Representative'

-- problem 4
SELECT FirstName, LastName, HireDate
FROM Employees
WHERE Title = 'Sales Representative' AND
	Country = 'USA'

-- problem 5
SELECT OrderID, OrderDate 
FROM Orders
WHERE EmployeeID = 5

-- problem 6
SELECT SupplierID, ContactName, ContactTitle
FROM Suppliers
WHERE ContactTitle != 'Marketing Manager'

-- problem 7
SELECT ProductID, ProductName
FROM Products
WHERE ProductName LIKE '%Queso%'

-- problem 8
SELECT OrderID, CustomerID, ShipCountry
FROM Orders
WHERE ShipCountry IN ('France', 'Belgium')

-- problem 9
SELECT OrderID, CustomerID, ShipCountry
FROM Orders
WHERE ShipCountry IN ('Brazil', 'Mexico', 'Argentina', 'Venezuela')

-- problem 10
SELECT FirstName, LastName, Title, BirthDate
FROM Employees
ORDER BY BirthDate 

-- problem 11
SELECT FirstName, LastName, Title, CONVERT(Date, BirthDate) AS DateOnlyBirthDate
FROM Employees
ORDER BY BirthDate 

-- problem 12
SELECT FirstName, LastName, CONCAT(FirstName, ' ', LastName) AS FullName
FROM Employees

-- problem 13
SELECT OrderID, ProductID, UnitPrice, Quantity, (UnitPrice * Quantity) AS TotalPrice
FROM OrderDetails

-- problem 14
SELECT COUNT(*) AS TotalCustomers
FROM Customers

-- problem 15
SELECT MIN(OrderDate) AS FirstOrder
FROM Orders

-- problem 16
SELECT Country
FROM Customers
GROUP BY Country

-- problem 17
SELECT DISTINCT(ContactTitle), Count(ContactTitle) AS TotalContactTitle
FROM Customers
GROUP BY ContactTitle
ORDER BY TotalContactTitle DESC

-- problem 18
SELECT p.ProductID, p.ProductName, s.CompanyName
FROM Products p
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
ORDER BY p.ProductID

-- problem 19
SELECT o.OrderID, CONVERT(DATE, o.OrderDate) AS OrderDate, s.CompanyName AS Shipper
FROM Orders o
INNER JOIN Shippers s ON o.ShipVia = s.ShipperID
WHERE OrderID < 10270
ORDER BY OrderID

-- Intermediate Problems
-- problem 20
SELECT c.CategoryName, COUNT(p.ProductID) as TotalProducts
FROM Categories c
INNER JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName
ORDER BY TotalProducts DESC

-- problem 21
SELECT Country, City, COUNT(CustomerID) AS TotalCustomers
FROM Customers
GROUP BY Country, City 
ORDER BY TotalCustomers DESC

-- problem 22
SELECT ProductID, ProductName, UnitsInStock, ReorderLevel
FROM Products
WHERE UnitsInStock <= ReorderLevel
ORDER BY ProductID

-- problem 23
SELECT ProductID, ProductName, UnitsInStock, ReorderLevel, CASE WHEN ReorderLevel = 0 THEN 1 ELSE 0 END AS Discontinued
FROM Products
WHERE (UnitsInStock + UnitsOnOrder) <= ReorderLevel AND
ReorderLevel > 0
ORDER BY ProductID 

-- problem 24
SELECT CustomerID, CompanyName, Region
FROM Customers
ORDER BY CASE WHEN Region IS NULL THEN 1 ELSE 0 END, Region, CustomerID

-- problem 25
SELECT ShipCountry, AVG(Freight) AS AverageFreight
FROM Orders
GROUP BY ShipCountry
ORDER BY AverageFreight DESC

-- problem 26
SELECT ShipCountry, AVG(Freight) AS AverageFreight
FROM Orders
WHERE YEAR(OrderDate) = 2015
GROUP BY ShipCountry
ORDER BY AverageFreight DESC 


-- problem 27
SELECT Top 3
	ShipCountry, AverageFreight = avg(Freight)
FROM Orders 
WHERE 
	OrderDate BETWEEN '20150101' and '20151231'
GROUP BY ShipCountry
ORDER BY AverageFreight DESC


SELECT * FROM Orders

-- OrderID 10806

-- problem 28
SELECT ShipCountry, AVG(Freight) AS AverageFreight
FROM Orders
WHERE OrderDate BETWEEN DATEADD(yy, -1, (SELECT MAX(OrderDate) FROM Orders)) AND (SELECT MAX(OrderDate) FROM Orders)
GROUP BY ShipCountry
ORDER BY AverageFreight DESC

-- problem 29
SELECT e.EmployeeID, e.LastName, o.OrderID, p.ProductName, od.Quantity
FROM Employees e
INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON p.ProductID = od.ProductID
ORDER BY OrderID, p.ProductID

-- problem 30
SELECT c.CustomerID, o.OrderID 
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL

-- problem 31
SELECT c.CustomerID, o.CustomerID
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID AND o.EmployeeID = 4 
WHERE o.CustomerID IS NULL

-- Advanced Problems
-- problem 32
SELECT x.CustomerID, x.CompanyName, x.OrderID, x.TotalOrderAmount
FROM
(
SELECT c.CustomerID, c.CompanyName, od.OrderID, SUM(od.UnitPrice * od.Quantity) AS TotalOrderAmount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE o.OrderDate >= '20160101' AND o.OrderDate <= '20170101'
GROUP BY c.CustomerID, c.CompanyName, od.OrderID
) AS x
WHERE TotalOrderAmount > 10000 
ORDER BY TotalOrderAmount DESC

--problem 33
SELECT x.CustomerID, x.CompanyName, x.TotalOrderAmount
FROM
(
SELECT c.CustomerID, c.CompanyName, SUM(od.UnitPrice * od.Quantity) AS TotalOrderAmount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE o.OrderDate >= '20160101' AND o.OrderDate <= '20161231'
GROUP BY c.CustomerID, c.CompanyName
) AS x
WHERE TotalOrderAmount > 15000 
ORDER BY TotalOrderAmount DESC

-- problem 34
SELECT x.CustomerID, x.CompanyName, x.TotalsNoDiscount, x.TotalsWithDiscount
FROM
(
SELECT c.CustomerID, c.CompanyName, SUM(od.UnitPrice * od.Quantity) AS TotalsNoDiscount, SUM((od.UnitPrice * od.Quantity) * (1-od.Discount)) AS TotalsWithDiscount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE o.OrderDate >= '20160101' AND o.OrderDate <= '20161231'
GROUP BY c.CustomerID, c.CompanyName
) AS x
WHERE TotalsNoDiscount > 15000 
ORDER BY TotalsWithDiscount DESC

-- problem 35
SELECT EmployeeID, OrderID, OrderDate
FROM Orders
WHERE OrderDate = EOMONTH(OrderDate)
ORDER BY EmployeeID, OrderID

-- problem 36
SELECT TOP 10 OrderID, COUNT(Quantity) AS TotalOrderDetails
FROM OrderDetails
GROUP BY OrderID
ORDER BY TotalOrderDetails DESC

-- problem 37
SELECT TOP 17 OrderID 
FROM OrderDetails
ORDER BY NEWID()

-- problem 38
SELECT OrderID
FROM OrderDetails
WHERE Quantity >= 60
GROUP BY OrderID, Quantity
HAVING SUM(CASE WHEN Quantity >= 60 THEN 1 ELSE 0 END) > 1
ORDER BY OrderID

-- problem 39
WITH DoubleOrders AS (
SELECT OrderID
FROM OrderDetails
WHERE Quantity >= 60
GROUP BY OrderID, Quantity
HAVING SUM(CASE WHEN Quantity >= 60 THEN 1 ELSE 0 END) > 1
)
SELECT * FROM OrderDetails 
WHERE OrderID in (SELECT OrderID FROM DoubleOrders)

--problem 40
SELECT od.OrderID, ProductID, UnitPrice, Quantity, Discount
FROM OrderDetails od
JOIN (SELECT DISTINCT(OrderID) 
		FROM OrderDetails
		WHERE Quantity >= 60
		GROUP BY OrderID, Quantity
		Having COUNT(*) > 1
	) PotentialProblemOrders
	ON PotentialProblemOrders.OrderID = od.OrderID
	Order BY OrderID, ProductID

-- problem 41
SELECT OrderID, CAST(OrderDate AS DATE) AS OrderDate, CAST(RequiredDate AS DATE) AS RequiredDate, CAST(ShippedDate AS DATE) AS ShippedDate
FROM Orders
WHERE DATEDIFF(DAY, RequiredDate, ShippedDate) > 0

-- problem 42
SELECT e.EmployeeID, e.LastName, COUNT(*) AS TotalLateOrders
FROM Orders o
JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE RequiredDate <= ShippedDate
GROUP BY e.EmployeeID, e.LastName
ORDER BY TotalLateOrders DESC

-- problem 43
WITH LateOrders AS (
SELECT EmployeeID, COUNT(*) AS LateOrders
FROM Orders
WHERE RequiredDate <= ShippedDate 
GROUP BY EmployeeID
),
TotalOrders AS (
SELECT EmployeeID, COUNT(*) AS AllOrders
FROM Orders
GROUP BY EmployeeID
)
SELECT lo.EmployeeID, e.LastName, AllOrders, LateOrders 
FROM LateOrders lo
JOIN TotalOrders t ON lo.EmployeeID = t.EmployeeID
JOIN Employees e ON t.EmployeeID = e.EmployeeID
GROUP BY e.LastName, lo.EmployeeID, AllOrders, LateOrders
ORDER BY lo.EmployeeID ASC

-- problem 44
WITH LateOrders AS (
SELECT EmployeeID, COUNT(*) AS LateOrders
FROM Orders
WHERE RequiredDate <= ShippedDate
GROUP BY EmployeeID
),
TotalOrders AS (
SELECT EmployeeID, COUNT(*) AS AllOrders
FROM Orders
GROUP BY EmployeeID
)
SELECT COALESCE(lo.EmployeeID, e.EmployeeID) AS EmployeeID, e.LastName, AllOrders, LateOrders
FROM Employees e
JOIN TotalOrders t ON t.EmployeeID = e.EmployeeID
LEFT JOIN LateOrders lo ON lo.EmployeeID = e.EmployeeID
GROUP BY e.LastName, e.EmployeeID, AllOrders, lo.LateOrders, lo.EmployeeID
ORDER BY e.EmployeeID ASC

-- problem 45
WITH LateOrders AS (
SELECT EmployeeID, COUNT(*) AS LateOrders
FROM Orders
WHERE RequiredDate <= ShippedDate
GROUP BY EmployeeID
),
TotalOrders AS (
SELECT EmployeeID, COUNT(*) AS AllOrders
FROM Orders
GROUP BY EmployeeID
)
SELECT COALESCE(lo.EmployeeID, e.EmployeeID) AS EmployeeID, e.LastName, AllOrders, COALESCE(LateOrders, 0) AS LateOrders
FROM Employees e
JOIN TotalOrders t ON t.EmployeeID = e.EmployeeID
LEFT JOIN LateOrders lo ON lo.EmployeeID = e.EmployeeID
GROUP BY e.LastName, e.EmployeeID, AllOrders, lo.LateOrders, lo.EmployeeID
ORDER BY e.EmployeeID ASC

-- problem 46
WITH LateOrders AS (
SELECT EmployeeID, COUNT(*) AS LateOrders
FROM Orders
WHERE RequiredDate <= ShippedDate
GROUP BY EmployeeID
),
TotalOrders AS (
SELECT EmployeeID, COUNT(*) AS AllOrders
FROM Orders
GROUP BY EmployeeID
)
SELECT COALESCE(lo.EmployeeID, e.EmployeeID) AS EmployeeID, e.LastName, AllOrders, COALESCE(LateOrders, 0) AS LateOrders, COALESCE(CAST(LateOrders AS FLOAT) / CAST(AllOrders AS FLOAT), 0) AS PercentLateOrders
FROM Employees e
JOIN TotalOrders t ON t.EmployeeID = e.EmployeeID
LEFT JOIN LateOrders lo ON lo.EmployeeID = e.EmployeeID
GROUP BY e.LastName, e.EmployeeID, AllOrders, lo.LateOrders, lo.EmployeeID
ORDER BY e.EmployeeID ASC

-- problem 47
WITH LateOrders AS (
SELECT EmployeeID, COUNT(*) AS LateOrders
FROM Orders
WHERE RequiredDate <= ShippedDate
GROUP BY EmployeeID
),
TotalOrders AS (
SELECT EmployeeID, COUNT(*) AS AllOrders
FROM Orders
GROUP BY EmployeeID
)
SELECT COALESCE(lo.EmployeeID, e.EmployeeID) AS EmployeeID, e.LastName, AllOrders, COALESCE(LateOrders, 0) AS LateOrders, ROUND(COALESCE(CAST(LateOrders AS FLOAT) / CAST(AllOrders AS FLOAT), 0), 2) AS PercentLateOrders
FROM Employees e
JOIN TotalOrders t ON t.EmployeeID = e.EmployeeID
LEFT JOIN LateOrders lo ON lo.EmployeeID = e.EmployeeID
GROUP BY e.LastName, e.EmployeeID, AllOrders, lo.LateOrders, lo.EmployeeID
ORDER BY e.EmployeeID ASC

-- problem 48
SELECT c.CustomerID, c.CompanyName, SUM(od.UnitPrice * od.Quantity) AS 'Total Order Amount', 
CASE WHEN SUM(od.UnitPrice * od.Quantity) >= 0 AND SUM(od.UnitPrice * od.Quantity) <= 1000 THEN 'Low'
WHEN SUM(od.UnitPrice * od.Quantity) >= 1001 AND SUM(od.UnitPrice * od.Quantity) <= 5000 THEN 'Medium'
WHEN SUM(od.UnitPrice * od.Quantity) >= 5001 AND SUM(od.UnitPrice * od.Quantity) <= 10000 THEN 'High'
WHEN SUM(od.UnitPrice * od.Quantity) > 10000 THEN 'Very High'
ELSE NULL END AS 'Customer Group'
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE o.OrderDate BETWEEN '20160101' AND '20161231'
GROUP BY c.CustomerID, c.CompanyName
ORDER BY c.CustomerID

-- problem 49
SELECT c.CustomerID, c.CompanyName, SUM(od.UnitPrice * od.Quantity) AS 'Total Order Amount', 
CASE WHEN SUM(od.UnitPrice * od.Quantity) >= 0.00 AND SUM(od.UnitPrice * od.Quantity) <= 1000 THEN 'Low'
WHEN SUM(od.UnitPrice * od.Quantity) >= 1000.00 AND SUM(od.UnitPrice * od.Quantity) <= 5000 THEN 'Medium'
WHEN SUM(od.UnitPrice * od.Quantity) >= 5000.00 AND SUM(od.UnitPrice * od.Quantity) <= 10000 THEN 'High'
WHEN SUM(od.UnitPrice * od.Quantity) > 10000 THEN 'Very High'
ELSE NULL END AS 'Customer Group'
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE o.OrderDate BETWEEN '20160101' AND '20161231'
GROUP BY c.CustomerID, c.CompanyName
ORDER BY c.CustomerID

-- problem 50
WITH CustomerGrouping AS (
SELECT c.CustomerID, c.CompanyName, SUM(od.UnitPrice * od.Quantity) AS 'Total Order Amount', 
CASE WHEN SUM(od.UnitPrice * od.Quantity) >= 0.00 AND SUM(od.UnitPrice * od.Quantity) <= 1000 THEN 'Low'
WHEN SUM(od.UnitPrice * od.Quantity) >= 1000.00 AND SUM(od.UnitPrice * od.Quantity) <= 5000 THEN 'Medium'
WHEN SUM(od.UnitPrice * od.Quantity) >= 5000.00 AND SUM(od.UnitPrice * od.Quantity) <= 10000 THEN 'High'
WHEN SUM(od.UnitPrice * od.Quantity) > 10000 THEN 'Very High'
ELSE NULL END AS 'CustomerGroup'
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE o.OrderDate BETWEEN '20160101' AND '20161231'
GROUP BY c.CustomerID, c.CompanyName
)
SELECT CustomerGroup, COUNT(CustomerGroup) AS TotalinGroup, COUNT(*) * 1.0/(SELECT COUNT(*) 
FROM CustomerGrouping) AS PercentageInGroup
FROM CustomerGrouping
GROUP BY CustomerGroup
ORDER BY TotalinGroup DESC

-- problem 51
WITH CustomerGrouping AS (
SELECT c.CustomerID, c.CompanyName, SUM(od.UnitPrice * od.Quantity) AS TotalOrderAmount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE o.OrderDate BETWEEN '20160101' AND '20161231'
GROUP BY c.CustomerID, c.CompanyName
)
SELECT CustomerID, CompanyName, TotalOrderAmount, CustomerGroupName
FROM CustomerGrouping
JOIN CustomerGroupThresholds ON CustomerGrouping.TotalOrderAmount BETWEEN 
CustomerGroupThresholds.RangeBottom AND CustomerGroupThresholds.RangeTop
ORDER BY CustomerID

-- problem 52
SELECT Country FROM Customers
UNION
SELECT Country FROM Suppliers

-- problem 53
WITH CustomerTable AS(
SELECT DISTINCT(Country) AS CustomerCountry FROM Customers
), 
SupplierTable AS (
SELECT DISTINCT(Country) AS SupplierCountry FROM Suppliers
)
SELECT CustomerCountry, SupplierCountry 
FROM CustomerTable
FULL OUTER JOIN SupplierTable ON CustomerCountry = SupplierCountry

-- problem 54
WITH CustomerTable AS (
    SELECT Country, COUNT(CustomerID) AS TotalCustomers 
    FROM Customers 
    GROUP BY Country
), 
SupplierTable AS (
    SELECT Country, COUNT(SupplierID) AS TotalSuppliers 
    FROM Suppliers 
    GROUP BY Country
)
SELECT COALESCE(CustomerTable.Country, SupplierTable.Country) AS Country, COALESCE(TotalSuppliers, 0) AS TotalSuppliers, COALESCE(TotalCustomers, 0) AS TotalCustomers
FROM CustomerTable
FULL OUTER JOIN SupplierTable ON CustomerTable.Country = SupplierTable.Country;

-- problem 55
WITH RowNums AS (
Select ShipCountry, CustomerID, OrderID, CONVERT(DATE, OrderDate) AS OrderDate, ROW_NUMBER() OVER (PARTITION BY ShipCountry ORDER BY OrderDate, OrderID) AS RowNumber
FROM Orders
)
SELECT ShipCountry, CustomerID, OrderID, OrderDate
FROM RowNums
WHERE RowNumber = 1

-- problem 56
SELECT io.CustomerID, io.OrderID, CONVERT(DATE, io.OrderDate) AS InitialOrderDate, no.OrderID, CONVERT(DATE, no.OrderDate) AS NextOrderDate, 
DATEDIFF(dd, io.OrderDate, no.OrderDate) AS DaysBetweenOrders
FROM Orders io
JOIN Orders no ON io.CustomerID = no.CustomerID
WHERE io.OrderID < no.OrderID AND 
DATEDIFF(DAY, io.OrderDate, no.OrderDate) <= 5
ORDER BY io.CustomerID, io.OrderDate

--problem 57
WITH NextOrderDate AS (
SELECT CustomerID, CONVERT(DATE, OrderDate) AS OrderDate, Lead(OrderDate, 1) OVER (PARTITION BY CustomerID ORDER BY CustomerID, OrderDate) AS NextOrder
FROM Orders
)
SELECT CustomerID, OrderDate, CONVERT(DATE, NextOrder) AS NextOrderDate, DATEDIFF(dd, OrderDate, NextOrder) AS DaysBetweenOrders
FROM NextOrderDate
WHERE NextOrder >= OrderDate AND
DATEDIFF(dd, OrderDate, NextOrder) <= 5
ORDER BY CustomerID, OrderDate




