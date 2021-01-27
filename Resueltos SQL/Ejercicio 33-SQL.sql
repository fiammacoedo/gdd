-- Ejercicio 33 [SQL]
--Se requiere obtener una estadística de venta de productos que sean componentes. Para ello se solicita que realiza la siguiente 
--consulta que retorne la venta de los componentes del producto más vendido del año 2012. Se deberá mostrar:
--a. Código de producto
--b. Nombre del producto
--c. Cantidad de unidades vendidas
--d. Cantidad de facturas en la cual se facturo
--e. Precio promedio facturado de ese producto.
--f. Total facturado para ese producto
--El resultado deberá ser ordenado por el total vendido por producto para el año 2012.

SELECT p.prod_codigo, p.prod_detalle, SUM(i.item_cantidad) AS unidades_vendidas,
		COUNT(DISTINCT f.fact_numero + f.fact_sucursal + f.fact_tipo) AS cantidad_facturas_prod,
		AVG(i.item_precio) AS precio_promedio, SUM(i.item_cantidad * i.item_precio) AS total_facturado_prod
FROM Item_Factura i JOIN Producto p ON i.item_producto = p.prod_codigo JOIN Factura f ON 
	(f.fact_numero = i.item_numero AND f.fact_sucursal = i.item_sucursal AND f.fact_tipo = i.item_tipo)
WHERE YEAR(f.fact_fecha) = 2012 
		AND p.prod_codigo IN (SELECT c.comp_componente
							FROM Composicion c
							WHERE c.comp_producto = (SELECT TOP 1 i2.item_producto
													FROM Item_Factura i2 JOIN Factura f2 ON
														(f2.fact_numero = i2.item_numero AND f2.fact_sucursal = i2.item_sucursal AND f2.fact_tipo = i2.item_tipo)
													WHERE YEAR(f2.fact_fecha) = 2012
													GROUP BY i2.item_producto
													ORDER BY SUM(i2.item_cantidad) DESC))
GROUP BY p.prod_codigo, p.prod_detalle
ORDER BY SUM(i.item_cantidad * i.item_precio) DESC