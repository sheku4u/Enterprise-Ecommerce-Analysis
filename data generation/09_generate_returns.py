"""
=========================================================
Enterprise Ecommerce Analytics Project
File: 09_generate_returns.py
=========================================================
"""

import random
from datetime import timedelta

import numpy as np
import pandas as pd

# --------------------------------------------------
# Configuration
# --------------------------------------------------

random.seed(42)
np.random.seed(42)

DATA_FOLDER = "data"
TOTAL_RETURNS = 8000

# --------------------------------------------------
# Load Orders
# --------------------------------------------------

orders = pd.read_csv(f"{DATA_FOLDER}/orders.csv")

orders["order_date"] = pd.to_datetime(orders["order_date"])

# --------------------------------------------------
# Return Reasons
# --------------------------------------------------

return_reasons = [
    "Damaged Product",
    "Wrong Product",
    "Late Delivery",
    "Quality Issue",
    "Changed Mind",
    "Size Issue",
    "Defective Item"
]

# --------------------------------------------------
# Select Random Orders
# --------------------------------------------------

returned_orders = orders.sample(
    n=TOTAL_RETURNS,
    random_state=42
).reset_index(drop=True)

records = []

print("Generating Returns...")

for i, row in returned_orders.iterrows():

    return_date = row["order_date"] + timedelta(
        days=random.randint(1, 30)
    )

    refund = round(
        row["sales"] * random.uniform(0.8, 1.0),
        2
    )

    records.append({

        "return_id": i + 1,

        "order_id": row["order_id"],

        "return_reason": random.choice(return_reasons),

        "return_date": return_date.date(),

        "refund_amount": refund

    })

returns = pd.DataFrame(records)

# --------------------------------------------------
# Introduce Data Cleaning Problems
# --------------------------------------------------

# Missing return reason
returns.loc[
    returns.sample(frac=0.02, random_state=1).index,
    "return_reason"
] = None

# Refund greater than sales
bad = returns.sample(50, random_state=2).index

returns.loc[bad, "refund_amount"] *= 1.5

# Future return dates
future = returns.sample(25, random_state=3).index

returns.loc[future, "return_date"] = "2032-01-01"

# Duplicate rows
duplicates = returns.sample(50, random_state=4)

returns = pd.concat(
    [returns, duplicates],
    ignore_index=True
)

# --------------------------------------------------
# Save
# --------------------------------------------------

returns.to_csv(
    f"{DATA_FOLDER}/returns.csv",
    index=False
)

print("\nReturns Generated Successfully")
print(f"Rows : {len(returns):,}")

print(returns.head())