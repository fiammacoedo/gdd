-- Ejercicio 2 T-SQL
-- Realizar una función que dado un artículo y una fecha, retorne el stock que existía a
-- esa fecha

CREATE FUNCTION ejercicio2 (@articulo char(8), @fecha smalldatetime)
RETURNS char(30)
AS
BEGIN
	declare @stock_retorno decimal(12, 2)
	declare @stock_actual_articulo decimal(12, 2)
	declare @stock_vendido_articulo decimal(12, 2)

	set @stock_actual_articulo = (SELECT SUM(s.stoc_cantidad)
								FROM STOCK s
								WHERE s.stoc_producto = @articulo)
	set @stock_vendido_articulo = (SELECT SUM(i.item_cantidad)
								FROM Factura f JOIN Item_Factura i ON (f.fact_numero = i.item_numero 
									AND f.fact_sucursal = i.item_sucursal AND f.fact_tipo = i.item_tipo)
								WHERE f.fact_fecha > @fecha AND i.item_producto = @articulo)
	set @stock_retorno = @stock_actual_articulo + @stock_vendido_articulo

	return @stock_retorno
END
GO