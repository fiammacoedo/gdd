-- Ejercicio 24 [SQL]
-- Escriba una consulta que considerando solamente las facturas correspondientes a los
-- dos vendedores con mayores comisiones, retorne los productos con composición facturados al menos en cinco facturas,
-- La consulta debe retornar las siguientes columnas:
-- Código de Producto
-- Nombre del Producto
-- Unidades facturadas
-- El resultado deberá ser ordenado por las unidades facturadas descendente.

SELECT p.prod_codigo, p.prod_detalle, SUM(i.item_cantidad) AS unidades_facturadas
FROM Producto p JOIN Item_Factura i ON p.prod_codigo = i.item_producto JOIN Factura f ON (f.fact_numero = i.item_numero AND f.fact_tipo = i.item_tipo AND f.fact_sucursal = i.item_sucursal)
WHERE f.fact_vendedor IN (SELECT TOP 2 e.empl_codigo
						FROM Empleado e
						ORDER BY e.empl_comision DESC) AND p.prod_codigo IN (SELECT c.comp_producto FROM Composicion c)
GROUP BY p.prod_codigo, p.prod_detalle
HAVING COUNT(DISTINCT (f.fact_sucursal + f.fact_tipo + f.fact_numero)) > 5
ORDER BY SUM(i.item_cantidad) DESC