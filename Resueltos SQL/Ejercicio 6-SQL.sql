-- Ejercicio 6 [SQL]
-- Mostrar para todos los rubros de art�culos c�digo, detalle, cantidad de art�culos de
-- ese rubro y stock total de ese rubro de art�culos. Solo tener en cuenta aquellos
-- art�culos que tengan un stock mayor al del art�culo �00000000� en el dep�sito �00�.

SELECT r.rubr_id, r.rubr_detalle, COUNT(DISTINCT p.prod_codigo) AS cantidad_articulos, ISNULL(SUM(s.stoc_cantidad), 0) AS stock_total_rubro
FROM Rubro r LEFT JOIN Producto p ON r.rubr_id = p.prod_rubro JOIN Stock s ON s.stoc_producto = p.prod_codigo
WHERE (SELECT SUM(s2.stoc_cantidad)
		FROM Stock s2
		WHERE s2.stoc_producto = s.stoc_producto) > (SELECT s3.stoc_cantidad
													FROM Stock s3
													WHERE s3.stoc_producto = '00000000' AND s3.stoc_deposito = '00')
GROUP BY r.rubr_id, r.rubr_detalle

-- Ojo: no se puede usar HAVING para agrupar las funciones de grupo, porque se esta agrupando por RUBRO y no por ARTICULO, el resultado seria incorrecto.
-- (El stock total del SELECT es del RUBRO, y el stock total del WHERE es del ARTICULO)

