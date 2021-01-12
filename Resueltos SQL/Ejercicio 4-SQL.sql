-- Ejercicio 4 [SQL]
-- Realizar una consulta que muestre para todos los artículos código, detalle y cantidad
-- de artículos que lo componen. Mostrar solo aquellos artículos para los cuales el
-- stock promedio por depósito sea mayor a 100.

SELECT p.prod_codigo, p.prod_detalle, COUNT(c.comp_producto) AS cantidad_componentes
FROM Producto p LEFT JOIN Composicion c ON p.prod_codigo = c.comp_producto JOIN Stock s ON p.prod_codigo = s.stoc_producto
GROUP BY p.prod_codigo, p.prod_detalle
HAVING AVG(s.stoc_cantidad) > 100
