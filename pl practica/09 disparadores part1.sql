# Antes de empezar a definir el TRIGGER es neceraio conocer unas cuantas varaibles
# por defecto que nos proporciona PostgreSQL:

# CURREN_USER: Almacena el nombre del usuario que esta actualmente conectado a la BD y que ejecuta las sentencias.
# CURRENT_DATE: Almacena la fecha actual del servidor. (no la del cliente)
# CURRENT_TIME: almacena la hora.

/* PostgreSQL tambien maneja unas cuantas variables al momento de ejecutar un trigger.
    - NEW: es una variable compuesta que almacena los nuevos valores de las tuplas que se estan
            modificando.
    - OLD: variable compuesta que almacena los valores antiguos de la tupla que se esta modificando.
    - TG_OP: variable de tipo STRING que indica que tipo de evento esta ocurriendo
             (INSERT,UPDATE,DELETE).
    - TG_ARGV: variable de tipo arreglo que almacena  los parametros de la funcion del trigger podemos accederlo de la forma:
        TG_ARGV[0], TG_ARGV[1], etc.
*/

"""--Disparadores
Los disparadores tiene la siguiente estructura:
1) Nombre del disparador:
    CREATE [or replace] TRIGGER <nombre del disparador>
2) Punto en el tiempo en que debe 'dispararse':
    [AFTER | BEFORE]
3) Eventos que pueden dispararlo:
    [INSERT | UPDATE | DELETE]
4) Tipo de disparador:
    FOR EACH [ROW | STATEMENT]
5) Funcion que modela la respuesta del disparador:
    EXECUTE PROCEDURE;

¡LO PRIMERO QUE TOCA HACER PARA TRABAJAR CON UN DISPARADOR ES HACER LA DEFINICION DE LA FUNCION.!

CREATE TRIGGER nombreTigger
	[AFTER | BEFORE] [INSERT|UPDATE|DELETE]
	ON nombreTabla
	FOR EACH [ROW | STATEMENT]
	EXECUTE PROCEDURE funcion;
"""

-- Formas de uso de los DISPARADORES
-- Verificar restricciones a nivel de la Base de Datos (ASSERTIONS)

-- Queremos asegurarnos que las cuentas que se abren o actualizan en CHIPAS
-- tienen al menos un saldo inicial de $1,000.00

-- Creamos en primer lugar la funcion que habrá de responder al disparador.

create or replace function check_saldo_chiapa() returns trigger
AS $$
DECLARE
	edo varchar(20);
BEGIN
	if(TG_OP = 'INSERT' OR TG_OP = 'UPDATE') then
		select estado into edo from sucursal
		where numsucursal = NEW.nunsucursal;
		if edo = 'CHIAPAS' AND NEW.saldo < 1000 then
			RAISE EXCEPTION 'El saldo minimo en % debe ser $1,000.00', edo;
		end if;
	end if;
	return null;
END;
$$ LANGUAGE plpgsql;

-- Ya que tenemos nuestra funcion Creamos el Disparador;
CREATE TRIGGER saldo_chiapas
AFTER INSERT OR UPDATE ON cuenta
FOR EACH ROW
EXECUTE PROCEDURE check_saldo_chiapas();
--------------------------

-- Porbemos el disparador, simulamos la apertura de una cuenta
-- Asignamos una cuenta al cliente, la cuenta se otorga en chiapas
-- Suc. 52: Tonala
INSERT INTO cuenta VALUES (52,'C-12185',500,current_date); -- Cuando se ejecuta esta instruccion el trigger dispara la funcion donde informa que el saldo minimo de 1,000.00

-- Asignamos una cuenta en otro estado, p.e. Guanajuato
insert into cuenta values(1,'C-12186',500,current_date); -- Esta ees una nueva apertura de cuenta y no genera problema por que no tiene ninguna restriccion de algun estado.

-- Verificamos las tuplas insertadas
select a.*, estado
from cuenta a JOIN sucursal b ON a.numsucursal = b.numsucursal
where numcta = 'C-12186';

select a.*, estado
from cuenta a JOIN sucursal b ON a.numsucursal = b.numsucursal
where numcta = 'C-12185';

-- Verificamos las Actualizaciones. Tomamos una cuenta de CHIAPAS
select a.*, estado
from cuenta a JOIN sucursal b ON a.numsucursal = b.numsucursal
where numcta = 'C-00536';

-- Disminuimos el saldo a $500.00
UPDATE cuenta SET saldo = 500 WHERE numcta = 'C-00536';
-- Esta actualizacion no sucedio por que tiene una restriccion en la funcion check_saldo_chiapas()

-- Tomamos una cuenta de otro estado.
select a.*, estado
from cuenta a JOIN sucursal b ON a.numsucursal = b.numsucursal
where numcta = 'C-00537';

-- Disminuimos el sado a $500.00
UPDATE cuenta SET saldo = 500 WHERE numcta = 'C-00537';
-- ----------------------------
-- Creacion de historicos
-- Monitorear los movimientos (retiros/depositos) de los clientes;

-- Creamos una tabla que almacene la informacion de los movimientos.
--drop table movimientos;
-- Podemos crear una bd de datos que tenga todo en memoria.
Create table movimientos(
numcta char(7),
fecha date,
saldo_anterior numeric(10,2),
saldo_nuevo numeric(10,2)
);

