-- Total ingresos

SELECT SUM(quantity_ordered*price_each) as revenue_year
FROM sales;

--Total Ordenes
SELECT
     count (distinct (order_id)) AS total_orders --usamos distinct debido a que una orden puede tener varios productos
FROM sales;

--total Product sold
SELECT
    count(product) AS total_product_sold
FROM sales;

-- promedio productos por orden

WITH product_order AS
     (SELECT order_id,
     count(product) as product_order
     FROM sales
     GROUP BY order_id)
SELECT sum(product_order)/ (select count ( distinct order_id) from sales)
FROM product_order
;

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
    COUNT(distinct(order_id)) AS num_order_month
FROM sales
GROUP BY number_month, month;


--Ciudad con mayor número de ventas (ordenes)

SELECT
    concat(city,', ', name) as city,
    count(distinct order_id) AS num_order
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
    revenue_state,
FROM revenue_state
ORDER BY percentage DESC
;

-- ¿A qué hora debemos mostrar la publicidad para maximizar la probabilidad de que el cliente compre el producto?

SELECT
    concat(s.city,', ', ee.name) as city,
    EXTRACT(hour from order_date ) as hour,
    count (distinct (s.order_id)) AS total_orders
FROM sales AS s
INNER JOIN estados_eeuu AS ee
    USING (state)
GROUP BY hour, s.city, ee.name
ORDER BY city, total_orders
 DESC;

SELECT
FROM hour_peak;

select order_date
from sales
group by order_date
order by order_date DESC
limit 1;


-- Product best seller

SELECT product,
       sum(quantity_ordered * price_each) AS revenue,
       sum(quantity_ordered)              AS quantity,
       price_each
FROM sales
GROUP BY product, price_each
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

-- Numero de ingresos y ordenes por categoria

WITH category AS (SELECT product,
                         quantity_ordered,
                         CASE
                             WHEN product LIKE ('%Batteries%') THEN 'Batteries'
                             WHEN product LIKE ('%Charging Cable%') THEN 'Charging Cable'
                             WHEN product LIKE ('%Headphones%') THEN 'Headphones'
                             WHEN product LIKE ('%Monitor%') THEN 'Monitor'
                             WHEN product LIKE ('%TV%') THEN 'TV'
                             WHEN product LIKE ('%Phone') THEN 'Phone'
                             WHEN product LIKE ('%Laptop%') THEN 'Laptop'
                             WHEN product LIKE ('%Washing Machine%') or product LIKE ('%Dryer%') THEN 'Washer or Dryer'
                             END as category
                  from sales)
SELECT category, sum(quantity_ordered) as quantity_sold
FROM category
GROUP BY category
;


SELECT
    name, count(distinct city)
FROM sales AS s
INNER JOIN estados_eeuu AS ee
    USING (state)
GROUP BY  ee.name




















