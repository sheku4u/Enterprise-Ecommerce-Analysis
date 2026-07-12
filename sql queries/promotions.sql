
SELECT * from promotions LIMIT 5;
SELECT * from orders LIMIT 5;
-- Q20. Count promotions by promotion type.
SELECT promotion_type, count(promotion_id) as total_promotions FROM promotions
GROUP BY promotion_type order by total_promotions desc;


-- Q47. Promotion usage count.
SELECT
promotion_type, count(promotion_id) as promtion_count FROM promotions
GROUP BY promotion_type
ORDER BY promtion_count desc;

-- Q48. Sales during promotions.
    SELECT  
        p.promotion_id, p.promotion_name , p.start_date as promo_start, p.end_date as promo_end, o.order_date
        FROM promotions p join orders o on p.promotion_id = o.promotion_id
        where o.order_date BETWEEN p.start_date and p.end_date;


-- Q49. Average discount by category.
SELECT
    promotion_type , AVG(discount_percentage) as avg_discount
    FROM promotions
    GROUP BY promotion_type
    ORDER BY avg_discount desc;


-- Q50. Top performing promotion.
SELECT
    p.promotion_type , count(o.order_id) as total_orders 
    FROM promotions p join orders o on p.promotion_id = o.promotion_id
    GROUP BY p.promotion_type
    ORDER BY total_orders DESC
    limit 5;