-- Ejercicio 2 [SQL]
-- Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados
-- por cantidad vendida.

SELECT prod_codigo, prod_detalle
FROM DBO.Item_Factura JOIN DBO.Producto ON prod_codigo = item_producto 
					JOIN DBO.Factura ON (fact_tipo = item_tipo AND fact_numero = item_numero AND fact_sucursal = item_sucursal)
WHERE YEAR(fact_fecha) = 2012
ORDER BY item_cantidad