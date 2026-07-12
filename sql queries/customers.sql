SELECT * from customers limit 5;

SELECT * from orders limit 5;

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












































