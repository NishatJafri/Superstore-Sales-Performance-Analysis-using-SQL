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
 
SELECT `Order Date` FROM superstore_dataset LIMIT 5;

SELECT `Order Date`
FROM superstore_dataset
WHERE CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
LIMIT 5;

SELECT `Order Date`
FROM superstore_dataset
WHERE CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(`Order Date`, '/', 2), '/', -1) AS UNSIGNED) > 12
LIMIT 5;

ALTER TABLE superstore_dataset ADD COLUMN order_date_clean DATE;

SET SQL_SAFE_UPDATES = 0;

UPDATE superstore_dataset
SET order_date_clean = STR_TO_DATE(`Order Date`, '%m/%d/%Y');

SELECT `Order Date`, order_date_clean
FROM superstore_dataset
LIMIT 10;

SELECT COUNT(*) AS null_dates
FROM superstore_dataset
WHERE order_date_clean IS NULL;

-- Customers whose total sales are above the average customer's total sales (CTE + subquery)
WITH customer_sales AS (
    SELECT `Customer Name`,
           ROUND(SUM(Sales), 2) AS total_sales
    FROM superstore_dataset
    GROUP BY `Customer Name`
)
SELECT *
FROM customer_sales
WHERE total_sales > (SELECT AVG(total_sales) FROM customer_sales)
ORDER BY total_sales DESC;

WITH customer_sales AS (
    SELECT `Customer Name`, SUM(Sales) AS total_sales
    FROM superstore_dataset
    GROUP BY `Customer Name`
)
SELECT COUNT(*) AS above_avg_customers, ROUND((SELECT AVG(total_sales) FROM customer_sales), 2) AS avg_spend
FROM customer_sales
WHERE total_sales > (SELECT AVG(total_sales) FROM customer_sales);

SELECT COUNT(DISTINCT `Customer Name`) AS total_customers FROM superstore_dataset;

-- Top 3 most profitable products in each category (2 CTEs + DENSE_RANK window function)
WITH product_profit AS (
    SELECT Category,
           `Product Name`,
           ROUND(SUM(Profit), 2) AS total_profit
    FROM superstore_dataset
    GROUP BY Category, `Product Name`
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY Category ORDER BY total_profit DESC) AS rnk
    FROM product_profit
)
SELECT *
FROM ranked
WHERE rnk <= 3;

-- Profit margin by discount band (CTE + CASE)
WITH discount_bands AS (
    SELECT CASE
             WHEN Discount = 0 THEN 'No discount'
             WHEN Discount <= 0.2 THEN 'Low (up to 20%)'
             WHEN Discount <= 0.4 THEN 'Medium (20-40%)'
             ELSE 'High (above 40%)'
           END AS discount_band,
           Sales,
           Profit
    FROM superstore_dataset
)
SELECT discount_band,
       COUNT(*) AS orders,
       ROUND(SUM(Sales), 2) AS total_sales,
       ROUND(SUM(Profit), 2) AS total_profit,
       ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin_pct
FROM discount_bands
GROUP BY discount_band
ORDER BY profit_margin_pct DESC;

-- Month-over-month sales growth (CTE + LAG window function)
WITH monthly_sales AS (
    SELECT DATE_FORMAT(order_date_clean, '%Y-%m') AS month,
           ROUND(SUM(Sales), 2) AS total_sales
    FROM superstore_dataset
    GROUP BY DATE_FORMAT(order_date_clean, '%Y-%m')
)
SELECT month,
       total_sales,
       LAG(total_sales) OVER (ORDER BY month) AS prev_month_sales,
       ROUND((total_sales - LAG(total_sales) OVER (ORDER BY month))
             / LAG(total_sales) OVER (ORDER BY month) * 100, 2) AS mom_growth_pct
FROM monthly_sales
ORDER BY month;

-- Loss-making sub-categories with their average discount (CTE + HAVING)
WITH subcat_summary AS (
    SELECT `Sub-Category`,
           ROUND(SUM(Sales), 2) AS total_sales,
           ROUND(SUM(Profit), 2) AS total_profit,
           ROUND(AVG(Discount) * 100, 1) AS avg_discount_pct
    FROM superstore_dataset
    GROUP BY `Sub-Category`
)
SELECT *
FROM subcat_summary
WHERE total_profit < 0
ORDER BY total_profit ASC;