-- Second Dashboard --

CREATE or replace VIEW vw_CustomerOrderDashboard AS
SELECT
    c.custid,
    c.first_name,
    c.last_name,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    c.phone,
    c.address,
    c.city,
    c.state,
    c.postal_code,

    o.order_id,
    o.order_date,
    o.order_time,
    o.status,

    od.order_details_id,
    od.pizza_id,
    od.quantity,

    p.pizza_type_id,
    p.size,
    p.price,

    pt.name AS pizza_name,
    pt.category,

    (od.quantity * p.price) AS revenue

FROM customers c
JOIN orders o
    ON c.custid = o.custid
JOIN order_details od
    ON o.order_id = od.order_id
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id;
    
    
    -- Top 5 Customers by Number of Orders
    
    SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.custId = o.custId
GROUP BY c.custId, c.first_name, c.last_name
ORDER BY total_orders DESC
LIMIT 5;

-- orders by month

SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS month_number,
    MONTHNAME(order_date) AS month_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    MONTHNAME(order_date)
ORDER BY
    order_year,
    month_number;
    
    -- top 5 customer by revenue
    
    SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(od.quantity * p.price) AS total_revenue
FROM customers c
JOIN orders o
    ON c.custId = o.custId
JOIN order_details od
    ON o.order_id = od.order_id
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
GROUP BY c.custId, c.first_name, c.last_name
ORDER BY total_revenue DESC
LIMIT 5;

-- order by customer location 

SELECT
    c.city,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.custId = o.custId
GROUP BY c.city
ORDER BY total_orders DESC;

-- order by order status

SELECT
    status,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY status
ORDER BY total_orders DESC;


-- order by month 

SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS month_number,
    MONTHNAME(order_date) AS month_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM vw_SalesPerformance
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    MONTHNAME(order_date)
ORDER BY
    order_year,
    month_number;