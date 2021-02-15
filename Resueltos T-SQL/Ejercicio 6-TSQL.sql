-- Ejercicio 6 T-SQL
-- Realizar un procedimiento que si en alguna factura se facturaron componentes que
-- conforman un combo determinado (o sea que juntos componen otro producto de
-- mayor nivel), en cuyo caso deberá reemplazar las filas correspondientes a dichos
-- productos por una sola fila con el producto que componen con la cantidad de dicho
-- producto que corresponda.

CREATE PROCEDURE ejercicio6
AS
BEGIN
	DECLARE @tipo char(1), @sucursal char(4), @numero char(8), @producto char(8), @cantidad_vendida decimal(12, 2), 
	@precio_producto decimal(12, 2), @cantidad_componente decimal(12, 2), @componente char(8)
	
	DECLARE C1 CURSOR FOR (SELECT item_tipo, item_sucursal, item_numero, item_producto, item_cantidad, comp_cantidad, comp_producto, prod_precio 
						FROM Item_Factura JOIN Composicion ON item_producto = comp_componente JOIN Producto ON comp_producto = prod_codigo
						WHERE item_cantidad % comp_cantidad = 0)

	OPEN C1
	FETCH NEXT FROM C1 INTO @tipo, @sucursal, @numero, @producto, @cantidad_vendida, @cantidad_componente, @componente, @precio_producto
	WHILE @@FETCH_STATUS = 0
	BEGIN

		DECLARE @componente2 char(8)
		DECLARE @cantidad decimal(12, 2)

		SET @cantidad = @cantidad_vendida / @cantidad_componente
		SET @componente2 = (SELECT comp_componente
							FROM Composicion JOIN Item_Factura ON comp_componente = item_producto
							WHERE item_tipo = @tipo AND item_sucursal = @sucursal AND item_numero = @numero AND
								comp_producto = @producto AND item_producto != @componente AND (item_cantidad / comp_cantidad) = @cantidad)

		IF @componente IS NOT NULL AND @componente2 IS NOT NULL
		BEGIN
			DELETE FROM Item_Factura WHERE item_tipo = @tipo AND item_sucursal = @sucursal AND item_numero = @numero AND item_producto = @componente 

			DELETE FROM Item_Factura WHERE item_tipo = @tipo AND item_sucursal = @sucursal AND item_numero = @numero AND item_producto = @componente2
			
			INSERT INTO Item_Factura VALUES (@tipo, @sucursal, @numero, @producto, @cantidad, @precio_producto)
		END

	END
	FETCH NEXT FROM C1 INTO @tipo, @sucursal, @numero, @producto, @cantidad_vendida, @cantidad_componente, @componente, @precio_producto
	CLOSE C1
	DEALLOCATE C1

END
GO