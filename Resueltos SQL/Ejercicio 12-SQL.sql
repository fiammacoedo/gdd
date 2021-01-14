-- Ejercicio 12 [SQL]
-- Mostrar nombre de producto, cantidad de clientes distintos que lo compraron
-- importe promedio pagado por el producto, cantidad de depósitos en lo cuales hay
-- stock del producto y stock actual del producto en todos los depósitos. Se deberán
-- mostrar aquellos productos que hayan tenido operaciones en el año 2012 y los datos
-- deberán ordenarse de mayor a menor por monto vendido del producto.

SELECT p.prod_detalle, COUNT(DISTINCT f.fact_cliente) AS cantidad_clientes,
		AVG(i.item_precio) AS importe_promedio,
		(SELECT COUNT(DISTINCT stoc_deposito)
		FROM Stock
		WHERE stoc_producto = p.prod_codigo AND stoc_cantidad > 0) AS depositos_con_stock,
		(SELECT ISNULL(SUM(stoc_cantidad), 0)
		FROM Deposito LEFT JOIN Stock ON stoc_deposito = depo_codigo
		WHERE stoc_producto = p.prod_codigo) AS stock_actual_total
FROM Producto p JOIN Item_Factura i ON p.prod_codigo = i.item_producto 
				JOIN Factura f ON (f.fact_numero = i.item_numero AND f.fact_sucursal = i.item_sucursal AND f.fact_tipo = i.item_tipo)
WHERE p.prod_codigo IN (SELECT i2.item_producto
						FROM Item_Factura i2 JOIN Factura f2 ON (f2.fact_numero = i2.item_numero AND f2.fact_sucursal = i2.item_sucursal AND f2.fact_tipo = i2.item_tipo)
						WHERE YEAR(f2.fact_fecha) = 2012)
GROUP BY p.prod_detalle, p.prod_codigo
ORDER BY ISNULL(SUM(i.item_cantidad * i.item_precio), 0) DESC
