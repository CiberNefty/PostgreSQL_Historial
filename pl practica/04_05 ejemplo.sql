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

