-- Ejercicio 12 TSQL
-- Cree el/los objetos de base de datos necesarios para implantar la siguiente regla
-- “Ningún jefe puede tener a su cargo más de 50 empleados en total (directos +
-- indirectos)”. Se sabe que en la actualidad dicha regla se cumple y que la base de
-- datos es accedida por n aplicaciones de diferentes tipos y tecnologías.

-- Si le cambian el jefe a un empleado, tengo que verificar que ese jefe no tenga ya 50 empleados
CREATE TRIGGER ejercicio12_update ON Empleado AFTER UPDATE
AS
BEGIN
	IF EXISTS(SELECT * FROM INSERTED WHERE cantidad_subordinados(empl_jefe) = 50)
	BEGIN
		ROLLBACK
	END

	ELSE
	BEGIN
		DELETE FROM Empleado WHERE empl_codigo IN (SELECT empl_codigo FROM DELETED)

		--INSERT INTO Empleado (empl_codigo, empl_nombre, empl_apellido, empl_nacimiento, empl_ingreso, empl_tareas, empl_salario, empl_comision, empl_jefe, empl_departamento) 
		--VALUES (SELECT empl_codigo, empl_nombre, empl_apellido, empl_nacimiento, empl_ingreso, empl_tareas, empl_salario, empl_comision, empl_jefe, empl_departamento FROM INSERTED)
	END

END
GO

-- Si insertan un nuevo empleado, tengo que verificar la cantidad de empleados de su jefe
CREATE TRIGGER ejercicio12_insert ON Empleado AFTER INSERT
AS
BEGIN
	IF EXISTS(SELECT * FROM INSERTED WHERE cantidad_subordinados(empl_jefe) = 50)
	BEGIN
		ROLLBACK
	END

	ELSE
	BEGIN
		--INSERT INTO Empleado (empl_codigo, empl_nombre, empl_apellido, empl_nacimiento, empl_ingreso, empl_tareas, empl_salario, empl_comision, empl_jefe, empl_departamento) 
		--VALUES (SELECT empl_codigo, empl_nombre, empl_apellido, empl_nacimiento, empl_ingreso, empl_tareas, empl_salario, empl_comision, empl_jefe, empl_departamento FROM INSERTED)		
	END

END
GO


-- Funcion que cuenta la cantidad de empleados directos e indirectos
CREATE FUNCTION cantidad_subordinados(@jefe char(6))
RETURNS numeric(6)
AS
BEGIN
	DECLARE @cantidad_subordinados numeric(6), @subordinado numeric(6)
	SET @cantidad_subordinados = 0

	-- Cuento empleados directos
	SET @cantidad_subordinados = @cantidad_subordinados + (SELECT COUNT(*)
															FROM Empleado
															WHERE empl_jefe = @jefe)

	-- Cuento empleados indirectos
	DECLARE C1 CURSOR FOR (SELECT empl_codigo
							FROM Empleado
							WHERE empl_jefe = @jefe)
	OPEN C1
	FETCH NEXT FROM C1 INTO @subordinado
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @cantidad_subordinados = @cantidad_subordinados + cantidad_subordinados(@subordinado)
		FETCH NEXT FROM C1 INTO @subordinado
	END

	RETURN @cantidad_subordinados
END
GO