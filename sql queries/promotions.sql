SELECT * from promotions LIMIT 5;

-- Q20. Count promotions by promotion type.
SELECT promotion_type, count(promotion_id) as total_promotions FROM promotions
GROUP BY promotion_type order by total_promotions desc;