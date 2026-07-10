"""
=========================================================
Enterprise Ecommerce Analytics Project
File: 10_generate_inventory.py
=========================================================
"""

import random
from datetime import datetime, timedelta

import numpy as np
import pandas as pd

# --------------------------------------------------
# Configuration
# --------------------------------------------------

random.seed(42)
np.random.seed(42)

DATA_FOLDER = "data"

TOTAL_INVENTORY = 15000

# --------------------------------------------------
# Load Data
# --------------------------------------------------

products = pd.read_csv(f"{DATA_FOLDER}/products.csv")
warehouses = pd.read_csv(f"{DATA_FOLDER}/warehouses.csv")

product_ids = products["product_id"].tolist()
warehouse_ids = warehouses["warehouse_id"].tolist()

# --------------------------------------------------
# Generate Inventory
# --------------------------------------------------

records = []

print("Generating Inventory...")

for inventory_id in range(1, TOTAL_INVENTORY + 1):

    product = random.choice(product_ids)

    warehouse = random.choice(warehouse_ids)

    stock = random.randint(0, 500)

    reorder_level = random.randint(20, 100)

    restock_date = (
        datetime(2022, 1, 1)
        + timedelta(days=random.randint(0, 1460))
    )

    records.append({

        "inventory_id": inventory_id,

        "product_id": product,

        "warehouse_id": warehouse,

        "stock": stock,

        "reorder_level": reorder_level,

        "last_restock_date": restock_date.date()

    })

inventory = pd.DataFrame(records)

# --------------------------------------------------
# Remove Duplicate Product-Warehouse Pairs
# --------------------------------------------------

inventory = inventory.drop_duplicates(
    subset=["product_id", "warehouse_id"]
).reset_index(drop=True)

inventory["inventory_id"] = range(
    1,
    len(inventory) + 1
)

# --------------------------------------------------
# Introduce Data Cleaning Problems
# --------------------------------------------------

# Negative stock
idx = inventory.sample(50, random_state=1).index

inventory.loc[idx, "stock"] = -10

# Missing stock values
idx = inventory.sample(75, random_state=2).index

inventory.loc[idx, "stock"] = np.nan

# Future restock dates
idx = inventory.sample(30, random_state=3).index

inventory.loc[idx, "last_restock_date"] = "2032-05-01"

# Very high stock (outliers)
idx = inventory.sample(40, random_state=4).index

inventory.loc[idx, "stock"] = 5000

# Duplicate inventory records
duplicates = inventory.sample(100, random_state=5)

inventory = pd.concat(
    [inventory, duplicates],
    ignore_index=True
)

# --------------------------------------------------
# Save
# --------------------------------------------------

inventory.to_csv(
    f"{DATA_FOLDER}/inventory.csv",
    index=False
)

# --------------------------------------------------
# Summary
# --------------------------------------------------

print("\nInventory Generated Successfully")
print(f"Rows : {len(inventory):,}")

print("\nSample Data")
print(inventory.head())