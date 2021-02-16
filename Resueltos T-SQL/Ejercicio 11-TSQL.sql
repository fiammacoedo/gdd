-- Ejercicio 11 TSQL
-- Cree el/los objetos de base de datos necesarios para que dado un código de
-- empleado se retorne la cantidad de empleados que este tiene a su cargo (directa o
-- indirectamente). Solo contar aquellos empleados (directos o indirectos) que
-- tengan un código mayor que su jefe directo.

CREATE FUNCTION ejercicio11 (@empleado numeric(6))
RETURNS numeric
AS
BEGIN
	DECLARE @cantidad_subordinados numeric(6), @subordinado numeric(6)
	SET @cantidad_subordinados = 0

	-- Cuento empleados directos
	SET @cantidad_subordinados = @cantidad_subordinados + (SELECT COUNT(*)
															FROM Empleado
															WHERE empl_jefe = @empleado AND empl_codigo > empl_jefe)

	-- Cuento empleados indirectos
	DECLARE C1 CURSOR FOR (SELECT empl_codigo
							FROM Empleado
							WHERE empl_jefe = @empleado AND empl_codigo > empl_jefe)
	OPEN C1
	FETCH NEXT FROM C1 INTO @subordinado
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @cantidad_subordinados = @cantidad_subordinados + ejercicio11(@subordinado)
		FETCH NEXT FROM C1 INTO @subordinado
	END

	CLOSE C1
	DEALLOCATE C1

	RETURN @cantidad_subordinados
END
GO