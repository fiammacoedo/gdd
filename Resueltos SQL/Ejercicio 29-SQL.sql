-- Ejercicio 29 [SQL]
-- Se solicita que realice una estadística de venta por producto para el año 2011, solo para
-- los productos que pertenezcan a las familias que tengan más de 20 productos asignados a
-- ellas, la cual deberá devolver las siguientes columnas:
-- a. Código de producto
-- b. Descripción del producto
-- c. Cantidad vendida
-- d. Cantidad de facturas en la que esta ese producto
-- e. Monto total facturado de ese producto
-- Solo se deberá mostrar un producto por fila en función a los considerandos establecidos
-- antes. El resultado deberá ser ordenado por el la cantidad vendida de mayor a menor.

SELECT p.prod_codigo, p.prod_detalle, SUM(i.item_cantidad) AS cantidad_vendida,
		COUNT(DISTINCT(f.fact_numero + f.fact_sucursal + f.fact_tipo)) AS cantidad_facturas_prod,
		SUM(i.item_cantidad * i.item_precio) AS monto_total_prod
FROM Factura f JOIN Item_Factura i ON (f.fact_numero = i.item_numero AND f.fact_sucursal = i.item_sucursal AND f.fact_tipo = i.item_tipo)
	JOIN Producto p ON p.prod_codigo = i.item_producto
WHERE YEAR(f.fact_fecha) = 2011 AND p.prod_familia IN (SELECT f2.fami_id
														FROM Familia f2 JOIN Producto p2 ON f2.fami_id = p2.prod_familia
														GROUP BY f2.fami_id
														HAVING COUNT(*) > 20)
GROUP BY p.prod_codigo, p.prod_detalle
ORDER BY SUM(i.item_cantidad) DESC
