

CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY,
    order_id INT,
    pizza_id VARCHAR(50),
    quantity INT
);
LOAD DATA LOCAL INFILE 'C:/Users/acer/Downloads/Domino-s-Pizza-Store-Analysis-SQL-Project-main/Domino-s-Pizza-Store-Analysis-SQL-Project-main/order_details.csv'
INTO TABLE order_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_details_id, order_id, pizza_id, quantity);

SET GLOBAL local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';
SELECT COUNT(*) FROM order_details;
SELECT * FROM order_details LIMIT 10;



CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    order_time TIME,
    custid INT,
    status VARCHAR(30)
);
LOAD DATA LOCAL INFILE 'C:/Users/acer/Downloads/Domino-s-Pizza-Store-Analysis-SQL-Project-main/Domino-s-Pizza-Store-Analysis-SQL-Project-main/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, order_date, order_time, custid, status);

LOAD DATA LOCAL INFILE 'C:/Users/acer/Downloads/Domino-s-Pizza-Store-Analysis-SQL-Project-main/Domino-s-Pizza-Store-Analysis-SQL-Project-main/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, order_date, order_time, custid, status);


SELECT * FROM orders LIMIT 10;


CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(150),
    category VARCHAR(50),
    ingredients TEXT
);

LOAD DATA LOCAL INFILE 'C:/Users/acer/Downloads/Domino-s-Pizza-Store-Analysis-SQL-Project-main/Domino-s-Pizza-Store-Analysis-SQL-Project-main/pizza_types.csv'
INTO TABLE pizza_types
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(pizza_type_id, name, category, ingredients);

SELECT * FROM pizza_types
LIMIT 10;


CREATE TABLE pizzas (
    pizza_id VARCHAR(50) PRIMARY KEY,
    pizza_type_id VARCHAR(50),
    size VARCHAR(10),
    price DECIMAL(10,2)
);
LOAD DATA LOCAL INFILE 'C:/Users/acer/Downloads/Domino-s-Pizza-Store-Analysis-SQL-Project-main/Domino-s-Pizza-Store-Analysis-SQL-Project-main/pizzas.csv'
INTO TABLE pizzas
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(pizza_id, pizza_type_id, size, price);

select count(*) from pizzas;
select * from pizzas;     
select count(*) from orders;
create view  vw_dominos_dashboard as
-- monthly trend--
SELECT
    YEAR(o.order_date) AS order_year,
    MONTH(o.order_date) AS month_number,
    MONTHNAME(o.order_date) AS month_name,
    SUM(od.quantity * p.price) AS total_revenue
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date),
    MONTHNAME(o.order_date)
ORDER BY
    order_year,
    month_number;

-- daily trend
SELECT
    DAYOFWEEK(o.order_date) AS day_number,
    DAYNAME(o.order_date) AS day_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
GROUP BY
    DAYOFWEEK(o.order_date),
    DAYNAME(o.order_date)
ORDER BY
    day_number;
    
    -- total revenue
   SELECT
    pt.name AS pizza_name,
    SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 5;

-- % of sales category
SELECT
    pt.category,
    SUM(od.quantity * p.price) AS total_revenue,
    ROUND(
        SUM(od.quantity * p.price) * 100 /
        (
            SELECT SUM(od2.quantity * p2.price)
            FROM order_details od2
            JOIN pizzas p2
                ON od2.pizza_id = p2.pizza_id
        ),
        2
    ) AS revenue_percentage
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY revenue_percentage DESC;
