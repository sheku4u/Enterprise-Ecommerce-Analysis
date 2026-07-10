import pandas as pd
import numpy as np
import random

random.seed(42)
np.random.seed(42)

NUM_PRODUCTS = 2000

######################################################
# Categories
######################################################

catalog = {
    "Electronics": [
        "Mobile",
        "Laptop",
        "Tablet",
        "Smart Watch",
        "Headphones",
        "Camera"
    ],
    "Home": [
        "Furniture",
        "Kitchen",
        "Decor",
        "Lighting",
        "Storage"
    ],
    "Fashion": [
        "Men Clothing",
        "Women Clothing",
        "Footwear",
        "Bags",
        "Watches"
    ],
    "Beauty": [
        "Skin Care",
        "Hair Care",
        "Makeup",
        "Perfume"
    ],
    "Sports": [
        "Fitness",
        "Outdoor",
        "Cycling",
        "Cricket"
    ],
    "Books": [
        "Fiction",
        "Education",
        "Biography",
        "Children"
    ]
}

######################################################
# Brands
######################################################

brands = [
    "Samsung","Apple","Sony","LG","Dell","HP","Lenovo",
    "Nike","Adidas","Puma","Boat","Noise","Mi","OnePlus",
    "Philips","Canon","Casio","Prestige","Ikea","Wildcraft",
    "Lakme","Loreal","Maybelline","Nivea","Mamaearth",
    "Reebok","US Polo","Allen Solly","Titan","Fastrack",
    "Borosil","Cello","Milton","Syska","Bajaj"
]

######################################################
# Product Adjectives
######################################################

adjectives = [
    "Premium","Smart","Ultra","Pro","Max","Mini",
    "Classic","Elite","Advanced","Eco",
    "Digital","Portable","Luxury","Wireless",
    "Essential"
]

######################################################
# Products
######################################################

products = []

for i in range(1, NUM_PRODUCTS + 1):

    category = random.choice(list(catalog.keys()))
    sub_category = random.choice(catalog[category])

    brand = random.choice(brands)

    cost = round(random.uniform(50,50000),2)

    markup = random.uniform(1.10,1.70)

    selling = round(cost*markup,2)

    product_name = f"{random.choice(adjectives)} {brand} {sub_category}"

    vendor = f"VEND{random.randint(1,300):04d}"

    products.append({

        "product_id":f"PROD{i:05d}",

        "product_name":product_name,

        "category":category,

        "sub_category":sub_category,

        "brand":brand,

        "vendor_id":vendor,

        "cost_price":cost,

        "selling_price":selling

    })

products = pd.DataFrame(products)

######################################################
# DIRTY DATA
######################################################

# Missing Brand

products.loc[
    products.sample(40, random_state=1).index,
    "brand"
] = np.nan

# Negative Cost

products.loc[
    products.sample(100, random_state=2).index,
    "cost_price"
] *= -1

# Negative Selling Price

products.loc[
    products.sample(50, random_state=3).index,
    "selling_price"
] *= -1

# Selling price lower than cost

idx = products.sample(25, random_state=4).index

products.loc[idx,"selling_price"] = (
    products.loc[idx,"cost_price"] * 0.60
)

# Zero Cost

products.loc[
    products.sample(6, random_state=5).index,
    "cost_price"
] = 0

# Zero Selling

products.loc[
    products.sample(60, random_state=6).index,
    "selling_price"
] = 0

# Extremely Expensive Products

products.loc[
    products.sample(10, random_state=7).index,
    "selling_price"
] = 999999

# Wrong Category/Subcategory

wrong = products.sample(20, random_state=8).index

products.loc[wrong,"category"] = "Electronics"

products.loc[wrong,"sub_category"] = "Hair Care"

# Brand in lower case

idx = products.sample(20, random_state=9).index

products.loc[idx,"brand"] = (
    products.loc[idx,"brand"]
    .astype(str)
    .str.lower()
)

# Leading spaces

idx = products.sample(20, random_state=10).index

products.loc[idx,"brand"] = (
    "   " +
    products.loc[idx,"brand"].astype(str) +
    "   "
)

######################################################
# Duplicate Products
######################################################

duplicates = products.sample(
    30,
    random_state=42
).copy()

products = pd.concat(
    [products,duplicates],
    ignore_index=True
)

######################################################
# Shuffle
######################################################

products = products.sample(
    frac=1,
    random_state=42
).reset_index(drop=True)

######################################################
# Save
######################################################

products.to_csv(
    "C:/Users/abhis/OneDrive/Documents/abhishek/Data_Analyst_Abhishek/data_analyst/python_data/practice/enterprise ecommerce project/data/products.csv",
    index=False
)

######################################################
# Summary
######################################################

print(products.head())

print("\nProducts Created Successfully")

print("Rows :",len(products))

print("\nMissing Values")

print(products.isna().sum())