-- Creamos la funcion que habra de responder al disparador
CREATE or replace function check_movimientos() returns trigger
AS $$
BEGIN
	if(TG_OP = 'INSERT') THEN
		insert into movimientos values(NEW.numcta,current_date,
									 NEW.saldo,NEW.saldo);
	else if(TG_OP = 'UPDATE' AND OLD.saldo <> NEW.saldo) THEN
		insert into movimientos values(NEW.numcta,current_date,
									 OLD.saldo,NEW.saldo);
		 end if;
	end if;
	return null;
END;
$$ LANGUAGE plpgsql;

-- Creamos el disparador sobre cuenta, para monitorear insert y update
create trigger movimientos
after insert OR update of saldo
ON cuenta
for each row
execute procedure check_movimientos();

-- Probamos el disparador, insertamos una nueva cuenta
insert into cuenta values (52,'C-12185',1000,current_date);
-- Comprobamos si se inserto
select a.*, estado
FROM cuenta a JOIN sucursal b on a.numsucursal = b.numsucursal
where numcta = 'C-12185';

-- Consultamos la tabla movimientos;
Select * from movimientos;

-- Probamos el disparador, actualizamos el saldo de una cuenta existente.
select * from cuenta where numcta = 'C-00536';
update cuenta SET saldo = 10000 where numcta = 'C-00536';
select * from movimientos;

UPDATE cuenta set saldo = 2000 where numcta = 'C-12185';
select * from movimiento;

-- Crear un disparador para almacenar la informacion que se haya eliminado
-- Creamos un procedimiento que elimine la informacion de cuentas de un cliente
create or replace procedure elimina_cuenta_cliente (id int)
AS $$
declare
	c char(7);
begin
	if not exists (select * from ctacliente where idcliente = id) then
		RAISE EXCEPTION 'El cliente con id % no existe', id;
	end if;
	while(exists(select * from ctacliente where idcliente = id))
		loop
			select numcta into c from ctacliente where idcliente = id;
			delete from ctacliente where numcta = c;
			delete from cuenta where numcta = c;
		end loop;
end;
$$ LANGUAGE plpgsql;
-- Ya estaria guardado la estructura para que se genere el borrado.

-- Creamos la tabla historico
create table baja_cuenta(
	idcliente int,
	cliente varchar(200),
	cuenta char(7),
	sucursal varchar(100),
	saldo numeric(10,2),
	apertura date,
	usuario varchar (100),
	fecha date
);

-- Creamos el disparador
create or replace function borrar_cuenta() returns trigger
AS $$
DECLARE
	c cuenta%rowtype; -- Recordar que la funcion wortype nos ayuda a copiar toda la infraestructura que tiene una abla para poder almacenar todo los elementeo de una tupla 
	s sucursal%rowtype;
	d cliente%rowtype;
BEGIN
	select * into c from cuenta where numcta = OLD.numcta;
	select * into s from sucursal where numsucursal = c.numsucursal;
	select * into d from cliente where idcliente = OLD.idcliente;
	insert into baja_cuenta values (OLD.idcliente,d.nombrecliente,
								   OLD.numcta, s.nombresucursal,c.saldo,
								   c.fecha,current_user,current_date);
	return null;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER eliminar_cuenta
AFTER DELETE ON ctacliente
FOR EACH row
execute procedure borrar_cuenta();

-- Probamos el disparador 
call elimina_cuenta_cliente (2000000); --No existe
call elimina_cuenta_cliente (1510);
call elimina_cuenta_cliente (15755);

-- Verificamos el historico
select * from baja_cuenta;
-----------------------------
-- Disparador que verifique si un cliente ya termino de pagar su prestamo
-- Hacemos una copia de la tabla prestamos
create table prestamo1 as select * from prestamos;

-- Agregamos una columna que permita validad si ya paggo o no!
Alter table prestamo1 add  pagado int default 0;
select * from prestamos1;

-- Creamos la funcion que responderá al disparador
create or replace function check_paguitos() returns trigger
AS $$
DECLARE
	pagado numeric(10,2);
	monto numeric(10,2);
BEGIN
	select importe into monto from prestamo1 where numprestamo = NEW.numprestamo;
	select sum(pago) into pagado from pagos where numprestamo = NEW.numprestamo;
	if (pagafo >= monto) then
	update prestamo1 set pagado = 1 WHERE numprestamos = NEW.numprestamo;
	end if;
end;
$$ language plpgsql;

-- Creamos el disparador
create trigger paguitos
after insert ON pagos
for each row
execute procedure check_paguitos();

-- Veamos las deudas de los clientes
select a.numprestamo, importe, pagado, sum(pago) pago, importe-sum(pago) deuda
from prestamo1 a JOIN pagos b ON a.numprestamo = b.numprestamo
group by a.numprestamo, importe, pagado
order by 1;

-- Vamos a pagar un par de prestamos
insert into pagos values ('P-00003',5000,current_date);
insert into pagos values ('P-00003',5890,current_date);
insert into pagos values ('P-00005',135255.26,current_date);

-- comprobamos que se haya pagado
select * from prestamo1 where pagado = 1;
END;
$$ LANGUAGE plpgsql;