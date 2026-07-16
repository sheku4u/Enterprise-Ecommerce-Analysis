# Ecommerce Analysis Project

## Project Roadmap
Enterprise_Ecommerce_Project/

│
├── data_generation/
│   ├── 01_generate_customers.py      ← Today
│   ├── 02_generate_vendors.py
│   ├── 03_generate_products.py
│   ├── 04_generate_warehouses.py
│   ├── 05_generate_employees.py
│   ├── 06_generate_promotions.py
│   ├── 07_generate_orders.py          ⭐ Biggest script (~700 lines)
│   ├── 08_generate_shipping.py
│   ├── 09_generate_returns.py
│   ├── 10_generate_inventory.py
│
├── database/
│   ├── create_database.py
│   ├── load_to_sqlite.py
│
├── data/
│
├── notebooks/
│
├── sql/
│
└── powerbi/

## technologies 
- Python
- SQL
- PowerBI
- Reports 

## Customer Table

### Python
isnull()
fillna()
drop_duplicates()
.duplicated()
type conversion
outlier detection
invalid value detection
string cleaning
### SQL
Find duplicate customers.
Find customers with invalid ages.
Find future join dates.
Find missing genders.
Count customers by segment.
Top states by customer count.
Monthly customer acquisition.
### Power BI
Customer demographics.
Customer acquisition trend.
Segment analysis.
Geographic distribution.
Data quality dashboard.

## Vendors Table
### Python
fillna()
drop_duplicates()
.duplicated()
.str.strip()
.str.title()
.str.upper()
.str.lower()
Rating validation
Company name standardization
### SQL Questions

You can practice questions like:

Easy
Count vendors by country.
Average vendor rating.
Vendors with missing ratings.
Medium
Top 10 highest-rated vendors.
Vendor distribution by country.
Duplicate vendor names.
Vendors with invalid ratings.
Hard
Standardize vendor names using SQL string functions.
Detect fuzzy duplicates (after trimming and changing case).
Rank vendors by rating within each country.
Find countries where average vendor rating is below the global average.

## Product Table
### Python
Detect products where selling_price < cost_price.
Find and fix missing brands.
Standardize brand names (strip, title).
Identify price outliers using IQR and Z-score.
Detect duplicate products.
### SQL
Top 10 most expensive products.
Average selling price by category.
Products with invalid prices.
Products whose selling price is below cost.
Rank products within each category by price.
Find categories with the highest average margin.
### Power BI
Product catalog dashboard.
Category and sub-category analysis.
Price distribution.
Margin analysis.
Brand performance.


## Warehouse Table
### Python
isnull()

fillna()

duplicated()

drop_duplicates()

str.strip()

str.title()

astype()

describe()

IQR Outlier Detection

Z-score

Data Validation
### SQL Questions

Examples:

Beginner
Count warehouses by state.
Average warehouse capacity.
Largest warehouse.
Intermediate
Warehouses with missing capacity.
Warehouses having invalid capacity.
Duplicate warehouse names.
Warehouses by region.
Advanced
Capacity contribution by region.
Rank warehouses by capacity.
Warehouses above regional average.
Detect wrong city-state mappings.
### Power BI

Later you'll build:

Warehouse Map
Capacity Utilization
Region-wise Warehouses
Inventory by Warehouse
Reorder Dashboard
Stock Distribution
























# ######################################################

# main
Python Data Cleaning

Interviewer may ask every one of these.

Missing Values

Handle

Customer age missing
Gender missing
Brand missing
Shipping mode missing
Duplicate Records

Remove duplicate

customer_id

order_id

shipment_id
Wrong Data Types

Convert

object → datetime

string → category

price → float

quantity → int
Invalid Values

Find

Negative sales

Negative profit

Age = 350

Discount >100%

Future dates

Delivery before shipping

Refund greater than sales

Quantity =0

Outlier Detection

Using

Boxplot

IQR

Z-score

Feature Engineering

Create

Revenue

Profit Margin

Year

Quarter

Week

Month

Weekend

Order Age

Customer Lifetime

Recency

Frequency

Monetary

Average Order Value

Days to Deliver

Late Delivery

Python EDA

Every interview topic.

Sales Analysis

Monthly Sales

Yearly Sales

Quarterly Sales

Weekday vs Weekend

Seasonality

Growth %

Moving Average

Rolling Sales

Customer Analysis

Top Customers

Bottom Customers

