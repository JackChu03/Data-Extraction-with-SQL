--Problem1
--Part A
SELECT st.Name,
        ROUND(SUM(SubTotal), 0) AS TotalRevenue
FROM Sales.SalesOrderHeader so
INNER JOIN Sales.SalesTerritory st
ON so.TerritoryID = st.TerritoryID
GROUP BY st.Name
ORDER BY TotalRevenue DESC


--Part B
SELECT  st.Name,
        ROUND(SUM(SubTotal), 2) AS TotalRevenue,
        DATEPART(year, OrderDate) AS year,
        DATEPART(MONTH, OrderDate) AS month
FROM Sales.SalesOrderHeader so
INNER JOIN Sales.SalesTerritory st
ON so.TerritoryID = st.TerritoryID
WHERE DATEPART(year, OrderDate) = 2013
GROUP BY st.Name, DATEPART(year, OrderDate), DATEPART(MONTH, OrderDate)
ORDER BY st.Name, month


-- Part C
SELECT  DISTINCT st.Name AS AWARDWINNERS
FROM Sales.SalesOrderHeader so
INNER JOIN Sales.SalesTerritory st
ON so.TerritoryID = st.TerritoryID
WHERE DATEPART(year, OrderDate) = 2013
GROUP BY st.Name, DATEPART(year, OrderDate), DATEPART(MONTH, OrderDate)
HAVING ROUND(SUM(SubTotal), 2) > 750000
ORDER BY st.Name


--Part D
SELECT  DISTINCT st.Name AS Terrotory_need_training
FROM Sales.SalesOrderHeader so
INNER JOIN Sales.SalesTerritory st
ON so.TerritoryID = st.TerritoryID
WHERE DATEPART(year, OrderDate) = 2013
GROUP BY st.Name, DATEPART(year, OrderDate), DATEPART(MONTH, OrderDate)
EXCEPT
SELECT  DISTINCT st.Name AS Terrotory_need_training
FROM Sales.SalesOrderHeader so
INNER JOIN Sales.SalesTerritory st
ON so.TerritoryID = st.TerritoryID
WHERE DATEPART(year, OrderDate) = 2013
GROUP BY st.Name, DATEPART(year, OrderDate), DATEPART(MONTH, OrderDate)
HAVING ROUND(SUM(SubTotal), 2) > 750000


--Problem2
--Part A
SELECT NAME,
        SUM(sod.OrderQty) AS QUANT
FROM Production.product  p
INNER JOIN Sales.SalesOrderDetail sod
ON sod.ProductID = p.ProductID
WHERE p.FinishedGoodsFlag = 1
GROUP BY NAME
HAVING SUM(sod.OrderQty) < 50
ORDER BY QUANT


--Part B
SELECT cr.Name AS COUNTRY_NAME,
        MAX(tax.TaxRate) AS MAX_TAX_RATE
FROM Sales.SalesTaxRate tax
INNER JOIN Person.StateProvince sp 
ON tax.StateProvinceID = sp.StateProvinceID
INNER JOIN Person.CountryRegion cr 
ON sp.CountryRegionCode = cr.CountryRegionCode
GROUP BY cr.Name
ORDER BY MAX_TAX_RATE DESC


--Part C
SELECT  DISTINCT store.Name AS Store_Name,
        st.Name AS SalesTerritory
FROM Sales.Store store 
INNER JOIN Sales.Customer cus 
ON store.BusinessEntityID = cus.StoreID
INNER JOIN Sales.SalesTerritory st 
ON cus.TerritoryID = st.TerritoryID
INNER JOIN Sales.SalesOrderHeader head
ON head.CustomerID = cus.CustomerID
INNER JOIN Sales.SalesOrderDetail sod 
ON sod.SalesOrderID = head.SalesOrderID
INNER JOIN Production.product p 
ON p.productid = sod.ProductID 
WHERE head.shipdate BETWEEN '2014-02-01' AND '2014-02-05'
        AND p.NAME LIKE '%helmet%'
ORDER BY SalesTerritory, Store_Name



