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
    count(order_id) AS num_order
FROM sales
GROUP BY city
ORDER BY  num_order DESC;

--ciudad con mas ingresos

SELECT
    city,
    SUM(quantity_ordered*price_each) as revenue
FROM sales
GROUP BY city
ORDER BY  revenue DESC;


SELECT *, count(*)
from sales
group by order_id, product, quantity_ordered, price_each, order_date, purchase_address, city, status
order by count(*) DESC;


WITH values_repeat as (
    select *,
    row_number() OVER (PARTITION BY order_id, product, quantity_ordered, price_each, order_date, purchase_address, city, status)  AS row_number
    from sales
    order by  order_id)
select *
from values_repeat
where row_number > 1
;

create TABLE sales_prueba as (select*from sales);

WITH values_repeat as (
    select *,
    row_number() OVER (PARTITION BY order_id, product, quantity_ordered, price_each, order_date, purchase_address, city, status)  AS row_number
    from sales
    order by  order_id)
DELETE
from values_repeat
where row_number > 1;

ALTER TABLE sales_prueba
ADD COLUMN  uniqueness INTEGER;


WITH values_repeat as (
    select *,
    row_number() OVER (PARTITION BY order_id, product, quantity_ordered, price_each, order_date, purchase_address, city, status)  AS row_number
    from sales_prueba
    order by  order_id)
update sales_prueba as p
set uniqueness=row_number
from values_repeat as r
WHERE p.id=r.id;


create temporary  table pruebita_fin as (
select
    row_number() over () as id,
    *
from sales_prueba)
;

select * from pruebita_fin;

DROP TABLE sales_prueba;

create table sales_prueba as (
    select * from pruebita_fin);

select * from sales_prueba;

with pruebita as (
select
    row_number() over () as idy,
    *
from sales_prueba)

UPDATE sales_prueba
set id=p.idy
from pruebita as p
;

select *,
    row_number() OVER (PARTITION BY order_id, product, quantity_ordered, price_each, order_date, purchase_address, city, status)  AS row_number
    from sales_prueba;



delete
from sales_prueba
where uniqueness > 1
;


select count(*) as c
from sales_prueba
group by order_id, order_id, product, quantity_ordered, price_each, order_date, purchase_address, city, status
having count(*) > 1;






