-- Primero que nada creamos una nueva BD que la llamamos articulos_ejemplo
-- Luego creamos las tablas.

CREATE TABLE articulo(
    item_id serial,
    nombre varchar(150),
    tipo varchar(100),
    cantidad int not null default 0,
    precio_compra numeric(7,2) not null,
    precio_venta numeric(7,2) not null,
    CONSTRAINT item_id_tipo PRIMARY KEY (item_id)
);

-- INSERTAMOS LOS DATOS
INSERT INTO articulo(, nombre, tipo, cantidad, precio_compra, precio_venta)
VALUES ('Switch 8 puertos','Switch', 2, 32.5 , 45.6),
('Switch 16 puertos','Switch', 2, 82.5, 95.6),
('DLink 56K','Modem', 0, 10.5, 15.6),
('Samsung 17','Monitor', 0, 100.0, 120.0),
('Dell 17','Monitor', 0, 100.0, 135.0),
('DDR2 512/533','RAM', 2, 40.0, 45.0),
('DDR2 1024/533','RAM', 0, 45.0, 97.0),
('NVIDIA FX 5200','Tarjeta', 7, 40.0, 48.5),
('NVIDIA FX 6400','Tarjeta', 0, 60.0, 98.5),
('Pentium4 3.2GHZ','Procesador', 7, 20.0, 230.0);

SELECT * FROM articulo
SELECT * FROM articulo WHERE cantidad = 0;

-- CREAMOS OTRA TABLA
--  EN donde indiquemos cual es el id y el articulo que ya se termino

CREATE TABLE IF NOT EXISTS articulo_por_comprar(
    item_id int not null,
    nombre varchar(150) not null
);

-- CREAMOS NUESTRA FUNCION

CREATE OR REPLACE FUNCTION articuloporcomprar() RETURNS int
AS $$
DECLARE
    cont_item int;
    fila articulo%rowtype; 
/* Esta variable fila la inicializamos con la caracteristica he infrestructura
de los articulos que tengo definidos en la tabla articulo.

Para copiar completamente la estructura que tenemos en las filas definidas
en la tabla articulo voy a utilizar el tipo %rowtype.

Esto me dara la avilidad de copiar la fila de una tabla, 
usando exactamente su infrestructura.
*/
BEGIN
    /*
    DROP TABLE articulo_por_comprar;
    CREATE TABLE articulo_por_comprar(
        item_id int not null,
        nombre varchar(150) not null
    );

    DELETE FROM articulo_por_comprar; # Ó podriams simplemente vaciar la tabla sin borrar la infrastructure.
    */ -- En este caso utilizaremos TRUNCATE TABLE para vaciar la tabla.
    TRUNCATE TABLE articulo_por_comprar; -- Vaciar tabla
    SELECT count(*) INTO cont_item FROM articulo WHERE cantidad = 0; 
-- Aqui contamos cuantos articulos tiene bajo la cantidad de 0,
-- y en lugar de desplegar el select, se va a guardar ese resultado
-- donde este inicializada la variable cont_item. No mostramos nada solo precerbamos una varible temporal.
    
    FOR fila in SELECT  * FROM  articulo WHERE cantidad = 0
/*Luego para cada una de las filas, vemos que esa variable fila se creo de tipo rowtype
copiando la infrastructure de la tabla articulo, esto funciona como un for donde fila va iterando por la consulta de select*/
        LOOP
            INSERT INTO articulo_por_comprar VALUES
                            (fila.item_id,fila.nombre);
        END LOOP;
    RETURN cont_item; #--luego retornamos lo que seria el valor que precerbamos en la variable cont_item, que se utilizo para el conteo.
END;
$$ LANGUAGE plpgsql;

-- INVOCAMOS LA FUNCION
SELECT articuloporcomprar(); -- Aqui observamos que la funcion sirve para dar el conteo de los articulos que ya no hay.
SELECT * FROM articulo_por_comprar; -- Luego de que se ejecute la funcion verificamos que contenidos se han agregado.

-- HACEMOS ACTUALIZACIONES DE DATOS.

UPDATE articulo SET cantidad = 10 WHERE item_id =0; -- Aqui asumimos que el proveedor ya entrego unos articulos.
UPDATE articulo SET cantidad = 0 WHERE item_id =1;
UPDATE articulo SET cantidad = 0 WHERE item_id =2;
UPDATE articulo SET cantidad = 0 WHERE item_id =6;
UPDATE articulo SET cantidad = 0 WHERE item_id =10;

SELECT articuloporcomprar();

-- FUNCION PATRIMONIO
--  Devolver cuanto es lo que tendria de dinero si vendiera todo lo que tengo en el stock
CREATE OR REPLACE FUNCTION patrimonio() RETURNS numeric(7,2)
AS $$
DECLARE
    total numeric(7,2) := 0.0; -- Creamos una variable total que es numeric y esta inicializada en 0.0  por que aqui va a tener el acumulado.
    fila articulo%rowtype; -- Y creamos una variable que va a almacenar la estructura de la tabla articulo.
BEGIN
    FOR fila IN SELECT * FROM articulo WHERE cantidad != 0
        LOOP
            total := total + (fila.cantidad * fila.precio_venta);
        END LOOP;
    RETURN total;
END;
$$ LANGUAGE plpgsql;

-- La funcion nos dice que si no vendieramos todos los productos que tenga en cantidad 0
-- en stock  estaria vendiendo tanto. 
SELECT to_char(patrimonio(),'LFM999,999.00') -- RESULTADO, invocamos la funcion patrimonio, le aplicamos un formato

