-- Ejercicio 9 TSQL
-- Hacer un trigger que ante alguna modificación de un ítem de factura de un artículo
-- con composición realice el movimiento de sus correspondientes componentes.

CREATE TRIGGER ejercicio_9 ON Item_Factura AFTER INSERT
AS
BEGIN
	DECLARE @componente char(8), @cantidad_vendida_producto decimal(12, 2), @cantidad_componente decimal(12, 2)
	DECLARE C1 CURSOR FOR (SELECT comp_componente, item_cantidad, comp_cantidad
							FROM INSERTED JOIN Composicion ON item_producto = comp_producto)

	OPEN C1
	FETCH NEXT FROM C1 INTO @componente, @cantidad_vendida_producto, @cantidad_componente
	WHILE @@FETCH_STATUS = 0
	BEGIN
		UPDATE Stock SET stoc_cantidad = stoc_cantidad - @cantidad_componente * @cantidad_vendida_producto
		WHERE stoc_producto = @componente

		FETCH NEXT FROM C1 INTO @componente, @cantidad_vendida_producto, @cantidad_componente
	END

	CLOSE C1
	DEALLOCATE C1

END
GO