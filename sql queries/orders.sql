SELECT * from orders limit 5;

-- Q11. Calculate total sales.
CREATE view total_sales as SELECT
sum(sales) as total_sales_amount from orders;

SELECT * from total_sales;

-- Q12. Calculate total profit.
CREATE view total_profit as SELECT
sum(profit) as total_profit_amount from orders;

SELECT * from total_profit;

-- Q13. Find average order value.
CREATE view avg_order_value as SELECT
round(COALESCE(avg(sales),0 ),2) as avg_order_amount from orders;

SELECT * from avg_order_value;

-- Q14. Count orders by payment method.
create view orders_by_payment_method as SELECT
    payment_method, count(DISTINCT order_id) as orders_count FROM orders
    GROUP BY payment_method ORDER BY orders_count DESC;

SELECT * from orders_by_payment_method;


-- Q15. Count orders by sales channel.
create view orders_by_channel as SELECT
    channel, count(DISTINCT order_id) as orders_count FROM orders
    GROUP BY channel ORDER BY orders_count DESC;

SELECT * from orders_by_channel;

-- Time Analysis

-- Q31. Monthly sales trend.

SELECT
    date_format(order_date, "%Y-%m") as order_month, round(sum(sales),2) as total_sales FROM orders
    GROUP BY date_format(order_date, "%Y-%m") order by order_month asc;


-- Q32. Monthly profit trend.
SELECT


    date_format(order_date, "%Y-%m") as order_month, 
    round(sum(profit),2) as total_profit
    FROM orders
    GROUP BY date_format(order_date, "%Y-%m") 
    order by order_month asc;

-- Q33. Quarterly sales.
SELECT
    date_format(order_date, "%Q") as order_month,
    round(sum(sales),2) as total_sales 
    FROM orders
    GROUP BY date_format(order_date, "%Q") order by order_month asc;


-- Q34. Year-over-year growth.
with yearly_data as (
    SELECT
        date_format(order_date, "%Y") as order_year, 
        round(sum(sales),2) as total_sales
    FROM orders
    GROUP BY date_format(order_date, "%Y") 
    order by order_year asc
)
SELECT
    order_year,
    total_sales,
    lag(total_sales) over(ORDER BY order_year) as prev_value,
    round(((total_sales - (lag(total_sales) over(ORDER BY order_year)))/ (lag(total_sales) over(ORDER BY order_year)))*100,2) as growth_rate
from yearly_data;

-- Q35. Month-over-month growth.
with yearly_data as (
    SELECT
        date_format(order_date, "%y-%m") as order_month, 
        round(sum(sales),2) as total_sales
    FROM orders
    GROUP BY date_format(order_date, "%y-%m") 
    order by order_month asc
)
SELECT
    order_month,
    total_sales,
    lag(total_sales) over(ORDER BY order_month) as prev_value,
    round((total_sales - (lag(total_sales) over(ORDER BY order_month)))/ (lag(total_sales) over(ORDER BY order_month))*100,2) as growth_rate
from yearly_data;

-- creating a new column in orders table rating 
alter TABLE orders
add column rating int;

-- adding data into it
UPDATE orders
set rating = floor(1 + rand() * 5);

