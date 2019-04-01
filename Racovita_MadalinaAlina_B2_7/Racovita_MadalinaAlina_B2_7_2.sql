drop table note_updatate;
drop package my_public_package;
/
CREATE TABLE note_updatate (
note_modificate INT, data_modificati DATE);
/
CREATE PACKAGE my_public_package IS
  v_updatate INT := 0;
END;

------------- FARA TRIGGERE COMPUSE ----------------
/*
set serveroutput on;
CREATE OR REPLACE TRIGGER update_note

  before UPDATE OF valoare ON note   -- aici se executa numai cand modificam valoarea !
  FOR EACH ROW
BEGIN
  dbms_output.put_line('ID nota: ' || :OLD.id); 
  dbms_output.put_line('Vechea nota: ' || :OLD.valoare);  
  dbms_output.put_line('Noua nota: ' || :NEW.valoare);    

  IF (:OLD.valoare != :NEW.valoare) THEN 
      :NEW.valoare := :OLD.valoare;
      my_public_package.v_updatate := my_public_package.v_updatate + 1;
      dbms_output.put_line('Note modificate acum: ' || my_public_package.v_updatate); 
      --INSERT into note_updatate values (my_public_package.v_updatate, sysdate);
  end if;  
END;
/
update note set valoare = 8 where id_student in (6,7,8,9);
select * from NOTE_UPDATATE;
/
DROP TRIGGER update_nota;
/
set serveroutput on;
DECLARE
auxilary INTEGER;
BEGIN
auxilary := my_public_package.v_updatate;
INSERT into note_updatate values (auxilary, sysdate);
END;
*/

---------- CU TRIGGERE COMPUSE --------------

set serveroutput on;

CREATE OR REPLACE TRIGGER update_note 
FOR UPDATE ON NOTE
COMPOUND TRIGGER
  
  BEFORE EACH ROW IS 
  BEGIN
     IF (:OLD.valoare < :NEW.valoare) THEN 
      :NEW.valoare := :OLD.valoare;
      my_public_package.v_updatate := my_public_package.v_updatate + 1;
      dbms_output.put_line('Note modificate acum: ' || my_public_package.v_updatate); 
     end if; 
  END BEFORE EACH ROW;
  
  AFTER STATEMENT IS BEGIN
     INSERT into note_updatate values (my_public_package.v_updatate, sysdate);
  END AFTER STATEMENT ;
END update_note;
/
update note set valoare = 8 where id_student between 101 and 103;
select * from note_updatate;
