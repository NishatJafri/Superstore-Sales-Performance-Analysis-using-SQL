CREATE DATABASE superstore_project;
USE superstore_project;
SELECT * FROM superstore_dataset LIMIT 10;
SELECT COUNT(*) AS total_rows FROM superstore_dataset ;
DESCRIBE superstore_dataset;
-- Calculating Total Sales
SELECT ROUND(SUM(Sales),2) AS total_sales FROM superstore_dataset;
-- Calculating Total Profit
SELECT ROUND(SUM(Profit),2) AS Total_Profit FROM superstore_dataset;
-- Sales by Region
SELECT Region, ROUND(SUM(Sales),2) AS total_sales 
FROM superstore_dataset
GROUP BY Region
ORDER BY total_sales DESC;
-- Sales by category
SELECT Category, ROUND(SUM(Sales),2) AS total_sales 
FROM superstore_dataset
GROUP BY Category
ORDER BY total_sales DESC;
-- Pr0fit by Region
 Select Region, ROUND(SUM(Profit),2) AS Total_Profit
 FROM superstore_dataset
 GROUP BY Region
 ORDER BY Total_Profit DESC;
 -- Profit by Category
 SELECT Category, ROUND(SUM(Profit),2) AS Total_Profit
 FROM superstore_dataset
 GROUP BY Category
 ORDER BY Total_Profit DESC;
 -- Top 10 Selling Products
 SELECT `Product Name`, ROUND(SUM(Sales),2) AS Total_Sales
 FROM superstore_dataset
 GROUP BY `Product Name`
 ORDER BY Total_Sales DESC
 LIMIT 10;
 -- Top 10 Profitable Products
 SELECT `Product Name`, ROUND(SUM(Profit),2) AS Total_Profit
 FROM superstore_dataset
 GROUP BY `Product Name`
 ORDER BY Total_Profit DESC
 LIMIT 10;
 -- Top Customers by Sales
 SELECT `Customer Name`, ROUND(SUM(Sales),2) AS Total_Sales
 FROM superstore_dataset
 GROUP BY `Customer Name`
 ORDER BY Total_Sales DESC
 LIMIT 10;
 -- Calculating the Average Sales
 SELECT ROUND(AVG(Sales),2) AS Average_Sales
 FROM superstore_dataset;
 -- Sales by Customer Segment
 SELECT Segment, Round(sum(Sales),2) AS Total_Sales
FROM superstore_dataset
GROUP BY Segment
ORDER BY Total_Sales DESC;
-- Top 10 loss-making Product
SELECT `Product Name`, ROUND(SUM(Profit),2) AS Total_Profit
 FROM superstore_dataset
 GROUP BY `Product Name`
 ORDER BY Total_Profit ASC
 LIMIT 10;