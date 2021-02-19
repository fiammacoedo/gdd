-- Ejercicio 14 TSQL
-- Cree el/los objetos de base de datos necesarios para implantar la siguiente regla
-- “Ningún jefe puede tener un salario mayor al 20% de las suma de los salarios de sus
-- empleados totales (directos + indirectos)”. Se sabe que en la actualidad dicha regla
-- se cumple y que la base de datos es accedida por n aplicaciones de diferentes tipos y
-- tecnologías

CREATE TRIGGER ejercicio14_insert ON Empleado AFTER UPDATE
AS
BEGIN
	IF EXISTS(SELECT empl_codigo FROM INSERTED WHERE empl_salario > (0.2 * calcular_salarios_subordinados(empl_codigo)))
	BEGIN
		-- Print mensaje
		ROLLBACK
	END

END
GO

-- Funcion que calcula la suma de los salarios de sus empleados (directos e indirectos)
CREATE FUNCTION calcular_salarios_subordinados(@jefe numeric(6))
RETURNS decimal(12, 2)
AS
BEGIN
	DECLARE @total numeric
	SET @total = 0

	IF(NOT EXISTS (SELECT * FROM Empleado WHERE empl_jefe = @jefe))
	BEGIN
		RETURN @total
	END

	ELSE
	BEGIN
		--Empleados directos
		set @total = (SELECT SUM(empl_salario) FROM Empleado WHERE empl_jefe = @jefe)

		--Empleados indirectos
		DECLARE C1 CURSOR FOR (SELECT empl_codigo FROM Empleado WHERE empl_jefe = @jefe)
		DECLARE @subordinado numeric (6)
		OPEN C2
		FETCH NEXT FROM C1 INTO @subordinado
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @total = @total + (SELECT SUM(empl_salario) FROM Empleado WHERE empl_jefe = @subordinado)
			FETCH NEXT FROM C1 INTO @subordinado
		END

		CLOSE C1
		DEALLOCATE C1
	END

	RETURN @total
END
GO