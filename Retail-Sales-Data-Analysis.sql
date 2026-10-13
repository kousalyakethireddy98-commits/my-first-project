/* ============================================
   PROJECT: Retail Sales Data Analysis Using SQL
   DATABASE: RetailSalesDB
   TOOL: SQL Server Management Studio
   ============================================ */

USE RetailSalesDB;
GO

/* 1. CUSTOMER ANALYSIS */

SELECT *
FROM Customers;

SELECT City, COUNT(*) AS TotalCustomers
FROM Customers
GROUP BY City
ORDER BY TotalCustomers DESC;


/* 2. PRODUCT ANALYSIS */

SELECT *
FROM Products;

SELECT
    ProductName,
    Category,
    Price
FROM Products
ORDER BY Price DESC;


/* 3. ORDER ANALYSIS */

SELECT *
FROM Orders;


/* 4. TOTAL SALES REVENUE */

SELECT
    SUM(O.Quantity * P.Price) AS TotalRevenue
FROM Orders O
JOIN Products P
    ON O.ProductID = P.ProductID;


/* 5. PRODUCT-WISE REVENUE */

SELECT
    P.ProductName,
    SUM(O.Quantity) AS TotalQuantity,
    SUM(O.Quantity * P.Price) AS TotalRevenue
FROM Orders O
JOIN Products P
    ON O.ProductID = P.ProductID
GROUP BY P.ProductID, P.ProductName
ORDER BY TotalRevenue DESC;


/* 6. TOP 5 SELLING PRODUCTS */

SELECT TOP 5
    P.ProductName,
    SUM(O.Quantity) AS TotalQuantitySold
FROM Orders O
JOIN Products P
    ON O.ProductID = P.ProductID
GROUP BY P.ProductID, P.ProductName
ORDER BY TotalQuantitySold DESC;


/* 7. MONTHLY SALES ANALYSIS */

SELECT
    YEAR(O.OrderDate) AS SalesYear,
    MONTH(O.OrderDate) AS SalesMonth,
    SUM(O.Quantity * P.Price) AS MonthlyRevenue
FROM Orders O
JOIN Products P
    ON O.ProductID = P.ProductID
GROUP BY
    YEAR(O.OrderDate),
    MONTH(O.OrderDate)
ORDER BY SalesYear, SalesMonth;


/* 8. CITY-WISE REVENUE */

SELECT
    C.City,
    SUM(O.Quantity * P.Price) AS TotalRevenue
FROM Orders O
JOIN Customers C
    ON O.CustomerID = C.CustomerID
JOIN Products P
    ON O.ProductID = P.ProductID
GROUP BY C.City
ORDER BY TotalRevenue DESC;


/* 9. TOP 5 CUSTOMERS */

SELECT TOP 5
    C.CustomerName,
    C.City,
    SUM(O.Quantity * P.Price) AS TotalSpending
FROM Customers C
JOIN Orders O
    ON C.CustomerID = O.CustomerID
JOIN Products P
    ON O.ProductID = P.ProductID
GROUP BY C.CustomerID, C.CustomerName, C.City
ORDER BY TotalSpending DESC;


/* 10. SALES CATEGORY ANALYSIS */

SELECT
    O.OrderID,
    P.ProductName,
    O.Quantity * P.Price AS SalesAmount,
    CASE
        WHEN O.Quantity * P.Price >= 20000 THEN 'High Sales'
        WHEN O.Quantity * P.Price >= 10000 THEN 'Medium Sales'
        ELSE 'Low Sales'
    END AS SalesCategory
FROM Orders O
JOIN Products P
    ON O.ProductID = P.ProductID
ORDER BY SalesAmount DESC;


/* 11. PRODUCTS ABOVE AVERAGE PRICE */

SELECT ProductName, Category, Price
FROM Products
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
)
ORDER BY Price DESC;


/* 12. CUSTOMER ORDER ANALYSIS */

SELECT CustomerID, CustomerName, City
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
)
ORDER BY CustomerName;


/* 13. PRODUCT REVENUE RANKING */

SELECT
    P.ProductName,
    SUM(O.Quantity * P.Price) AS TotalRevenue,
    DENSE_RANK() OVER (
        ORDER BY SUM(O.Quantity * P.Price) DESC
    ) AS RevenueRank
FROM Products P
JOIN Orders O
    ON P.ProductID = O.ProductID
GROUP BY P.ProductID, P.ProductName
ORDER BY RevenueRank;


/* 14. MONTHLY SALES USING CTE */

WITH MonthlySales AS (
    SELECT
        YEAR(O.OrderDate) AS SalesYear,
        MONTH(O.OrderDate) AS SalesMonth,
        SUM(O.Quantity * P.Price) AS Revenue
    FROM Orders O
    JOIN Products P
        ON O.ProductID = P.ProductID
    GROUP BY
        YEAR(O.OrderDate),
        MONTH(O.OrderDate)
)
SELECT *
FROM MonthlySales
ORDER BY SalesYear, SalesMonth;