set serveroutput on;
DECLARE 
   CURSOR cursor_studenti IS SELECT * FROM studenti;
   CURSOR cursor_note IS SELECT * FROM note;
   CURSOR cursor_cursuri IS SELECT * FROM cursuri;
   numar_note INTEGER;
   medie_note FLOAT;
   suma_note INTEGER;
   medie_note_maxima FLOAT := 0;
   id_student_noteMax studenti.id%TYPE;
   nume_student_noteMax studenti.nume%TYPE;
   an_student_noteMax studenti.an%TYPE;
BEGIN
   FOR v_linie_studenti IN cursor_studenti LOOP
      numar_note := 0;
      suma_note := 0;
      medie_note := 0;
      FOR v_linie_note IN cursor_note LOOP
          IF(v_linie_note.id_student = v_linie_studenti.id)
          THEN
              numar_note := numar_note + 1;
              suma_note := suma_note + v_linie_note.valoare;
          END IF;    
      END LOOP;
      IF(numar_note >= 3) --verificare daca studentul are mai mult de 3 note
      THEN
          medie_note := suma_note / numar_note;
          IF(medie_note_maxima = 0 AND medie_note != 0) --initializare medie maxima
          THEN
               medie_note_maxima := medie_note;
               id_student_noteMax := v_linie_studenti.id;
               nume_student_noteMax := v_linie_studenti.nume;
               an_student_noteMax := v_linie_studenti.an;
          ELSE IF(medie_note_maxima < medie_note) --calculare medie maxima
               THEN
                    medie_note_maxima := medie_note;
                    id_student_noteMax := v_linie_studenti.id;
                    nume_student_noteMax := v_linie_studenti.nume;
                    an_student_noteMax := v_linie_studenti.an;
               ELSE IF(medie_note_maxima = medie_note AND v_linie_studenti.an > an_student_noteMax) --studenti cu aceeasi medie dar in ani diferiti
                    THEN
                        id_student_noteMax := v_linie_studenti.id;
                        nume_student_noteMax := v_linie_studenti.nume;
                        an_student_noteMax := v_linie_studenti.an;
                    ELSE IF(medie_note_maxima = medie_note AND v_linie_studenti.an = an_student_noteMax AND v_linie_studenti.nume < nume_student_noteMax) 
                          --studenti cu aceeasi medie, in acelasi an, il alegem pe primul in ordine alfabetica
                          THEN
                              id_student_noteMax := v_linie_studenti.id;
                              nume_student_noteMax := v_linie_studenti.nume;
                          END IF;
                    END IF;
               END IF;
          END IF;
      END IF;    
   END LOOP;
   
  DBMS_OUTPUT.PUT_LINE('Studentul cu cele mai mari note este: '|| nume_student_noteMax);
  DBMS_OUTPUT.PUT_LINE('Are media: '|| medie_note_maxima);
  DBMS_OUTPUT.PUT_LINE('Are id-ul: '|| id_student_noteMax);
  DBMS_OUTPUT.PUT_LINE('Este in anul: '|| an_student_noteMax);
  
   FOR v_linie_note IN cursor_note LOOP
    FOR v_linie_curs IN cursor_cursuri LOOP
      IF(v_linie_curs.id = v_linie_note.id_curs AND v_linie_note.id_student = id_student_noteMax) THEN
          DBMS_OUTPUT.PUT_LINE('Nota: ' || v_linie_note.valoare ||' obtinuta la cursul '|| v_linie_curs.titlu_curs);
      END IF;    
    END LOOP;
   END LOOP;
END;
