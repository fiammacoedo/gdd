-- Ejercicio 7 TSQL
-- Hacer un procedimiento que dadas dos fechas complete la tabla Ventas. Debe
-- insertar una línea por cada artículo con los movimientos de stock realizados entre
-- esas fechas. La tabla se encuentra creada y vacía.

-- Tabla Ventas - Columnas:
-- Codigo: codigo del articulo
-- Detalle: detalle del articulo
-- Cant. Mov.: cantidad de movimientos de ventas (item factura)
-- Precio de venta: precio promedio de venta
-- Renglon: nro de linea de la tabla
-- Ganancia: precio venta - cantidad * costo actual

CREATE PROCEDURE ejercicio7 (@fecha_inicio smalldatetime, @fecha_fin smalldatetime)
AS
BEGIN
	DECLARE @codigo char(8), @detalle char(50), @cant_mov numeric, @precio_venta decimal(12, 2), @renglon numeric, @ganancia decimal(12, 2)

	DECLARE C1 CURSOR FOR (SELECT item_producto, prod_detalle, COUNT(*), AVG(item_precio), item_precio - item_cantidad * prod_precio
						FROM Item_Factura JOIN Factura ON item_numero = fact_numero AND item_sucursal = fact_sucursal AND item_tipo = fact_tipo 
							JOIN Producto ON item_producto = prod_codigo
						WHERE fact_fecha BETWEEN @fecha_inicio AND @fecha_fin
						GROUP BY item_producto, prod_detalle)

	OPEN C1
	FETCH NEXT FROM C1 INTO @codigo, @detalle, @cant_mov, @precio_venta, @ganancia
	
	IF((SELECT * FROM Ventas) IS NOT NULL)
		SET @renglon = (SELECT MAX(renglon) FROM Ventas) + 1
	ELSE
		SET @renglon = 0

	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO Ventas VALUES (@codigo, @detalle, @cant_mov, @precio_venta, @renglon, @ganancia)

		SET @renglon = @renglon + 1

		FETCH NEXT FROM C1 INTO @codigo, @detalle, @cant_mov, @precio_venta, @ganancia
	END

	CLOSE C1
	DEALLOCATE C1

END
GO