-- Ejercicio 3 T-SQL
-- Cree el/los objetos de base de datos necesarios para corregir la tabla empleado en
-- caso que sea necesario. Se sabe que debería existir un único gerente general (debería
-- ser el único empleado sin jefe). Si detecta que hay más de un empleado sin jefe
-- deberá elegir entre ellos el gerente general, el cual será seleccionado por mayor
-- salario. Si hay más de uno se seleccionara el de mayor antigüedad en la empresa.
-- Al finalizar la ejecución del objeto la tabla deberá cumplir con la regla de un único
-- empleado sin jefe (el gerente general) y deberá retornar la cantidad de empleados
-- que había sin jefe antes de la ejecución.

-- Un procedure por si actualmente la regla no se cumple + un trigger para mantener la regla de ahora en mas

CREATE PROCEDURE ejercicio3 (@empleados_sin_jefe int out)
AS
BEGIN
	set @empleados_sin_jefe = 0
	declare @gerente_general numeric(6)

	set @gerente_general = (SELECT TOP 1 e.empl_codigo
							FROM Empleado e
							WHERE e.empl_jefe = NULL
							ORDER BY e.empl_salario DESC, e.empl_ingreso ASC)
	set @empleados_sin_jefe = (SELECT COUNT(*)
								FROM Empleado e
								WHERE e.empl_jefe = NULL)

	UPDATE Empleado SET empl_jefe = @gerente_general WHERE empl_codigo <> @gerente_general AND empl_jefe = NULL
END
GO

CREATE TRIGGER unico_jefe ON Empleado INSTEAD OF INSERT
AS
BEGIN
	exec ejercicio3 @empleados_sin_jefe = 0
END
GO