CREATE OR REPLACE TYPE my_triangle FORCE AS OBJECT 
(first_side NUMBER,
 second_side NUMBER,
 third_side NUMBER,
 CONSTRUCTOR FUNCTION my_triangle(side_one NUMBER, side_two NUMBER)
    RETURN SELF AS RESULT,
 member procedure display_perimeter,
 NOT FINAL member procedure display_area,
 member procedure display_side_dimensions,
 map member function return_perimeter return number
) NOT FINAL; 
/ 
CREATE OR REPLACE TYPE BODY my_triangle AS

   CONSTRUCTOR FUNCTION my_triangle(side_one NUMBER, side_two NUMBER)
    RETURN SELF AS RESULT
   AS
   BEGIN
    SELF.first_side := side_one;
    SELF.second_side := side_two; 
    SELF.third_side := 0;
    RETURN;
   END;
  
   MEMBER PROCEDURE display_side_dimensions IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE('First side: '||self.first_side);
      DBMS_OUTPUT.PUT_LINE('Second side: '||self.second_side);
      DBMS_OUTPUT.PUT_LINE('Third side: '||self.third_side);
   END display_side_dimensions;
   
   MEMBER PROCEDURE display_perimeter IS
   perimeter NUMBER;
   BEGIN
       perimeter := SELF.first_side + SELF.second_side + SELF.third_side;
       DBMS_OUTPUT.PUT_LINE('The perimeter for the given triangle is: '|| perimeter);
   END display_perimeter;
   
    MEMBER PROCEDURE display_area IS
    semiperimeter FLOAT;
    area FLOAT;
    horner_result FLOAT;
    BEGIN
        semiperimeter := (SELF.first_side + SELF.second_side + SELF.third_side) / 2;
        horner_result := semiperimeter * (semiperimeter - SELF.first_side) * (semiperimeter - SELF.second_side) * (semiperimeter - SELF.third_side);
        area := sqrt(horner_result);
        DBMS_OUTPUT.PUT_LINE('The area for the given triangle is: '|| area);
    END display_area;
    
    MAP MEMBER FUNCTION return_perimeter RETURN NUMBER IS
    BEGIN
        return self.first_side;
    END return_perimeter;
     
END;
/
CREATE OR REPLACE TYPE equilateral_triangle UNDER my_triangle
(
   v_color varchar2(50),
   OVERRIDING member procedure display_area,
   member procedure change_color,
   member procedure change_color(new_color varchar2)
);
/
CREATE OR REPLACE TYPE BODY equilateral_triangle AS
    OVERRIDING member procedure display_area IS
    area FLOAT;
    BEGIN
        area := sqrt(3)* first_side * first_side /4;
        DBMS_OUTPUT.PUT_LINE('Area for the colored triangle is: ' || area);
    END display_area;
    
    member procedure change_color IS
    BEGIN
        IF(self.first_side * 3 > 20) THEN
              self.v_color := 'red';
              DBMS_OUTPUT.PUT_LINE('The new color of the equilateral triangle is: '|| self.v_color);
        END IF;
    END change_color; 
    
    member procedure change_color(new_color varchar2) IS
    BEGIN
         self.v_color := new_color;
         DBMS_OUTPUT.PUT_LINE('The new color of the equilateral triangle is: '|| self.v_color);
    END change_color;
END;
/
DROP TYPE equilateral_triangle;
CREATE TABLE lista_triunghi (id NUMBER, figura_geometrica my_triangle);
DROP TABLE lista_triunghi;
DROP TYPE equilateral_triangle;
/
set serveroutput on;
DECLARE
    t1 my_triangle;
    t2 my_triangle;
    t3 my_triangle;
    t4 my_triangle;
    t5 my_triangle;
    t6 my_triangle;
    t7 my_triangle;
    t8 equilateral_triangle;
BEGIN
    t1 := my_triangle(10,12,11);
    t2 := my_triangle(8,19,11);
    t3 := my_triangle(15,20,8);
    t4 := my_triangle(6,13,10);
    t5 := my_triangle(4,3,1);
    t6 := my_triangle(30,22,31);
    t7 := my_triangle(20,21);
    t1.display_side_dimensions;
    t1.display_area;
    t1.display_perimeter;
    t8 := equilateral_triangle(20,20,20, 'black');
    t8.change_color;
    t8.change_color('black');
    /*INSERT INTO lista_triunghi VALUES('1', t1);
    INSERT INTO lista_triunghi VALUES('2', t2);
    INSERT INTO lista_triunghi VALUES('3', t3);
    INSERT INTO lista_triunghi VALUES('4', t4);
    INSERT INTO lista_triunghi VALUES('5', t5);
    INSERT INTO lista_triunghi VALUES('6', t6);
    INSERT INTO lista_triunghi VALUES('7', t7); 
    */
END;

select * from lista_triunghi order by 2 asc;
