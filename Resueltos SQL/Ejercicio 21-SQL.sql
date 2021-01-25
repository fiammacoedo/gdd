-- Ejercicio 21 [SQL]
-- Escriba una consulta sql que retorne para todos los años, en los cuales se haya hecho al
-- menos una factura, la cantidad de clientes a los que se les facturo de manera incorrecta
-- al menos una factura y que cantidad de facturas se realizaron de manera incorrecta. Se
-- considera que una factura es incorrecta cuando la diferencia entre el total de la factura
-- menos el total de impuesto tiene una diferencia mayor a $ 1 respecto a la sumatoria de
-- los costos de cada uno de los items de dicha factura. Las columnas que se deben mostrar
-- son: Año, Clientes a los que se les facturo mal en ese año, Facturas mal realizadas en ese año

SELECT YEAR(f.fact_fecha) AS anio, COUNT(DISTINCT f.fact_cliente) AS clientes, COUNT(*) AS factura_mal_realizadas
FROM Factura f
WHERE (f.fact_total - f.fact_total_impuestos) - (SELECT ISNULL(SUM(i.item_precio * i.item_cantidad), 0)
													FROM Item_Factura i
													WHERE f.fact_numero = i.item_numero AND f.fact_sucursal = i.item_sucursal 
													AND f.fact_tipo = i.item_tipo) > 1 
GROUP BY YEAR(f.fact_fecha)
