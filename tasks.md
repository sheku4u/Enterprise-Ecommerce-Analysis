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