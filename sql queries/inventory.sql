SELECT * from inventory LIMIT 5;


SELECT avg(reorder_level) from inventory;


-- Q45. Products below reorder level.
SELECT
    product_id, reorder_level 
    FROM inventory
    where reorder_level < (SELECT avg(reorder_level) from inventory);


-- Q46. Warehouses needing restocking.
SELECT
    warehouse_id, stock
    from inventory
    where stock <= 0;
    