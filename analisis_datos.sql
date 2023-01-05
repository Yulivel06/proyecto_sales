-- Total ingresos

SELECT SUM(quantity_ordered*price_each) as revenue_year
FROM sales;

--Total Ordenes
SELECT
     count (distinct (order_id)) AS total_orders
FROM sales;

--total Product sold
SELECT
    count(product) AS total_product_sold
FROM sales;

-- promedio por orden

-- total productos


-- ¿Cual fue el mejor MES para ventas? ¿Cuanto se ganó por mes?

WITH revenue_month AS (
    SELECT to_char(order_date, 'month')  AS month, -- To_chart extrae el nombre del mes del año
    to_char(order_date, 'MM')   AS number_month,
    SUM(quantity_ordered * price_each) AS revenue_month
    FROM sales
    GROUP BY number_month, month, extract(year from order_date)
    )
SELECT
    month,
    number_month,
    revenue_month,
    round(revenue_month/(SELECT SUM(quantity_ordered*price_each) FROM sales),2) AS percentage
FROM revenue_month;

--Ordenes por mes

SELECT
    to_char(order_date, 'month') AS month,      -- To_chart extrae el nombre del mes del año
    to_char(order_date, 'MM') AS number_month,
    COUNT(order_id) AS num_order_month
FROM sales
GROUP BY number_month, month;

--Ciudad con mayor numero de ventas (ordenes)

SELECT
    city,
    name,
    count(order_id) AS num_order
FROM sales
INNER JOIN estados_eeuu
    USING (state)
GROUP BY city, name
ORDER BY  num_order DESC;

--ingresos por estados

SELECT
    name AS  state,
        SUM(quantity_ordered*price_each) as revenue_state
FROM sales
INNER JOIN estados_eeuu
USING (state)
GROUP BY name;

-- city con mas ingresos y % de ingresos

WITH revenue_state as (
    SELECT
        city,
        name AS  state,
        SUM(quantity_ordered*price_each) as revenue_state
    FROM sales
        INNER JOIN estados_eeuu
        USING (state)
    GROUP BY name,city)
SELECT
    concat(city,', ', state) as city,
    round(revenue_state/ (SELECT SUM(quantity_ordered*price_each) FROM sales),2) AS percentage,
    revenue_state
FROM revenue_state
ORDER BY percentage DESC
;

-- ¿A qué hora debemos mostrar la publicidad para maximizar la probabilidad de que el cliente compre el producto?

SELECT
    name,
    city,
    extract(hour FROM order_date) as hour,
    count (distinct (order_id)) AS total_orders
FROM sales
INNER JOIN estados_eeuu
    USING (state)
GROUP BY order_id,hour , city, name
ORDER BY total_orders;

-- dia con mas ordenes

SELECT
    name,
    to_char(order_date, 'day') AS name_day,
	date_part('dow', order_date) as num_day,
    count (distinct (order_id)) AS total_orders
FROM sales
INNER JOIN estados_eeuu
    USING (state)
GROUP BY order_id, name, num_day, name_day
ORDER BY total_orders;


-- Product best seller

SELECT product,
           sum(quantity_ordered*price_each) AS revenue,
           sum(quantity_ordered) AS quantity,
           price_each
FROM sales
GROUP BY  product, price_each
ORDER BY quantity DESC;


-- ¿Qué probabilidad hay de que las próximas personas soliciten el cable de carga USB-C?

SELECT product, 1.0*SUM(quantity_ordered)/
                (SELECT sum(quantity_ordered)   FROM sales)
FROM  sales
WHERE product = 'USB-C Charging Cable'
GROUP BY product;


-- ¿Cuánta probabilidad de que la próxima gente ordene un iPhone?

select product, 1.0*SUM(quantity_ordered)/
                (SELECT sum(quantity_ordered)   FROM sales)
from sales
where product like ('%iPhone%')
group by  product;

-- ¿Cuánta probabilidad de que la próxima gente ordene Google Phone?

select product, 1.0*SUM(quantity_ordered)/
                (SELECT sum(quantity_ordered)   FROM sales)
from sales
where product like ('%Google%')
group by  product;

-- ¿Cuánta probabilidad de que otras personas ordenen auriculares con cable?

select product, SUM(quantity_ordered)/
                (SELECT sum(quantity_ordered) FROM sales)::float
from sales
where product = 'Wired Headphones'
group by product
;


select*from sales;

















