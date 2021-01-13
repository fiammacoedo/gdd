-- Ejercicio 10 [SQL]
-- Mostrar los 10 productos mas vendidos en la historia y también los 10 productos
-- menos vendidos en la historia. Además mostrar de esos productos, quien fue el
-- cliente que mayor compra realizo.

SELECT (SELECT TOP 1 fact_cliente 
		FROM Item_Factura JOIN Factura ON (fact_tipo = item_tipo AND fact_numero = item_numero AND fact_sucursal = item_sucursal)
		WHERE item_producto = prod_codigo
		GROUP BY fact_cliente
		ORDER BY ISNULL(SUM(item_cantidad), 0) DESC) AS cliente_mayor_compra,
		prod_codigo, prod_detalle
FROM Item_Factura JOIN Producto ON item_producto = prod_codigo
WHERE item_producto IN (SELECT TOP 10 (prod_codigo)
					FROM Producto JOIN Item_Factura ON prod_codigo = item_producto
					GROUP BY prod_codigo
					ORDER BY ISNULL(SUM(item_cantidad), 0) DESC) -- Mas vendidos
	OR item_producto IN (SELECT TOP 10 (prod_codigo)
					FROM Producto JOIN Item_Factura ON prod_codigo = item_producto
					GROUP BY prod_codigo
					ORDER BY ISNULL(SUM(item_cantidad), 0) ASC) -- Menos vendidos
GROUP BY prod_codigo, prod_detalle -- Sin GROUP BY no falla, pero no corta a los 20