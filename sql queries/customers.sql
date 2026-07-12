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

-- Show all customers who never placed an order.
SELECT
    c.CustomerID,
    coalesce(o.Amount, 0) as order_amount
from Customers c left join Orders o on c.CustomerID = o.CustomerID
where o.OrderID is Null;

-- Find the second highest order amount.
with order_data as (
    SELECT
        OrderID,
        CustomerID,
        Amount,
        DENSE_RANK() over(ORDER BY Amount desc) as amt_rnk
    from Orders
)
SELECT
    OrderID,
    CustomerID,
    Amount
from order_data
where amt_rnk = 2;

-- Calculate the total sales for each customer.
with customer_data as (
    select c.CustomerID as customer_id,
    c.Name as cust_name,
    o.Amount as sales_amt
    from Customers c left join Orders o on c.CustomerID = o.CustomerID
)
select
    customer_id,
    cust_name,
    coalesce(sum(sales_amt),0) as total_sales
from customer_data
group by customer_id, cust_name
order by total_sales desc;

-- Explain the difference between ROW_NUMBER(), RANK(), and DENSE_RANK().
-- row_number() is used to give the unique rank number to each row it doesn't matter to where the ties is happens or not  ex- 1,2,3,4,5
-- rank() is used to give the ranks based on specific conditions but, when the ties happens it skips the ranks and jump to the next number ex - 1,2,2,4,5
-- dense_rank() is best in terms of real life sceniros because it works same as rank() but it dont skips the rank it gives the same rank to ties ones and continues the rank after ex - 1,2,2,3,4
-- If the Orders table has 100 million rows, what indexes would you create and why?
-- indexs helps to find the row data more quickly . when there is 100million data then i would use the created customer groups , order_months and all to retrieve the data based on big things not the row by row columns 



-- A Sales Dashboard has become very slow. It contains:

-- 20 million rows
-- 15 visuals on one page
-- Several slicers
-- Many DAX measures

-- Please answer the following:

-- What steps would you take to identify the performance bottleneck?
-- first i check the speed of loading time of visuals on dashboard by dax analysis tools, then i would change the visuals tables which takes lots of data to load with other metrics like charts, pie chart or summary table that doesnt take long data init but gives the perfect understanding of performance , then i would replace the calulated columns with the meausures if possible because measures dont take space in memory and its fast to load also its only load when it called. i will remove extra over slicers which dont give involed in business problems perspective

-- What is the difference between a calculated column and a measure?
-- a calculated columns is take space in memory ,it stores as a column in table but the measures dont take any space in memory also it reletaively faster then calculated columns and its only load when they called.

-- When would you use SUMX() instead of SUM()?
-- sumx() is used when the data has their categoreis, and sum() is simple sum the amount

-- Explain the difference between star schema and snowflake schema. Which would you recommend for Power BI and why?
-- A manager says, "The total sales shown in the card visual don't match the sum of the rows in my table." What are three possible reasons, and how would you investigate them?
-- first i will confirm the matrics is correct or not, then i will check wheather is there any slicer or filter occurs between, then check the data model is connect corectly or not 

-- What metrics would you check first?\
-- first thing first check the metrics is correct or it just happens by mistake, then i would splits the revenue into its main components like (no. of customers, total_sales, Quantity, Price, Discount , website traffice , returns , user funnel ) from current month to previous month when the this happens
-- after the insights i will provide the suggestions to what to do, and what are the weaknesses or how to improve them

-- What hypotheses would you form?
-- see, if the customer chrun rate is increased compare to previous month then i will assume the website traffic might have some issue which is the reasons for it, 
-- How would you validate or reject those hypotheses?
-- i woukd check the metrics first and then after the result i can check them wheather i used to data or not
-- What recommendations would you present to the CEO?
-- i would provide it after only getting the results for example if the payment funnel have issue less customers  then improve the ui process payment process so the customers dont skips the payment and it improves their experience