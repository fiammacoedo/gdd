-- Ejercicio 5 [SQL]
-- Realizar una consulta que muestre código de artículo, detalle y cantidad de egresos
-- de stock que se realizaron para ese artículo en el año 2012 (egresan los productos
-- que fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el 2011.

SELECT p.prod_codigo, p.prod_detalle, ISNULL(SUM(i.item_cantidad), 0) AS egresos
FROM Producto p JOIN Item_Factura i ON p.prod_codigo = i.item_producto 
				JOIN Factura f ON (f.fact_numero = i.item_numero AND f.fact_sucursal = i.item_sucursal AND f.fact_tipo = i.item_tipo)
WHERE YEAR(f.fact_fecha) = 2012
GROUP BY p.prod_codigo, p.prod_detalle
HAVING ISNULL(SUM(i.item_cantidad), 0) > (SELECT ISNULL(SUM(i2.item_cantidad), 0)
										FROM Item_Factura i2 JOIN Factura f2 ON 
											(f2.fact_numero = i2.item_numero AND f2.fact_sucursal = i2.item_sucursal AND f2.fact_tipo = i2.item_tipo)
										WHERE YEAR(f2.fact_fecha) = 2011 AND p.prod_codigo = i2.item_producto)
