use library;
#-------------------------------------
# INSERCION DATOS CON QUERIES

El laberinto de la soledad, Octavio Paz, 1952
Vuelta al laberinto de la soledad, Octavio Paz, 1960
INSERT INTO BOOKS (title,author_id,lenguage) VALUES ('El laberinto de la soledad',193); # Aquí tuvimos que ir al archivo de authors y crear a el authors Octavio Paz y tambie tuvimos que crear una insercion en el archivo de books para este libro, osea no se utilizo este insercion por motivos de campos necesarios.

INSERT INTO books (title,author_id, year, language) 
VALUES ('Vuelta al laberinto de la soledad, Octavio Paz',
(SELECT author_id FROM authors 
WHERE name = 'Octavio Paz'
LIMIT 1),1960,'es'
); # Aqui por medio de una insercion creamos un subquery para insertar un libro pero a la vez que haga una consulta de aquien debe asignarle este valor.


# Actualizamos si es vendible o no!, y en medio tenemos un subquery.
INSERT INTO books (title,author_id, year, language,sellable) VALUES ('Vuelta al laberinto de la soledad, Octavio Paz',(SELECT author_id FROM authors 
WHERE name = 'Octavio Paz'LIMIT 1),1960,null,1) ON DUPLICATE KEY UPDATE sellable = VALUES (sellable);
#-------------------------------------
# El Majestuoso SELECT

--- Aqui solo me traera dos columnas
SELECT name, gender from clients;

-- Para poder visualizar datos de una manera mas ORDENADA tenemos que CONDICIONAR  las consultas:
SELECT name, gender from clients LIMIT 10;
SELECT name, gender FROM clients WHERE gender = 'M';
SELECT birthdate FROM clients;
SELECT year(birthdate) FROM clients; # Esta funcion nos trae lo que seria solo el año de birthdate
SELECT now(); # Nos dice cual es la fecha y la hora de hoy, solo es la fecha del pc
SELECT year(now()); # Esta solo nos trae el año de la fecha

SELECT year(now()) - year(birthdate) FROM clients; # Esta nos trae la edad de cada una de las personas.
SELECT name, year(now()) - year(birthdate) FROM clients;
SELECT * from clients WHERE name LIKE '%Saave%'; # Esta clausala o funcion nos trae cercania de textos.
SELECT name,year(now()) - year(birthdate), gender FROM clients WHERE gender = 'f' AND name LIKE '%lop%'; # Aqui utilizamos una condicion con otra y debe cumplor las dos para mostrarlas

SELECT name,year(now()) - year(birthdate) AS EDAD, gender FROM clients WHERE gender = 'f' AND name LIKE '%lop%'; # Aquí utiilizamos le agregamos un alias con AS y el nombre del alias
-- --------------------
--   COMANDO JOIN
-- --------------------
SELECT count(*) from books; -- con esto sabemos cuantos registros tiene cada tabla.
select * from authors WHERE author_id > 0 and author_id <= 5; -- con este podemos averiguar cuantos clientes hay, con esa condicion.
SELECT * FROM books WHERE author_id between 1 and 5; -- Aquí tambien estamos poniendo una consultada  como el anterior comando pero estamos diciendo que nos muestre los libros de los authors de tal rango.
SELECT book_id, author_id, title FROM books WHERE author_id between 1 and 5; 
-- -------------------
--  Vamos con JOINS
-- -------------------
SELECT b.book_id, a.name, b.title FROM books as b INNER JOIN authors as a on a.author_id = b.author_id; -- Aquie le decimos que relaciones la tabla de libros y authors siempre y cuando el author ID de cada tabla se igual.
SELECT b.book_id, a.name, b.title FROM books as b INNER JOIN authors as a on a.author_id = b.author_id WHERE a.author_id between 1 and 5; -- le damos una condicion de between
SELECT b.book_id, a.name, a.author_id, b.title FROM books as b INNER JOIN authors as a on a.author_id = b.author_id WHERE a.author_id between 1 and 5;

SELECT c.name, b.title, t.type FROM transactions AS t
JOIN books as b ON t.book_id = b.book_id	
JOIN clients AS c ON t.client_id = c.client_id;

SELECT c.name, b.title, t.type FROM transactions AS t
JOIN books as b ON t.book_id = b.book_id
JOIN clients AS c ON t.client_id = c.client_id
WHERE c.gender = 'F' AND t.type = 'sell';

