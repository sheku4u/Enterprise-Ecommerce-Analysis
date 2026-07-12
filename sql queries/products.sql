SELECT * from products LIMIT 5;

SELECT * from orders LIMIT 5;


-- Q6. Find total products in each category.
create view no_of_products_in_category as SELECT
category, count(DISTINCT product_id) as total_products FROM products
GROUP BY category order by total_products desc;

SELECT * from no_of_products_in_category;

-- Q7. Find average selling price by category.
create or replace view avg_selling_price_by_category as 
SELECT
category, ROUND(COALESCE(avg(p.selling_price),0), 2) as avg_selling_price 
FROM products
GROUP BY category ORDER BY avg_selling_price desc;

SELECT category, round(avg_selling_price,2) as avg_selling_price FROM avg_selling_price_by_category;


-- Q8. Find products whose selling price is lower than cost price.
create view products_lower_selling_price as SELECT
product_id, product_name, cost_price, selling_price FROM products
WHERE cost_price > selling_price;
SELECT * FROM products_lower_selling_price;

-- Q9. Find products with missing brand names.
CREATE view missing_brand as SELECT
product_id,product_name,category, cost_price, brand FROM products
WHERE brand is NULL;

SELECT * FROM missing_brand;


-- Q10. Find the top 10 most expensive products
with expensive_products as (
    SELECT
        product_id, product_name,category, cost_price, DENSE_RANK() OVER(order by cost_price DESC) as rnk FROM products
)
SELECT * from expensive_products
where rnk <= 10;


-- Q26. Top selling products.
with top_selling_products as (
    SELECT
        product_id, product_name, selling_price, 
        DENSE_RANK() over(ORDER BY selling_price desc) as sel_rnk
        FROM products
)
SELECT * from top_selling_products where sel_rnk <= 10;

-- Q27. Bottom selling products.
with bottom_selling_products as (
    SELECT
        product_id, product_name, selling_price, 
        DENSE_RANK() over(ORDER BY selling_price asc) as sel_rnk
        FROM products
)
SELECT * from bottom_selling_products where sel_rnk <= 10;
-- Q28. Highest profit category.
with highest_profit_category as (
    SELECT
        category, profit, 
        DENSE_RANK() over(ORDER BY profit desc) as sel_rnk
        FROM products
)
SELECT * from highest_profit_category where sel_rnk = 1;

-- Q29. Category-wise revenue contribution.
with category_rev as 
(SELECT
    p.category, round(COALESCE(sum(o.sales),0),2) as revenue
    FROM products p LEFT JOIN orders o on p.product_id = o.product_id
    GROUP BY p.category )

SELECT
    category,
    revenue,
    round((revenue / (select sum(sales) from orders))*100,2) as contribution
from category_rev
order by contribution;


-- Q30. Product return rate.
SELECT  
    product_id,product_name, round(((selling_price-cost_price)/cost_price)*100,2) as return_rate FROM products
    order by return_rate desc;


