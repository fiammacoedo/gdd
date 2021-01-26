-- Ejercicio 25 [SQL]
-- Realizar una consulta SQL que para cada año y familia muestre :
-- a. Año
-- b. El código de la familia más vendida en ese año.
-- c. Cantidad de Rubros que componen esa familia.
-- d. Cantidad de productos que componen directamente al producto más vendido de esa familia.
-- e. La cantidad de facturas en las cuales aparecen productos pertenecientes a esa familia.
-- f. El código de cliente que más compro productos de esa familia.
-- g. El porcentaje que representa la venta de esa familia respecto al total de venta del año.
-- El resultado deberá ser ordenado por el total vendido por año y familia en forma descendente.

SELECT YEAR(f.fact_fecha) AS anio, p.prod_familia AS codigo_familia,
		COUNT(DISTINCT p.prod_rubro) AS cantidad_rubros_familia,
		--(SELECT COUNT(c.comp_componente)
		--FROM Composicion c
		--WHERE c.comp_producto = (SELECT TOP 1 p2.prod_codigo
		--						FROM Item_Factura i2 JOIN Producto p2 ON i2.item_producto = p2.prod_codigo
		--						WHERE p2.prod_familia = p.prod_familia
		--						GROUP BY p2.prod_codigo
		--						ORDER BY SUM(i2.item_cantidad) DESC)) AS cantidad_comp_producto_mas_vendido,
		COUNT(DISTINCT (f.fact_numero + f.fact_sucursal + f.fact_tipo)) AS cantidad_facturas_familia,
		--(SELECT TOP 1 f3.fact_cliente
		--FROM Item_Factura i3 JOIN Factura f3 ON (f3.fact_sucursal = i3.item_sucursal AND f3.fact_tipo = i3.item_tipo AND f3.fact_numero = i3.item_numero)
		--	JOIN Producto p3 ON p3.prod_codigo = i3.item_producto
		--WHERE p3.prod_familia = p.prod_familia
		--GROUP BY f3.fact_cliente
		--ORDER BY SUM(i3.item_cantidad) DESC) AS mayor_comprador_familia,
		SUM(f.fact_total) / (SELECT SUM(f4.fact_total)
							FROM Factura f4
							WHERE YEAR(f4.fact_fecha) = YEAR(f.fact_fecha)) * 100 AS porcentaje_ventas_familia
FROM Item_Factura i JOIN Producto p ON i.item_producto = p.prod_codigo
	JOIN Factura f ON (f.fact_sucursal = i.item_sucursal AND f.fact_tipo = i.item_tipo AND f.fact_numero = i.item_numero)
GROUP BY YEAR(f.fact_fecha), p.prod_familia
ORDER BY SUM(i.item_cantidad) DESC, p.prod_familia DESC