SELECT  c.name, b.title, a.name, t.type
FROM transactions AS t
JOIN books as b ON t.book_id = b.book_id
JOIN clients AS c ON t.client_id = c.client_id
JOIN authors AS a ON b.author_id = a.author_id
WHERE c.gender = 'F'
AND t.type = 'sell'; # Aquí relacionamos las 4 tablas pero el ultimo join no lo relacionamos con la tabla pivote.
# Aquí estamos trayendo lo que seria quien compro el libro, que libro, de que author y en que estado esta el libro que seria vendido.

SELECT c.client_id, c.name, b.title, a.name, t.type FROM transactions AS t JOIN books as b ON t.book_id = b.book_id 
JOIN clients AS c ON t.client_id = c.client_id JOIN authors AS a ON b.author_id = a.author_id 
WHERE c.gender = 'm' AND t.type IN ('sell','lend'); # Aqui con la funcion IN le ponemos las opciones que puede retornar.

# La gente utilza el inner join sin siquiera darse cuenta, entre cruce de tablas siendo un inner join implicito:
select b.title, a.name FROM  authors as a, books as b WHERE a.author_id = b.author_id LIMIT 10;
-- # Inner JOIN explicito es el que estamos viendo ultimamente.
select b.title, a.name FROM books as b inner join authors as a ON a.author_id = b.author_id LIMIT 10;
# ------------------------
# 		LEFT JOIN
# ------------------------
select a.author_id, a.name, a.nationality, b.title 
FROM authors as a JOIN books as b on b.author_id = a.author_id 
WHERE a.author_id Between 1 and 5 ORDER BY a.author_id;
-- # Ordenamos por la clausula ORDER BY author_id

select a.author_id, a.name, a.nationality, COUNT(b.book_id) 
FROM authors as a LEFT JOIN books as b on b.author_id = a.author_id 
WHERE a.author_id Between 1 and 5 GROUP BY a.author_id ORDER BY a.author_id; -- Aqui nos mostrara que la tabla que le tiene mayor prioridad que en este caso es la tabla de authors y la de pibote es la de books

select a.author_id, a.name, a.nationality, COUNT(b.book_id) 
FROM authors as a RIGHT JOIN books as b on b.author_id = a.author_id 
WHERE a.author_id Between 1 and 5 GROUP BY a.author_id ORDER BY a.author_id; -- Aqui la tabla prioritaria es la del lado derecho que seria books, esta consulta quiere decir que todo lo que este relacionado con la tabla books sera mostrado pero lo que no este relacionado con la tabla de la izquierda no se motrara.
-- --------------------------------
-- CONSULTAS TRANSACTIONS LEFT JOIN

SELECT  C.client_id, C.name, T.type, T.created_at FROM transactions as t INNER JOIN clients as C on t.client_Id = C.client_id ; # Aqui esta mostrando cuando el cliente hizo la transaction de compra o prestamo
SELECT  C.client_id, C.name, T.type, T.created_at FROM transactions as t RIGHT JOIN clients as C on t.client_Id = C.client_id  ORDER BY t.created_at ASC; # Aqui la tabla prioritaria es la Clients con lo cual me va a mostrar todos los  registros de clients y de ultimas me mostrara los que tienen relacion con una transaction que hayan realizado.

SELECT  C.name, T.type, b.title, T.created_at FROM transactions as t JOIN clients as C on t.client_Id = C.client_id left JOIN books as b on t.book_id = b.book_id ORDER BY t.created_at ASC; # Aqui nos muestra Dos uniones entre las tablas relacionadas, y nos muestra que el cliente compro o pidio prestado tal libro en tal fecha.
SELECT  t.transaction_id, C.name, T.type, b.title, T.created_at FROM transactions as t JOIN clients as C on t.client_Id = C.client_id left JOIN books as b on t.book_id = b.book_id WHERE c.gender = 'F'; # Aqui mostramos cuantas mujeres realizaron alguna transaccion.
SELECT  t.transaction_id, C.name, T.type, b.title, T.created_at FROM transactions as t JOIN clients as C on t.client_Id = C.client_id left JOIN books as b on t.book_id = b.book_id WHERE c.gender = 'F' and t.type = 'sell'; # Aqui mostramos mujeres que comparon un libro.
SELECT  C.name, T.type, COUNT(t.client_id) FROM transactions as t JOIN clients as C on t.client_Id = C.client_id left JOIN books as b on t.book_id = b.book_id WHERE c.gender = 'F' ; # Aqui me mostrara todas las transactions que tiene la cliente que realizo una transaction.
SELECT  C.name, T.type, COUNT(t.client_id) FROM transactions as t JOIN clients as C on t.client_Id = C.client_id left JOIN books as b on t.book_id = b.book_id WHERE c.gender = 'F' GROUP BY t.type; #Aqui nos muestra cuantos libros tiene comprado y cuantos pidio prestado.

