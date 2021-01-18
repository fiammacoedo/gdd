-- Ejercicio 17 [SQL]
-- Escriba una consulta que retorne una estadística de ventas por año y mes para cada
-- producto. La consulta debe retornar:
-- PERIODO: Año y mes de la estadística con el formato YYYYMM
-- PROD: Código de producto
-- DETALLE: Detalle del producto
-- CANTIDAD_VENDIDA= Cantidad vendida del producto en el periodo
-- VENTAS_AÑO_ANT= Cantidad vendida del producto en el mismo mes del
-- periodo pero del año anterior
-- CANT_FACTURAS = Cantidad de facturas en las que se vendió el producto en el periodo
-- La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada por periodo y código de producto.

SELECT ltrim(str(YEAR(f.fact_fecha)) ++ str(MONTH(f.fact_fecha))) AS periodo,
	ISNULL(p.prod_codigo, 0) AS prod, ISNULL(p.prod_detalle, 0) AS detalle,
	ISNULL(SUM(i.item_cantidad), 0) AS cantidad_vendida,
	(SELECT ISNULL(SUM(i2.item_cantidad), 0)
	FROM Item_Factura i2 JOIN Factura f2 ON (f2.fact_numero = i2.item_numero AND f2.fact_sucursal = i2.item_sucursal AND f2.fact_tipo = i2.item_tipo)
	WHERE MONTH(f2.fact_fecha) = MONTH(f.fact_fecha) AND YEAR(f2.fact_fecha) = (YEAR(f.fact_fecha) - 1)) AS ventas_año_ant,
	COUNT(*) AS cant_facturas
FROM Producto p LEFT JOIN Item_Factura i ON i.item_producto = p.prod_codigo 
				JOIN Factura f ON (f.fact_numero = i.item_numero AND f.fact_sucursal = i.item_sucursal AND f.fact_tipo = i.item_tipo)
GROUP BY f.fact_fecha, p.prod_codigo, p.prod_detalle
ORDER BY periodo, prod
