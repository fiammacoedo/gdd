-- Ejercicio 14 [SQL]
-- Escriba una consulta que retorne una estadística de ventas por cliente. Los campos
-- que debe retornar son:
-- Código del cliente
-- Cantidad de veces que compro en el último año
-- Promedio por compra en el último año
-- Cantidad de productos diferentes que compro en el último año
-- Monto de la mayor compra que realizo en el último año
-- Se deberán retornar todos los clientes ordenados por la cantidad de veces que
-- compro en el último año.
-- No se deberán visualizar NULLs en ninguna columna

SELECT c.clie_codigo, ISNULL(COUNT(*), 0) AS compras_ultimo_anio, 
		ISNULL(AVG(f.fact_total), 0) AS promedio_por_compra,
		ISNULL(COUNT(DISTINCT i.item_producto), 0) AS productos_distintos,
		ISNULL(MAX(f.fact_total), 0) AS maximo_monto
FROM Cliente c LEFT JOIN Factura f ON c.clie_codigo = f.fact_cliente -- LEFT JOIN para mostrar TODOS los clientes
				JOIN Item_Factura i ON (i.item_numero = f.fact_numero AND i.item_sucursal = f.fact_sucursal AND i.item_tipo = f.fact_tipo)
WHERE YEAR(f.fact_fecha) = 2012
GROUP BY c.clie_codigo
ORDER BY ISNULL(COUNT(*), 0) DESC

-- NOTA: uso el ultimo año como 2012 - el ultimo año cargado en la db - asi obtengo valores.