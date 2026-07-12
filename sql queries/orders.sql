SELECT * from orders limit 10;

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

-- Q32. Monthly profit trend.

-- Q33. Quarterly sales.

-- Q34. Year-over-year growth.

-- Q35. Month-over-month growth.