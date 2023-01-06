-- Problem 1
SELECT  DISTINCT st.Name AS Terrotory,
        CASE WHEN st.Name in (SELECT DISTINCT st.Name AS AWARDWINNERS
                        FROM Sales.SalesOrderHeader so
                        INNER JOIN Sales.SalesTerritory st
                        ON so.TerritoryID = st.TerritoryID
                        WHERE DATEPART(year, OrderDate) = 2013
                        GROUP BY st.Name, DATEPART(year, OrderDate), DATEPART(MONTH, OrderDate)
                        HAVING ROUND(SUM(SubTotal), 2) > 750000)
                THEN 'Yes'
                ELSE 'No'
                END AS TrainingRequired
FROM Sales.SalesTerritory st


--Problem 2
--Part A
SELECT CASE WHEN pc.Name IS NULL AND ps.Name IS NULL
       THEN '*Total'
       ELSE pc.Name
       END AS COUNTRY,
       CASE  WHEN ps.Name IS NULL AND pc.Name IS NULL
       THEN '*Total'
       WHEN ps.Name IS NULL
       THEN '*SubTotal'
       ELSE ps.Name 
       END AS STATE,
       COUNT(sod.SalesOrderID) AS Number_Of_Order
FROM Sales.SalesOrderHeader sod
INNER JOIN Person.Address pa 
ON sod.ShipToAddressID = pa.AddressID
INNER JOIN Person.StateProvince ps 
ON pa.StateProvinceID = ps.StateProvinceID 
INNER JOIN Person.CountryRegion pc 
ON ps.CountryRegionCode = pc.CountryRegionCode
GROUP BY rollup(pc.NAME, ps.NAME)
ORDER BY pc.NAME, Number_Of_Order DESC



-- Part B
SELECT CASE WHEN pc.Name IS NULL AND ps.Name IS NULL
       THEN '*Total'
       ELSE pc.Name
       END AS COUNTRY,
       CASE  WHEN ps.Name IS NULL AND pc.Name IS NULL
       THEN '*Total'
       WHEN ps.Name IS NULL
       THEN '*SubTotal'
       ELSE ps.Name 
       END AS STATE,
       COUNT(sod.SalesOrderID) AS Number_Of_Order
FROM Sales.SalesOrderHeader sod
INNER JOIN Person.Address pa 
ON sod.ShipToAddressID = pa.AddressID
INNER JOIN Person.StateProvince ps 
ON pa.StateProvinceID = ps.StateProvinceID 
INNER JOIN Person.CountryRegion pc 
ON ps.CountryRegionCode = pc.CountryRegionCode
GROUP BY rollup(pc.NAME, ps.NAME)
HAVING COUNT(sod.SalesOrderID) >= 100
ORDER BY pc.NAME, Number_Of_Order DESC


-- Problem 3
SELECT pc.NAME AS Catagory,
        p.NAME AS Product, 
        SUM(OrderQty) AS Number_Sold,
        RANK() OVER (PARTITION BY pc.NAME ORDER BY SUM(OrderQty) DESC) AS Rank,
	NTILE(5) OVER (PARTITION BY pc.NAME ORDER BY SUM(OrderQty) DESC) AS Quintile
FROM Production.Product p
INNER JOIN Production.ProductSubcategory ps 
ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN Production.ProductCategory pc
ON pc.ProductCategoryID = ps.ProductCategoryID
INNER JOIN Sales.SalesOrderDetail sod 
ON p.productid = sod.ProductID
GROUP BY p.NAME, pc.NAME
ORDER BY Catagory
