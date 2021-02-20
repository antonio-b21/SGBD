--lab 4 PLSQL
   
--1
DECLARE
  v_nume employees.last_name%TYPE := Initcap('&p_nume');   

  FUNCTION f1 RETURN NUMBER IS
    salariu employees.salary%type; 
  BEGIN
    SELECT salary INTO salariu 
    FROM   employees
    WHERE  last_name = v_nume;
    RETURN salariu;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       DBMS_OUTPUT.PUT_LINE('Nu exista angajati cu numele dat');
    WHEN TOO_MANY_ROWS THEN
       DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati cu numele dat');
    WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('Alta eroare!');
  END f1;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Salariul este '|| f1);

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Eroarea are codul = '||SQLCODE
            || ' si mesajul = ' || SQLERRM);
END;
/
--Bell, King, Kimball

--2
CREATE OR REPLACE FUNCTION f2_abi 
  (v_nume employees.last_name%TYPE DEFAULT 'Bell')    
RETURN NUMBER IS
    salariu employees.salary%type; 
  BEGIN
    SELECT salary INTO salariu 
    FROM   employees
    WHERE  last_name = v_nume;
    RETURN salariu;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
    WHEN TOO_MANY_ROWS THEN
       RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
    WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END f2_abi;
/

-- metode de apelare
-- bloc plsql
BEGIN
  DBMS_OUTPUT.PUT_LINE('Salariul este '|| f2_abi);
END;
/

BEGIN
  DBMS_OUTPUT.PUT_LINE('Salariul este '|| f2_abi('King'));
END;
/

-- SQL
  SELECT f2_abi FROM DUAL;
  SELECT f2_abi('King') FROM DUAL;

-- SQL*PLUS CU VARIABILA HOST
  VARIABLE nr NUMBER
  EXECUTE :nr := f2_abi('Bell');
  PRINT nr
  
-- 3 
-- varianta 1
DECLARE
  v_nume employees.last_name%TYPE := Initcap('&p_nume');   
  
  PROCEDURE p3 
  IS 
      salariu employees.salary%TYPE;
  BEGIN
    SELECT salary INTO salariu 
    FROM   employees
    WHERE  last_name = v_nume;
    DBMS_OUTPUT.PUT_LINE('Salariul este '|| salariu);
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       DBMS_OUTPUT.PUT_LINE('Nu exista angajati cu numele dat');
    WHEN TOO_MANY_ROWS THEN
       DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati cu numele dat');
    WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('Alta eroare!');
  END p3;

BEGIN
  p3;
END;
/

-- varianta 2
DECLARE
  v_nume employees.last_name%TYPE := Initcap('&p_nume');  
  v_salariu employees.salary%type;

  PROCEDURE p3(salariu OUT employees.salary%type) IS 
  BEGIN
    SELECT salary INTO salariu 
    FROM   employees
    WHERE  last_name = v_nume;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20000,'Nu exista angajati cu numele dat');
    WHEN TOO_MANY_ROWS THEN
       RAISE_APPLICATION_ERROR(-20001,'Exista mai multi angajati cu numele dat');
    WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
  END p3;

BEGIN
  p3(v_salariu);
  DBMS_OUTPUT.PUT_LINE('Salariul este '|| v_salariu);
END;
/
 
--4
-- varianta 1
CREATE OR REPLACE PROCEDURE p4_abi
      (v_nume employees.last_name%TYPE)
  IS 
      salariu employees.salary%TYPE;
  BEGIN
    SELECT salary INTO salariu 
    FROM   employees
    WHERE  last_name = v_nume;
    DBMS_OUTPUT.PUT_LINE('Salariul este '|| salariu);
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
    WHEN TOO_MANY_ROWS THEN
       RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
    WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
  END p4_abi;
/

-- metode apelare
-- 1. Bloc PLSQL
BEGIN
  p4_abi('Bell');
END;
/

-- 2. SQL*PLUS
EXECUTE p4_abi('Bell');
EXECUTE p4_abi('King');
EXECUTE p4_abi('Kimball');

-- varianta 2
CREATE OR REPLACE PROCEDURE 
       p4_abi(v_nume IN employees.last_name%TYPE,
               salariu OUT employees.salary%type) IS 
  BEGIN
    SELECT salary INTO salariu 
    FROM   employees
    WHERE  last_name = v_nume;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
    WHEN TOO_MANY_ROWS THEN
       RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
    WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
  END p4_abi;
/

-- metode apelare
-- Bloc PLSQL
DECLARE
   v_salariu employees.salary%type;
BEGIN
  p4_abi('Bell',v_salariu);
  DBMS_OUTPUT.PUT_LINE('Salariul este '|| v_salariu);
END;
/

-- SQL*PLUS
VARIABLE v_sal NUMBER
EXECUTE p4_abi ('Bell',:v_sal)
PRINT v_sal

--5
VARIABLE ang_man VARCHAR2
BEGIN
 :ang_man:='Bell';
END;
/

CREATE OR REPLACE PROCEDURE p5_abi  (nume IN OUT VARCHAR2) IS 
BEGIN
 SELECT last_name INTO nume
 FROM employees
 WHERE employee_id = (select manager_id
                      from employees
                      where last_name = nume);
END p5_abi;
/

EXECUTE p5_abi (:ang_man)
PRINT ang_man

