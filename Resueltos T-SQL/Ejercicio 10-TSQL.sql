-- Ejercicio 10 TSQL
-- Hacer un trigger que ante el intento de borrar un artículo verifique que no exista
-- stock y si es así lo borre en caso contrario que emita un mensaje de error.

CREATE TRIGGER ejercicio10 ON Producto INSTEAD OF DELETE 
AS
BEGIN
	-- Si ALGUNO de los productos a eliminar tiene stock, rollbackeo todo
	IF EXISTS (SELECT * FROM DELETED JOIN Stock ON prod_codigo = stoc_producto HAVING SUM(stoc_cantidad) > 0)
	BEGIN
		RAISERROR(0, 0, 0, 'No se puede borrar el articulo porque existe stock del mismo') -- Ver argumentos
		ROLLBACK
	END

	ELSE
	BEGIN
		DELETE FROM Composicion WHERE comp_producto IN (SELECT prod_codigo FROM DELETED)

		DELETE FROM Producto WHERE prod_codigo IN (SELECT prod_codigo FROM DELETED)
	END

END
GO