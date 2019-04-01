set serveroutput on;
   DROP TABLE TEMA2;
   CREATE TABLE TEMA2 (A NUMBER(5), B NUMBER(1));
DECLARE
   numar INTEGER := 0;
   divizor INTEGER;
   suma_cifre INTEGER;
   constanta INTEGER := 5;
   flag INTEGER;
BEGIN
   FOR numar IN 1..10000 LOOP
       suma_cifre := numar mod 10 + FLOOR(numar / 10) mod 10 + FLOOR(numar / 100) mod 10 +  FLOOR(numar / 1000) mod 10 + FLOOR(numar / 10000) mod 10;
       flag := 1;
       IF(suma_cifre mod 9 = constanta)
       THEN
            FOR divizor IN 2..numar/2 LOOP
                IF (numar MOD divizor = 0)
                THEN
                    flag := 0;
                END IF;
            END LOOP;
        INSERT INTO TEMA2 VALUES(numar, flag);
       END IF; 
    END LOOP;
END;
--select * from TEMA2;