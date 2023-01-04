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

-- ¿Cual fue el mejor MES para ventas? ¿Cuanto se ganó por mes?

SELECT
    to_char(order_date, 'month') AS month,      -- To_chart extrae el nombre del mes del año
    to_char(order_date, 'MM') AS number_month,
    extract(year from order_date),
    SUM(quantity_ordered*price_each) AS revenue_month
FROM sales
GROUP BY number_month, month, extract(year from order_date);

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

--ciudad con mas ingresos

SELECT
    city,
    name,
    SUM(quantity_ordered*price_each) as revenue
FROM sales
    INNER JOIN estados_eeuu
    USING (state)
GROUP BY city, name
ORDER BY  revenue DESC;

-- Estado con mas ingresos y % de ingresos

WITH revenue_state as (
    SELECT
        name AS  state,
        SUM(quantity_ordered*price_each) as revenue_state
    FROM sales
        INNER JOIN estados_eeuu
        USING (state)
    GROUP BY name)
SELECT
    state,
    round(revenue_state/ (SELECT SUM(quantity_ordered*price_each) FROM sales),2) AS percentage
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


-- Product best seller

SELECT product, sum(quantity_ordered) AS quantity
from sales
GROUP BY  product
ORDER BY quantity DESC;




















