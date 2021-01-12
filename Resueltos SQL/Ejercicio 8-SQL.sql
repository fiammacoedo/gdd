-- Ejercicio 8 [SQL]
-- Mostrar para el o los art�culos que tengan stock en todos los dep�sitos, nombre del
-- art�culo, stock del dep�sito que m�s stock tiene.

SELECT	p.prod_detalle, MAX(s.stoc_cantidad) AS stock_maximo
FROM Producto p JOIN Stock s ON p.prod_codigo = s.stoc_producto
WHERE s.stoc_cantidad > 0
GROUP BY p.prod_detalle
HAVING COUNT(s.stoc_deposito) = (SELECT COUNT(*) FROM Deposito)