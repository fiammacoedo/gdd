-- Ejercicio 22 [SQL]
-- Escriba una consulta sql que retorne una estadistica de venta para todos los rubros por
-- trimestre contabilizando todos los años. Se mostraran como maximo 4 filas por rubro (1 por cada trimestre).
-- Se deben mostrar 4 columnas:
-- Detalle del rubro
-- Numero de trimestre del año (1 a 4)
-- Cantidad de facturas emitidas en el trimestre en las que se haya vendido al menos un producto del rubro
-- Cantidad de productos diferentes del rubro vendidos en el trimestre
-- El resultado debe ser ordenado alfabeticamente por el detalle del rubro y dentro de cada
-- rubro primero el trimestre en el que mas facturas se emitieron.
-- No se deberan mostrar aquellos rubros y trimestres para los cuales las facturas emitiadas no superen las 100.
-- En ningun momento se tendran en cuenta los productos compuestos para esta estadistica.

SELECT r.rubr_detalle, DATEPART(quarter, f.fact_fecha) AS trimestre, 
	COUNT(DISTINCT (f.fact_numero + f.fact_sucursal + f.fact_tipo)) AS cantidad_facturas,
	COUNT(DISTINCT(i.item_producto)) AS productos_distintos
FROM Rubro r LEFT JOIN Producto p ON r.rubr_id = p.prod_rubro JOIN Item_Factura i ON p.prod_codigo = i.item_producto
	JOIN Factura f ON (f.fact_numero = i.item_numero AND f.fact_sucursal = i.item_sucursal AND f.fact_tipo = i.item_tipo)
WHERE p.prod_codigo NOT IN (SELECT c.comp_producto
							FROM Composicion c)
GROUP BY r.rubr_detalle, DATEPART(quarter, f.fact_fecha)
HAVING COUNT(DISTINCT (f.fact_numero + f.fact_sucursal + f.fact_tipo)) > 100
ORDER BY r.rubr_detalle ASC, COUNT(DISTINCT (f.fact_numero + f.fact_sucursal + f.fact_tipo)) DESC