New vs Repeat

Customer Lifetime Value

RFM

Customer Segmentation

Retention

Churn

Product Analysis

Top Products

Worst Products

Most Returned Products

Highest Margin Products

Low Margin Products

ABC Analysis

Basket Analysis

Regional Analysis

State

City

Country

Warehouse

Region

Vendor Analysis

Vendor Performance

Vendor Rating

Vendor Profitability

Vendor Return Rate

Shipping Analysis

Average Delivery Time

Late Shipments

Fastest Shipping Mode

Shipping Cost Analysis

Return Analysis

Return %

Return Reason

Return by Category

Refund Analysis

Inventory Analysis

Stock Out

Reorder Needed

Inventory Turnover

Slow Moving Products

Dead Stock

Promotion Analysis

Promotion Effectiveness

Sales Before Promotion

Sales During Promotion

Sales After Promotion

ROI

Employee Analysis

Sales by Employee

Profit by Employee

Orders Processed

SQL Business Questions

Now comes interview level.

I would write nearly 120 SQL questions.

Beginner

Total Sales

Total Orders

Average Sales

Highest Sale

Lowest Sale

Unique Customers

Unique Products

Intermediate

Top 10 Customers

Top Products

Top Categories

Monthly Sales

Monthly Growth

Running Total

Ranking

Dense Rank

Lead

Lag

NTILE

Percent Rank

CTE

Subqueries

Correlated Queries

Advanced

Rolling 3 Month Sales

Moving Average

Cohort Analysis

RFM

Customer Retention

Churn

ABC Analysis

Pareto Analysis

Basket Analysis

Market Basket

Customer Journey

Conversion Funnel

Sales Forecast Input

Seasonality

Median Sales

Percentile

Window Functions

Recursive CTE

Pivot

Unpivot

Dynamic SQL

Date Intelligence

Extremely Hard Interview Questions

These are exactly interviewer favorites.

Find customers whose every order is above average.

Find products never sold.

Find products sold in every state.

Find customer buying consecutive months.

Find second highest selling product in every category.

Find top 3 products per month.

Find employee contributing >40% revenue.

Find vendor with increasing sales every month.

Find customers ordering only weekends.

Find products whose return rate exceeds category average.

Find warehouse with lowest stock but highest sales.

Find products that generated loss but high revenue.

Find top customers responsible for 80% revenue.

Find cities where profit decreased 3 months continuously.

Find products sold together frequently.

Detect duplicate orders.

Find suspicious refund transactions.

Detect fake customers.

Find customers inactive for 180 days.

Predict reorder candidates.

Power BI Dashboard Pages
Executive Dashboard

KPIs

Revenue

Profit

Orders

Customers

Margin

Growth

Sales Dashboard

Trend

Category

Subcategory

Region

Customer Dashboard

Retention

RFM

Segments

Top Customers

Product Dashboard

Top Products

Low Performers

ABC

Inventory Dashboard

Stock

Dead Stock

Reorder

Shipping Dashboard

Delivery

Delay

Shipping Cost

Vendor Dashboard

Vendor Ranking

Performance

Returns

Return Dashboard

Reasons

Refund

Categories

Drill Through Pages

Customer Detail

Product Detail

Vendor Detail

Power BI DAX Questions

Interviewers love these.

Write measures for

Running Total
YTD Sales
MTD Sales
QTD Sales
Previous Month Sales
YoY Growth
Profit Margin
Average Order Value
Customer Lifetime Value
Dynamic Ranking
Pareto 80/20
Rolling 12 Months
Moving Average
Dynamic Titles
Field Parameters
Calculation Groups (if available)
Top N
Dynamic Date Filters
Forecast Measures
Python Skills You'll Practice
pandas
NumPy
matplotlib
Plotly
missing value handling
feature engineering
groupby
merge
pivot_table
crosstab
datetime
RFM analysis
cohort analysis
outlier detection
SQL Skills You'll Practice
Joins
CTEs
Recursive CTEs
Window Functions
Aggregations
Ranking
Date Functions
Pivot/Unpivot
Correlated Subqueries
Views
Indexes
Query Optimization
Execution Plans
Power BI Skills You'll Practice
Star schema modeling
Relationship design
Power Query (M)
DAX
Time intelligence
Bookmarks
Drill-through
Tooltips
Dynamic titles
Row-level security (RLS)
Incremental refresh (conceptually)
Performance optimization