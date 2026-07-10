import os
import random
from datetime import datetime, timedelta

import pandas as pd
from faker import Faker
from tqdm import tqdm

# -------------------------------------------------------
# Configuration
# -------------------------------------------------------

SEED = 42
TOTAL_PROMOTIONS = 500

OUTPUT_FOLDER = "data"
OUTPUT_FILE = os.path.join(OUTPUT_FOLDER, "promotions.csv")

random.seed(SEED)
fake = Faker()
Faker.seed(SEED)

os.makedirs(OUTPUT_FOLDER, exist_ok=True)

# -------------------------------------------------------
# Promotion Templates
# -------------------------------------------------------

SEASONS = [
    "New Year", "Republic Day", "Valentine", "Holi", "Summer", "Monsoon",
    "Back To School", "Independence Day", "Festival", "Diwali",
    "Black Friday", "Cyber Monday", "Christmas", "Year End"
]

CATEGORIES = [
    "Electronics", "Furniture", "Fashion", "Beauty", "Sports", "Home",
    "Office Supplies", "Automotive"
]

PROMOTION_TYPES = [
    "Category Discount", "Brand Promotion", "Flash Sale", "Festival Sale",
    "Clearance", "Weekend Sale", "BOGO", "Member Exclusive",
    "Limited Time", "Seasonal Offer"
]

DISCOUNTS = [5, 10, 15, 20, 25, 30, 35, 40, 50, 60]

# -------------------------------------------------------
# Helper Functions
# -------------------------------------------------------

def random_start_date():
    start = datetime(2021, 1, 1)
    end = datetime(2025, 12, 31)
    return start + timedelta(days=random.randint(0, (end - start).days))

def promotion_status(start_date, end_date):
    today = datetime(2025, 1, 1)
    if end_date < today:
        return "Expired"
    elif start_date > today:
        return "Upcoming"
    return "Active"

def generate_name():
    season = random.choice(SEASONS)
    category = random.choice(CATEGORIES)
    ptype = random.choice(PROMOTION_TYPES)

    patterns = [
        f"{season} {category} Sale",
        f"{season} Mega Offer",
        f"{category} Discount Fest",
        f"{ptype} {category}",
        f"{season} Flash Sale",
        f"{category} Weekend Deal",
        f"{season} Super Saver",
        f"{category} Price Drop",
        f"{season} Exclusive",
        f"{category} Bonanza"
    ]
    return random.choice(patterns)

# -------------------------------------------------------
# Generate Promotions
# -------------------------------------------------------

used_names = set()
records = []

for promotion_id in tqdm(range(1, TOTAL_PROMOTIONS + 1)):
    attempts = 0
    while True:
        name = generate_name()
        attempts += 1
        if name not in used_names or attempts > 1000:
            used_names.add(name)
            break

    start_date = random_start_date()
    duration = random.randint(3, 45)
    end_date = start_date + timedelta(days=duration)
    discount = random.choice(DISCOUNTS)
    promotion_type = random.choice(PROMOTION_TYPES)
    status = promotion_status(start_date, end_date)

    records.append({
        "promotion_id": promotion_id,
        "promotion_name": name,
        "promotion_type": promotion_type,
        "discount_percentage": discount,
        "status": status,
        "start_date": start_date.date(),
        "end_date": end_date.date()
    })

# -------------------------------------------------------
# DataFrame
# -------------------------------------------------------

promotions = pd.DataFrame(records).sort_values(by="promotion_id").reset_index(drop=True)

# -------------------------------------------------------
# Save
# -------------------------------------------------------

promotions.to_csv(OUTPUT_FILE, index=False)

# -------------------------------------------------------
# Summary
# -------------------------------------------------------

print("\nPromotion Dataset Created Successfully")
print("--------------------------------------")
print(f"Rows      : {len(promotions):,}")
print(f"Columns   : {len(promotions.columns)}")
print(f"File      : {OUTPUT_FILE}")

print("\nDiscount Distribution")
print(promotions["discount_percentage"].value_counts().sort_index())

print("\nPromotion Status")
print(promotions["status"].value_counts())

print("\nSample")
print(promotions.head())