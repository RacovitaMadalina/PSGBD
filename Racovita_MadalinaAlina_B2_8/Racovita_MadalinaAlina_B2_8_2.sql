--DELETE FROM PRIETENI;
--DELETE FROM STUDENTI;
/
CREATE OR REPLACE PROCEDURE parsare_linie_student (v_std_linie_studenti VARCHAR2) AS
id_importat STUDENTI.ID%TYPE;
nr_matricol_importat STUDENTI.NR_MATRICOL%TYPE;
nume_importat STUDENTI.NUME%TYPE;
prenume_importat STUDENTI.PRENUME%TYPE;
an_importat STUDENTI.AN%TYPE;
grupa_importat STUDENTI.GRUPA%TYPE;
bursa_importat STUDENTI.BURSA%TYPE;
data_nastere_importat STUDENTI.DATA_NASTERE%TYPE;
email_importat STUDENTI.EMAIL%TYPE;
created_at_importat STUDENTI.CREATED_AT%TYPE;
updated_at_importat STUDENTI.UPDATED_AT%TYPE;
aparitie1 INTEGER;
aparitie2 INTEGER;
BEGIN
          -- CAMP ID
          aparitie1 := INSTR(v_std_linie_studenti, '/', 1, 1);
          id_importat := SUBSTR(v_std_linie_studenti, 1, aparitie1 - 1);
          
          -- CAMP NR_MATRICOL
          aparitie2 := INSTR(v_std_linie_studenti, '/', 1, 2);
          nr_matricol_importat := SUBSTR(v_std_linie_studenti, aparitie1 + 1, aparitie2 - (aparitie1 + 1));
          
          -- CAMP NUME
          aparitie1 := aparitie2;
          aparitie2 := INSTR(v_std_linie_studenti, '/', 1, 3);
          nume_importat := SUBSTR(v_std_linie_studenti, aparitie1 + 1, aparitie2 - (aparitie1 + 1));
          
          -- CAMP PRENUME
          aparitie1 := aparitie2;
          aparitie2 := INSTR(v_std_linie_studenti, '/', 1, 4);
          prenume_importat := SUBSTR(v_std_linie_studenti, aparitie1 + 1, aparitie2 - (aparitie1 + 1));
          
          -- CAMP AN
          aparitie1 := aparitie2;
          aparitie2 := INSTR(v_std_linie_studenti, '/', 1, 5);
          an_importat := SUBSTR(v_std_linie_studenti, aparitie1 + 1, aparitie2 - (aparitie1 + 1));
          
          -- CAMP GRUPA
          aparitie1 := aparitie2;
          aparitie2 := INSTR(v_std_linie_studenti, '/', 1, 6);
          grupa_importat := SUBSTR(v_std_linie_studenti, aparitie1 + 1, aparitie2 - (aparitie1 + 1));
          
          -- CAMP BURSA
          aparitie1 := aparitie2;
          aparitie2 := INSTR(v_std_linie_studenti, '/', 1, 7);
          bursa_importat := SUBSTR(v_std_linie_studenti, aparitie1 + 1, aparitie2 - (aparitie1 + 1));
          
          -- CAMP DATA_NASTERE
          aparitie1 := aparitie2;
          aparitie2 := INSTR(v_std_linie_studenti, '/', 1, 8);
          data_nastere_importat := SUBSTR(v_std_linie_studenti, aparitie1 + 1, aparitie2 - (aparitie1 + 1));
          
          -- CAMP EMAIL
          aparitie1 := aparitie2;
          aparitie2 := INSTR(v_std_linie_studenti, '/', 1, 9);
          email_importat := SUBSTR(v_std_linie_studenti, aparitie1 + 1, aparitie2 - (aparitie1 + 1));
          
          -- CAMP CREATED_AT
          aparitie1 := aparitie2;
          aparitie2 := INSTR(v_std_linie_studenti, '/', 1, 10);
          created_at_importat := SUBSTR(v_std_linie_studenti, aparitie1 + 1, aparitie2 - (aparitie1 + 1));
          
          -- CAMP UPDATED_AT
          aparitie1 := aparitie2;
          aparitie2 := INSTR(v_std_linie_studenti, '/', 1, 11);
          updated_at_importat := SUBSTR(v_std_linie_studenti, aparitie1 + 1, aparitie2 - (aparitie1 + 1));
          
          INSERT INTO STUDENTI VALUES (id_importat, nr_matricol_importat, nume_importat, prenume_importat, an_importat,
                                       grupa_importat, bursa_importat, data_nastere_importat, email_importat, created_at_importat,
                                       updated_at_importat);
          EXCEPTION
              WHEN DUP_VAL_ON_INDEX THEN
                    DBMS_OUTPUT.PUT_LINE('Eroare: ID duplicat in tabela studenti');    
