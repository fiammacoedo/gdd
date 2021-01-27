-- Ejercicio 30 [SQL]
-- Se desea obtener una estadistica de ventas del año 2012, para los empleados que sean jefes, o sea, que tengan empleados a su cargo, 
-- para ello se requiere que realice la consulta que retorne las siguientes columnas:
-- Nombre del Jefe
-- Cantidad de empleados a cargo
-- Monto total vendido de los empleados a cargo
-- Cantidad de facturas realizadas por los empleados a cargo
-- Nombre del empleado con mejor ventas de ese jefe
-- Debido a la perfomance requerida, solo se permite el uso de una subconsulta si fuese necesario.
-- Los datos deberan ser ordenados por de mayor a menor por el Total vendido y solo se
-- deben mostrarse los jefes cuyos subordinados hayan realizado más de 10 facturas.

SELECT (j.empl_nombre + j.empl_apellido) AS nombre_jefe, COUNT(DISTINCT e.empl_codigo) AS cant_empl_a_cargo,
	SUM(f.fact_total) AS monto_total_empl_a_cargo,
	COUNT(*) AS cant_fact_empl_a_cargo,
	(SELECT TOP 1 (me.empl_nombre + me.empl_apellido)
	FROM Empleado me JOIN Factura f ON me.empl_codigo = f.fact_vendedor
	WHERE me.empl_jefe = j.empl_codigo
	GROUP BY (me.empl_nombre + me.empl_apellido)
	ORDER BY SUM(f.fact_total) DESC) AS empl_mejor_ventas_jefe
FROM Factura f JOIN Empleado e ON f.fact_vendedor = e.empl_codigo JOIN Empleado j ON e.empl_jefe = j.empl_codigo
WHERE YEAR(f.fact_fecha) = 2012
GROUP BY (j.empl_nombre + j.empl_apellido), j.empl_codigo
HAVING COUNT(*) > 10
ORDER BY SUM(f.fact_total) DESC