-- ---------------------------
-- SEIS 6 TIPOS DE JOINS

-- 1. INNER JOIN 
SELECT column1 , column2, column3, columnN FROM tabla_a As A 
INNER JOIN tabla_b as B ON a.pk = b.pk;

SELECT b.book_id, b.title, a.name, a.author_id, a.nationality
FROM authors AS a
INNER JOIN books AS b ON a.author_id = b.author_id
WHERE a.name LIKE 'c%';

-- 2. LEFT JOIN
SELECT b.book_id, b.title, a.name, a.author_id, a.nationality
FROM authors AS a
LEFT JOIN books AS b ON a.author_id = b.author_id
WHERE a.name LIKE 'c%';

-- 3. RIGHT JOIN 
SELECT b.book_id, b.title, a.name, a.author_id, a.nationality
FROM authors AS a
RIGHT JOIN books AS b ON a.author_id = b.author_id
WHERE a.name LIKE 'c%';

-- 4. OUTER JOIN 
-- Retorna TODAS las filas de las dos tablas, hace la union entre las filas que coinciden entre la tabla A y la tabla B.

-- SELECT column2 , column1, columnN FROM tabla_a As A FULL OUTER JOIN tabla_b as B ON a.pk = b.pk; # Este parece que ya no sirve en Mysql

SELECT b.book_id, b.title, a.name, a.author_id, a.nationality
 #FROM authors AS a OUTER JOIN books AS b ON a.author_id = b.author_id
WHERE a.name LIKE 'c%';

-- 5. LEFT EXCLUDING JOIN
-- Esta consulta retorna todas las filas de la tabla de la izquierda, que no tienen ninguna coincidencia con la tabla de la derecha.

SELECT b.book_id, b.title, a.name, a.author_id, a.nationality
FROM authors AS a
LEFT JOIN books AS b ON a.author_id = b.author_id
WHERE b.author_id is null;

-- 6. RIGHT EXCLUDING JOIN
-- Esta consulta retorna todas las filas de la tabla de la derecha, es decir la tabla B que no tienen coincidencia en la tabla de la izquierda.

SELECT b.book_id, b.title, a.name, a.author_id, a.nationality
FROM authors AS a
RIGHT JOIN books AS b 
ON a.author_id = b.author_id
WHERE b.book_id is null;
-- --------------------------------
-- Cuales son los requeirmientos de los clientes. 
-- Ahora vamos a traducir preguntas normales que podria tener el administrador de una bibloteca a QUERIES de SQL continuando con el curso:

-- 1. ¿Que nacionalidades hay?
-- 2. ¿Cuantos escritores hay de cada nacionalidad?
-- 3. ¿Cuantos libros hay de cada nacionalidad?
-- 4. ¿Cual es el promedio/desviacion standard del precio de libros?
-- 5. idem, pero por nacionalidad
-- 6. cual es el precio maximo/minimo de un libro
-- 7. ¿Como quedaria el reporte de prestamos?

-- (Siemper que trabajen con funciones como scrum(), Count(), Avg(),Max(), Min(), debemos agregar la funcion GROUP cuando en el select incluyan otra columna que deseen mostrar aparte de la funcion de agrupamiento otra columna)

-- 1. ¿Que nacionalidades hay?
SELECT nationality FROM authors; 
-- Esto tiene un problema por que nos traerea toda la columna que exista de nacionalidad de todas las tuplas.

-- hay una palabra reservada que se llama DISTINCT, al utilizar esta palabra reservada nos dara los diferentes elementos que hay en esa columna.
SELECT DISTINCT nationality FROM authors;  
SELECT DISTINCT nationality FROM authors ORDER BY nationality; 
-- -------------------
-- 2. ¿Cuantos escritores hay de cada nacionalidad?
SELECT nationality, count(author_id) from authors; # esta consulta no esta bien, por que la funcion COUNT requiere ser ordenada con GROUP BY. 	

SELECT nationality, count(author_id) AS c_authors from authors GROUP BY nationality; # Cuantos escritores hay de cada nacionalidad.

