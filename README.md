# Superstore Sales Performance Analysis Using SQL

SQL analysis of retail sales data in MySQL, covering sales, profit, customers, products and discounting. The project uses aggregate queries, CTEs, subqueries, window functions and `CASE` logic to turn raw order data into business findings.

## Dataset
- Superstore sales dataset (9,694 order lines, 793 customers, 2014-2017)
- Single table: `superstore_dataset`
- Columns used: Order Date, Region, Category, Sub-Category, Segment, Product Name, Customer Name, Sales, Discount, Profit

## Tools
MySQL, MySQL Workbench

## Data Preparation
- `Order Date` was stored as text in `month/day/year` format (e.g. `11/8/2016`).
- Added a clean `DATE` column (`order_date_clean`) using `STR_TO_DATE(..., '%m/%d/%Y')`.
- Verified the conversion: 0 NULL dates after the update.

## SQL Concepts Used
| Concept | Where it is used |
|---|---|
| Aggregates, `GROUP BY`, `ORDER BY`, `LIMIT` | Sales and profit by region, category, segment, product, customer |
| CTE + subquery | Customers spending above the average |
| Multiple CTEs + `DENSE_RANK() OVER (PARTITION BY ...)` | Top 3 products per category by profit |
| CTE + `LAG()` | Month-over-month sales growth |
| CTE + `CASE` | Profit margin by discount band |
| CTE + aggregates + `WHERE` on results | Loss-making sub-categories |

## Key Findings

**1. Discounts above 20% destroy profit.**

| Discount band | Orders | Profit margin |
|---|---|---|
| No discount | 4,657 | 29.57% |
| Up to 20% | 3,693 | 11.91% |
| 20-40% | 459 | -15.31% |
| Above 40% | 885 | -77.20% |

Orders discounted above 20% were about 14% of all orders but produced a combined loss of about 134K, equal to roughly 40% of the 317K profit earned on undiscounted orders.

**2. Only three sub-categories lose money, and two of them discount heavily.**
Tables (-17.7K), Bookcases (-3.5K) and Supplies (-1.3K). Tables account for about 79% of the combined loss. Tables and Bookcases also have the highest average discounts (26.1% and 21.1%). Supplies has a low average discount (7.6%), so discounting does not explain its loss; this would need further analysis of costs or individual orders.

**3. Sales are strongly seasonal.**
Sales peak in September and November each year and fall sharply in January (-73.9%, -75.3% and -54.4% month over month in 2015, 2016 and 2017). November sales rose from about 78.5K in 2016 to about 117.4K in 2017 (roughly +50%).

**4. A minority of customers drive spending.**
299 of 793 customers (about 38%) spend above the average of 2,865.64 per customer. The top customer spent about 25.0K, roughly 32% more than the second-highest.

**5. Profit is concentrated in Technology.**
The most profitable product in each category: Technology 25.2K (Canon imageCLASS 2200 Advanced Copier), Office Supplies 7.8K, Furniture 1.9K.

## Business Recommendation
Review discount policy for orders above 20%, starting with Tables and Bookcases, and plan inventory and promotions around the September and November peaks.

## Repository Structure
```
├── README.md
└── superstore_analysis.sql   # all queries, commented
```

## How to Run
1. Create the database: `CREATE DATABASE superstore_project;`
2. Import the Superstore CSV into a table named `superstore_dataset` (Table Data Import Wizard in MySQL Workbench).
3. Run the date-conversion step, then the queries in `superstore_analysis.sql` in order.

## Author
Nishat Jafri
