import os
import random
from datetime import datetime, timedelta

import numpy as np
import pandas as pd
from tqdm import tqdm

# --------------------------------------------------
# Configuration
# --------------------------------------------------

random.seed(42)
np.random.seed(42)

TOTAL_ORDERS = 200000
DATA_FOLDER = "data"

customers = pd.read_csv(f"{DATA_FOLDER}/customers.csv")
products = pd.read_csv(f"{DATA_FOLDER}/products.csv")
employees = pd.read_csv(f"{DATA_FOLDER}/employees.csv")
warehouses = pd.read_csv(f"{DATA_FOLDER}/warehouses.csv")
promotions = pd.read_csv(f"{DATA_FOLDER}/promotions.csv")

# --------------------------------------------------
# Clean / validate lookup tables
# --------------------------------------------------

promotions = promotions.drop_duplicates(subset=["promotion_id"]).copy()
products = products.drop_duplicates(subset=["product_id"]).copy()

if promotions["promotion_id"].duplicated().any():
    raise ValueError("promotion_id still has duplicates after cleaning.")

if products["product_id"].duplicated().any():
    raise ValueError("product_id still has duplicates after cleaning.")

# --------------------------------------------------
# Lookup Lists
# --------------------------------------------------

customer_ids = customers["customer_id"].tolist()
employee_ids = employees["employee_id"].tolist()
warehouse_ids = warehouses["warehouse_id"].tolist()

product_lookup = products.set_index("product_id").to_dict(orient="index")
promotion_lookup = promotions.set_index("promotion_id").to_dict(orient="index")
promotion_ids = promotions["promotion_id"].tolist()

payment_methods = [
    "Credit Card",
    "Debit Card",
    "UPI",
    "Cash",
    "Net Banking"
]

channels = [
    "Online",
    "Store",
    "Marketplace"
]

# --------------------------------------------------
# Helper
# --------------------------------------------------

def random_date():
    start = datetime(2022, 1, 1)
    end = datetime(2025, 12, 31)
    return start + timedelta(days=random.randint(0, (end - start).days))

# --------------------------------------------------
# Generate Orders
# --------------------------------------------------

orders = []

print("Generating Orders...")

for order_id in tqdm(range(1, TOTAL_ORDERS + 1)):
    customer = random.choice(customer_ids)
    product = random.choice(list(product_lookup.keys()))
    promo = random.choice(promotion_ids)
    quantity = random.randint(1, 5)

    product_info = product_lookup[product]
    price = product_info["selling_price"]
    cost = product_info["cost_price"]

    discount_pct = promotion_lookup[promo]["discount_percentage"]
    discount = discount_pct / 100.0

    sales = quantity * price * (1 - discount)
    profit = sales - (quantity * cost)

    orders.append({
        "order_id": order_id,
        "customer_id": customer,
        "order_date": random_date().date(),
        "product_id": product,
        "quantity": quantity,
        "discount": round(discount_pct, 2),
        "sales": round(sales, 2),
        "profit": round(profit, 2),
        "payment_method": random.choice(payment_methods),
        "channel": random.choice(channels),
        "warehouse_id": random.choice(warehouse_ids),
        "employee_id": random.choice(employee_ids),
        "promotion_id": promo
    })

# --------------------------------------------------
# Save
# --------------------------------------------------

orders = pd.DataFrame(orders)
orders.to_csv(f"{DATA_FOLDER}/orders.csv", index=False)

print("\nOrders Generated Successfully")
print(f"Rows : {len(orders):,}")
print(orders.head())