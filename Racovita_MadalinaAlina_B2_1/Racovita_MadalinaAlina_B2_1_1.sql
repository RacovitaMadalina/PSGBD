set serveroutput on;
accept input_nume prompt "Please enter your name: "; -- permite inserarea numelui de catre utilizator

DECLARE
   nume_familie         VARCHAR2(15);
   input_nume           VARCHAR2(15);
   numar_inregistrari   NUMBER(4);     
   id_first             STUDENTI.ID%TYPE;
   prenume_first        STUDENTI.PRENUME%TYPE;
   nota_min             NOTE.VALOARE%TYPE;
   nota_max             NOTE.VALOARE%TYPE;
   rezultat_putere      NUMBER(20);
BEGIN 
   nume_familie := '&input_nume';
   SELECT COUNT(*) INTO numar_inregistrari FROM STUDENTI s WHERE s.nume=nume_familie; 
   
   IF (numar_inregistrari != 0) --afisare numar de inregistrari
      THEN DBMS_OUTPUT.PUT_LINE('Numarul de studenti cu numele: ' || nume_familie || ' este ' || numar_inregistrari);
      
      SELECT ID, PRENUME INTO id_first, prenume_first FROM (SELECT s.ID, s.PRENUME FROM STUDENTI s WHERE s.nume=nume_familie
      ORDER BY s.PRENUME ASC) WHERE ROWNUM = 1;
      DBMS_OUTPUT.PUT_LINE('Primul student in ordine lexicografica dupa prenume are id-ul: '|| id_first ||' si prenume :' || prenume_first);
      
      SELECT MAX(n.VALOARE) INTO nota_max FROM NOTE n WHERE n.ID = id_first;
      SELECT MIN(n.VALOARE) INTO nota_min FROM NOTE n WHERE n.ID = id_first;
      DBMS_OUTPUT.PUT_LINE('Cea mai mica nota a studentului de mai sus este: '|| nota_min ||' si cea mai mare: ' || nota_max);
      
      rezultat_putere := POWER(nota_max, nota_min);
      DBMS_OUTPUT.PUT_LINE('Nota maxima la o putere egala cu nota minima va fi: '|| rezultat_putere);
      
      ELSE 
      DBMS_OUTPUT.PUT_LINE('Nu exista in baza de date studenti cu numele de familie: ' || nume_familie);
   END IF;   
END; 
