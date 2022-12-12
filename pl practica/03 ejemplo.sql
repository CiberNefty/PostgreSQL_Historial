-- EJEMPLO 3

-- FUNCION QUE DETERMINA SI UN CIERTO NUMERO ES POSITVO O NEGATIVO

CREATE OR REPLACE FUNCTION esPositivo(int)
    RETURNS boolean;
AS $$
DECLARE
-- Ejemplo 3: determinar si un cierto numero es positivo o negativo
    a int;
    res boolean := false;
BEGIN
    a := $1; -- Aqui tomamos el parametro de la posicion 1 y lo asignamos a (a).
    IF (a > 0) THEN
        res := TRUE;
    ELSE
        IF (a = 0) THEN
            res := TRUE;
        END IF;
    END IF;
    RETURN res;
END;

SELECT esPositivo(-1);
SELECT esPositivo(0);
$$ LANGUAGE plpgsql;