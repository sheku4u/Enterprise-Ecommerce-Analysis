SELECT * from customers limit 5;

SELECT * from orders limit 5;
SELECT * from promotions limit 5;




-- Q1. Find the total number of customers.
create VIEW no_of_cusotmers as 
SELECT
    count(DISTINCT customer_id) from customers;

SELECT * from no_of_cusotmers;
-- Q2. Count customers by customer segment.
create view no_of_customers_by_segment as 
SELECT
    customer_segment, count(DISTINCT customer_id) as customer_count FROM customers
    GROUP BY customer_segment order by customer_count desc;

SELECT * from no_of_customers_by_segment;

-- Q3. Count customers by state.
CREATE view customers_by_state as 
SELECT state, count(DISTINCT customer_id) as customer_count from customers
group by state order by customer_count desc;

SELECT * from customers_by_state;
-- Q4. Find customers whose age is missing.
CREATE view missing_age_customers as 
SELECT
    customer_id,customer_name, age  FROM customers
    where age is NULL;

SELECT * from missing_age_customers;

-- Q5. Find customers with invalid ages (>100 or <18).
create view invalid_age as SELECT
customer_name, age FROM customers
where age > 100 OR age < 18;

SELECT * from invalid_age;

-- Customer Analysis

-- Q21. Top 10 customers by revenue.
with cust_revenue_data as (
    SELECT
        c.customer_id, c.customer_name,round(coalesce(sum(o.sales),0),2) as total_revenue 
        FROM customers c left join orders o on c.customer_id = o.customer_id
        GROUP BY c.customer_id, c.customer_name
), renenue_rnk as (
    SELECT
    *, DENSE_RANK() over(ORDER BY total_revenue desc) as rnk
    from cust_revenue_data
)
SELECT customer_id, customer_name, total_revenue
from renenue_rnk
where rnk <= 10;
    

-- Q22. Top 10 customers by profit.
with cust_profit_data as (
    SELECT
        c.customer_id, c.customer_name,round(coalesce(sum(o.profit),0),2) as total_profit 
        FROM customers c left join orders o on c.customer_id = o.customer_id
        GROUP BY c.customer_id, c.customer_name
), profit_rnk as (
    SELECT
    *, DENSE_RANK() over(ORDER BY total_profit desc) as rnk
    from cust_profit_data
)
SELECT customer_id, customer_name, total_profit
from profit_rnk
where rnk <= 10;
-- Q23. Customers who placed more than 10 orders.
with cust_order_data as (
    SELECT
        c.customer_id, c.customer_name,round(coalesce(count(o.order_id),0),2) as total_orders 
        FROM customers c left join orders o on c.customer_id = o.customer_id
        GROUP BY c.customer_id, c.customer_name
), orders_rnk as (
    SELECT
    *, DENSE_RANK() over(ORDER BY total_orders desc) as rnk
    from cust_order_data
)
SELECT customer_id, customer_name, total_orders
from orders_rnk
where rnk <= 10;

-- Q24. Customers who never placed an order.
SELECT
    c.customer_id, c.customer_name, c.age FROM customers c left join orders o on c.customer_id = o.customer_id
    where o.order_id is null;


-- Q25. Average revenue by customer segment.
SELECT
    c.customer_segment, round(COALESCE(avg(o.sales),0),2) as avg_revenue 
    FROM customers c left join orders o on c.customer_id = o.customer_id
    GROUP BY c.customer_segment order by avg_revenue desc;



-- Window Functions

-- Q51. Rank products by revenue within each category.
with product_sales as (
    SELECT
        p.product_name, p.category, round(COALESCE(sum(o.sales),0),2) as revenue 
    FROM products p left JOIN orders o on p.product_id = o.product_id
    GROUP BY p.product_name, p.category
    order by revenue desc
)
SELECT
    category,
    product_name,
    revenue,
    DENSE_RANK() over(PARTITION BY category ORDER BY revenue desc) as product_rank
