-- Ejercicio 9 [SQL]
-- Mostrar el c�digo del jefe, c�digo del empleado que lo tiene como jefe, nombre del
-- mismo y la cantidad de dep�sitos que ambos tienen asignados.

SELECT empl_jefe, empl_codigo, empl_nombre, COUNT(*)
FROM Empleado JOIN Deposito ON (empl_codigo = depo_encargado OR empl_jefe = depo_encargado)
GROUP BY empl_jefe, empl_codigo, empl_nombre