-- FUNCIONES QUE DEVUELVEN TABLAS
-- Funcion para crear saldos promedio por sucursal.


/* Podemos utilizar las funciones dando lé una prespectiva que nos devuelve una tabla,
Esto permitira que podamos utilizar este dato devuelto en algun otro proceso almacenado
ó otra funcion, incluso en una consulta SQL*/

-- Estamos utilizando la BD (articulo_ejemp, y transporte)
CREATE OR REPLACE FUNCTION saldoprom() RETURNS setof "record" 
/* setof "record" esto devuelve un conjunto de registro con el returns.
vimos que podemos utiilizar el %rowtype, la deventaja del rowtype es que este tipo
me permite copiar completamente la infrastructura en, cuanto ha atributos y tipos
de dato que tiene una tabla, pero si yo quiero recuperar datos que se encuentran repartidos
en mas de una tabla, el rowtype no me sirve por que solamente me permite copiar la infrastructura
de una unica tabla. Entonces para recuperar datos de mas de una tabla utilizamos el setof.*/
AS $$
DECLARE
    r record; -- Aqui estamos definiendo una variable de tipo registro
BEGIN
    FOR r in SELECT numsucursal.avg(saldo)
             FROM cuenta -- Aqui estamos recuperando el saldo promedio.
             GROUP BY numsucursal
        LOOP
            return next r;
        END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;

-- USO (podemos llamar a una funcion dentro de una clausula SELECT)
SELECT sucursal,to_char(saldoprom,'LFM999.999.00') saldoprom
FROM saldoprom() AS (sucursal int, saldoprom numeric) # Aqui esta arrojando dos columnas, donde la primera columna la llamamos sucrusal de tipo entero y, la segunda como saldoprom que es de tipo numeric.
ORDER BY sucursal,saldoprom DESC;
-- -----------------------------------------------------

-- FUNCION que devuelve el numero de cuentas y prestamos de cada cliente.
CREATE OR REPLACE FUNCTION clientesCtas() RETURNS setof "record"
AS $$
DECLARE
    r record;
BEGIN
    FOR r IN SELECT nombrecliente,
                    count(distinct numcta),count(DISTINCT numprestamo)
             FROM cliente nutural JOIN ctacliente natural JOIN prestatario
             GROUP BY idcliente
        LOOP
            return next r;
        END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;

-- USO
SELECT * FROM clientesctas() AS (nombrecliente varchar, cuentas bigint, prestamos bigint)
WHERE cuentas = 2;

-- ---------------------------------------------------
-- Funcion que devuelve un "Subconjunto" de tabla cuenta.
CREATE OR REPLACE FUNCTION getCuentas() RETURNS setof cuenta -- Aqui nos devuelve un conjunto de cuentas de dcicha tabla
AS 'SELECT * FROM cuenta WHERE saldo BETWEEN 50000 AND 95000;'
LANGUAGE sql;

-- USO
SELECT * FROM getCuentas();

CREATE OR REPLACE FUNCTION getCuentas(numeric,numeric,int) RETURNS setof cuenta
AS $$
SELECT * FROM cuenta WHERE saldo $1 AND $2 extract(year from fecha) = $3;
$$ LANGUAGE sql;

SELECT * FROM getCuentas(3000,50000,2015);

-- --------------------------------
-- FUNCION que devuelve el numero de cuentas y prestamos de cada cliente.
CREATE OR REPLACE FUNCTION clientes(nombre varchar) RETURNS -- Aqui recibe como parametro nombre varchar
    TABLE(cliente varchar(100),totalcuentas bigint, totalprestamos bigint)
    -- Aqui la opcion returns table podemos expecificar que resultado se puede ver como una tabla,
    -- Sino que ademas le podemos dar ya la estructura que va a tener la tabla.
    --  Esta es una tabla de grado 3.
AS$$
    SELECT nombrecliente,count(distinct numcta),count(distinct numprestamo)
    FROM cliente NATURAL JOIN ctacliente NATURAL JOIN prestatario
    GROUP BY idcliente
    HAVING nombrecliente LIKE nombre;
END $$ LAGUAGE sql;

SELECT * FROM clientes('%SÁNCHEZ%'); -- Aqui estamos llamando la funcion que creamos y le damos el parametro que necesitamos buscar.
SELECT (clientes('CARLOS%')).cliente; -- Aqué le decimos que devuelva toda la información de la consulta pero nada mas la informacion de los clientes
                                      -- Osea como creamos una estructura en la cual cree una tabla le decimos que muestre solo la primera columna.
-- -------------------------------
-- FUNCION IGUAL que la anterior, pero esta vez recibe dos parametros, que al final recupera un total de cuentas en total.
CREATE OR REPLACE FUNCTION clientes(nombre varchar, total bigint) RETURNS
    TABLE(cliente varchar(100),cuentas bigint, prestamos bigint)

AS$$
    SELECT nombrecliente,count(distinct numcta),count(distinct numprestamo)
    FROM cliente NATURAL JOIN ctacliente NATURAL JOIN prestatario
    GROUP BY idcliente
    HAVING nombrecliente LIKE nombre AND count(distinct numcta) = total;
END $$ LAGUAGE sql;
-- USO
SELECT * FROM clientes('CARLOS%',2);

-- PARA ELIMINAR UNA FUNCTION
-- Recordar que si ya no nos sirve una funcion es mejor eliminarla del sistema para ahorra espacio en memoria
-- Tambien recordar que para borrar un function el sistema manejador de BD nos pide que coloquemos lo que seria los parametros que tiene la funcion.
DROP FUNCTION clientes(varchar);
-- -------------------------------
-- OTRA FORMA DE DEVOLVER UNA TABLA

CREATE OR REPLACE FUNCTION clientesctas(est varchar, nombre varchar) RETURNS
    TABLE(cliente varchar(100),cuenta bigint, prestamos bigint)
AS $$
-- Aqui estamos trabajando con return que tambien hace parte de plpgsql
    RETURN QUERY SELECT nombrecliente, count(distinct numcta),COUNT(distinct numprestamo)
                 FROM (ctacliente NATURAL JOIN prestatario) NATURAL JOIN clinte
                 WHERE estado = est
                 GROUP BY idcliente, nombrecliente
                 HAVING nombrecliente LIKE nombre;
$$ LANGUAGE plpgsql;

-- USO
SELECT * FROM clientesctas('Chihuahua','%');
SELECT * FROM clientesctas('C%','%');
SELECT * FROM clientesctas('C%','%PEREZ%');