from product_sales;

-- Q52. Rank customers by yearly revenue.
with customer_yearly_data as (
    SELECT
        c.customer_id, c.customer_name , date_format(o.order_date, "%Y") as order_year, 
        round(COALESCE(sum(o.sales),0),0) as revenue
    FROM customers c LEFT JOIN orders o on c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name, date_format(o.order_date, "%Y")
)
SELECT
    *, DENSE_RANK() OVER(PARTITION BY order_year order by revenue desc) as yearly_rank
from customer_yearly_data;

-- Q53. Find second-highest selling product in every category.
with product_sales as (
    SELECT
        p.product_name, p.category, round(COALESCE(sum(o.sales),0),2) as revenue 
    FROM products p left JOIN orders o on p.product_id = o.product_id
    GROUP BY p.product_name, p.category
    order by revenue desc
), product_ranks as 
(SELECT
    category,
    product_name,
    revenue,
    DENSE_RANK() over(PARTITION BY category ORDER BY revenue desc) as product_rank
from product_sales)
SELECT *
from product_ranks
where product_rank = 2;

-- Q54. Top 3 customers in every state.
with customer_order_data as (
    SELECT
        c.customer_id, c.customer_name , c.state, 
        COALESCE(count(o.order_id),0) as order_count
    FROM customers c LEFT JOIN orders o on c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name, c.state
), ranked as 
(SELECT
    *, DENSE_RANK() OVER(PARTITION BY state order by order_count desc) as order_rank
from customer_order_data)
SELECT
    * from ranked
WHERE order_rank <= 3;

-- Q55. Find top-selling product every month.
-- top 5 
WITH product_revenue as (
    SELECT
        product_id, date_format(order_date, "%Y-%m") as order_month,
        round(COALESCE(sum(sales),0),0) as total_sales 
    FROM orders
    GROUP BY product_id, date_format(order_date, "%Y-%m")
),
product_rnk as (
    SELECT
        *,
        DENSE_RANK() OVER(PARTITION BY order_month ORDER BY total_sales desc) as rnk
    from product_revenue
)
SELECT
    *
FROM product_rnk
where rnk <=5;


-- Q56. Find employees contributing more than 40% of regional revenue.
-- with emp_contributes AS (
--     SELECT
--     employee_id, COALESCE(sum(sales),0) as revenue FROM orders
--     GROUP BY employee_id
--     order by revenue desc
-- ),

with 
regional_revenue as (
    SELECT
        e.region, COALESCE(sum(o.sales),0) as regional_rev
        FROM employees e left join orders o on e.employee_id = o.employee_id
        GROUP BY e.region
)
SELECT
    e.employee_id
    ,COALESCE(sum(e.salary),0) as revenue 
    FROM employees e JOIN  regional_revenue r on e.region = r.region
    GROUP BY e.employee_id
    HAVING sum(e.salary) > r.regional_rev;
-- Q57. Running total sales by month.
with monthly_sales as 
(SELECT
    date_format(order_date, '%Y-%M') as order_month, sum(sales) as total_sales FROM orders
    GROUP BY date_format(order_date, '%Y-%M')
    order by order_month asc
)
SELECT
    order_month, total_sales, sum(total_sales) over(ORDER BY order_month asc) as running_sales
    from monthly_sales;

-- Q58. Rolling 3-month revenue.
(SELECT
    date_format(order_date, '%Y-%M') as order_month, sum(sales) as total_sales FROM orders
    GROUP BY date_format(order_date, '%Y-%M')
    order by order_month asc
)
SELECT
    order_month, total_sales, sum(total_sales) over(ORDER BY order_month current_row and 3 preceeding row) as running_sales
    from monthly_sales;

-- Q59. Rolling 12-month revenue.


