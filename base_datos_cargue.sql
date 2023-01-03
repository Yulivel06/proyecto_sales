-- creamos un schema donde alojaremos nuestra data cruda

create schema raw;

-- creamos la tabla donde guardamos nuestra informacion cruda

CREATE TABLE raw.sales (
    order_id VARCHAR,
    product varchar,
    quantity_ordered VARCHAR,
    price_each VARCHAR,
    order_date VARCHAR,
    purchase_address VARCHAR
);



-- Eliminamos valores nulos, normalizamos nuestros datos y establecemos los tipso de datos.
-- Creamos la tabla sale en schema public que contiene la data limpia y transformada

CREATE TABLE public.sales as

    WITH filtered as (SELECT order_id, product, quantity_ordered, price_each, order_date, purchase_address -- tabla con valores no nulos y diferente a string
                       from raw.sales
                       WHERE order_id IS NOT NULL AND order_id !='Order ID' ),
          parsed AS (SELECT order_id::INTEGER                            AS order_id,  -- asignamos los tipos de datos para cada columna
                            product,
                            quantity_ordered::INTEGER                    as quantity_ordered,
                            price_each::decimal                          AS price_each,
                            to_timestamp(order_date, 'MM/DD/YY HH24:MI') AS order_date,
                            purchase_address
                     FROM filtered)
     SELECT
            order_id, product, quantity_ordered, price_each, order_date, purchase_address,
            ltrim (split_part(purchase_address, ',', 2), ' '
                ) as city, -- ltrim se usa para eliminar espacio en blanco inicial y split para extraer la ciudad de la direccion
            ltrim (split_part(purchase_address, ',', 3), ' '
                ) as status
     FROM parsed
;



CREATE TABLE public.sales_prueba as

    WITH filtered as (SELECT order_id, product, quantity_ordered, price_each, order_date, purchase_address -- tabla con valores no nulos y diferente a string
                       from raw.sales
                       WHERE order_id IS NOT NULL AND order_id !='Order ID' ),
          parsed AS (SELECT order_id::INTEGER                            AS order_id,  -- asignamos los tipos de datos para cada columna
                            product,
                            quantity_ordered::INTEGER                    as quantity_ordered,
                            price_each::decimal                          AS price_each,
                            to_timestamp(order_date, 'MM/DD/YY HH24:MI') AS order_date,
                            purchase_address
                     FROM filtered)
     SELECT
            order_id, product, quantity_ordered, price_each, order_date, purchase_address,
            ltrim (split_part(purchase_address, ',', 2), ' '
                ) as city -- ltrim se usa para eliminar espacio en blanco inicial y split para extraer la ciudad de la direccion
     FROM parsed
;

-- BORRAMOS DATOS DEL AÑO 2020

DELETE
FROM  sales
WHERE extract (year from order_date) = '2020';



select * from sales_prueba
where status is not null;

ALTER TABLE  sales_prueba
ADD COLUMN  status varchar;

UPDATE sales_prueba AS sp
SET status = s.status
FROM sales as s
WHERE s.order_id=sp.order_id;

    select * from sales;

select status
from sales_prueba
group by  status;

CREATE TABLE estados_eeuu as (
            SELECT
                        distinct (    split_part(status, ' ', 1))  AS estado,
                        null as name
            from sales_prueba
            group by  sales_prueba.status);

select * from estados_eeuu;

DELETE
FROM  sales
WHERE extract (year from order_date) = '2020';





