/* CONN / AS SYSDBA;
GRANT EXECUTE ON UTL_FILE TO STUDENT; 
GRANT CREATE ANY DIRECTORY TO STUDENT;
CONN STUDENT/STUDENT@localhost/XE;
CREATE OR REPLACE DIRECTORY MYDIR as 'C:\Users\Racovi\Desktop\Anul 2 FII\PSGBD\Student';
CONN / AS SYSDBA;
GRANT READ,WRITE ON DIRECTORY MYDIR TO STUDENT; */

CREATE OR REPLACE PROCEDURE export_StudentiPrieteni AS
v_fisier_studenti UTL_FILE.FILE_TYPE;
v_fisier_prieteni UTL_FILE.FILE_TYPE;
string_linie_noua VARCHAR2(256);
CURSOR lista_studenti IS SELECT * FROM studenti;
CURSOR lista_prieteni IS SELECT * FROM prieteni;
BEGIN
    v_fisier_studenti := UTL_FILE.FOPEN('MYDIR','export_Studenti_tabel1.txt','W');
    FOR v_std_linie in lista_studenti LOOP
        string_linie_noua := v_std_linie.id||'/'||v_std_linie.nr_matricol||'/'||v_std_linie.nume||'/'||v_std_linie.prenume||'/'||v_std_linie.an||'/'||
                      v_std_linie.grupa||'/'||v_std_linie.bursa||'/'||v_std_linie.data_nastere||'/'||v_std_linie.email||'/'||v_std_linie.created_at||'/'||
                      v_std_linie.updated_at||'/';
        UTL_FILE.PUT_LINE(v_fisier_studenti, string_linie_noua);
    END LOOP;
    UTL_FILE.FCLOSE(v_fisier_studenti);
    
    v_fisier_prieteni := UTL_FILE.FOPEN('MYDIR','export_Prieteni_tabel1.txt','W');
    FOR v_std_linie in lista_prieteni LOOP
        string_linie_noua := v_std_linie.id||'/'||v_std_linie.id_student1||'/'||v_std_linie.id_student2||'/'||
                             v_std_linie.created_at||'/'||v_std_linie.updated_at||'/';
        UTL_FILE.PUT_LINE(v_fisier_prieteni, string_linie_noua);
    END LOOP;
    UTL_FILE.FCLOSE(v_fisier_prieteni);   
END export_StudentiPrieteni;
/
set serveroutput on;
BEGIN
    export_StudentiPrieteni;
END;

--select count(*) from studenti;
