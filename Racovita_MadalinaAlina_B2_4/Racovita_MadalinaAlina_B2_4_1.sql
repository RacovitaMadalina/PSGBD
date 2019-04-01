CREATE OR REPLACE PACKAGE modificari_burse IS
TYPE inregistrare_student IS RECORD(id_student studenti.id%type, procent_crestere INTEGER );
TYPE vector_studenti IS VARRAY(30) OF inregistrare_student;
PROCEDURE crestere_bursa (lista vector_studenti);
PROCEDURE afisare_cresteri;
END modificari_burse;
/

CREATE OR REPLACE PACKAGE BODY modificari_burse IS

    PROCEDURE crestere_bursa (lista vector_studenti) IS
    bursa_actuala studenti.bursa%TYPE;
    bursa_modificata FLOAT;
    marire vector;
    istoric vector := new vector(null);
    numar_modificari INTEGER := 0;
    BEGIN 
        FOR i in lista.FIRST..lista.LAST LOOP
              select nvl(bursa,0) into bursa_actuala from studenti where id = lista(i).id_student;
              select istoric_mariri into istoric from studenti where id = lista(i).id_student;
              IF(istoric is null) THEN 
                  numar_modificari := 0;
              ELSE
                  numar_modificari := istoric.last;
              END IF;
              IF(numar_modificari = 0) THEN
                  IF(bursa_actuala = 0) THEN
                      bursa_actuala := 100;
                      marire := vector(100);
                  ELSE
                      marire := vector(bursa_actuala);
                  END IF;    
                  bursa_modificata := to_binary_float(bursa_actuala + bursa_actuala *lista(i).procent_crestere / 100);
                  marire.extend(1);
                  marire(2) := bursa_modificata;
                  UPDATE studenti set istoric_mariri = marire where id = lista(i).id_student;
              else
                  bursa_actuala := istoric(numar_modificari);
                  marire := istoric;
                  bursa_modificata := to_binary_float(bursa_actuala + bursa_actuala *lista(i).procent_crestere / 100);
                  marire.extend(1);
                  marire(numar_modificari + 1) := bursa_modificata;
                  UPDATE studenti set istoric_mariri = marire where id = lista(i).id_student;
              END IF;
              IF(bursa_actuala = 100) THEN
                  DBMS_OUTPUT.PUT_LINE('Studentul cu id-ul: '||lista(i).id_student||' avea bursa inainte de modificari 0 iar dupa crestere cu procentul '||
                  lista(i).procent_crestere||' are: '||bursa_modificata);
              ELSE
                  DBMS_OUTPUT.PUT_LINE('Studentul cu id-ul: '||lista(i).id_student||' avea bursa inainte de modificari '||bursa_actuala||' iar dupa crestere 
                  cu procentul '||lista(i).procent_crestere||' are: '||bursa_modificata);
              END IF;
        END LOOP;
    END crestere_bursa;
    
    PROCEDURE afisare_cresteri IS
    CURSOR lista_studenti IS SELECT nume, prenume, istoric_mariri FROM studenti where istoric_mariri is not null;
    BEGIN
        FOR v_std_linie in lista_studenti LOOP
             DBMS_OUTPUT.PUT_LINE('Studentul '||v_std_linie.nume||' '||v_std_linie.prenume||'are urmatoarele cresteri de bursa: ');
             FOR j in v_std_linie.istoric_mariri.first..v_std_linie.istoric_mariri.last LOOP
                  DBMS_OUTPUT.PUT_LINE(v_std_linie.istoric_mariri(j));
             END LOOP;
             DBMS_OUTPUT.PUT_LINE(' ');
        END LOOP;
    END afisare_cresteri;
END modificari_burse;
/

set serveroutput on;
DECLARE
lista modificari_burse.vector_studenti;
id_random INTEGER;
BEGIN
    lista := modificari_burse.vector_studenti();
    lista.EXTEND(30);
    DBMS_OUTPUT.PUT_LINE(' ------------LISTA INITIALA---------- ');
    FOR i IN 1..30 LOOP
         id_random := DBMS_RANDOM.VALUE(1,1000);
         lista(i).id_student := 1025-i;
         lista(i).procent_crestere := DBMS_RANDOM.VALUE(1,100);
    END LOOP;
    modificari_burse.crestere_bursa(lista);
    modificari_burse.afisare_cresteri;
END;
/

--CREATE TYPE vector IS VARRAY(30) OF FLOAT;
--ALTER TABLE studenti drop column istoric_mariri;
--ALTER TABLE studenti add istoric_mariri vector;
 
  