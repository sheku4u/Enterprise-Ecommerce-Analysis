SELECT count(customer_id) from customers ;

-- SELECT
--     c.customer_id,
--     c.customer_name,
--     COALESCE(sum(o.amount),0) as total_amount
-- from customers c left JOIN orders o 
-- on c.customer_id = o.customer_id
-- GROUP BY c.customer_id , c.customer_name
-- ORDER BY total_amount DESC;

-- with order_data as (
--     SELECT
--     order_id,
--     amount,
--     DENSE_RANK() OVER(ORDER BY amount desc) as or_rnk
--     from orders
-- )
-- SELECT
--     order_id,
--     amount
-- from order_data
-- where or_rnk = 2;

-- Write a query to find customers who made more than one order and calculate:

-- customer_id

-- first_order_date

-- last_order_date

-- total_orders

-- total_amount

-- average_days_between_orders (difference between first and last order divided by number_of_gaps).
SELECT
    customer_id,
    min(order_date) as first_order_date,
    max(order_date) as last_order_date,
    count(order_id) as total_orders,
    sum(amount) as total_amount,
    (datedif(max(order_date) , min(order_date)) / (count(order_id ) - 1)) as average_days_between_orders
from orders
GROUP BY customer_id
HAVING count(order_id) > 1

--  explain - in this i would get the dates by using min, or max to get first and last order data ,then i would examine the customers specific details on it by divide the max - min / total orders - 1 it gives the gap difference for answers 
-- Question 4

-- For each customer, show:

-- customer_id
-- order_date
-- amount
-- previous order amount
-- difference between current amount and previous amount

-- Write the SQL query and explain your approach.

with customer_data as (
    SELECT
        customer_id,
        order_date,
        sum(amount) as total_amount
    from orders 
    group by customer_id , order_date
    order by order_date asc 
)
    SELECT
        customer_id,
        order_date,
        total_amount,
        lag(total_amount) over(partition by customer_id order by order_date asc) as prev_total_amount,
        round((total_amount - lag(total_amount) over(partition by customer_id order by order_date asc)),2) as diff_btw_current_and_prev
    from customer_data;

-- here first i gruoped the data based on customers and then get the sort them vased on order date. after this i would examine the previous amount by lag windows function which gives the power to fetch the previous row data for performing aggregation on it. 



-- A product manager says:

-- “Revenue dropped by 20% in June compared to May.”

-- You have these tables:

-- orders(order_id, customer_id, order_date, amount)

-- customers(customer_id, signup_date, city)

-- As a Data Analyst:

-- What 3–5 checks would you perform to find the root cause?

-- Write one SQL query that compares May vs June revenue.

-- Explain how you would communicate your findings to a non-technical stakeholder.

-- first i would confirm the if the drop is genuinely happens or it just mis calculation 
with monthly_data as (
    SELECT
        date_format(order_date, "%Y-%m") as order_month,
        sum(amount) as total_amount
    from orders
    group by date_format(order_date, "%Y-%m")
    ORDER BY order_month asc
)
SELECT
    order_month,
    total_amount,
    lag(total_amount) over(ORDER BY order_month asc) as prev_amount,
    round(((total_amount - (lag(total_amount) over(ORDER BY order_month asc))/(lag(total_amount) over(ORDER BY order_month asc)))*100),2) as revenue_pct
from monthly_data
where year(order_month) = "2026";

-- after geting the matrix is right , then i would examine where the drop happens 
-- to do i would seperate hte matrics into its main segments (order count , customer count, no of new customers, avg order value, avg customer orders, city analysis)

-- first - order segment
with order_details as (SELECT
    date_format(order_date, "%Y-%m") as order_month,
    count(distinct order_id) as total_orders,
    (sum(amount) / (count(distinct order_id))) as avg_order_amount,
    sum(amount) as total_order_amount
from orders
group by  date_format(order_date, "%Y-%m")
order by order_month asc)

SELECT
    order_month,
    total_orders,
    avg_order_amount,
    lag(total_orders) over(order by order_month asc) as prev_orders_count,
    lag(total_order_amount) over(order by order_month asc) as prev_order_amount,
    round((((total_orders - (lag(total_orders) over(order by order_month asc)))/(lag(total_orders) over(order by order_month asc)))*100),2) as count_pct,
    round((((total_order_amount - lag(total_order_amount) over(order by order_month asc))/(lag(total_order_amount) over(order by order_month asc)))*100),2) as amount_pct
from order_details;

-- customer segment analysis
with customer_details as (
    c.customer_id,
    date_format(o.order_date, "%y-%m") as order_month,
    COALESCE(sum(o.amount),0) as total_amount,
    count(o.order_id) as order_counts
    from customers c left join orders o on c.customer_id = o.customer_id
    group by c.customer_id, date_format(o.order_date, "%y-%m")
)

SELECT
    customer_id,
    order_month,
    total_amount,
    (lag(total_amount) over(partition by customer_id order by order_month asc )) as prev_amount,
    round((((total_amount- ((lag(total_amount) over(partition by customer_id order by order_month asc ))))/((lag(total_amount) over(partition by customer_id order by order_month asc ))))*100),2) as amount_pct,
    order_counts,
    (lag(order_counts) over(partition by customer_id order by order_month asc )) as prev_order_count,
    round((((order_counts) - ((lag(order_counts) over(partition by customer_id order by order_month asc )))/((lag(order_counts) over(partition by customer_id order by order_month asc ))))*100),2) as order_pct
from customer_details 
where year(order_month) = "2026";

-- city segment analysis
with city_details as (
    c.city,
    date_format(o.order_date, "%y-%m") as order_month,
    COALESCE(sum(o.amount),0) as total_amount,
    count(o.order_id) as order_counts
    from customers c left join orders o on c.customer_id = o.customer_id
    group by  c.city, date_format(o.order_date, "%y-%m")
)

SELECT
    city,
    order_month,
    total_amount,
    (lag(total_amount) over(partition by city order by order_month asc )) as prev_amount,
    round((((total_amount- ((lag(total_amount) over(partition by city order by order_month asc ))))/((lag(total_amount) over(partition by city order by order_month asc ))))*100),2) as amount_pct,
    order_counts,
    (lag(order_counts) over(partition by city order by order_month asc )) as prev_order_count,
    round((((order_counts) - ((lag(order_counts) over(partition by city order by order_month asc )))/((lag(order_counts) over(partition by city order by order_month asc ))))*100),2) as order_pct
from city_details 
where year(order_month) = "2026";

-- here i check the wheather the drop happens in 2026 year current year, after getting the difference i will suggest the recommendation how to do that or which areas are stronger or which are not 