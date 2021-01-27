-- Ejercicio 31 [SQL]
-- Escriba una consulta sql que retorne una estad�stica por A�o y Vendedor que retorne las siguientes columnas:
-- A�o.
-- Codigo de Vendedor
-- Detalle del Vendedor
-- Cantidad de facturas que realiz� en ese a�o
-- Cantidad de clientes a los cuales les vendi� en ese a�o.
-- Cantidad de productos facturados con composici�n en ese a�o
-- Cantidad de productos facturados sin composicion en ese a�o.
-- Monto total vendido por ese vendedor en ese a�o
-- Los datos deberan ser ordenados por a�o y dentro del a�o por el vendedor que haya vendido mas productos diferentes de mayor a menor.

SELECT YEAR(f.fact_fecha) AS anio, e.empl_codigo AS codigo_vendedor, (e.empl_nombre + e.empl_apellido) AS detalle_vendedor,
		COUNT(DISTINCT f.fact_numero + f.fact_sucursal + f.fact_tipo) AS cant_fact_anio, 
		COUNT(DISTINCT f.fact_cliente) AS cant_clientes_anio,
		(SELECT COUNT(DISTINCT i2.item_producto)
		FROM Factura f2 JOIN Item_Factura i2 ON (f2.fact_numero = i2.item_numero AND f2.fact_sucursal = i2.item_sucursal AND f2.fact_tipo = i2.item_tipo)
		WHERE YEAR(f.fact_fecha) = YEAR(f2.fact_fecha) AND i2.item_producto IN (SELECT comp_producto FROM Composicion)) AS cant_prod_con_comp_anio,
		(SELECT COUNT(DISTINCT i2.item_producto)
		FROM Factura f2 JOIN Item_Factura i2 ON (f2.fact_numero = i2.item_numero AND f2.fact_sucursal = i2.item_sucursal AND f2.fact_tipo = i2.item_tipo)
		WHERE YEAR(f.fact_fecha) = YEAR(f2.fact_fecha) AND i2.item_producto NOT IN (SELECT comp_producto FROM Composicion)) AS cant_prod_con_comp_anio,
		SUM(f.fact_total) AS monto_total_vendedor_anio
FROM Factura f JOIN Empleado e ON f.fact_vendedor = e.empl_codigo 
GROUP BY YEAR(f.fact_fecha), e.empl_codigo, (e.empl_nombre + e.empl_apellido)
ORDER BY YEAR(f.fact_fecha), (SELECT COUNT(DISTINCT(i3.item_producto))
							FROM Item_Factura i3 JOIN Factura f3 ON i3.item_tipo = f3.fact_tipo AND i3.item_sucursal = f3.fact_sucursal AND i3.item_numero = f3.fact_numero
							WHERE year(f3.fact_fecha) = year(f.fact_fecha) AND f3.fact_vendedor = e.empl_codigo) DESC