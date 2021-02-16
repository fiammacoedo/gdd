-- Ejercicio 9 TSQL
-- Hacer un trigger que ante alguna modificación de un ítem de factura de un artículo
-- con composición realice el movimiento de sus correspondientes componentes.

CREATE TRIGGER ejercicio9 ON Item_Factura AFTER INSERT 
AS
BEGIN
	DECLARE @tipo char(1), @sucursal char(4), @numero char(8), @componente char(8), @cantidad decimal(12, 2), @precio decimal(12, 2)

	DECLARE C1 CURSOR FOR (SELECT item_tipo, item_sucursal, item_numero, comp_componente, comp_cantidad * item_cantidad, prod_precio * comp_cantidad
							FROM INSERTED JOIN Composicion ON item_producto = comp_producto JOIN Producto ON comp_componente = prod_codigo
							WHERE item_producto IN (SELECT comp_producto FROM Composicion))
	OPEN C1
	FETCH NEXT FROM C1 INTO @tipo, @sucursal, @numero, @componente, @cantidad, @precio
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO Item_Factura VALUES (@tipo, @sucursal, @numero, @componente, @cantidad, @precio)
		FETCH NEXT FROM C1 INTO @tipo, @sucursal, @numero, @componente, @cantidad, @precio
	END

	CLOSE C1
	DEALLOCATE C1

END
GO