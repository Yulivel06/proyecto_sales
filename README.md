


> 
# Datos de productos de venta

### Contexto 

En este reporte se analizan datos sobre venta de productos electrónicos, en diferente estados de Estados Unidos. Esto nos brindó informacion sobre los productos mas y menos vendidos, así como los que generaron mayores ingresos, tambien se visualizo horarios picos y ciudades mayor cantidad de pedidos. 
Esto nos permite obtener información de valor para la toma de decisiones, permitiendo así, establecer objetivos, pronosticar ventas, lanzar campañas de marketing entre otros. 

### Información sobre el conjunto de datos 

Los datos fueron obtenido de la siguiente pagina web: [kaggle](https://www.kaggle.com/datasets/knightbearr/sales-product-data). 
También pude descargar los archivos [Aquí](https://github.com/Yulivel06/proyecto_sales/tree/master/dataset)

#### **Contenido archivos**

-   `Order ID`- Un ID de pedido es el sistema numérico que Amazon utiliza exclusivamente para realizar un seguimiento de los pedidos. Cada pedido recibe su propio ID de pedido que no se duplicará. Este número puede ser útil para el vendedor cuando intenta averiguar ciertos detalles sobre un pedido, como la fecha o el estado del envío.
-   `Product`- El producto que se ha vendido.
-   `Quantity Ordered`- Cantidad solicitada es la cantidad total de artículos solicitados en el pedido inicial (sin ningún cambio).
-   `Price Each`- El precio de cada producto.
-   `Order Date`- Esta es la fecha en que el cliente solicita que se envíe el pedido.
-   `Purchase Address`- La orden de compra la prepara el comprador, a menudo a través de un departamento de compras. La orden de compra, u orden de compra, generalmente incluye un número de orden de compra, que es útil para hacer coincidir los envíos con las compras; una fecha de envío; Dirección de Envio; Dirección de Envío; y los artículos solicitados, cantidades y precio.

Nos proporcionan una serie de preguntas que nos ayuda analizar los datos. Puede consultarlas [Aquí](https://github.com/Yulivel06/proyecto_sales/blob/master/preguntas.txt).

## Ahora si, comencemos 

 ### ¿Que herramientas utilizamos?
 
 -   PostgreSQL (Análisis exploratorio de datos)
-   Power BI (visualización de datos)

## ETL 
El primero paso es realizar un proceso de ETL (Extracción, transformación y cargue de nuestros datos). 
Para esto: 

 1. Creamos un schema donde guardamos nuestros datos crudos (sin procesar).
 ** nota: schema es una conjunto de tablas
 
 ``` sql
 create schema raw;
 ```

2. Seguidamente procedemos a crear una tabla (para este caso solo fue necesario una) debido a que tenemos 12 archivos que tienen las mismas columnas. 

 ``` sql
 CREATE TABLE raw.sales (  
    order_id VARCHAR,  
  product varchar,  
  quantity_ordered VARCHAR,  
  price_each VARCHAR,  
  order_date VARCHAR,  
  purchase_address VARCHAR  
);  
``` 

3.  Ahora, es momento de crear un schema que tenga nuestros datos transformados y limpios para poder analizar. 
 **Recuerda: Si Entra Basura, Sale Basura**
 
Explorando los datos nos dimos cuenta que existían valores nulos, ademas que los encabezados se repetian en varios registros, asi que procedimos a eliminar estos registros.
Para esto creamos un nuevo schema que almacenara la información limpia (por defecto en postgres utilizamos una llamada "public". 

 3.1. Creamos una nueva tabla en public (sin registros y sin los encabezados repetidos) 
 CREATE TABLE public.sales as  
  
   ``` sql
 WITH filtered as (SELECT order_id, product, quantity_ordered, price_each, order_date, purchase_address -- tabla con valores no nulos y diferente a string  
  from raw.sales  
                       WHERE order_id IS NOT NULL AND order_id !='Order ID' ),  
  parsed AS (SELECT order_id::INTEGER                            AS order_id, -- asignamos los tipos de datos para cada columna  
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
  ltrim (split_part( (split_part(purchase_address, ',', 3)), ' ',2), ' '  
  ) as status  
     FROM parsed  
;
```

Posteriormente decidimos extrar los estados de la columna "purchase_addres" y crear una tabla con lo estados de Estados Unidos que se encontraban en el conjunto de datos. 
   ``` sql
   CREATE TABLE estados_eeuu AS (  
            SELECT  
 DISTINCT (    split_part(status, ' ', 1))  AS estado,  
 NULL AS name FROM sales  
            GROUP BY status);
 ```
 
