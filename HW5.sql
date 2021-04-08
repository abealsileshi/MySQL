use information_schema;

#1)
select TABLE_Name, TABLE_ROWS
from Tables 
where TABLE_SCHEMA = 'aw';

#2) 
select TABLE_NAME, column_key from COLUMNS where column_key = 'PRI';

#3) //naming convention changes from camCase in the aw table schema to all CAPS for Information_schema tables
select * from Tables;

#4) Some employees may have their own employees, therefore necesitating a recursive relationship

#5) What are the three types of models of bikes sold by AdventureWorks?
SELECT EnglishProductSubcategoryName FROM aw.DimProductSubcategory where EnglishProductSubcategoryName like '%Bikes%';
#mountain bikes, road bikes, touring bikes

use aw;
#6)

select CalendarYear, DPS.EnglishProductSubcategoryName, SUM(FI.UnitPrice*FI.OrderQuantity) as 'Sales'
from DimTime DT, DimProductSubcategory DPS, FactInternetSales FI, DimProduct DP
where DP.ProductKey = FI.ProductKey and DT.TimeKey = FI.OrderDateKey and DPS.ProductSubcategoryKey = DP.ProductSubcategoryKey
and DPS.EnglishProductSubcategoryName like '%Bikes%'
and DT.CalendarYear = '2003'
group by DPS.EnglishProductSubcategoryName, DT.CalendarYear
order by 3 desc;

#7)
#5 non-bike products are Jerseys, Gloves, Caps, Socks, Shorts
select CalendarYear, DPS.EnglishProductSubcategoryName
from DimTime DT, DimProductSubcategory DPS, FactInternetSales FI, DimProduct DP
where DP.ProductKey = FI.ProductKey and DT.TimeKey = FI.OrderDateKey and DPS.ProductSubcategoryKey = DP.ProductSubcategoryKey
and DPS.EnglishProductSubcategoryName not like '%Bikes%'
and DT.CalendarYear = '2003'
group by DPS.EnglishProductSubcategoryName, DT.CalendarYear;

#8)
SELECT DT.CalendarYear, count(DP.Color) as ColorSold, DP.Color
from DimTime DT, FactInternetSales FI, DimProduct DP, DimProductSubcategory DPS
where DT.CalendarYear between "2001" and "2004"
and DPS.EnglishProductSubcategoryName like "%Bikes%"
and DT.TimeKey = FI.OrderDateKey
and DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
and FI.ProductKey = DP.ProductKey
GROUP BY DT.CalendarYear, DP.Color
ORDER BY DT.CalendarYear, count(DP.Color) DESC; 

#9)
SELECT DC.EnglishEducation, count(DPS.ProductSubcategoryKey) as BikeSold, DPS.EnglishProductSubcategoryName
from DimCustomer DC, DimProductSubcategory DPS, FactInternetSales FI, DimProduct DP
WHERE DC.EnglishEducation = 'Graduate Degree'
and DPS.EnglishProductSubcategoryName like "%Bikes%"
and DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
and FI.ProductKey = DP.ProductKey
and DC.CustomerKey = FI.CustomerKey
group by DC.EnglishEducation, DPS.ProductSubcategoryKey
order by DC.EnglishEducation, count(DPS.ProductSubcategoryKey) desc;

#10) For the year 2004, which State/Province yielded the highest margin for AdventureWorks? 
#(HINT: use the customer’s State/Province.) Provide your SQL query, and your answer set along with your answer to the question. 
SELECT DT.CalendarYear, DG.StateProvinceName , sum(FI.UnitPrice - FI.ProductStandardCost) as Margin
from DimTime DT, FactInternetSales FI, DimCustomer DC, DimProduct DP, DimProductSubcategory DPS, DimGeography DG
where DT.CalendarYear = '2004'
and DPS.EnglishProductSubcategoryName like "%Bikes%"
and DG.GeographyKey = DC.GeographyKey
and DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
and FI.ProductKey = DP.ProductKey
ORDER BY DG.StateProvinceName, Margin DESC; 
