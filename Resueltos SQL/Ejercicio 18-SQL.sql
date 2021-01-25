-- Ejercicio 18 [SQL]
-- Escriba una consulta que retorne una estadística de ventas para todos los rubros.
-- La consulta debe retornar:
-- DETALLE_RUBRO: Detalle del rubro
-- VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro
-- PROD1: Código del producto más vendido de dicho rubro
-- PROD2: Código del segundo producto más vendido de dicho rubro
-- CLIENTE: Código del cliente que compro más productos del rubro en los últimos 30 días
-- La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar
-- ordenada por cantidad de productos diferentes vendidos del rubro

SELECT ISNULL(r.rubr_detalle,'Sin nombre') AS detalle_rubro, ISNULL(SUM(i.item_cantidad * i.item_precio), 0) AS ventas,
		(SELECT TOP 1 p1.prod_codigo
		FROM Producto p1 JOIN Item_Factura i1 ON p1.prod_codigo = i1.item_producto
		WHERE p1.prod_rubro = r.rubr_id
		GROUP BY p1.prod_codigo
		ORDER BY SUM(i1.item_cantidad) DESC) AS prod1,
		(SELECT TOP 1 p1.prod_codigo
		FROM Producto p1 JOIN Item_Factura i1 ON p1.prod_codigo = i1.item_producto
		WHERE p1.prod_rubro = r.rubr_id AND p1.prod_codigo <> (SELECT TOP 1 p1.prod_codigo
															FROM Producto p1 JOIN Item_Factura i1 ON p1.prod_codigo = i1.item_producto
															WHERE p1.prod_rubro = r.rubr_id
															GROUP BY p1.prod_codigo
															ORDER BY SUM(i1.item_cantidad) DESC)
		GROUP BY p1.prod_codigo
		ORDER BY SUM(i1.item_cantidad) DESC) AS prod2,
		(SELECT TOP 1 f.fact_cliente
		FROM Factura f JOIN Item_Factura i ON f.fact_sucursal = i.item_sucursal AND f.fact_numero = i.item_numero AND f.fact_tipo = i.item_tipo 
						JOIN Producto p ON p.prod_codigo = i.item_producto
		WHERE p.prod_rubro = r.rubr_id -- Faltan los 30 dias pero sino no me devuelve resultados
		GROUP BY f.fact_cliente
		ORDER BY COUNT(DISTINCT i.item_producto) DESC) AS cliente
FROM Rubro r LEFT JOIN Producto p ON r.rubr_id = p.prod_rubro JOIN Item_Factura i ON p.prod_codigo = i.item_producto
GROUP BY r.rubr_detalle, r.rubr_id
ORDER BY COUNT(DISTINCT(i.item_producto))