-- Ejercicio 26 [SQL]
-- Escriba una consulta sql que retorne un ranking de empleados devolviendo las siguientes columnas:
-- Empleado
-- Depósitos que tiene a cargo
-- Monto total facturado en el año corriente
-- Codigo de Cliente al que mas le vendió
-- Producto más vendido
-- Porcentaje de la venta de ese empleado sobre el total vendido ese año.
--Los datos deberan ser ordenados por venta del empleado de mayor a menor.

SELECT d.depo_encargado AS empleado, 
		COUNT(DISTINCT d.depo_codigo) AS depositos_a_cargo,
		SUM(f.fact_total) AS monto_total_facturado_anio,
		(SELECT TOP 1 f1.fact_cliente
		FROM Factura f1
		WHERE f1.fact_vendedor = f.fact_vendedor
		GROUP BY f1.fact_cliente
		ORDER BY SUM(f1.fact_total) DESC) AS cliente_max,
		(SELECT TOP 1 i.item_producto
		FROM Item_Factura i JOIN Factura f1 ON (f1.fact_numero = i.item_numero AND f1.fact_sucursal = i.item_sucursal AND f1.fact_tipo = i.item_tipo)
		WHERE f.fact_vendedor = f1.fact_vendedor
		GROUP BY i.item_producto
		ORDER BY SUM(i.item_cantidad) DESC) AS prod_mas_vendido,
		SUM(f.fact_total) / (SELECT SUM(f3.fact_total)
							FROM Factura f3
							WHERE YEAR(f3.fact_fecha) = 2012) * 100 AS porcentaje_ventas_empleado
FROM Deposito d JOIN Factura f ON d.depo_encargado = f.fact_vendedor
WHERE YEAR(f.fact_fecha) = 2012 -- No uso el corriente año porque no tiene datos
GROUP BY d.depo_encargado, f.fact_vendedor
ORDER BY SUM(f.fact_total) DESC