-- Ejercicio 1 [SQL]
-- Mostrar el c�digo, raz�n social de todos los clientes cuyo l�mite de cr�dito sea
-- mayor o igual a $ 1000 ordenado por c�digo de cliente.

SELECT clie_codigo, clie_razon_social
FROM DBO.Cliente
WHERE clie_limite_credito >= 1000
ORDER BY clie_codigo