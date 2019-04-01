drop table schimbariDB;
drop package username_package;
/
create table schimbariDB(nume varchar2(30), ora timestamp);

CREATE PACKAGE username_package IS
  v_username varchar2(50) := NULL;
END;
/
drop trigger drop_trigger;
drop trigger truncate_trigger;
drop trigger alter_trigger;
/
CREATE OR REPLACE TRIGGER drop_trigger
  BEFORE DROP ON DATABASE
  DECLARE
   PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    select user into username_package.v_username from dual;
    insert into schimbariDB values (username_package.v_username, CURRENT_TIMESTAMP);
    commit;
    RAISE_APPLICATION_ERROR (
      num => -20000,
      msg => 'can''t execute the drop operation');
  END;
/
CREATE OR REPLACE TRIGGER truncate_trigger
  BEFORE TRUNCATE ON DATABASE
  DECLARE
   PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    select user into username_package.v_username from dual;
    insert into schimbariDB values (username_package.v_username, CURRENT_TIMESTAMP);
    commit;
    RAISE_APPLICATION_ERROR (
      num => -20000,
      msg => 'can''t execute the truncate operation');
  END;
/
CREATE OR REPLACE TRIGGER alter_trigger
  BEFORE ALTER ON DATABASE
  DECLARE
   PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    select user into username_package.v_username from dual;
    insert into schimbariDB values (username_package.v_username, CURRENT_TIMESTAMP);
    commit;
    RAISE_APPLICATION_ERROR (
      num => -20000,
      msg => 'can''t execute the alter table operation');
  END;
/
CREATE OR REPLACE TRIGGER db_logon AFTER LOGON ON DATABASE
BEGIN
    EXECUTE IMMEDIATE 'ALTER SESSION SET CURRENT_SCHEMA = STUDENT';
END;
/
/*CONN first_student/first_student@localhost/XE;
CONN second_student/second_student@localhost/XE;
ALTER TABLE student add preferinte varchar2(50);
TRUNCATE TABLE note;
*/

select user from dual;
select * from schimbariDB;