-- ORDENAR DE MAYOR A MENOR
SELECT nationality, count(author_id) AS c_authors from authors GROUP BY nationality ORDER BY c_authors DESC;

-- ORDENAR ALFABETICAMENTE
SELECT nationality, count(author_id) AS c_authors from authors GROUP BY nationality ORDER BY c_authors DESC, nationality ASC;

-- TRAER TODAS las nacioanalidades siempre y caundo esten dadas de alta de alguna forma, si ya es NULL no lo trae.
SELECT nationality, count(author_id) AS c_authors 
from authors 
WHERE nationality IS NOT NULL
GROUP BY nationality 
ORDER BY c_authors DESC, nationality ASC;

-- Treeme todas las nacionalidades en orden exceptuando los que esten excentos (null) y que sean diferentes de RUSIA.
SELECT nationality, count(author_id) AS c_authors 
from authors 
WHERE nationality IS NOT NULL
AND nationality <> 'RUS'
GROUP BY nationality 
ORDER BY c_authors DESC, nationality ASC;

SELECT nationality, count(author_id) AS c_authors 
from authors 
WHERE nationality IS NOT NULL
AND nationality NOT IN ('RUS')
GROUP BY nationality 
ORDER BY c_authors DESC, nationality ASC;

SELECT nationality, count(author_id) AS c_authors 
from authors 
WHERE nationality IS NOT NULL
AND nationality NOT IN ('RUS','ESP','AUS')
GROUP BY nationality 
ORDER BY c_authors DESC, nationality ASC;

-- SOlmanten apareceme estos tres valores, ordenados.
SELECT nationality, count(author_id) AS c_authors 
from authors 
WHERE nationality IS NOT NULL
AND nationality IN ('RUS','ESP','AUS')
GROUP BY nationality 
ORDER BY c_authors DESC, nationality ASC;
-- ----------------------------
-- 4. ¿Cual es el promedio/desviacion standar del precio de libros?

SELECT AVG(price) FROM books; # Esta funcion nos ayuda a ver el promedio de de una columna.


SELECT AVG(price) AS prom, stddev(price) AS std FROM books;  # Desviacion standar y prmedio.


SELECT nationality, COUNT(book_id) AS libros, AVG(price) AS prom, stddev(price) AS std 
FROM books as b JOIN authors as a
ON a.author_id = b.author_id 
GROUP BY nationality
ORDER BY libros DESC
-- ----------------------------
-- 6. Cual es el precio maximo/minimo de un libro.

SELECT nationality, MAX(price), MIN(price) 
FROM books as b JOIN authors as a
ON a.author_id = b.author_id
GROUP BY nationality
-- ----------------------------
-- Como quedaria el reporte final de prestamos, quien rento o quien, que libro y cuando fue.

SELECT c.name, t.type, b.title, a.name, a.nationality
FROM transactions AS t
LEFT JOIN clients AS C
ON c.client_id = t.client_id
-- -------------------------------
COMANDOS UPDATE Y DELETE

TRUCO (Ordenar aleatoriamente)
select * from authors order BY rand() limit 10;

-- DELETE 
-- SIEMPRE QUE SE HACE UN DELETE O UN UPDATE COLOCAR AL FINAL UN LIMIT 1.
DELETE FROM authors where author_id = 161 LIMIT 1;

-- UPDATE
-- Vamos a desactivar añgunas tuplas con UPDATE 
UPDATE tabla 
SET 
  [columna = valor]
WHERE 
  [condiciones]
LIMIT 1;

UPDATE clients
SET active = 0
WHERE client_id = 80 LIMIT 1;

-- Podemos modificar cualquier cosa con un valor nuevo

UPDATE tabla 
SET 
  email = 'javier@gmail.com'
WHERE 
  client_id = 7
  OR client_id = 9

DESCIVAMOS A VARIOS 
UPDATE clients 
SET 
  active = 0
WHERE 
  client_id IN (1,6,8,27,90)
  OR name LIKE '%Lopez%'

Select client_id, name, active from clients WHERE 
  client_id IN (1,6,8,27,90)
  OR name LIKE '%Lopez%'

-- Vamor a vaciar la tabla transactions;
truncate transactions;

drop table if exists fabricante;
drop table if exists producto;
-- --------------------------------
-- un quiere para hacer un reporte (una matriz), utilizando condicionales en las columnas.
-- vamos a realizar un super QUIERE

select distinct nationality from authors;