-- Q60. Month-over-month revenue growth using LAG().
with monthly_sales as (
    SELECT
         date_format(order_date, '%Y-%M') as order_month, sum(sales) as total_sales FROM orders
    GROUP BY date_format(order_date, '%Y-%M')
    order by order_month asc
)
SELECT
    order_month,
    total_sales,
    round(COALESCE(lag(total_sales) over(ORDER BY order_month asc),0),0) as prev_sales,
    COALESCE(round(((total_sales -lag(total_sales) over(ORDER BY order_month asc) )/(lag(total_sales) over(ORDER BY order_month asc)))*100,0),0 )as growth_rate
from monthly_sales;




-- Who is the top customer?
with cust_rnk as (SELECT
    Customers,
    Orders,
    Sales,
    DENSE_RANK() OVER(ORDER BY Sales desc) as rnk
from customer_table)

SELECT
    Customers,
    Orders,
    Sales
from cust_rank;


-- Would you rank by:

-- A. Number of orders
-- B. Revenue
-- C. Average order value

-- Explain why.

-- -- What questions would you ask first?
-- First i would check the metrics is correct or its just my unclean data ,then comfirming the insight is correct i would classify the sales into its main components 
-- no of customers, no of orders, new customers, chrun rate, customer feedback, website traffic , marketing spends and CAC on monthly basis next i would examine and compare all the insights after that i got the insights then i give the dashboards, reports with clear problems , insights and recommendations too 

-- -- What data would you check?
-- First i would check the metrics is correct or its just my unclean data ,then comfirming the insight is correct i would classify the sales into its main components 
-- no of customers, no of orders, new customers, chrun rate, customer feedback, website traffic , marketing spends and CAC
-- -- Which KPIs would you analyze?
-- no of customers, no of orders, new customers, chrun rate, customer feedback, website traffic , marketing spends and CAC based on monthly analysis
-- -- How would you present your findings to the CEO?
-- first i check the insights what they actually want , then create a report to give recommendations and explain the insights we find out, after that i will provide a visualized dashboard as well for easy understanding to them


-- top_5_customers_by_total_sales = orders.groupby('customer_id', as_index = False)['amount'].sum().sort_values("sales",ascending=False).head(5)

-- -- Why you chose that approach.
-- beacuase its fast and easy it takes less code and clear reading for that code.
-- -- Its time complexity at a high level.
-- its time complexity is high when there is 10 million rows 
-- -- Whether it would still work efficiently if the dataset had 10 million rows, and what you might consider if it became a bottleneck.
-- still if i would do the same with 10 million rows. so this is not a good option for 10 million rows i would use the sql first to examine the dataset then only load those data which is relevent to my query 



-- Which customers generate the highest lifetime value?
SELECT
    c.customer_id, c.customer_name,
    round(coalesce(sum(o.sales),0),0) as lifetime_revenue,
    round(COALESCE(avg(o.sales),0),0) as avg_order_value,
    min(o.order_date) as first_purchase,
    max(o.order_date) as last_purchase
FROM customers c left join orders o on c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY lifetime_revenue DESC;

-- Which product categories drive the most revenue?
SELECT
    p.category,
    round(COALESCE(sum(o.sales),0),0) as revenue
FROM products p LEFT JOIN orders o on p.product_id = o.product_id
GROUP BY p.category
ORDER BY revenue DESC
limit 1;

-- How much do delivery delays impact customer satisfaction?
-- with delay_deliveries as (
--     SELECT
--         o.customer_id,o.rating , datediff(s.delivery_date, s.ship_date) as delay_days
--     from orders o JOIN shipping s on o.order_id = s.order_id
--     GROUP BY o.customer_id , o.rating
--     ORDER BY delay_days DESC
-- )
-- SELECT
--     c.customer_id, c.customer_name, 

-- SELECT * from shipping limit 4;


SELECT
    datediff(s.delivery_date, s.ship_date) as delay_days,
    round(min(o.rating),0) min_rating ,
    round(max(o.rating),0) max_rating ,
    round(avg(o.rating),0) avg_rating 
