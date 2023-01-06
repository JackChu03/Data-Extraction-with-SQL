--1
SELECT dr.ResellerName,
        dt.SalesTerritoryCountry,
        dpc.EnglishProductCategoryName,
        sum(fr.SalesAmount) AS Total_amount,
        dcur.CurrencyName
FROM FactResellerSales fr
INNER JOIN DimPromotion dp
ON dp.PromotionKey = fr.PromotionKey
INNER JOIN DimSalesTerritory dt 
ON dt.SalesTerritoryKey = fr.SalesTerritoryKey 
INNER JOIN DimReseller dr 
ON dr.ResellerKey = fr.ResellerKey 
INNER JOIN DimProduct dpt
ON dpt.ProductKey = fr.ProductKey 
INNER JOIN DimProductSubcategory dps 
ON dps.ProductSubcategoryKey = dpt.ProductSubcategoryKey 
INNER JOIN DimProductCategory  dpc
ON dpc.ProductCategoryKey = dps.ProductCategoryKey 
INNER JOIN DimCurrency dcur 
ON dcur.CurrencyKey = fr.CurrencyKey 
WHERE fr.PromotionKey = 13 
GROUP BY dr.ResellerName, dt.SalesTerritoryCountry, dpc.EnglishProductCategoryName, dcur.CurrencyName
ORDER BY Total_amount DESC


--2
SELECT Case WHEN dg.City IS NULL
        THEN 'Total'
        ELSE dg.City
        END AS CITY, 
        CASE WHEN dg.StateProvinceName IS NULL AND dg.City IS NULL
        THEN '*Total'
        WHEN dg.StateProvinceName IS NULL
        THEN '*Subtotoal'
        ELSE dg.StateProvinceName
        END AS StateProvinceName,
        sum(fr.SalesAmount) as Total_Sale
FROM FactResellerSales fr
INNER JOIN DimReseller dr 
ON fr.ResellerKey = dr.ResellerKey
INNER JOIN DimGeography dg 
ON dr.GeographyKey = dg.GeographyKey
INNER JOIN DimCurrency dcur 
ON dcur.CurrencyKey = fr.CurrencyKey 
WHERE dcur.CurrencyAlternateKey = 'EUR'
GROUP BY rollup(dg.City, dg.StateProvinceName)


--3
SELECT dcur.CurrencyAlternateKey,
        ROUND(SUM(fr.SalesAmount),2) as Total_Sale
FROM FactResellerSales fr
INNER JOIN DimReseller dr 
ON fr.ResellerKey = dr.ResellerKey
INNER JOIN DimGeography dg 
ON dr.GeographyKey = dg.GeographyKey
INNER JOIN DimCurrency dcur 
ON dcur.CurrencyKey = fr.CurrencyKey 
GROUP BY dcur.CurrencyAlternateKey
ORDER BY Total_Sale DESC


--4
SELECT wider_data.EnglishPromotionName,
        wider_data.FiscalYear,
        wider_data.[2] as Fiscal_Q2,
        wider_data.[3] as Fiscal_Q3,
        wider_data.CurrencyName
FROM (
	SELECT  dp.EnglishPromotionName,
        dd.FiscalYear, 
        FiscalQuarter,
        fr.SalesAmount AS SalesAmount,
        dcur.CurrencyName
FROM FactResellerSales fr
INNER JOIN DIMDATE dd
ON fr.OrderDatekey = dd.DateKey
INNER JOIN DimPromotion dp
ON dp.PromotionKey = fr.PromotionKey
INNER JOIN DimCurrency dcur 
ON dcur.CurrencyKey = fr.CurrencyKey 
WHERE dp.EnglishPromotionName IN ('Touring-1000 Promotion', 'Touring-3000 Promotion')
) as Promotion_Data
PIVOT
(
	SUM(SalesAmount)
	FOR FiscalQuarter
	IN ([2], [3])
) as wider_data


--5
SELECT wider_data.EnglishPromotionName,
        wider_data.FiscalYear,
        CASE WHEN wider_data.[2] IS NULL
        THEN 0 
        ELSE wider_data.[2]
        END as Fiscal_Q2,
        wider_data.[3] as Fiscal_Q3,
        wider_data.CurrencyAlternateKey
FROM (
	SELECT  dp.EnglishPromotionName,
        dd.FiscalYear, 
        FiscalQuarter,
        fr.SalesAmount AS SalesAmount,
        dcur.CurrencyAlternateKey
FROM FactInternetSales fr
INNER JOIN DIMDATE dd
ON fr.OrderDatekey = dd.DateKey
INNER JOIN DimPromotion dp
ON dp.PromotionKey = fr.PromotionKey
INNER JOIN DimCurrency dcur 
ON dcur.CurrencyKey = fr.CurrencyKey 
WHERE dp.EnglishPromotionName IN ('Touring-1000 Promotion', 'Touring-3000 Promotion')

) as Promotion_Data
PIVOT
(
	SUM(SalesAmount)
	FOR FiscalQuarter
	IN ([2], [3])
) as wider_data



