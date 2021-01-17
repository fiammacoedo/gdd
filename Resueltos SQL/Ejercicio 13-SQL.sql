-- Ejercicio 13 [SQL]
-- Realizar una consulta que retorne para cada producto que posea composición
-- nombre del producto, precio del producto, precio de la sumatoria de los precios por
-- la cantidad de los productos que lo componen. Solo se deberán mostrar los
-- productos que estén compuestos por más de 2 productos y deben ser ordenados de
-- mayor a menor por cantidad de productos que lo componen.

SELECT p.prod_detalle, p.prod_precio, SUM(pc.prod_precio * c.comp_cantidad) AS precios_por_cantidad
FROM Composicion c JOIN Producto p ON c.comp_producto = p.prod_codigo JOIN Producto pc ON c.comp_componente = pc.prod_codigo
GROUP BY p.prod_detalle, p.prod_precio
HAVING COUNT(c.comp_componente) > 2
ORDER BY COUNT(c.comp_componente) DESC