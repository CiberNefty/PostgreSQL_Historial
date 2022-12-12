-- EJEMPLO 6
-- MANEJOR DE FECHAS

SELECT age(current_date,date '1998-02-22');

-- Si queremos ver esto mismo tenemos que crear una cadena formateada.

CREATE OR REPLACE FUNCTION fun_tiempo(date,date)
-- Esta funcion recibe dos parametros la fecha de inicio y la fecha final y me va a devolver una cadena formateada con el resultado en español.
    RETURNS varchar(50)
AS $$
DECLARE
    g varchar(150);
BEGIN
-- Esta variable g la estoy inicializando con el resultado de un
-- remplazamiento, estamos internamente invocando la funcion age para la fecha inicial y,
-- la fecha final y esto me devolver un tipo varchar y, sobre ese varchar incovamos
-- un manejo de cadenas que es replace, entonces donde quiera que se encuentre year se
-- remplazara con año, etc.
    g := replace(
            replace(
                replace(
                    replace(
                        upper(
                            (age($1,$2)) :: varchar)
                    ,'YEAR','AÑO')
                ,'MONS','MESES')
            ,'MON','MES')
        ,'DAY','DIA');
    return g;
END;
$$ LANGUAGE plpgsql;
SELECT fun_tiempo(current_date'1987-01-01');
SELECT age(current_date,'1987-01-01');

$$ LANGUAGE plpgsql;