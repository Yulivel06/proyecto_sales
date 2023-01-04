-- 1. Verificamos si nuestra data tiene duplicados

WITH repeats AS (
    SELECT *,
    ROW_NUMBER() OVER(PARTITION BY order_id, product, quantity_ordered,
        price_each, order_date, purchase_address, city, state) AS repeats
    from sales)
SELECT *
FROM repeats
WHERE  repeats > 1
ORDER BY order_id;

--2 Teniendo en cuenta lo anterior procedomos a eliminar los duplicados de la siguiente manera:
--2.1. Agregar un id: Esto nos permite tener un identificador único para cada registro, seguidamente,
-- creamos una tabla temporal para poder guardar nuestra tabla original "sales", esto con el
-- objetivo de poder consultarla despues borrarla, lo hacemos así:

CREATE TEMPORARY TABLE  table_temporary AS (
SELECT
     row_number() over () AS id,   -- usamos el row number sin partition by para generar el id
     *
FROM sales);

-- 2.2 Borrar y crear la tabla a partir de la tabla temporal creada anteriormente

DROP TABLE sales;

CREATE TABLE sales AS (
    SELECT * FROM table_temporary
);

-- 2.3. Crear una columna que nos permita conocer cual es el número de iteración (veces que se repite) de cada registro,
--Para nuestro caso la llamamos "uniqueness"

ALTER TABLE sales
ADD COLUMN uniqueness INTEGER;

-- Agremamos valores a la columna uniqueness con row number

WITH repeats  AS (
    SELECT *,
    ROW_NUMBER() OVER(PARTITION BY order_id, product, quantity_ordered,
        price_each, order_date, purchase_address, city, state) AS repetitions
    from sales)
UPDATE sales AS s
SET uniqueness=r.repetitions
FROM repeats AS r
WHERE s.id=r.id;              -- cruzamos con id que es identificador

--2.4 Identificar los duplicados y eliminamos

DELETE
FROM sales
WHERE uniqueness > 1;


-- Encontramos datos del año 2020, los cuales procedemos a eliminar

DELETE
FROM  sales
WHERE extract (year from order_date) = '2020';















