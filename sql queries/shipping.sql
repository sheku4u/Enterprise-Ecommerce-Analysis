SELECT * from shipping LIMIT 10;


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

