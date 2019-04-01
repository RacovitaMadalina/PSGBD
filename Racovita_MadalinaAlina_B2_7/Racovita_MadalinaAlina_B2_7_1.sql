drop table customers;
drop table purchases;
drop view customer_purchase;
/
CREATE TABLE customers
( id number(10) not null primary key, 
  first_name varchar2(50),
  second_name varchar2(50),
  email varchar2(50));
  
CREATE TABLE purchases
( id_purchase number(10) not null primary key, 
  id_customer number(10), 
  product_name varchar2(50),
  CONSTRAINT fk_purchase FOREIGN KEY (id_customer) REFERENCES customers(id));
  
CREATE VIEW customer_purchase as select * from customers c full outer join purchases p on c.id = p.id_customer;
/
set serveroutput on;

INSERT INTO customers values ('1', 'Andreea', 'Mardare', 'andreea.mardare@gmail.com');
INSERT INTO customers values ('2', 'Bianca', 'Antonescu', 'bianca.antonescu@gmail.com');
INSERT INTO customers values ('3', 'Radu', 'Nastase', 'radu.nastase@gmail.com');
INSERT INTO customers values ('4', 'Elena', 'Vasiliu', 'elena.vasiliu@gmail.com');
INSERT INTO customers values ('5', 'Ion', 'Ionescu', 'ion.ionescu@gmail.com');
INSERT INTO customers values ('6', 'Marian', 'Popescu', 'marian.popescu@gmail.com');
INSERT INTO customers values ('7', 'Ilie', 'Buraga', 'ilie.buraga@gmail.com');
INSERT INTO customers values ('8', 'Constantin', 'Panaite', 'constantin.panaite@gmail.com');
INSERT INTO customers values ('9', 'Bogdan', 'Chiriac', 'bogdan.chiriac@gmail.com');
INSERT INTO customers values ('10', 'Ilinca', 'Cornea', 'chiriac.cornea@gmail.com');

select * from customers;

INSERT INTO purchases VALUES ('1', '3', 'chocolate');
INSERT INTO purchases VALUES ('2', '2', 'coffee');
INSERT INTO purchases VALUES ('3', '5', 'sugar');
INSERT INTO purchases VALUES ('4', '6', 'soap');
INSERT INTO purchases VALUES ('5', '2', 'toothpaste');
INSERT INTO purchases VALUES ('6', '4', 'gummybears');
INSERT INTO purchases VALUES ('7', '7', 'bread');
INSERT INTO purchases VALUES ('8', '8', 'oranges');
INSERT INTO purchases VALUES ('9', '10', 'bananas');
INSERT INTO purchases VALUES ('10', '2', 'sugar');
INSERT INTO purchases VALUES ('11', '3', 'soap');
INSERT INTO purchases VALUES ('12', '3', 'coffee');

select * from purchases;
select * from CUSTOMER_PURCHASE;
/
set SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER delete_customer
  INSTEAD OF delete ON customer_purchase
BEGIN
  dbms_output.put_line('Stergem un purchase din view pentru customerul cu id-ul '|| :OLD.id );
  delete from purchases where id_customer = :OLD.id;
  delete from customers where id = :OLD.id ;
END;
/
delete from CUSTOMER_PURCHASE where id ='4';
/
drop trigger delete_customer;
/
CREATE OR REPLACE TRIGGER insert_customer
  INSTEAD OF INSERT ON customer_purchase
BEGIN
  dbms_output.put_line('Inseram un customer din view cu id-ul '|| :NEW.id);
  INSERT INTO CUSTOMERS values (:NEW.id, :NEW.first_name, :NEW.second_name, :NEW.email);
  INSERT INTO PURCHASES values (:NEW.id_purchase, :NEW.id_customer, :NEW.product_name);
END;
/
drop trigger insert_customer;
insert into customer_purchase values ('14', 'Ana', 'Maria', 'ana.maria@gmail.com', '20', '14', 'sugar'); 
/
CREATE OR REPLACE TRIGGER update_purchase
  INSTEAD OF UPDATE ON customer_purchase
BEGIN
  dbms_output.put_line('Updatam un purchase din view cu id-ul customerului '|| :OLD.id);
  UPDATE customers set email = :NEW.email where id in (select id_customer from purchases where product_name like '%a%');
END;
/
drop trigger update_purchase;
UPDATE customer_purchase set product_name = 'coffee' where id = '6';
UPDATE customer_purchase set email= 'b' where product_name like '%a%';




