-- Ejercicio 28 [SQL]
-- Escriba una consulta sql que retorne una estadística por Año y Vendedor con las siguientes columnas:
-- Año.
-- Codigo de Vendedor
-- Detalle del Vendedor
-- Cantidad de facturas que realizó en ese año
-- Cantidad de clientes a los cuales les vendió en ese año.
-- Cantidad de productos facturados con composición en ese año
-- Cantidad de productos facturados sin composicion en ese año.
-- Monto total vendido por ese vendedor en ese año
-- Los datos deberan ser ordenados por año y dentro del año por el vendedor que haya vendido mas productos diferentes de mayor a menor.

SELECT YEAR(f.fact_fecha) AS anio, 
	e.empl_codigo as codigo_vendedor, 
	(e.empl_nombre + e.empl_apellido) AS detalle_vendedor,
	COUNT(*) AS cantidad_facturas_anio,
	COUNT(DISTINCT f.fact_cliente) AS cantidad_clientes_anio,
	(SELECT COUNT(*)
	FROM Item_Factura i1 JOIN Factura f1 ON (f1.fact_numero = i1.item_numero AND f1.fact_sucursal = i1.item_sucursal AND f1.fact_tipo = i1.item_tipo)
	WHERE YEAR(f1.fact_fecha) = YEAR(f.fact_fecha) AND f1.fact_vendedor = f.fact_vendedor
		AND i1.item_producto IN (SELECT comp_producto FROM Composicion)) AS cant_prod_comp_anio,
	(SELECT COUNT(*)
	FROM Item_Factura i1 JOIN Factura f1 ON (f1.fact_numero = i1.item_numero AND f1.fact_sucursal = i1.item_sucursal AND f1.fact_tipo = i1.item_tipo)
	WHERE YEAR(f1.fact_fecha) = YEAR(f.fact_fecha) AND f1.fact_vendedor = f.fact_vendedor
		AND i1.item_producto NOT IN (SELECT comp_producto FROM Composicion)) AS cant_prod_sin_comp_anio,
	SUM(f.fact_total) AS monto_total_anio
FROM Factura f JOIN Empleado e ON f.fact_vendedor = e.empl_codigo 
	JOIN Item_Factura i ON (f.fact_numero = i.item_numero AND f.fact_sucursal = i.item_sucursal AND f.fact_tipo = i.item_tipo)
GROUP BY YEAR(f.fact_fecha), e.empl_codigo, (e.empl_nombre + e.empl_apellido), f.fact_vendedor
ORDER BY YEAR(f.fact_fecha), COUNT(DISTINCT i.item_producto) DESC