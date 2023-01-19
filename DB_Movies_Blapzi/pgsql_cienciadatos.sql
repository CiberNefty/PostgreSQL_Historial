PUNTOS FUERTES DE LAS RDB

* Multiproposito.
* Ampliamente utilizadas.
* Informacion consistente.
* Flexible.
* Retrocompatible.
* Completamente programable.

-------------------------------------
ESTAMOS UTILIZANDO LA DB de MOVIES


SELECT MAX(ultima_actualizacion) AS fecha_ultima_actualizacion,
		clasificacion, COUNT(*) AS cantidad_peliculas
FROM peliculas
WHERE duracion_renta > 3
GROUP BY clasificacion, ultima_actualizacion
ORDER BY fecha_ultima_actualizacion;

-- -----------------------------------
CREATE OR REPLACE PROCEDURE test_dropcreate_procedure()
LANGUAGE SQL
AS $$
	DROP TABLE  IF EXISTS aaa; -- Aquí estamos haciendo una pruba de borrar
	CREATE TABLE aaa(bbb char(5) CONSTRAINT firstkey PRIMARY KEY);
$$;

-- Ahora para llamar nuestro procedimiento
CALL test_dropcreate_procedure();	
-- ------------------------------------
CREATE OR REPLACE FUNCTION test_dropcreate_function()
RETURNS VOID -- Aqui estamos diciendo que regresa un vacio
LANGUAGE plpgsql
AS $$
BEGIN
	DROP TABLE IF EXISTS aaa;
	CREATE TABLE aaa (bbb char(5) constraint firstkey PRIMARY KEY,
					 ccc char(5));
	DROP TABLE IF EXISTS aaab;
	CREATE TABLE aaab (bbba char(5) constraint secondkey PRIMARY KEY,
					 ccca char(5)); -- las llaves unicas deben ser diferentes todas las de la BD
END;
$$;

-- Ahora una firma de llamar a las funciones es con SELECT
-- Puede ser de la siguiente manera 
-- SELECT * FROM test_dropcreate_function();
SELECT test_dropcreate_function();

-- -------------------------------
CREATE OR REPLACE FUNCTION count_total_movies()
RETURNS int
LANGUAGE plpgsql
AS $$
BEGIN
	return COUNT(*) FROM peliculas;
END;
$$;

SELECT count_total_movies();
-- ------------------------

CREATE OR REPLACE FUNCTION duplicate_records()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
-- La idea de esta funcion es tomar el registro que se inserto en la tabla y lo vamos a meter
-- igual o transformado en otra tabla.
BEGIN
	INSERT INTO aaab(bbba,ccca)
	VALUES(NEW.bbb, NEW.ccc);
	RETURN NEW;
END;
$$;

CREATE TRIGGER aaa_changes 
-- Este nombre del trigger es para que se pamos que se ejecutara cuando cambia la tabla aaa
BEFORE INSERT 
ON aaa
FOR EACH ROW
--  Esta funcion es para que cada vez que ingrese un registro en la tabla aaa ingrese un registro igual en la table aaab
EXECUTE PROCEDURE duplicate_records();

INSERT INTO aaa (bbb,ccc) 
VALUES ('abcde','efghi');

SELECT * FROM aaab;
-- ------------------------------------
CREATE OR REPLACE FUNCTION movies_stats()
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
	total_rated_r REAL := 0.0; -- Esta variable se utiliza para decir las peliculas que no peliculas para niños.
	total_larger_thank_100 REAL := 0.0; -- Peliculas de una duracion de mas de 100 minutes
	total_published_2006 REAL := 0.0;
	-- Vamos a declarar dos variables promedios 
	average_duracion REAL := 0.0; -- Esta es una variable de promedio de duracion que tienen las peliculas.
	average_rental_price REAL := 0.0; -- Esta es una variable de promedio de renta a las que se rentan las peliculas.
BEGIN
-- DEntro de la funcion vamos a asignarle a cada variable el resultado de una consulta.
	to
END;
$$;