USE [Pizza];
GO

/* ====== Source table as-is (optional) ====== */
CREATE OR ALTER VIEW All_Pizza_Sales AS
SELECT * FROM dbo.pizza_sales;
GO

/* ====== KPI Views ====== */

/* 1) Total Revenue */
CREATE OR ALTER VIEW dbo.vw_KPI_1_Total_Revenue AS
SELECT SUM(total_price) AS [Total Revenue]
FROM dbo.pizza_sales;
GO

/* 2) Average Order Value */
CREATE OR ALTER VIEW dbo.vw_KPI_2_Avg_Order_Value AS
SELECT SUM(total_price) / COUNT(DISTINCT order_id) AS Avg_Order_Value
FROM dbo.pizza_sales;
GO

/* 3) Total Pizza Sold */
CREATE OR ALTER VIEW dbo.vw_KPI_3_Total_Pizza_Sold AS
SELECT SUM(quantity) AS Total_Pizza_Sold
FROM dbo.pizza_sales;
GO

/* 4) Total Orders */
CREATE OR ALTER VIEW dbo.vw_KPI_4_Total_Orders AS
SELECT COUNT(DISTINCT order_id) AS Total_Orders
FROM dbo.pizza_sales;
GO

/* 5) Average Pizzas per Order */
CREATE OR ALTER VIEW dbo.vw_KPI_5_Avg_Pizzas_Per_Order AS
SELECT CAST(
         CAST(SUM(quantity) AS DECIMAL(10,2)) /
         CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2))
       AS DECIMAL(10,2)) AS AVG_Pizzas_Per_Order
FROM dbo.pizza_sales;
GO
/* ================== Chart Views ================== */

/* Daily Trend for Total Orders */
CREATE OR ALTER VIEW dbo.vw_Chart_1_Daily_Trend_Total_Orders AS
SELECT 
    DATEPART(WEEKDAY, order_date) AS Day_Num,
    DATENAME(WEEKDAY, order_date) AS Order_day,
    COUNT(DISTINCT order_id) AS Total_orders
FROM dbo.pizza_sales
GROUP BY DATENAME(WEEKDAY, order_date), DATEPART(WEEKDAY, order_date);
GO
/* [2] Monthly Trend for Total Orders */
CREATE OR ALTER VIEW dbo.vw_Chart_2_Monthly_Trend_Total_Orders AS
SELECT 
    DATEPART(MONTH, order_date) AS Month_Num,
    DATENAME(MONTH, order_date) AS Month_Name,
    COUNT(DISTINCT order_id) AS Total_orders
FROM dbo.pizza_sales
GROUP BY DATENAME(MONTH, order_date), DATEPART(MONTH, order_date);
GO
/* [3] Percentage of Sales by pizza Category (all data) */
CREATE OR ALTER VIEW dbo.vw_Chart_3_Pct_Sales_By_Category AS
SELECT 
    pizza_category,
    ROUND(SUM(total_price), 2) AS Total_Sales,
    ROUND(
        SUM(total_price) * 100.0 /
        (SELECT SUM(total_price) FROM dbo.pizza_sales),
    2) AS PCT
FROM dbo.pizza_sales
GROUP BY pizza_category;
GO

/* [4] Percentage of Sales by pizza Size (all data) */
CREATE OR ALTER VIEW dbo.vw_Chart_4_Pct_Sales_By_Size AS
SELECT 
    pizza_size,
    ROUND(SUM(total_price), 2) AS Total_Sales,
    ROUND(
        SUM(total_price) * 100.0 /
        (SELECT SUM(total_price) FROM dbo.pizza_sales),
    2) AS PST
FROM dbo.pizza_sales
GROUP BY pizza_size;
GO

/* [5] Total Pizza Sold by pizza Category (all data) */
CREATE OR ALTER VIEW dbo.vw_Chart_5_Total_Pizza_Sold_By_Category AS
SELECT 
    pizza_category,
    SUM(quantity) AS Total_Quantity_Sold
FROM dbo.pizza_sales
GROUP BY pizza_category;
GO
USE [Pizza DB];
GO

/* ================== Top 5 Best Sellers ================== */

/* Top 5 by Revenue */
CREATE OR ALTER VIEW dbo.vw_Top5_Pizzas_By_Revenue AS
SELECT TOP 5
    pizza_name,
    ROUND(SUM(total_price), 2) AS Total_Revenue
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC;
GO

/* Top 5 by Total Quantity */
CREATE OR ALTER VIEW dbo.vw_Top5_Pizzas_By_Quantity AS
SELECT TOP 5
    pizza_name,
    ROUND(SUM(quantity), 2) AS Total_Quantity
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity DESC;
GO

/* Top 5 by Total Orders */
CREATE OR ALTER VIEW dbo.vw_Top5_Pizzas_By_Orders AS
SELECT TOP 5
    pizza_name,
    ROUND(COUNT(DISTINCT order_id), 2) AS Total_Order
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY Total_Order DESC;
GO


/* ================== Bottom 5 Worst Sellers ================== */

/* Bottom 5 by Revenue */
CREATE OR ALTER VIEW dbo.vw_Bottom5_Pizzas_By_Revenue AS
SELECT TOP 5
    pizza_name,
    ROUND(SUM(total_price), 2) AS Total_Revenue
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue ASC;
GO

/* Bottom 5 by Total Quantity */
CREATE OR ALTER VIEW dbo.vw_Bottom5_Pizzas_By_Quantity AS
SELECT TOP 5
    pizza_name,
    ROUND(SUM(quantity), 2) AS Total_Quantity
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity ASC;
GO

/* Bottom 5 by Total Orders */
CREATE OR ALTER VIEW dbo.vw_Bottom5_Pizzas_By_Orders AS
SELECT TOP 5
    pizza_name,
    ROUND(COUNT(DISTINCT order_id), 2) AS Total_Order
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY Total_Order ASC;
GO
