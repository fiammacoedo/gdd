-- Ejercicio 7 [SQL]
-- Generar una consulta que muestre para cada articulo: código, detalle, mayor precio
-- menor precio y % de la diferencia de precios respecto del menor (Ej.: menor precio
-- = 10, mayor precio =12 => mostrar 20 %). 
-- Mostrar solo aquellos artículos que posean stock.

SELECT p.prod_codigo, p.prod_detalle, MAX(i.item_precio) AS mayor_precio, MIN(i.item_precio) AS menor_precio, 
		((MAX(i.item_precio) - MIN(i.item_precio)) * 100 / MIN(i.item_precio)) AS diferencia_precios
FROM Producto p JOIN Item_Factura i ON p.prod_codigo = i.item_producto JOIN Stock s ON s.stoc_producto = p.prod_codigo
WHERE p.prod_codigo IN (SELECT s2.stoc_producto FROM Stock s2 WHERE s2.stoc_cantidad > 0)
GROUP BY p.prod_codigo, p.prod_detalle
--HAVING ISNULL(SUM(s.stoc_cantidad), 0) > 0  (Ver este caso)
