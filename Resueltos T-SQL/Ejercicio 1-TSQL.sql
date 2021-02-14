-- Ejercicio 1 T-SQL
-- Hacer una funci�n que dado un art�culo y un deposito devuelva un string que
-- indique el estado del dep�sito seg�n el art�culo. Si la cantidad almacenada es menor
-- al l�mite retornar �OCUPACION DEL DEPOSITO XX %� siendo XX el % de
-- ocupaci�n. Si la cantidad almacenada es mayor o igual al l�mite retornar
-- �DEPOSITO COMPLETO�.

CREATE FUNCTION ejercicio1 (@articulo char(8), @deposito char(2))
RETURNS char(30)
AS
BEGIN
	declare @cantidad_almacenada decimal(12, 2)
	declare @limite decimal(12, 2)
	declare @return char(30)

	set @cantidad_almacenada = (SELECT s.stoc_cantidad
					FROM DEPOSITO d JOIN STOCK s ON d.depo_codigo = s.stoc_deposito 
					WHERE s.stoc_deposito = @deposito AND s.stoc_producto = @articulo)
	set @limite = (SELECT s.stoc_stock_maximo
					FROM STOCK s
					WHERE s.stoc_deposito = @deposito AND s.stoc_producto = @articulo)

	if(@cantidad_almacenada < @limite)
		set @return = 'Ocupacion del deposito ' ++ str(@deposito) ++ ' %' ++ str(@cantidad_almacenada / @limite * 100)
	else
		set @return = 'Deposito completo'

	return @return
END
GO