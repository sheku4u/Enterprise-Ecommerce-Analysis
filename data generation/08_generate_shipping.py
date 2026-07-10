"""
=========================================================
Enterprise Ecommerce Analytics Project
File: 08_generate_shipping.py
=========================================================
"""

import random
from datetime import timedelta

import numpy as np
import pandas as pd
from tqdm import tqdm

# --------------------------------------------------
# Configuration
# --------------------------------------------------

random.seed(42)
np.random.seed(42)

DATA_FOLDER = "data"

orders = pd.read_csv(f"{DATA_FOLDER}/orders.csv")

# Convert order date
orders["order_date"] = pd.to_datetime(orders["order_date"])

shipping_modes = [
    "Standard",
    "Express",
    "Same Day",
    "Economy"
]

# Shipping cost ranges
shipping_cost = {
    "Standard": (50, 150),
    "Express": (150, 300),
    "Same Day": (250, 500),
    "Economy": (30, 80)
}

records = []

print("Generating Shipping Data...")

for _, row in tqdm(orders.iterrows(), total=len(orders)):

    mode = random.choice(shipping_modes)

    # Ship after 0-2 days
    ship_date = row["order_date"] + timedelta(days=random.randint(0, 2))

    # Delivery days based on mode
    if mode == "Same Day":
        delivery_days = 0

    elif mode == "Express":
        delivery_days = random.randint(1, 2)

    elif mode == "Standard":
        delivery_days = random.randint(3, 6)

    else:
        delivery_days = random.randint(5, 8)

    delivery_date = ship_date + timedelta(days=delivery_days)

    low, high = shipping_cost[mode]

    records.append({

        "shipment_id": len(records) + 1,

        "order_id": row["order_id"],

        "ship_date": ship_date.date(),

        "delivery_date": delivery_date.date(),

        "shipping_mode": mode,

        "shipping_cost": round(random.uniform(low, high), 2)

    })

shipping = pd.DataFrame(records)

# --------------------------------------------------
# Introduce Data Cleaning Problems
# --------------------------------------------------

# Missing shipping mode
shipping.loc[
    shipping.sample(frac=0.03, random_state=42).index,
    "shipping_mode"
] = None

# Delivery before shipping (invalid)
idx = shipping.sample(100, random_state=1).index

shipping.loc[idx, "delivery_date"] = (
    pd.to_datetime(shipping.loc[idx, "ship_date"])
    - timedelta(days=1)
)

# Future shipping dates
idx = shipping.sample(50, random_state=7).index

shipping.loc[idx, "ship_date"] = "2032-01-01"

# Duplicate shipments
duplicates = shipping.sample(100, random_state=10)

shipping = pd.concat([shipping, duplicates], ignore_index=True)

# --------------------------------------------------
# Save
# --------------------------------------------------

shipping.to_csv(
    f"{DATA_FOLDER}/shipping.csv",
    index=False
)

print("\nShipping Generated Successfully")
print(f"Rows : {len(shipping):,}")

print(shipping.head())