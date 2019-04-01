/*CREATE TABLE StudentiErasmus (
nr_matricol VARCHAR2(6) NOT NULL PRIMARY KEY,
nume VARCHAR2(15) NOT NULL,
prenume VARCHAR2(30) NOT NULL, 
tara INTEGER NOT NULL
);*/

CREATE OR REPLACE PROCEDURE inserare_student
IS
student_deja_existent EXCEPTION;
PRAGMA EXCEPTION_INIT(student_deja_existent, -20001);
id_random INTEGER;
numar_matricol studenti.nr_matricol%type;
nume_student studenti.nume%type;
nr_studenti_existenti INTEGER;
prenume_student studenti.prenume%type;
id_tara INTEGER;
BEGIN
    id_random := DBMS_random.value(1,1000);
    select nr_matricol into numar_matricol from studenti where id = id_random;
    select nvl(count(nr_matricol), 0) into nr_studenti_existenti from StudentiErasmus where nr_matricol = numar_matricol;
    select nume into nume_student from studenti where id = id_random;
    select prenume into prenume_student from studenti where id = id_random;
    IF(nr_studenti_existenti != 0) THEN
         DBMS_OUTPUT.PUT_LINE('Studentul cu nr_matricol '||numar_matricol||' pe nume '||nume_student||'  '||prenume_student||' NU A FOST copiat cu succes.');
         raise student_deja_existent;
    ELSE  id_tara := DBMS_random.value(1,30);
         INSERT INTO StudentiErasmus(nr_matricol, nume, prenume, tara) VALUES(numar_matricol, nume_student, prenume_student, id_tara);
         DBMS_OUTPUT.PUT_LINE('Studentul cu nr_matricol '||numar_matricol||' pe nume '||nume_student||'  '||prenume_student||' A FOST copiat cu succes.');
    END IF;
    EXCEPTION
    WHEN student_deja_existent THEN
      DBMS_OUTPUT.PUT_LINE('Am gasit un student deja existent in tabela.');
END;
/
set serveroutput on;
BEGIN
     FOR i in 1..100 LOOP
           inserare_student;
     END LOOP;
END;
