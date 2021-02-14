-- Ejercicio 4 T-SQL
-- Cree el/los objetos de base de datos necesarios para actualizar la columna de
-- empleado empl_comision con la sumatoria del total de lo vendido por ese empleado
-- a lo largo del último año. Se deberá retornar el código del vendedor que más vendió
-- (en monto) a lo largo del último año.

CREATE PROCEDURE ejercicio4 (@maximo_vendedor numeric(6))
AS
BEGIN
	set @maximo_vendedor = (SELECT TOP 1 f.fact_vendedor
							FROM Factura f
							WHERE DATEDIFF(year, f.fact_fecha, GETDATE()) <= 365
							GROUP BY f.fact_vendedor
							ORDER BY SUM(f.fact_total) DESC)

	UPDATE Empleado SET empl_comision = (SELECT SUM(f.fact_total)
										FROM Factura f
										WHERE empl_codigo = f.fact_vendedor AND DATEDIFF(year, f.fact_fecha, GETDATE()) <= 365)
END
GO