USE AdventureWorks2014

-- Problem 1
-- Part A
SELECT DISTINCT JobTitle
FROM HumanResources.Employee
ORDER BY JobTitle ASC


-- Part B
SELECT DISTINCT JobTitle
FROM HumanResources.Employee
WHERE JobTitle LIKE '%Manager%' 
                OR JobTitle LIKE '%Supervisor%'
                    OR JobTitle LIKE 'Chief%'
                        OR JobTitle LIKE '%Vice President%'
ORDER BY JobTitle ASC


-- Part C
SELECT COUNT(JobTitle) AS Managers
FROM HumanResources.Employee
WHERE JobTitle LIKE '%Manager%' 
                OR JobTitle LIKE '%Supervisor%'
                    OR JobTitle LIKE 'Chief%'
                        OR JobTitle LIKE '%Vice President%'



-- Part D
SELECT BusinessEntityID AS EmployeeID, 
            JobTitle,
                BirthDate,
                    CAST((GETDATE() - CAST(BirthDate AS DATETIME))AS numeric)/ 365.25 AS Age
FROM HumanResources.Employee
--WHERE CAST((GETDATE() - CAST(BirthDate AS DATETIME))AS numeric)/ 365.25 >= 60
WHERE DATEDIFF(Day, BirthDate, GETDATE())/ 365.25 >= 60
ORDER BY BirthDate DESC


---Prof
SELECT
 BusinessEntityID AS EmployeeID
 ,JobTitle
 ,BirthDate
 ,CAST((GETDATE()- CAST(BirthDate as datetime)) as numeric)/365.25 AS 'Age'
FROM HumanResources.Employee
WHERE CAST((GETDATE()- CAST(BirthDate as datetime)) as numeric)/365.25
>= 60
AND CurrentFlag>=1
ORDER BY Age 


--Prof
SELECT 
 BusinessEntityID AS EmployeeID
 ,JobTitle
 ,BirthDate
 ,DATEDIFF(Day,BirthDate,GETDATE())/365.25 AS 'Age'
FROM HumanResources.Employee
WHERE DATEDIFF(Day,BirthDate,GETDATE())/365.25 >=60
AND CurrentFlag>=1
ORDER BY Age 


-- Part E
-- WHY can not use: where EmploymentYears >= 7
SELECT BusinessEntityID AS EmployeeID, 
            HireDate,
                CAST(GETDATE() - CAST(HireDate AS DATETIME) AS INT)/365 AS EmploymentYears
FROM HumanResources.Employee
WHERE DATEDIFF(DD, BirthDate, GETDATE())/ 365.25 >= 60
        AND DATEDIFF(Day, HireDate, GETDATE())/ 365.25 >= 7
--WHERE CAST((GETDATE()- CAST(BirthDate as datetime)) as numeric)/365.25 >= 60
--AND 
    --CAST((GETDATE()- CAST(HireDate as datetime)) as numeric)/365.25 >= 7
--ORDER BY EmploymentYears DESC


-- Problem 2
-- Part A
SELECT  
        Name AS Product_Name,
        ListPrice,
        SafetyStockLevel
FROM Production.Product
WHERE FinishedGoodsFlag = 1 
    AND SellEndDate IS NULL
ORDER BY SafetyStockLevel, Product_Name ASC


-- Part B
SELECT Name, Color
FROM Production.Product
WHERE Name LIKE '%Yellow%'
AND (Color != 'Yellow' OR Color is NULL)


-- Part C
SELECT Name, 
        SellStartDate
FROM Production.Product
WHERE SellStartDate BETWEEN '2013-01-01' AND '2013-05-31'
ORDER BY Name ASC


-- Part D
SELECT Name,
        SellStartDate,
            DATEPART(WEEKDAY, SellStartDate) AS The_Day_Of_The_Week
FROM Production.Product
WHERE DATEPART(WEEKDAY, SellStartDate) >= 4
ORDER BY SellStartDate ASC, Name ASC



