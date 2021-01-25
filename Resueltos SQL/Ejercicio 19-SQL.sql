-- Ejercicio 19 [SQL]
-- En virtud de una recategorizacion de productos referida a la familia de los mismos se
-- solicita que desarrolle una consulta sql que retorne para todos los productos:
--- Codigo de producto
--- Detalle del producto
--- Codigo de la familia del producto
--- Detalle de la familia actual del producto
--- Codigo de la familia sugerido para el producto
--- Detalla de la familia sugerido para el producto
-- La familia sugerida para un producto es la que poseen la mayoria de los productos cuyo detalle coinciden 
-- en los primeros 5 caracteres. En caso que 2 o mas familias pudieran ser sugeridas se debera 
-- seleccionar la de menor codigo. Solo se deben mostrar los productos para los cuales la familia actual 
-- sea diferente a la sugerida. Los resultados deben ser ordenados por detalle de producto de manera ascendente

SELECT p.prod_codigo, p.prod_detalle, f.fami_id AS id_fami_actual, f.fami_detalle AS detalle_fami_actual,
		(SELECT TOP 1 f2.fami_id
		FROM Familia f2 JOIN Producto p2 ON f2.fami_id = p2.prod_familia
		WHERE SUBSTRING(p2.prod_detalle, 0, 5) = SUBSTRING(p.prod_detalle, 0, 5)
		ORDER BY f2.fami_id ASC) AS id_fami_sugerida, 
		(SELECT TOP 1 f2.fami_detalle
		FROM Familia f2 JOIN Producto p2 ON f2.fami_id = p2.prod_familia
		WHERE SUBSTRING(p2.prod_detalle, 0, 5) = SUBSTRING(p.prod_detalle, 0, 5)
		ORDER BY f2.fami_id ASC) AS detalle_fami_sugerida
FROM Producto p LEFT JOIN Familia f ON p.prod_familia = f.fami_id
WHERE f.fami_id <> (SELECT TOP 1 f2.fami_id
					FROM Familia f2 JOIN Producto p2 ON f2.fami_id = p2.prod_familia
					WHERE SUBSTRING(p2.prod_detalle, 0, 5) = SUBSTRING(p.prod_detalle, 0, 5)
					ORDER BY f2.fami_id ASC)


