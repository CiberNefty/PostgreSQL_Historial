Select Vino, Anaquel, Productor From Vinos Where Listo = 1991;
Select Vino, Productor From Vinos Where Anaquel = 72;
Select Vino, Productor From Vinos Where year > 1987;
Select Anaquel, vino, year From Vinos Where Listo < 90;
Select Vino, Anaquel , year From Vinos Where Productor = 'Buena vista' And Botellas > 1;
Select Anaquel, Vino, Botellas From Vinos Where Productor = 'Mirassou';
Select Anaquel, Vino From Vinos Where Botellas > 5;
Select Anaquel From Vinos Where Vino = 'Cab Sauvignon' Or Vino = 'Pinot Noir'
Or Vino = 'Zinfaldel' Or Vino = 'Gamay';
SELECT anaquel, vino FROM vinos WHERE vino = 'Cab Sauvignon' AND Vino = 'Pinot Noir'
AND Vino = 'Zinfaldel' AND Vino = 'Gamay';

Insert Into Vinos Values (53, 'Pinot Noir', 'Saintsbury', 1987, 1 , 1993, 'Para Navidad');
Insert Into Vinos Values (80, 'Merlot', 'Clos du Bois', 1988, 12, 1992, 'Navidad') ;
Insert Into Vinos Values (5, 'Chardonnay', 'Mirassou' , 1988, 12, 1992, 'Primer premio');

Update Vinos Set Botellas = 4 Where Anaquel = 3;
Update Vinos Set Botellas = 5 Where Anaquel = 50;
Update Vinos Set Botellas = Botellas + 2 Where Anaquel = 50;
Update Vinos Set Botellas = Botellas + 3 Where Anaquel = 30;

Delete From Vinos Where Anaquel = 2;
Delete From Vinos Where Listo > 1991;
Delete From Vinos Where Vino = 'Chardonnay';
#--------------------------------------------------------------------------------------------
select vino, productor, year FROM vinos LIMIT 10;
select vino, productor, year FROM vinos WHERE year >1963 ;
SELECT * FROM vinos WHERE vino LIKE '%ot%'; #Con esta consulta estamosbuscando todos los datos que contengan 'ot' en sus inicios o finales.
SELECT * FROM vinos WHERE vino LIKE '%C%' AND botellas >5;
SELECT *  FROM vinos WHERE vino LIKE '%C';
SELECT *  FROM vinos WHERE vino LIKE '_o%';
SELECT *  FROM vinos WHERE vino LIKE '%_a_';
SELECT ANAQUEl as ID,vino AS 'Estos son los vinos' FROM vinos; #Aqui le dimos un alias con la funcion AS y nos damos cuenta que por defecto el sistema no molesta por no colocarle comillas al alias.
SELECT ANAQUEl as ID,vino AS 'Estos son los vinos' FROM vinos WHERE Listo / 2; #aquie nos muestra todos los vinos pero se pueden realizar operaciones con palabras recerbadas.
SELECT ANAQUEl as ID,vino AS 'Estos son los vinos' FROM vinos WHERE Listo > 1990 AND vino LIKE '%on%';
SELECT count(*) FROM VINOS;
SELECT count(anaquel) FROM VINOS; #Esta funcion nos lista toda la cantidad de registros que tengamos dentro de una tabla.
SELECT * FROM vinos WHERE anaquel > 0 and anaquel <= 5; #Esta consulta nos ayuda a traer registros hasta una cantidad exacta.
SELECT * FROM vinos WHERE anaquel BETWEEN 1 and 13; #Esta funcion nos ayuda a traer registros hasta una cantidad exacta con BETWEEN.


POSD: Podemos observar que a la hora de utilizar postgresql sabiendo que este archivo
     que cree viene de Mysql Wordbench no nos permite hacer lo sigueinte;

     1. Los alias no los deja colocar con comillas simples.
     2. Las operaaciones recebadas en mysql a la hora de hacer un WHERE no deja hacer operacion eje: 
        a int := 20;
        WHERE a / 2;  No dejara hacer operacion por que la variable (a) no es  boolean.
        Esto no quiere decir que PostgreSQL no admita operaciones.
    