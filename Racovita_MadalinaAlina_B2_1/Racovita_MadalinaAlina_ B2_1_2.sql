set serveroutput on;
DECLARE
      data_nastere     VARCHAR2(30) := '16-10-1997';
      numar_luni       NUMBER(20);
      numar_zile       NUMBER(20);
      ziua_saptamanii  VARCHAR(20);
      --data_nastere2    VARCHAR2(30) := '28-02-2018';
BEGIN
      SELECT floor(months_between(sysdate,to_date(data_nastere, 'DD-MM-YYYY'))) INTO numar_luni from dual;
      DBMS_OUTPUT.PUT_LINE('Numarul de luni care au trecut este: '||numar_luni);
      
      SELECT trunc(sysdate-add_months(to_date(data_nastere, 'DD-MM-YYYY'),numar_luni)) INTO numar_zile from dual;
      DBMS_OUTPUT.PUT_LINE('Numarul de zile care au trecut este: '||numar_zile);
      
      SELECT TO_CHAR(to_date(data_nastere, 'DD-MM-YYYY'), 'day') into ziua_saptamanii from dual;
      DBMS_OUTPUT.PUT_LINE('Ziua saptamanii in care a cazut ziua reprezentata in constanta este: '||ziua_saptamanii);
END;