-- Ejercicio 15 [SQL]
-- Escriba una consulta que retorne los pares de productos que hayan sido vendidos
-- juntos (en la misma factura) más de 500 veces. El resultado debe mostrar el código
-- y descripción de cada uno de los productos y la cantidad de veces que fueron
-- vendidos juntos. El resultado debe estar ordenado por la cantidad de veces que se
-- vendieron juntos dichos productos. Los distintos pares no deben retornarse más de una vez.
-- Ejemplo de lo que retornaría la consulta:
-- PROD1 DETALLE1 PROD2 DETALLE2 VECES
-- 1731 MARLBORO KS 1 7 1 8 P H ILIPS MORRIS KS 5 0 7
-- 1718 PHILIPS MORRIS KS 1 7 0 5 P H I L I P S MORRIS BOX 10 5 6 2

SELECT p1.prod_codigo AS prod1_codigo, p1.prod_detalle AS prod1_detalle, p2.prod_codigo AS prod2_codigo,
	p2.prod_detalle AS prod2_detalle, COUNT(*) AS cantidad_vendidos_juntos
FROM Item_Factura i1, Item_Factura i2, Producto p1, Producto p2
WHERE i1.item_numero = i2.item_numero AND i1.item_sucursal = i2.item_sucursal AND i1.item_tipo = i2.item_tipo
	AND p1.prod_codigo = i1.item_producto
	AND p2.prod_codigo = i2.item_producto
	AND p1.prod_codigo != p2.prod_codigo
	AND p1.prod_codigo > p2.prod_codigo -- Le agrego esta validacion para que no me devuelva dos veces el mismo par pero invertido
GROUP BY p1.prod_codigo, p1.prod_detalle, p2.prod_codigo, p2.prod_detalle
HAVING COUNT(*) > 500
ORDER BY COUNT(*) DESC