-- vamos actualizar una nacionalidad.

UPDATE authors
SET nationality = 'GBR'
WHERE nationality = 'ENG'

SELECT count(book_id) from books;
SELECT count(book_id), sum(1) from books;

-- Para saber cuanto podre ganar por mi cantidad de libros que tengo y la cantidad de copias que tengo.

SELECT sum(price*copies) FROM books WHERE sellable = 1;

SELECT sellable, sum(price*copies) FROM books group by sellable;

-- utilizar el sum de una forma mas inteligente, utilizando condicionales.

-- contemos cuantos libros hay antes de 1950 y cuantos libros hay posteriores a 1950.
SELECT count(book_id), sum(if(year < 1950, 1, 0)) as '<1950' FROM Books;

-- vamos a comprobar lo mismo de otra manera.
SELECT count(book_id) FROM books WHERE year <= 1950 # se ve que no tiene como gran diferencia, la diferencia lo que hace es que le damos inteligencia a nuestras consultas.

-- Quiero tener posterior y anterior a 1950
SELECT count(book_id), 
  sum(if(year < 1950, 1, 0)) as '<1950',
  sum(if(year < 1950, 0, 1)) as '>1950' 
FROM Books;

-- Tabla un poco mas compleja
-- Observando la cantidad de libros por una determinada fecha.
SELECT count(book_id), 
  sum(if(year < 1950, 1, 0)) as '<1950',
  sum(if(year >= 1950 and year < 1990, 1, 0)) as '<1900',
  sum(if(year >= 1990 and year < 2000, 1, 0)) as '<2000',
  sum(if(year >= 2000, 1, 0)) as '<hoy' 
FROM Books;

-- Ademas de que pais por seccion de año podemos dividir el año de seccion de libro que contenga.
SELECT nationality, count(book_id),
  sum(if(year <1950, 1, 0)) as '<1950',
  sum(if(year >= 1950 and year < 1900, 1, 0)) as '<1900',
  sum(if(year >= 1990 and year < 2000, 1, 0)) as '<2000',
  sum(if(year >= 2000, 1, 0)) as '<hoy'
from books as b
JOIN authors as a
  on  a.author_id = b.author_id
WHERE a.nationality is not null 
GROUP BY nationality

-- -------------------------------
-- vamos a ver un comando ageno de sql que es ( mysqldump) que nos ayudara hacer respaldos de bases de datos y como podemos hacer de este uso de buenas practicas para tener un versionado de las bases de datos.
-- Supongamos que vamos a agregar el año que nacio alguien (Comando alter)
ALTER table authors add column birthyear integer default 1930 after name 
-- la palabra after significa Significa colocarlo despues de la columna, podemos utilizar la palabra firts para luego porder.

-- Si queremos modificar el tipo de columna:

ALTER TABLE authors 
modify column birthyear 
year default 1920;

-- Eliminar una columba con ALTER y DROP.
ALTER TABLE authors DROP COLUMN birthyear;

-- TRUCO RAPIDO (El laki tambien puede usarse en las tablas y las columnas 
SHOW TABLES LIKE '%i%';

-- ----------------------------

-- CUANDO NECESITAMOS ALMACENAR O HACER un BACKUP, hay dos manera desde mysql pero no es parte de mysql, es una herramienta del sistema se llama mysqldump

-- Vamos hacer dos casos:
-- 1. Traernos toda las bases de datos a un archivo de texto para despues ingresarlo o crear la base de datos.
-- 2. Traer solo el squema.

-- TRUNCATE table_name SET (column_value = valuees) WHERE column_Values = value; Actualiza una tupla.
-- mysqldump -u user -p database_name > esquema.sql - guarda el esquema de una base de datos con todo y datos en un archivo sql.
-- mysqldump-u user -p database_name  Es parecido al comando anterior solo que aqui no se guardan los datos.

-- Vamos a usar mysqldump las banderas son muy parecidas.
mysqldump -u root -p library 
# Este ultimo argumento o bandera es que base de dato es.
-- Nos mostrara un monton de cosas, que es todo lo que realizamos, esto esta bien y nos sirve para un respaldo local nuestro.
-- Pero si nosotros queremos versionar el schema es decirle que nos traiga solo el schema.
mysqldump -u root -p -d library; # El argumento -d es, sin datos. 
-- TRUCO
mysqldump -u root -p -d library | more; # significa paginame de lo que vaya a traer ahorita.

mysqldump -u root -p -d library > esquema.sql