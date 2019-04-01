set serveroutput on;
DECLARE
   firstFibonacci INTEGER;
   secondFibonacci INTEGER;
   nextFibonacci INTEGER;
   flag INTEGER;
   CURSOR cursor_numarAles IS SELECT * FROM TEMA2;
   numar INTEGER;
BEGIN
    FOR v_linie IN cursor_numarAles LOOP
       firstFibonacci := 0;
       secondFibonacci := 1;
       nextFibonacci := firstFibonacci + secondFibonacci;
       WHILE nextNumber < v_linie.A LOOP
            firstFibonacci := secondFibonacci;
            secondFibonacci := nextFibonacci;
            nextFibonacci := firstFibonacci + secondFibonacci;
       IF (v_linie.A = 5) 
            THEN 
                 UPDATE note SET valoare=5 WHERE CURRENT OF update_note;
       END IF;
   END LOOP;
END;