create index index_name on note(id_student);
create index index_prieten1 on prieteni(id_student1);
create index index_idValoare on note(id_student, valoare);
--drop index index_name;
--drop index index_prieten1;
--drop index index_idValoare;
/
CREATE OR REPLACE PROCEDURE truncAvg_egale as 
id_prieten1 prieteni.id_student1%TYPE;
id_prieten2 prieteni.id_student2%TYPE;
media1 note.valoare%TYPE;
media2 note.valoare%TYPE;
CURSOR lista_studenti IS SELECT id from studenti;
CURSOR lista_prieteni IS SELECT id_student2 from prieteni where id_student1=id_prieten1;
BEGIN
    FOR v_std_linie_studenti IN lista_studenti LOOP  
        id_prieten1 := v_std_linie_studenti.id;
        select trunc(avg(valoare)) into media1 from note where id_student = id_prieten1;
        FOR v_std_linie_prieteni IN lista_prieteni LOOP
        select trunc(avg(valoare)) into media2 from note where id_student = v_std_linie_prieteni.id_student2;
        IF(media1 = media2) THEN
              DBMS_OUTPUT.PUT_LINE(id_prieten1||'-'||v_std_linie_prieteni.id_student2); 
        END IF;
        END LOOP;
    END LOOP;
END truncAvg_egale;
/
set serveroutput on;
BEGIN
truncAvg_egale();
END;
