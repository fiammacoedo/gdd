-- Ejercicio 11 [SQL]
-- Realizar una consulta que retorne el detalle de la familia, la cantidad diferente de
-- productos vendidos y el monto de dichas ventas sin impuestos. Los datos se deberán
-- ordenar de mayor a menor, por la familia que más productos diferentes vendidos
-- tenga, solo se deberán mostrar las familias que tengan una venta superior a 20000
-- pesos para el año 2012.

SELECT f1.fami_detalle, COUNT(DISTINCT(i.item_producto)) AS distintos_productos_vendidos,
		ISNULL(SUM(i.item_cantidad * i.item_precio), 0) AS total_sin_impuestos
FROM Familia f1 JOIN Producto p ON f1.fami_id = p.prod_familia JOIN Item_Factura i ON p.prod_codigo = i.item_producto
WHERE f1.fami_id IN (SELECT p2.prod_familia
					FROM Producto p2 JOIN Item_Factura i2 ON p2.prod_codigo = i2.item_producto 
					JOIN Factura f3 ON (f3.fact_sucursal = i2.item_sucursal AND f3.fact_numero = i2.item_numero AND f3.fact_tipo = i2.item_tipo)
					WHERE YEAR(f3.fact_fecha) = 2012
					GROUP BY p2.prod_familia
					HAVING (ISNULL(SUM(i2.item_cantidad * i2.item_precio), 0) > 20000)) 
GROUP BY f1.fami_detalle
ORDER BY COUNT(DISTINCT(i.item_producto)) DESC
