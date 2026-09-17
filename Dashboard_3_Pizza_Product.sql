
-- third dashboard --


CREATE OR REPLACE VIEW vw_PizzaProductDashboard AS
SELECT
    p.pizza_id,
    p.pizza_type_id,
    p.size,
    p.price,
    pt.name AS pizza_name,
    pt.category,
    pt.ingredients,
    od.order_details_id,
    od.order_id,
    od.quantity,
    o.order_date,
    o.order_time,
    o.status,
    (od.quantity * p.price) AS revenue
FROM pizzas p
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details od
    ON p.pizza_id = od.pizza_id
JOIN orders o
    ON od.order_id = o.order_id;
    
    -- Revenue by Pizza Category
    SELECT
    pt.category,
    SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_revenue DESC;

-- Top 10 Best-Selling Pizzas

SELECT
    pt.name AS pizza_name,
    SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity DESC
LIMIT 10;
    
    
    
 -- Pizza Sales Trend by Month
 
 SELECT
    YEAR(o.order_date) AS order_year,
    MONTH(o.order_date) AS month_number,
    MONTHNAME(o.order_date) AS month_name,
    SUM(od.quantity) AS total_quantity
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date),
    MONTHNAME(o.order_date)
ORDER BY
    order_year,
    month_number;
    
    -- Pizza Quantity by Size
    
    SELECT
    p.size,
    SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_quantity DESC;

-- Average Pizza Price by Category

SELECT
    pt.category,
    ROUND(AVG(p.price), 2) AS average_price
FROM pizzas p
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY average_price DESC;

-- pizza type by count of category

SELECT
    category,
    COUNT(DISTINCT pizza_type_id) AS pizza_type_count
FROM pizza_types
GROUP BY category
ORDER BY pizza_type_count DESC;
