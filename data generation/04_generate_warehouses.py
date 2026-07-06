import pandas as pd
import numpy as np
import random

random.seed(42)
np.random.seed(42)

NUM_WAREHOUSES = 50

# ---------------------------------------------------
# Cities by State
# ---------------------------------------------------

locations = {
    "Delhi": ["New Delhi"],
    "Maharashtra": ["Mumbai", "Pune", "Nagpur"],
    "Karnataka": ["Bangalore", "Mysore"],
    "Tamil Nadu": ["Chennai", "Coimbatore"],
    "West Bengal": ["Kolkata"],
    "Uttar Pradesh": ["Lucknow", "Noida", "Kanpur"],
    "Punjab": ["Ludhiana", "Amritsar"],
    "Rajasthan": ["Jaipur"],
    "Gujarat": ["Ahmedabad", "Surat"],
    "Haryana": ["Gurgaon", "Faridabad"]
}

# ---------------------------------------------------
# Region Mapping
# ---------------------------------------------------

region_map = {
    "Delhi": "North",
    "Punjab": "North",
    "Haryana": "North",
    "Uttar Pradesh": "North",

    "Rajasthan": "West",
    "Gujarat": "West",
    "Maharashtra": "West",

    "Karnataka": "South",
    "Tamil Nadu": "South",

    "West Bengal": "East"
}

# ---------------------------------------------------
# Generate Warehouses
# ---------------------------------------------------

warehouses = []

for i in range(1, NUM_WAREHOUSES + 1):

    state = random.choice(list(locations.keys()))
    city = random.choice(locations[state])

    warehouses.append({

        "warehouse_id": f"WH{i:03d}",

        "warehouse_name": f"{city} Distribution Center",

        "city": city,

        "state": state,

        "region": region_map[state],

        "capacity": random.randint(5000,50000)

    })

warehouse_df = pd.DataFrame(warehouses)

# ---------------------------------------------------
# DIRTY DATA
# ---------------------------------------------------

# Missing city

warehouse_df.loc[
    warehouse_df.sample(3, random_state=1).index,
    "city"
] = np.nan

# Missing capacity

warehouse_df.loc[
    warehouse_df.sample(3, random_state=2).index,
    "capacity"
] = np.nan

# Capacity = 0

warehouse_df.loc[
    warehouse_df.sample(2, random_state=3).index,
    "capacity"
] = 0

# Negative Capacity

warehouse_df.loc[
    warehouse_df.sample(2, random_state=4).index,
    "capacity"
] = -500

# Wrong City-State Combination

wrong = warehouse_df.sample(3, random_state=5).index

warehouse_df.loc[wrong, "city"] = "Mumbai"
warehouse_df.loc[wrong, "state"] = "Punjab"

# Lower Case Warehouse Name

idx = warehouse_df.sample(4, random_state=6).index

warehouse_df.loc[idx, "warehouse_name"] = (
    warehouse_df.loc[idx, "warehouse_name"]
    .str.lower()
)

# Extra Spaces

idx = warehouse_df.sample(4, random_state=7).index

warehouse_df.loc[idx, "warehouse_name"] = (
    "   " +
    warehouse_df.loc[idx, "warehouse_name"] +
    "   "
)

# ---------------------------------------------------
# Duplicate Warehouses
# ---------------------------------------------------

duplicates = warehouse_df.sample(
    5,
    random_state=42
).copy()

warehouse_df = pd.concat(
    [warehouse_df, duplicates],
    ignore_index=True
)

# ---------------------------------------------------
# Shuffle
# ---------------------------------------------------

warehouse_df = warehouse_df.sample(
    frac=1,
    random_state=42
).reset_index(drop=True)

# ---------------------------------------------------
# Save
# ---------------------------------------------------

warehouse_df.to_csv(
    "C:/Users/abhis/OneDrive/Documents/abhishek/Data_Analyst_Abhishek/data_analyst/python_data/practice/enterprise ecommerce project/data/warehouses.csv",
    index=False
)

# ---------------------------------------------------
# Summary
# ---------------------------------------------------

print(warehouse_df.head())

print("\nWarehouses Generated Successfully")

print(f"Rows : {len(warehouse_df)}")

print("\nMissing Values")

print(warehouse_df.isna().sum())