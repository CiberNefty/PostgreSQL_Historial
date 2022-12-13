DROP DATABASE IF EXISTS vinoteca_sinRelaciones;
CREATE DATABASE IF NOT EXISTS vinoteca_sinRelaciones;
USE vinoteca_sinRelaciones;
SHOW TABLES;
DROP TABLE IF exists vinos;

CREATE TABLE IF NOT exists vinos(
anaquel serial NOT NULL,
vino varchar(35) not null,
productor varchar(25) not null,
year int not null default '1900',
botellas int not null default '1',
listo int not null,
description text,
PRIMARY KEY (anaquel)
);
SELECT * FROM vinos;
DELETE FROM vinos;
INSERT INTO vinos(anaquel, vino, productor, year, botellas, listo) VALUES(2,'Chardonnay','Buena Vista', 1988, 1,1991);
INSERT INTO vinos(anaquel,vino, productor, year, botellas, listo) VALUES (3,'Chardonnay','Louis Martino', 1989,5,1990);
INSERT INTO vinos (anaquel,vino,productor,year,Botellas,listo,description) VALUES(6,'Chardonnay','Chappellet',1987,4,1991,'Dia de gracia');
## ---------------------------------------------------
INSERT INTO vinos(anaquel,vino,productor,year,botellas,listo,description) 
VALUES (11,'Jo. Riesling','Jekel',1989,10,1992,null),
(12,'Jo. Riesling','Buena Vista',1987,1,1992,'Cosecha tarde'),
(16,'Jo. Riesling','Sttui',1987,1,1989,'Muy seco');
# ---------------------------------------------------------
INSERT INTO vinos VALUES(21,'Fume Blanc','Ch. St. Jean',1988,4,1991,'Robt. Flores'),
(22,'Fume Blanc','Robt. Maldavi',1987,2,1990,null),
(25,'Borgona blanco','Mirassou',1986,6,1989,null),
(30,'Gewurztraminer','Buena Vista',1987,3,1990,null);
INSERT INTO vinos VALUES(43,'Cab Sauvignon','Robt. Maldavi',1982,12,1992,null),
(50,'Pinot Noir','Mirassou',1982,3,1990,'Cosecha'),
(51,'Pinot Noir','Ch. St. Jean',1986,2,1992,null),
(72,'Gamay','Robt. Maldavi',1085,2,1990,null),
(64,'Zinfaldel','Mirassou',1984,9,1992,null);

INSERT INTO vinos VALUES (80,'Merlot','Clos du Bois',1988, 12,1992,'Navidad'),
(53, 'Pinot Noir', 'Saintsbury', 1987, 1 , 1993, 'Para Navidad');