--6
DECLARE
  nume employees.last_name%TYPE;
  PROCEDURE p6 (rezultat OUT employees.last_name%TYPE,
                comision IN  employees.commission_pct%TYPE:=NULL,
                cod      IN  employees.employee_id%TYPE:=NULL) 
   IS
   BEGIN
   IF (comision IS NOT NULL) THEN
      SELECT last_name 
      INTO rezultat
      FROM employees
      WHERE commission_pct= comision;
      DBMS_OUTPUT.PUT_LINE('numele salariatului care are comisionul ' 
                          ||comision||' este '||rezultat);
   ELSE 
      SELECT last_name 
      INTO rezultat
      FROM employees
      WHERE employee_id =cod;
      DBMS_OUTPUT.PUT_LINE('numele salariatului avand codul ' ||cod||' este '||rezultat);
   END IF;
  END p6;

BEGIN
  p6(nume,0.4);
  p6(nume,cod=>200);
END;
/

--7
DECLARE
  medie1 NUMBER(10,2);
  medie2 NUMBER(10,2);
  FUNCTION medie (v_dept employees.department_id%TYPE) 
    RETURN NUMBER IS
    rezultat NUMBER(10,2);
  BEGIN
    SELECT AVG(salary) 
    INTO   rezultat 
    FROM   employees
    WHERE  department_id = v_dept;
    RETURN rezultat;
  END;
  
  FUNCTION medie (v_dept employees.department_id%TYPE,
                  v_job employees.job_id %TYPE) 
    RETURN NUMBER IS
    rezultat NUMBER(10,2);
  BEGIN
    SELECT AVG(salary) 
    INTO   rezultat 
    FROM   employees
    WHERE  department_id = v_dept AND job_id = v_job;
    RETURN rezultat;
  END;

BEGIN
  medie1:=medie(80);
  DBMS_OUTPUT.PUT_LINE('Media salariilor din departamentul 80' 
      || ' este ' || medie1);
  medie2 := medie(80,'SA_MAN');
  DBMS_OUTPUT.PUT_LINE('Media salariilor managerilor din'
      || ' departamentul 80 este ' || medie2);
END;
/

--8
CREATE OR REPLACE FUNCTION factorial_abi(n NUMBER) 
 RETURN INTEGER 
 IS
 BEGIN
  IF (n=0) THEN RETURN 1;
  ELSE RETURN n*factorial_abi(n-1);
  END IF;
END factorial_abi;
/

VARIABLE v_nr NUMBER
EXECUTE :v_nr := factorial_abi(3)
PRINT v_nr


--9
CREATE OR REPLACE FUNCTION medie_abi 
RETURN NUMBER 
IS 
rezultat NUMBER;
BEGIN
  SELECT AVG(salary) INTO   rezultat
  FROM   employees;
  RETURN rezultat;
END;
/
SELECT last_name,salary
FROM   employees
WHERE  salary >= medie_abi;


--afisati toti angajatii care au salariul mai mare ca media salariala prin intermediul unei proceduri stocate
CREATE OR REPLACE PROCEDURE p10_abi IS 
BEGIN
 FOR i IN (SELECT *
            FROM employees
            WHERE salary > medie_abi) LOOP
    DBMS_OUTPUT.PUT_LINE(i.last_name || '  ' || i.first_name || '  ' || i.salary);
  END LOOP;
          
END p10_abi;
/

execute p10_abi;

create or replace procedure p12_afda2(val IN NUMBER) is 
begin 
  begin
    begin
      begin
        begin
          declare 
            CURSOR c IS (select employee_id, last_name, salary 
                          from employees 
                          where salary > val); 
          begin 
            for ang in c loop 
              dbms_output.put_line(ang.employee_id || ' ' || ang.last_name || ' ' || ang.salary); 
            end loop; 
          end;
        end;
      end; 
    end;
  end;
END p12_afda2;
/

BEGIN p12_afda2(medie_afda); END; 


--ex1
CREATE TABLE info_abi (
  utilizator VARCHAR2(50),
  data DATE,
  comanda VARCHAR2(50),
  nr_linii NUMBER(5),
  eroare VARCHAR2(100)
);
/

--drop table info_abi;
--ex2
CREATE OR REPLACE FUNCTION fex2_abi 
  (v_nume employees.last_name%TYPE DEFAULT 'Bell')    
RETURN NUMBER IS
    salariu employees.salary%type; 
  BEGIN
    SELECT salary INTO salariu 
    FROM   employees
    WHERE  last_name = v_nume;
    
    INSERT INTO info_abi
    VALUES (USER, sysdate, 'select', 1, null);
    RETURN salariu;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      INSERT INTO info_abi
      VALUES (USER, sysdate, 'select', 0, 'Nu exista angajati cu numele dat');
      RETURN -1;
    WHEN TOO_MANY_ROWS THEN
      INSERT INTO info_abi
      VALUES (USER, sysdate, 'select', 2, 'Exista mai multi angajati cu numele dat');
      RETURN -1;
    WHEN OTHERS THEN
      INSERT INTO info_abi
      VALUES (USER, sysdate, 'select', null, 'Alta eroare!');
      RETURN -1;
END fex2_abi;
/

BEGIN
  DBMS_OUTPUT.PUT_LINE('Salariul este '|| fex2_abi);
END;
/

BEGIN
  DBMS_OUTPUT.PUT_LINE('Salariul este '|| fex2_abi('King'));
END;
/

BEGIN
  DBMS_OUTPUT.PUT_LINE('Salariul este '|| fex2_abi('Kingsasasasa'));
END;
/

select * from info_abi;