from orders o JOIN shipping s on o.order_id = s.order_id
where s.delivery_date >= s.ship_date
GROUP BY datediff(s.delivery_date, s.ship_date)
ORDER BY  delay_days ASC;

-- 💰 Which promotions actually increase profit instead of just sales?
SELECT
    p.promotion_id, p.promotion_name, p.promotion_type , COALESCE(round(sum(o.profit),0),0) as profit,
    round(((sum(o.profit) / (select sum(profit) from orders))*100),2) as profit_margin 
FROM promotions p LEFT JOIN orders o on p.promotion_id = o.promotion_id
group by p.promotion_id, p.promotion_name, p.promotion_type
order by profit_margin desc;

-- Find customers whose monthly spending increased for 3 consecutive months.
-- step 1 
with monthly_sales as (
    SELECT
        customer_id, date_format(order_date, "%Y-%m-01") as order_month, sum(sales) as revenue FROM orders
        GROUP BY customer_id, order_month
),
-- previous data calculations 
lagged_data as (
    SELECT
        *,
        lag(revenue,1) OVER(PARTITION BY customer_id ORDER BY order_month asc) as prev_value_1,
        lag(revenue,2) OVER(PARTITION BY customer_id ORDER BY order_month asc) as prev_value_2
    from monthly_sales
)

SELECT
    customer_id,
    order_month,
    prev_value_1,
    prev_value_2,
    revenue
from lagged_data
where revenue > prev_value_1 and prev_value_1 > prev_value_2;

-- Rank products by revenue within each category and return the top 3.
with product_data as (
    SELECT
        p.product_id, p.category, sum(o.sales) as revenue 
        FROM products p join orders o on p.product_id = o.product_id 
        GROUP BY p.product_id, p.category
),
rnked_data as (
    SELECT
    category,
    product_id,
    revenue,
    DENSE_RANK() OVER(PARTITION BY category order BY revenue desc) as rnk
    from product_data
)
SELECT
    category,
    product_id,
    revenue
from rnked_data
where rnk <=3;

-- Find customers who purchased in every month of a given year.

--  1st way
SELECT
    customer_id 
FROM orders
where year(order_date) = 2025
GROUP BY customer_id
HAVING count(DISTINCT month(order_date)) = 12;

--  2nd way
-- that way helps to take customer name as well with thier ids 
SELECT
    c.customer_id, c.customer_name FROM customers c join (
        SELECT
        customer_id from orders where YEAR(order_date) = 2025 GROUP BY customer_id HAVING count(DISTINCT month(order_date)) = 12
        ) t on c.customer_id = t.customer_id;

-- Calculate a 30-day rolling revenue.

SELECT
    order_date,
    sum(sales) 
    over(ORDER BY order_date RANGE BETWEEN INTERVAL 29 DAY PRECEDING and CURRENT ROW) as rolling_rev 
    FROM orders;


-- Find the longest streak of consecutive ordering days for each customer.
WITH daily_orders AS (
    SELECT DISTINCT
        customer_id,
        DATE(order_date) AS order_day
    FROM orders
),
numbered AS (
    SELECT
        customer_id,
        order_day,
        ROW_NUMBER() OVER(
            PARTITION BY customer_id
            ORDER BY order_day
        ) AS rn
    FROM daily_orders
),
groups_cte AS (
    SELECT
        customer_id,
        order_day,
        DATE_SUB(order_day, INTERVAL rn DAY) AS grp
    FROM numbered
),
streaks AS (
    SELECT
        customer_id,
        MIN(order_day) AS streak_start,
        MAX(order_day) AS streak_end,
        COUNT(*) AS streak_length
    FROM groups_cte
    GROUP BY customer_id, grp
),
ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY streak_length DESC, streak_start
        ) AS rnk
    FROM streaks
)
SELECT
    customer_id,
    streak_start,
    streak_end,
    streak_length
FROM ranked
WHERE rnk = 1;