CREATE OR REPLACE PACKAGE management_faculty IS
FUNCTION compute_age (date_of_birth DATE) RETURN VARCHAR2;
PROCEDURE add_student (nume studenti.nume%type, prenume studenti.prenume%type);
PROCEDURE delete_student (nr_matr studenti.nr_matricol%type);
PROCEDURE infos_student (nume studenti.nume%type, prenume studenti.prenume%type);
END management_faculty;
/
CREATE OR REPLACE PACKAGE BODY management_faculty IS
    FUNCTION compute_age (date_of_birth DATE) RETURN VARCHAR2 AS
    age_years NUMBER(10);
    age_months NUMBER;
    age_days NUMBER;
    age VARCHAR2(100); 
    BEGIN
       age_years := FLOOR((sysdate - date_of_birth)/365);
       age_months := FLOOR(months_between(sysdate,date_of_birth)) - age_years * 12;
       age_days := TRUNC(sysdate-add_months(date_of_birth,age_months + age_years * 12));
       age := age_years||' ani '||age_months||' luni '||age_days||' zile ';
       RETURN age;
    END compute_age;
    
    PROCEDURE add_student (nume studenti.nume%type, prenume studenti.prenume%type) IS
    id_studentNou studenti.id%type;
    nr_matricol_random studenti.nr_matricol%type;
    auxilary number;
    an_student studenti.an%type;
    nota_aleasa note.valoare%type;
    id_nota note.id%type;
    e_mail studenti.email%type;
    zi_nastere INTEGER;
    luna_nastere INTEGER;
    an_nastere INTEGER;
    dataNastere studenti.data_nastere%type;
    createdAt studenti.created_at%type;
    updatedAt studenti.updated_at%type;
    nr_prieteni INTEGER;
    grupa_student studenti.grupa%type;
    id_prietenie prieteni.id%type;
    CURSOR lista_cursuri IS SELECT * from cursuri;
    CURSOR lista_studenti IS select id from studenti where id <= nr_prieteni;
    BEGIN
       select max(id)+1 into id_studentNou from studenti;
       DBMS_OUTPUT.PUT_LINE('ID-ul studentului va fi: '||id_studentNou);
       
       auxilary := 1;
       while (auxilary != 0) LOOP
          nr_matricol_random := FLOOR(DBMS_RANDOM.VALUE(100,999)) || CHR(FLOOR(DBMS_RANDOM.VALUE(65,91))) || CHR(FLOOR(DBMS_RANDOM.VALUE(65,91))) || FLOOR(DBMS_RANDOM.VALUE(0,9));
          select nvl(count(nr_matricol),0) into auxilary from studenti where nr_matricol = nr_matricol_random;
       END LOOP;
       DBMS_OUTPUT.PUT_LINE('Numarul matricol al studentului va fi: '||nr_matricol_random);
      
       an_student := FLOOR(DBMS_RANDOM.VALUE(1,3));
       grupa_student := CHR(FLOOR(DBMS_RANDOM.VALUE(65,66)))||an_student;
       e_mail := nume||'.'||prenume||'@gmail.com';
       createdAt := sysdate;
       updatedAt := sysdate;
       zi_nastere := FLOOR(DBMS_RANDOM.VALUE(1,28));
       luna_nastere := FLOOR(DBMS_RANDOM.VALUE(1,12));
       an_nastere := FLOOR(DBMS_RANDOM.VALUE(1975,1997));
       dataNastere := to_date(zi_nastere||'/'||luna_nastere||'/'||an_nastere);
       
       DBMS_OUTPUT.PUT_LINE('Anul din care face parte studentul va fi:'||an_student);
       INSERT INTO studenti(id, nr_matricol, nume, prenume, an,grupa, email, DATA_NASTERE, CREATED_AT, UPDATED_AT) VALUES 
       (id_studentNou, nr_matricol_random, nume, prenume, an_student,grupa_student, e_mail, dataNastere, createdAt, updatedAt);
       IF(an_student = 2) THEN
           FOR v_std_linie IN lista_cursuri LOOP 
               IF(v_std_linie.an = 1) THEN
                    nota_aleasa := FLOOR(DBMS_RANDOM.VALUE(4,10));
                    select max(id)+1 into id_nota from note;
                    INSERT INTO note VALUES(id_nota, id_studentNou, v_std_linie.id, nota_aleasa, NULL, NULL, NULL);
               END IF;
           END LOOP;
        ELSE IF(an_student = 3) THEN
                FOR v_std_linie IN lista_cursuri LOOP 
                   IF((v_std_linie.an = 1) OR (v_std_linie.an = 2)) THEN
                        nota_aleasa := FLOOR(DBMS_RANDOM.VALUE(4,10));
                        select max(id)+1 into id_nota from note;
                        INSERT INTO note VALUES(id_nota, id_studentNou, v_std_linie.id, nota_aleasa, NULL, NULL, NULL);
                   END IF;
                END LOOP;
              END IF;  
        END IF;
       nr_prieteni := FLOOR(DBMS_RANDOM.VALUE(1,50));
       select max(id) into id_prietenie from prieteni;
       id_prietenie := id_prietenie + 1;
       FOR v_std_linie IN lista_studenti LOOP
            insert into prieteni(id, id_student1, id_student2) values (id_prietenie, id_studentNou, v_std_linie.id);
            id_prietenie := id_prietenie + 1;
        END LOOP;
    END add_student;
    
    PROCEDURE delete_student (nr_matr studenti.nr_matricol%type) IS
    id_stud studenti.id%type;
    BEGIN
    select id into id_stud from studenti where nr_matricol=nr_matr;
    delete from prieteni where prieteni.id_student1=id_stud or prieteni.id_student2=id_stud;
    delete from note where note.id_student=id_stud;
    delete from studenti where nr_matricol=nr_matr;
    END delete_student;
    
    PROCEDURE infos_student (nume studenti.nume%type, prenume studenti.prenume%type) IS
    nr_matricol_stud studenti.nr_matricol%type;
    id_stud studenti.id%TYPE;
    data_nastere_stud studenti.data_nastere%TYPE;
    CURSOR lista_studenti IS SELECT * from studenti;
    CURSOR lista_note IS SELECT * FROM note join cursuri on note.id_curs = cursuri.id;
    media_anul1 FLOAT;
    media_anul2 FLOAT;
    media_anul3 FLOAT;
    media_total FLOAT;
    grupa_stud studenti.grupa%type;
    an_stud studenti.an%TYPE;
    loc_grupa INTEGER;
    CURSOR lista_colegi IS SELECT id_student, avg(valoare) FROM studenti join note on studenti.id=note.id_student where grupa=grupa_stud and an=an_stud group by id_student order by 2 desc;
    CURSOR lista_prieteni IS SELECT id_student1, id_student2 FROM prieteni where id_student1=id_stud or id_student2 = id_stud;
    nume_prieten studenti.nume%type;
    prenume_prieten studenti.prenume%type;
    BEGIN
        FOR v_std_linie IN lista_studenti LOOP 
            IF(v_std_linie.nume = nume AND v_std_linie.prenume = prenume) THEN
                 nr_matricol_stud := v_std_linie.nr_matricol;
                 id_stud := v_std_linie.id;
                 DBMS_OUTPUT.PUT_LINE('Studentul '||nume||' '||prenume||' are numarul matricol: '||nr_matricol_stud);
                 DBMS_OUTPUT.PUT_LINE(' ');
                 DBMS_OUTPUT.PUT_LINE(' ****FISA MATRICOLA**** ' );
                 FOR v_std_linie_note IN lista_note LOOP
                     IF(v_std_linie_note.id_student = id_stud) THEN
                          DBMS_OUTPUT.PUT_LINE('Cursul: '||v_std_linie_note.titlu_curs||', din anul: '||v_std_linie_note.an||', nota: '
                          ||v_std_linie_note.valoare||', data notare: '||v_std_linie_note.data_notare);
                     END IF;
                 END LOOP;
                 DBMS_OUTPUT.PUT_LINE(' ');
                 select data_nastere into data_nastere_stud from studenti where nr_matricol=nr_matricol_stud;
                 DBMS_OUTPUT.PUT_LINE(' ');
                 
                 IF(v_std_linie.an =1) THEN 
                     select avg(valoare)into media_anul1 from note where note.id_student=id_stud group by id_student;
                     DBMS_OUTPUT.PUT_LINE('Media studentului in anul 1 este: '||media_anul1);
                 ELSE IF(v_std_linie.an =2) THEN
                         select avg(note.valoare) into media_anul1 from note join cursuri on note.id_curs=cursuri.id where note.id_student=id_stud and cursuri.an=1 group by note.id_student;
                         DBMS_OUTPUT.PUT_LINE('Media studentului in anul 1 a fost: '||media_anul1);
                         select avg(note.valoare) into media_anul2 from note join cursuri on note.id_curs=cursuri.id where note.id_student=id_stud and cursuri.an=2 group by note.id_student;
                         DBMS_OUTPUT.PUT_LINE('Media studentului in anul 2 este: '||media_anul2);
                      ELSE IF(v_std_linie.an =3) THEN
                                select avg(note.valoare) into media_anul1 from note join cursuri on note.id_curs=cursuri.id where note.id_student=id_stud and cursuri.an=1 group by note.id_student;
                                DBMS_OUTPUT.PUT_LINE('Media studentului in anul 1 a fost: '||media_anul1);
                                select avg(note.valoare) into media_anul2 from note join cursuri on note.id_curs=cursuri.id where note.id_student=id_stud and cursuri.an=2 group by note.id_student;
                                DBMS_OUTPUT.PUT_LINE('Media studentului in anul 2 a fost: '||media_anul2);
                                select avg(note.valoare) into media_anul3 from note join cursuri on note.id_curs=cursuri.id where note.id_student=id_stud and cursuri.an=3 group by note.id_student;
                                DBMS_OUTPUT.PUT_LINE('Media studentului in anul 3 este: '||media_anul3);
                              END IF;
                      END IF;
                 END IF;
                 select avg(valoare) into media_total from note where note.id_student=id_stud;
                 DBMS_OUTPUT.PUT_LINE('Media studentului TOTAL este: '||media_total);
                 DBMS_OUTPUT.PUT_LINE('');
                 DBMS_OUTPUT.PUT_LINE('Varsta studentului este: '||MANAGEMENT_FACULTY.COMPUTE_AGE(data_nastere_stud));
                 select grupa into grupa_stud from studenti where id=id_stud;
                 select an into an_stud from studenti where id=id_stud;
                 loc_grupa := 1;
                 FOR v_std_linie_colegi in lista_colegi LOOP
                     IF(v_std_linie_colegi.id_student != id_stud) THEN
                          loc_grupa := loc_grupa + 1;
                     ELSE
                          DBMS_OUTPUT.PUT_LINE('Locul ocupat pe in cadrul grupei este: '||loc_grupa);
                     END IF;
                 END LOOP;
                 FOR v_std_linie_prieteni in lista_prieteni LOOP
                     IF(v_std_linie_prieteni.id_student1=id_stud) THEN
                        select nume into nume_prieten from studenti where id = v_std_linie_prieteni.id_student2;
                        select prenume into prenume_prieten from studenti where id = v_std_linie_prieteni.id_student2;
                        DBMS_OUTPUT.PUT_LINE('Este prieten cu: '||nume_prieten||' '||prenume_prieten);
                     ELSE
                        select nume into nume_prieten from studenti where id = v_std_linie_prieteni.id_student1;
                        select prenume into prenume_prieten from studenti where id = v_std_linie_prieteni.id_student1;
                        DBMS_OUTPUT.PUT_LINE('Este prieten cu: '||nume_prieten||' '||prenume_prieten);
                     END IF;
                 END LOOP;
            END IF;
        END LOOP;
    END infos_student;
END management_faculty;  
/
set serveroutput on;
DECLARE 
id_auxilary studenti.id%type;
nr_matric studenti.nr_matricol%type;
BEGIN
   DBMS_OUTPUT.PUT_LINE(management_faculty.compute_age(to_date('01/01/1990','DD/MM/YYYY')));
   --management_faculty.add_student('j', 'Luther');
   DBMS_OUTPUT.PUT_LINE(' ');
   management_faculty.infos_student('Musca', 'Irina');
   --MANAGEMENT_FACULTY.DELETE_STUDENT('908TT5');
   --DBMS_OUTPUT.PUT_LINE('Am sters studentul cu numarul matricol 908TT5');
   
END;
/
  --select * from studenti where nume='Michael' and prenume='Jackson';
  --select * from note where id_student=id_auxilary;