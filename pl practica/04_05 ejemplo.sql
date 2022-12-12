-- EJEMPLO 4

-- FUNCION QUE SUMA LOS n PRIMEROS NUMEROS ENTEROS.
-- ESTRUCTURA DE ITERACION

CREATE OR REPLACE FUNCTION adicion(int) 
    RETURNS int
AS $$
DECLARE
-- ESTRUCTURA DE ITERACION
    cont int := 1;
    res int := 0;
    n int := $1;
BEGIN
-- Esto se va ir repitiendo siempre que el contador sea menor que n que, n es el limite de numero maximo de valores sobre los cuales quiero sumar.
    WHILE(cont <= n) 
        LOOP 
            res := res + cont;
            cont := cont + 1;
        END LOOP;
    RETURN res;
END;
$$ LANGUAGE plpgsql;
--------------------------------
-- EJEMPLO 5
-- SUMA con FOR

CREATE OR REPLACE FUNCTION sumaFor()
    RETURNS int
AS $$
DECLARE
    cont int;
    res int := 0;
BEGIN
-- En la itecion for tenemos que saber hasta donde deve terminar
-- por eso podemos ver que 1..10 es el rango q va a iterar, 
-- donde los dos puntos nos indican el limite.
    FOR cont in 1..10
        LOOP 
            res := res + cont;
        END LOOP;
    RETURN res;
END;
$$ LANGUAGE plpgsql;

SELECT sumaFor() -- Esta funcion no recibe parametro ya que solo suma los 10 primero numeros.
