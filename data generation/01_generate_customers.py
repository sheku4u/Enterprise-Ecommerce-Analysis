import pandas as pd
import numpy as np
import datetime as dt
from faker import Faker
import random

fake = Faker('en_IN')

random.seed(42)
np.random.seed(42)

num_customers = 10000

segments = [
    "Consumer",
    "Corporate",
    "Home Office",
    "Small Business"
]

gender = ['Male','Female']

states = {
    "Delhi":["New Delhi"],
    "Maharashtra":["Mumbai","Pune","Nagpur"],
    "Karnataka":["Bangalore","Mysore"],
    "Tamil Nadu":["Chennai","Coimbatore"],
    "Uttar Pradesh":["Lucknow","Noida","Kanpur"],
    "West Bengal":["Kolkata"],
    "Rajasthan":["Jaipur"],
    "Punjab":["Ludhiana","Amritsar"],
    "Haryana":["Gurgaon","Faridabad"],
    "Gujarat":["Ahmedabad","Surat"]
}

customers = []

for i in range(1,num_customers+1):
    state = random.choice(list(states.keys()))
    city = random.choice(states[state])

    join_date = fake.date_between(
        start_date='-6y',
        end_date='today'
    )

    customers.append({

        "customer_id":f"CUST{i:05d}",

        "customer_name":fake.name(),

        "gender":random.choice(gender),

        "age":random.randint(18,70),

        "city":city,

        "state":state,

        "country":"India",

        "join_date":join_date,

        "customer_segment":random.choice(segments)

    })

customers=pd.DataFrame(customers)

#######################################################
# Dirty Data
#######################################################

# Missing age

customers.loc[
    customers.sample(250).index,
    "age"
]=np.nan

# Missing gender

customers.loc[
    customers.sample(200).index,
    "gender"
]=None

# Impossible age

customers.loc[
    customers.sample(15).index,
    "age"
]=350

# Future join date

future_idx=customers.sample(20).index

customers.loc[
    future_idx,
    "join_date"
]=pd.Timestamp("2032-01-01")

# Wrong city-state

wrong_idx=customers.sample(30).index

customers.loc[
    wrong_idx,
    "city"
]="Mumbai"

customers.loc[
    wrong_idx,
    "state"
]="Punjab"

#######################################################
# Duplicate Customers
#######################################################

duplicates=customers.sample(40)

customers=pd.concat(
    [customers,duplicates],
    ignore_index=True
)

#######################################################
# Shuffle
#######################################################

customers=customers.sample(
    frac=1,
    random_state=42
).reset_index(drop=True)

#######################################################
# Save
#######################################################

customers.to_csv(
    "C:/Users/abhis/OneDrive/Documents/abhishek/Data_Analyst_Abhishek/data_analyst/python_data/practice/enterprise ecommerce project/data/customers.csv",
    index=False
)

print(customers.head())

print()

print("Rows :",len(customers))

print("CSV Saved Successfully")