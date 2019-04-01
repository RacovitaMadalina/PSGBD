set serveroutput on;
DECLARE
    limita_depasita EXCEPTION;
    PRAGMA EXCEPTION_INIT(limita_depasita, -20001);
    id_student studenti.id%type;
    valoare_majorare INTEGER;
    CURSOR lista_studenti IS select * from (SELECT id, bursa, nume, prenume, bursa_initiala from studenti where bursa is not null) where rownum<11; 
    bursa_dupa_apel studenti.bursa%type;
    bursa_init studenti.bursa%type;
    
    PROCEDURE majorare(id_stud studenti.id%type, val_majorare INTEGER)
    IS
    bursa_student studenti.bursa%type;
    bursa_modificata studenti.bursa%type;
    BEGIN
         select nvl(bursa,0) into bursa_student from studenti where id = id_stud;
         bursa_modificata := bursa_student + val_majorare;
         IF(bursa_modificata>3000) THEN
              DBMS_OUTPUT.PUT_LINE('Pentru studentul '||id_stud||' valoarea bursei dupa majorare a depasit 3000 lei');
              bursa_modificata := 3000;
              UPDATE studenti set bursa = bursa_modificata where id = id_stud;
              raise limita_depasita;
         ELSE DBMS_OUTPUT.PUT_LINE('Pentru studentul '||id_student||' valoarea bursei dupa majorare este '||bursa_modificata);
              UPDATE studenti set bursa = bursa_modificata where id = id_stud;
         END IF;
    EXCEPTION
    WHEN limita_depasita THEN
        DBMS_OUTPUT.PUT_LINE('Dupa majorare, bursa a ajuns la o valoare mai mare de 3000.');
    END majorare;
BEGIN
    FOR i in 1..1025 LOOP
        select nvl(bursa,0) into bursa_init from studenti where id = i;
        update studenti set bursa_initiala = bursa_init where id = i;
    END LOOP;
    FOR i in 1..1025 LOOP
        --id_student := DBMS_random.value(1,1000);
        valoare_majorare := 2100;
        DBMS_OUTPUT.PUT_LINE('Majoram pentru studentul '||i||' bursa, cu '||valoare_majorare||' lei.');
        majorare(i, valoare_majorare);
    END LOOP; 
    
    FOR v_std_linie in lista_studenti LOOP
        valoare_majorare := v_std_linie.bursa - v_std_linie.bursa_initiala;
        DBMS_OUTPUT.PUT_LINE('Pentru studentul '||v_std_linie.nume||' '||v_std_linie.prenume||' bursa noua este '||v_std_linie.bursa||' si a fost majorata cu '
        ||valoare_majorare);
    END LOOP;      
END;
--ALTER TABLE studenti add bursa_initiala INTEGER;


