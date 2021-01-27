-- Ejercicio 35 [SQL]
-- Se requiere realizar una estadística de ventas por año y producto, para ello escribir una consulta sql que retorne las siguientes columnas:
-- Año
-- Codigo de producto
-- Detalle del producto
-- Cantidad de facturas emitidas a ese producto ese año
-- Cantidad de vendedores diferentes que compraron ese producto ese año. (supongo que VENDIERON???)
-- Cantidad de productos a los cuales compone ese producto, si no compone a ninguno se debera retornar 0.
-- Porcentaje de la venta de ese producto respecto a la venta total de ese año.
-- Los datos deberan ser ordenados por año y por producto con mayor cantidad vendida.

SELECT YEAR(f.fact_fecha) AS anio, p.prod_codigo, p.prod_detalle, 
	COUNT(DISTINCT f.fact_numero + f.fact_sucursal + f.fact_tipo) AS cantidad_facturas,
	COUNT(DISTINCT f.fact_vendedor) AS cantidad_vendedores,
	ISNULL((SELECT COUNT(*)
	FROM Composicion
	WHERE comp_componente = p.prod_codigo), 0) AS cantidad_prod_compuestos,
	SUM(i.item_cantidad * i.item_precio) / (SELECT SUM(f2.fact_total)
											FROM Factura f2 
											WHERE YEAR(f2.fact_fecha) = YEAR(f.fact_fecha)) * 100 AS porcentaje_venta_prod
FROM Factura f JOIN Item_Factura i ON (f.fact_numero = i.item_numero AND f.fact_sucursal = i.item_sucursal AND f.fact_tipo = i.item_tipo)
	JOIN Producto p ON p.prod_codigo = i.item_producto
GROUP BY YEAR(f.fact_fecha), p.prod_codigo, p.prod_detalle
ORDER BY YEAR(f.fact_fecha), SUM(i.item_cantidad) DESC