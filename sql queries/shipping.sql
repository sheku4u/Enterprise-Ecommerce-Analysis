SELECT * from shipping LIMIT 5;
SELECT * from warehouses LIMIT 5;
SELECT * from orders LIMIT 5;


-- Q16. Find average delivery time.
create or replace view avg_delivery_days as SELECT
    avg(datediff(delivery_date,ship_date)) as avg_delivery_days
     from shipping;

SELECT * from avg_delivery_days;


-- Q17. Find delayed deliveries (>7 days).
with delayed_delivery as (
    SELECT
        order_id,shipping_mode, shipping_cost, ship_date, delivery_date, 
        datediff(delivery_date, ship_date) as delivery_days
        FROM shipping
)
SELECT * from delayed_delivery where delivery_days > 7;


-- Q36. Average delivery days by shipping mode.
select 
shipping_mode , round(avg(datediff(delivery_date,ship_date)),0) as avg_delivery_days
 FROM shipping
GROUP BY shipping_mode
order by avg_delivery_days asc;



-- Q38. Shipping cost by state.-- Q37. Warehouse with the fastest delivery.
with warehouse_data as (
    SELECT
        w.warehouse_id, w.warehouse_name, datediff(s.delivery_date, s.ship_date) as delivery_days
        FROM warehouses w join orders o on w.warehouse_id = o.warehouse_id join shipping s on o.order_id = s.order_id 
        
)
SELECT warehouse_id, warehouse_name , min(delivery_days) as delivery_day
from warehouse_data 
GROUP BY warehouse_id, warehouse_name
order by delivery_day ASC
limit 1;