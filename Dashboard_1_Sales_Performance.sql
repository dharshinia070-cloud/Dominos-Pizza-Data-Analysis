-- first dashboard--

CREATE or replace VIEW vw_SalesPerformance AS
SELECT
    o.order_id,
    o.order_date,
    o.order_time,
    o.status,
    
    c.custid,
    c.first_name,
    c.last_name,
    c.city,
    c.state,
    
    od.order_details_id,
    od.pizza_id,
    od.quantity,
    
    p.pizza_type_id,
    p.size,
    p.price,
    
    pt.name AS pizza_name,
    pt.category,
    pt.ingredients,

    (od.quantity * p.price) AS revenue

FROM orders o

JOIN customers c
    ON o.custid = c.custid

JOIN order_details od
    ON o.order_id = od.order_id

JOIN pizzas p
    ON od.pizza_id = p.pizza_id

JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id;
    
-- Daily Orders Trend

SELECT
    DAYOFWEEK(order_date) AS day_number,
    DAYNAME(order_date) AS day_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM vw_SalesPerformance
GROUP BY DAYOFWEEK(order_date), DAYNAME(order_date)
ORDER BY day_number;

-- monthly revenue trend 

SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS month_number,
    MONTHNAME(order_date) AS month_name,
    SUM(revenue) AS total_revenue
FROM vw_SalesPerformance
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    MONTHNAME(order_date)
ORDER BY order_year, month_number;

-- Revenue by Category

SELECT
    category,
    SUM(revenue) AS total_revenue
FROM vw_SalesPerformance
GROUP BY category
ORDER BY total_revenue DESC;

-- revenue by pizza size

SELECT
    size,
    SUM(revenue) AS total_revenue
FROM vw_SalesPerformance
GROUP BY size
ORDER BY total_revenue DESC;

-- Top 5 pizza types by revenue

SELECT
    pizza_name,
    SUM(revenue) AS total_revenue
FROM vw_SalesPerformance
GROUP BY pizza_name
ORDER BY total_revenue DESC
LIMIT 5;
