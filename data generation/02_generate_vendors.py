import pandas as pd
import numpy as np
import random 
from faker import Faker

faker = Faker()

random.seed(42)
np.random.seed(42)

num_vendors = 300

countries = [
    'India',
    'China',
    'USA',
    'Germany',
    'Japan',
    'South Korea',
    'Vietnam',
    'Thailand',
    'Singapore',
    'Malaysia'
]

company_suffix = [
    "Ltd",
    "Pvt Ltd",
    "Industries",
    "Corporation",
    "Enterprises",
    "Global",
    "Solutions",
    "Traders",
    "Suppliers",
    "Manufacturing"
]

vendors = []

for i in range(1, num_vendors + 1):
    company = f"{faker.company().split()[0]} {random.choice(company_suffix)}"

    vendors.append({
        "vendor_id":f"VEND{i:04d}",
        "vendor_name" : company,
        "country": random.choice(countries),
        "rating": round(random.uniform(2.5, 5.0),1)
    })

vendors = pd.DataFrame(vendors)



############################################################
# Dirty Data
############################################################

# missing data
vendors.loc[
    vendors.sample(15, random_state= 1).index,
    "rating"
] = np.nan

# invalid rating > 5
vendors.loc[
    vendors.sample(4, random_state=2).index,
    "rating"
] = 5.9

vendors.loc[
    vendors.sample(6, random_state=3).index,
    "rating"
] = 0.5

# missing vendor name
vendors.loc[
    vendors.sample(5, random_state=4).index,
    "vendor_name"
] = None

# Leading / Trailling Spaces
space_idx = vendors.sample(8, random_state=5).index

vendors.loc[
    space_idx,
    "vendor_name"
] = vendors.loc[
    space_idx,
    "vendor_name"
].astype(str).apply(lambda X : " " + X + "   ")

# lower Case Name
lower_idx = vendors.sample(8, random_state=6).index

vendors.loc[
    lower_idx,
    "vendor_name"
] = vendors.loc[
    lower_idx,
    "vendor_name"
].astype(str).str.lower()

# Upper Case Names
upper_idx = vendors.sample(8, random_state=7).index

vendors.loc[
    upper_idx,
    "vendor_name"
] = vendors.loc[
    upper_idx,
    "vendor_name"
].astype(str).str.upper()

########################################################
# Duplicate Vendors
########################################################

duplicates = vendors.sample(10, random_state=42).copy()

vendors = pd.concat(
    [vendors, duplicates],
    ignore_index=True
)

########################################################
# Shuffle Rows
########################################################

vendors = vendors.sample(
    frac=1,
    random_state=42
).reset_index(drop=True)

########################################################
# Save CSV
########################################################

vendors.to_csv("C:/Users/abhis/OneDrive/Documents/abhishek/Data_Analyst_Abhishek/data_analyst/python_data/practice/enterprise ecommerce project/data/vendors.csv", index=False)

########################################################
# Summary
########################################################

print(vendors.head(5))

print("\nDataset is created successfully!")

print(f"total rows: {len(vendors)}")
print(f"total columns: {vendors.shape[1]}")

print('\n Missing Value')

print(vendors.isna().sum())


