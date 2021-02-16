-- Ejercicio 8 TSQL
-- Realizar un procedimiento que complete la tabla Diferencias de precios, para los
-- productos facturados que tengan composición y en los cuales el precio de
-- facturación sea diferente al precio del cálculo de los precios unitarios por cantidad
-- de sus componentes, se aclara que un producto que compone a otro, también puede
-- estar compuesto por otros y así sucesivamente, la tabla se debe crear y está formada
-- por las siguientes columnas:
-- Codigo: codigo del articulo
-- Detalle: detalle del articulo
-- Cantidad: cantidad de productos que conforman el combo
-- Precio_generado: precio que se compone a traves de sus componentes
-- Precio_facturado: precio del producto

-- PROCEDURE
CREATE PROCEDURE sp_ej8
AS
BEGIN
	INSERT INTO DIFERENCIAS (dife_codigo, dife_detalle, dife_cantidad, dife_precio_generado, dife_precio_facturado)
	VALUES (SELECT prod_codigo, prod_detalle, COUNT(DISTINCT(comp_componente)), funcion_ej8(prod_codigo), item_precio
			FROM Item_Factura JOIN Composicion ON item_producto = comp_producto JOIN Producto ON prod_codigo = comp_producto
			WHERE prod_precio != funcion_ej8(prod_codigo)
			GROUP BY prod_codigo, prod_detalle, item_precio)

END
GO

-- FUNCION: calcula el precio del calculo de los precios unitarios por cantidad de componentes
CREATE FUNCTION funcion_ej8 (@producto char(8))
RETURNS decimal(12, 2)
AS
BEGIN
	DECLARE @costo decimal(12, 2), @componente char(8), @cantidad decimal(12, 2)

	IF NOT EXISTS (SELECT * FROM Composicion WHERE comp_producto = @producto) -- Si el producto no es compuesto
	BEGIN
		SET @costo = (SELECT prod_precio FROM Producto WHERE prod_codigo = @producto)
	END

	-- Si el producto es compuesto, recorro sus componentes y por cada componente calculo el precio (es recursivo, porque podrian
	-- ser otros productos compuestos)
	SET @costo = 0
	DECLARE C1 CURSOR FOR (SELECT comp_componente, comp_cantidad FROM Composicion WHERE comp_producto = @producto)
	OPEN C1
	FETCH NEXT FROM C1 INTO @componente, @cantidad
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @costo = @costo + funcion_ej8(@componente) * @cantidad
		FETCH NEXT FROM C1 INTO @componente, @cantidad
	END

	CLOSE C1
	DEALLOCATE C1

	RETURN @costo
END
GO