-- Ejercicio 13 TSQL
-- Cree el/los objetos de base de datos necesarios para que nunca un producto pueda
-- ser compuesto por sí mismo. Se sabe que en la actualidad dicha regla se cumple y
-- que la base de datos es accedida por n aplicaciones de diferentes tipos y tecnologías.
-- No se conoce la cantidad de niveles de composición existentes.

-- Si se inserta en composicion hay que revisar
CREATE TRIGGER ejercicio13_insert ON Composicion INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO Composicion (comp_producto, comp_componente, comp_cantidad)
	VALUES (SELECT *
			FROM INSERTED
			WHERE fcompone(comp_componente, comp_producto) = 0)
END
GO

-- Si se updatea en composicion hay que revisar
CREATE TRIGGER ejercicio13_update ON Composicion INSTEAD OF UPDATE
AS
BEGIN
	INSERT INTO Composicion (comp_producto, comp_componente, comp_cantidad)
	VALUES (SELECT *
			FROM INSERTED
			WHERE fcompone(comp_componente, comp_producto) = 0)
END
GO

-- Funcion que se fija si un producto (@componente) compone a otro (@producto)
CREATE FUNCTION fcompone (@componente char(8), @producto char(6))
RETURNS bit
AS
BEGIN
	DECLARE @componente_iteracion char(6)
	-- Chequeo si lo compone directamente
	IF EXISTS(SELECT COUNT(*) FROM Composicion WHERE comp_producto = @producto AND comp_componente = @componente)
	BEGIN
		RETURN 1
	END

	-- Chequeo si lo compone indirectamente: si compone a alguno de sus componentes
	DECLARE C1 CURSOR FOR (SELECT comp_componente FROM Composicion WHERE comp_producto = @producto)
	OPEN C1
	FETCH NEXT FROM C1 INTO @componente_iteracion
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF(fcompone(@componente, @componente_iteracion) = 1)
		BEGIN
			RETURN 1
		END
		FETCH NEXT FROM C1 INTO @componente_iteracion
	END

	RETURN 0
END
GO