END parsare_linie_student;
/
CREATE OR REPLACE PROCEDURE parsare_linie_prieten (v_std_linie_prieteni VARCHAR2) AS
id_prieteni_importat PRIETENI.ID%TYPE;
id_student1_importat PRIETENI.ID_STUDENT1%TYPE;
id_student2_importat PRIETENI.ID_STUDENT2%TYPE;
created_at_importat2 PRIETENI.CREATED_AT%TYPE;
updated_at_importat2 PRIETENI.UPDATED_AT%TYPE;
aparitie1 INTEGER;
aparitie2 INTEGER;
BEGIN
        -- CAMP ID
        aparitie1 := INSTR(v_std_linie_prieteni, '/', 1, 1);
        id_prieteni_importat := SUBSTR(v_std_linie_prieteni, 1, aparitie1 - 1);
          
        -- CAMP NR_MATRICOL
        aparitie2 := INSTR(v_std_linie_prieteni, '/', 1, 2);
        id_student1_importat := SUBSTR(v_std_linie_prieteni, aparitie1 + 1, aparitie2 - (aparitie1 + 1));
          
        -- CAMP NUME
        aparitie1 := aparitie2;
        aparitie2 := INSTR(v_std_linie_prieteni, '/', 1, 3);
        id_student2_importat := SUBSTR(v_std_linie_prieteni, aparitie1 + 1, aparitie2 - (aparitie1 + 1));
          
        -- CAMP PRENUME
        aparitie1 := aparitie2;
        aparitie2 := INSTR(v_std_linie_prieteni, '/', 1, 4);
        created_at_importat2 := SUBSTR(v_std_linie_prieteni, aparitie1 + 1, aparitie2 - (aparitie1 + 1));
          
        -- CAMP AN
        aparitie1 := aparitie2;
        aparitie2 := INSTR(v_std_linie_prieteni, '/', 1, 5);
        updated_at_importat2 := SUBSTR(v_std_linie_prieteni, aparitie1 + 1, aparitie2 - (aparitie1 + 1));
        --DBMS_OUTPUT.PUT_LINE(id_prieteni_importat||'/'||id_student1_importat||'/'||id_student2_importat||'/'||created_at_importat2||'/'||updated_at_importat2);
        INSERT INTO PRIETENI VALUES (id_prieteni_importat, id_student1_importat, id_student2_importat, created_at_importat2, updated_at_importat2);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                  DBMS_OUTPUT.PUT_LINE('Eroare: ID duplicat in tabela prieteni.');
END parsare_linie_prieten;
/
CREATE OR REPLACE PROCEDURE import_StudentiPrieteni AS
v_fisier_studenti UTL_FILE.FILE_TYPE;
v_fisier_prieteni UTL_FILE.FILE_TYPE;

v_linie_studenti VARCHAR2(200);
v_linie_prieteni VARCHAR2(200);
BEGIN
     v_fisier_studenti := UTL_FILE.FOPEN('MYDIR','export_Studenti_tabel1.txt','R');
     LOOP
        BEGIN
          UTL_FILE.GET_LINE(v_fisier_studenti,v_linie_studenti);
          parsare_linie_student(v_linie_studenti);
          v_linie_studenti := '';
          EXCEPTION
              WHEN NO_DATA_FOUND THEN EXIT;
        END;
     END LOOP;
     DBMS_OUTPUT.PUT_LINE('Import succeeded! Am terminat de inserat in tabela studenti!');
     UTL_FILE.FCLOSE(v_fisier_studenti);
     
     v_fisier_prieteni := UTL_FILE.FOPEN('MYDIR','export_Prieteni_tabel1.txt','R');
     LOOP
        BEGIN
          UTL_FILE.GET_LINE(v_fisier_prieteni, v_linie_prieteni);
          parsare_linie_prieten(v_linie_prieteni);
          v_linie_prieteni := '';
          EXCEPTION
              WHEN NO_DATA_FOUND THEN EXIT;
        END;
     END LOOP;
     DBMS_OUTPUT.PUT_LINE('Import succeeded! Am terminat de inserat in tabela prieteni!');
     UTL_FILE.FCLOSE(v_fisier_prieteni);
END import_StudentiPrieteni;
/
set serveroutput on;
BEGIN
    import_StudentiPrieteni;
END;
/ 
select count(*) from studenti;
select count(*) from prieteni;
/
--DELETE FROM studenti WHERE id = 10000;
--DELETE FROM studenti WHERE id = 340;

