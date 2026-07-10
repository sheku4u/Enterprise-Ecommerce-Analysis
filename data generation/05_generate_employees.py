import pandas as pd
import numpy as np
import random
from faker import Faker

fake = Faker("en_IN")

random.seed(42)
np.random.seed(42)

NUM_EMPLOYEES = 200

############################################################
# Lookup Lists
############################################################

designations = [
    "Sales Executive",
    "Senior Sales Executive",
    "Sales Manager",
    "Regional Manager",
    "Warehouse Manager",
    "Inventory Analyst",
    "Business Analyst",
    "Data Analyst",
    "Operations Executive",
    "Operations Manager"
]

departments = [
    "Sales",
    "Operations",
    "Inventory",
    "Analytics",
    "Supply Chain"
]

regions = [
    "North",
    "South",
    "East",
    "West"
]

genders = [
    "Male",
    "Female"
]

############################################################
# Generate Employees
############################################################

employees = []

for i in range(1, NUM_EMPLOYEES + 1):

    designation = random.choice(designations)

    manager = None if i <= 10 else f"EMP{random.randint(1,10):04d}"

    employees.append({

        "employee_id": f"EMP{i:04d}",

        "employee_name": fake.name(),

        "gender": random.choice(genders),

        "age": random.randint(22,60),

        "designation": designation,

        "department": random.choice(departments),

        "region": random.choice(regions),

        "hire_date": fake.date_between(
            start_date="-10y",
            end_date="today"
        ),

        "salary": random.randint(300000,1800000),

        "manager_id": manager

    })

employees = pd.DataFrame(employees)

############################################################
# DIRTY DATA
############################################################

# Missing Salary

employees.loc[
    employees.sample(10, random_state=1).index,
    "salary"
] = np.nan

# Missing Gender

employees.loc[
    employees.sample(8, random_state=2).index,
    "gender"
] = np.nan

# Missing Department

employees.loc[
    employees.sample(6, random_state=3).index,
    "department"
] = np.nan

# Impossible Age

employees.loc[
    employees.sample(4, random_state=4).index,
    "age"
] = 350

# Future Hire Date

employees.loc[
    employees.sample(5, random_state=5).index,
    "hire_date"
] = pd.Timestamp("2031-05-01")

# Negative Salary

employees.loc[
    employees.sample(3, random_state=6).index,
    "salary"
] = -750000

# Salary = 0

employees.loc[
    employees.sample(3, random_state=7).index,
    "salary"
] = 0

# Lower Case Names

idx = employees.sample(6, random_state=8).index

employees.loc[idx, "employee_name"] = (
    employees.loc[idx, "employee_name"]
    .str.lower()
)

# Leading Spaces

idx = employees.sample(6, random_state=9).index

employees.loc[idx, "employee_name"] = (
    "   " +
    employees.loc[idx, "employee_name"] +
    "   "
)

############################################################
# Duplicate Employees
############################################################

duplicates = employees.sample(
    10,
    random_state=42
).copy()

employees = pd.concat(
    [employees, duplicates],
    ignore_index=True
)

############################################################
# Shuffle
############################################################

employees = employees.sample(
    frac=1,
    random_state=42
).reset_index(drop=True)

############################################################
# Save
############################################################

employees.to_csv(
    "C:/Users/abhis/OneDrive/Documents/abhishek/Data_Analyst_Abhishek/data_analyst/python_data/practice/enterprise ecommerce project/data/employees.csv",
    index=False
)

############################################################
# Summary
############################################################

print(employees.head())

print("\nEmployees Generated Successfully")

print(f"Rows : {len(employees)}")

print("\nMissing Values")

print(employees.isna().sum())