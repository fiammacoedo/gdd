-- Ejercicio 27 [SQL]
-- Escriba una consulta sql que retorne una estadística basada en la facturacion por año y envase devolviendo las siguientes columnas:
-- Año
-- Codigo de envase
-- Detalle del envase
-- Cantidad de productos que tienen ese envase
-- Cantidad de productos facturados de ese envase
-- Producto mas vendido de ese envase
-- Monto total de venta de ese envase en ese año
-- Porcentaje de la venta de ese envase respecto al total vendido de ese año
-- Los datos deberan ser ordenados por año y dentro del año por el envase con más facturación de mayor a menor

SELECT YEAR(f.fact_fecha) AS anio, e.enva_codigo AS codigo_envase, e.enva_detalle AS detalle_envase,
		(SELECT COUNT(*)
		FROM Producto p1
		WHERE p1.prod_envase = e.enva_codigo) AS prods_con_envase,
		COUNT(DISTINCT (f.fact_numero + f.fact_tipo + f.fact_sucursal)) AS prods_con_envase_facturados,
		(SELECT TOP 1 p1.prod_codigo
		FROM Producto p1 JOIN Item_Factura i1 ON i1.item_producto = p1.prod_codigo
		WHERE p1.prod_envase = e.enva_codigo
		GROUP BY p1.prod_codigo
		ORDER BY SUM(i1.item_cantidad) DESC) AS prod_mas_vendido_con_envase,
		SUM(f.fact_total) AS monto_total_envase_anio,
		SUM(f.fact_total) / (SELECT SUM(f3.fact_total)
							FROM Factura f3
							WHERE YEAR(f3.fact_fecha) = YEAR(f.fact_fecha)) * 100 AS porcentaje_venta_envase_anio
FROM Factura f JOIN Item_Factura i ON (f.fact_numero = i.item_numero AND f.fact_sucursal = i.item_sucursal AND f.fact_tipo = i.item_tipo)
	JOIN Producto p ON p.prod_codigo = i.item_producto JOIN Envases e ON e.enva_codigo = p.prod_envase
GROUP BY YEAR(f.fact_fecha), e.enva_codigo, e.enva_detalle
ORDER BY YEAR(f.fact_fecha), SUM(f.fact_total)
