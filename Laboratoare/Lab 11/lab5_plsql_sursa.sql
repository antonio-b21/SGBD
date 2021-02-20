
--I. Pachete definite de utilizator
--1
CREATE OR REPLACE PACKAGE pachet1_abi AS
   FUNCTION  f_numar(v_dept departments.department_id%TYPE) 
        RETURN NUMBER;
   FUNCTION  f_suma(v_dept departments.department_id%TYPE) 
        RETURN NUMBER;
END pachet1_abi;
/
CREATE OR REPLACE PACKAGE BODY pachet1_abi AS
   FUNCTION  f_numar(v_dept  departments.department_id%TYPE) 
      RETURN NUMBER IS numar NUMBER;
   BEGIN
      SELECT COUNT(*)INTO numar
      FROM   employees
      WHERE  department_id =v_dept;
   RETURN numar;
   END f_numar;

   FUNCTION  f_suma (v_dept  departments.department_id%TYPE) 
      RETURN NUMBER IS
      suma NUMBER;
   BEGIN
      SELECT SUM(salary+salary*NVL(commission_pct,0))
      INTO suma
      FROM employees
      WHERE department_id =v_dept;
   RETURN suma;
   END f_suma;
END pachet1_abi;
/

SELECT pachet1_abi.f_numar(80)
FROM DUAL;
SELECT pachet1_abi.f_suma(80)
FROM DUAL;

BEGIN
  DBMS_OUTPUT.PUT_LINE('numarul de salariati este '||
                        pachet1_abi.f_numar(80));
  DBMS_OUTPUT.PUT_LINE('suma alocata este '||
                        pachet1_abi.f_suma(80));
END;
/

--2 
create sequence sec_abi;

CREATE OR REPLACE PACKAGE pachet2_abi AS
   PROCEDURE p_dept (v_codd dept_abi.department_id%TYPE,
                     v_nume dept_abi.department_name%TYPE,
                     v_manager dept_abi.manager_id%TYPE,
                     v_loc dept_abi.location_id%TYPE);
   PROCEDURE p_emp (v_first_name emp_abi.first_name%TYPE,
                 v_last_name emp_abi.last_name%TYPE,
                 v_email emp_abi.email%TYPE,
                 v_phone_number emp_abi.phone_number%TYPE:=NULL, 
                 v_hire_date emp_abi.hire_date%TYPE :=SYSDATE,     
                 v_job_id emp_abi.job_id%TYPE,        
                 v_salary   emp_abi.salary%TYPE :=0,      
                 v_commission_pct emp_abi.commission_pct%TYPE:=0,
                 v_manager_id emp_abi.manager_id%TYPE,   
                 v_department_id emp_abi.department_id%TYPE);

  FUNCTION exista (cod_loc dept_abi.location_id%TYPE, 
                   manager dept_abi.manager_id%TYPE) 
  RETURN NUMBER;
END pachet2_abi;
/

CREATE OR REPLACE PACKAGE BODY pachet2_abi AS

FUNCTION exista(cod_loc dept_abi.location_id%TYPE, 
                manager dept_abi.manager_id%TYPE)
 RETURN NUMBER  IS 
      rezultat NUMBER:=1;
      rez_cod_loc NUMBER;
      rez_manager NUMBER;
 BEGIN
    SELECT count(*) INTO   rez_cod_loc
    FROM   locations
    WHERE  location_id = cod_loc;
    
    SELECT count(*) INTO   rez_manager
    FROM   emp_abi
    WHERE  employee_id = manager;
    
    IF rez_cod_loc=0 OR rez_manager=0 THEN 
         rezultat:=0;     
    END IF;
RETURN rezultat;
END;

PROCEDURE p_dept(v_codd dept_abi.department_id%TYPE,
                 v_nume dept_abi.department_name%TYPE,
                 v_manager dept_abi.manager_id%TYPE,
                 v_loc dept_abi. location_id%TYPE) IS
BEGIN
   IF exista(v_loc, v_manager)=0 THEN 
       DBMS_OUTPUT.PUT_LINE('Nu s-au introdus date coerente pentru tabelul dept_abi');
   ELSE
     INSERT INTO dept_abi
          (department_id,department_name,manager_id,location_id)
     VALUES (v_codd, v_nume, v_manager, v_loc);
   END IF;
 END p_dept;

PROCEDURE p_emp
(v_first_name emp_abi.first_name%TYPE,
 v_last_name emp_abi.last_name%TYPE,
 v_email emp_abi.email%TYPE,
 v_phone_number emp_abi.phone_number%TYPE:=null, 
 v_hire_date emp_abi.hire_date%TYPE :=SYSDATE,     
 v_job_id emp_abi.job_id%TYPE,        
 v_salary emp_abi.salary %TYPE :=0,      
 v_commission_pct emp_abi.commission_pct%TYPE:=0,
 v_manager_id emp_abi.manager_id%TYPE,   
 v_department_id  emp_abi.department_id%TYPE)
AS
 BEGIN
     INSERT INTO emp_abi
     VALUES (sec_abi.NEXTVAL, v_first_name, v_last_name, v_email,
            v_phone_number,v_hire_date, v_job_id, v_salary,
            v_commission_pct, v_manager_id,v_department_id);
END p_emp;
END pachet2_abi;
/

EXECUTE pachet2_abi.p_dept(50,'Economic',200,2000);

SELECT * FROM dept_abi WHERE department_id=50;

EXECUTE pachet2_abi.p_emp('f','l','e',v_job_id=>'j',v_manager_id=>200,v_department_id=>50);

SELECT * FROM emp_abi WHERE job_id='j';

ROLLBACK;


BEGIN
   pachet2_abi.p_dept(50,'Economic',99,2000);
   pachet2_abi.p_emp('f','l','e',v_job_id=>'j',v_manager_id=>200,v_department_id=>50);
END;
/

SELECT * FROM emp_abi WHERE job_id='j';
ROLLBACK;

--3
CREATE  OR REPLACE PACKAGE pachet3_abi AS
   CURSOR c_emp(nr NUMBER) RETURN employees%ROWTYPE; 
   FUNCTION  f_max  (v_oras  locations.city%TYPE) RETURN NUMBER;
END pachet3_abi;
/

CREATE OR REPLACE PACKAGE BODY pachet3_abi AS

CURSOR c_emp(nr NUMBER) RETURN employees%ROWTYPE  
      IS
      SELECT * 
      FROM employees 
      WHERE salary >= nr; 

FUNCTION  f_max (v_oras  locations.city%TYPE) RETURN NUMBER  IS
      maxim  NUMBER;
BEGIN
     SELECT  MAX(salary) 
     INTO    maxim  
     FROM    employees e, departments d, locations l
     WHERE   e.department_id=d.department_id 
             AND d.location_id=l.location_id 
             AND UPPER(city)=UPPER(v_oras);
    RETURN  maxim;
END f_max;
END pachet3_abi;
/

DECLARE
  oras    locations.city%TYPE:= 'Toronto';
  val_max NUMBER;
  lista   employees%ROWTYPE;
BEGIN
   val_max:=  pachet3_abi.f_max(oras);
   FOR v_cursor IN pachet3_abi.c_emp(val_max) LOOP
      DBMS_OUTPUT.PUT_LINE(v_cursor.last_name||' '||
                           v_cursor.salary);   
   END LOOP;
END;
/

--4
CREATE OR REPLACE  PACKAGE pachet4_abi IS
  PROCEDURE p_verific 
      (v_cod employees.employee_id%TYPE,
       v_job   employees.job_id%TYPE);
  CURSOR c_emp RETURN employees%ROWTYPE;  
END pachet4_abi;
/

CREATE OR REPLACE PACKAGE BODY pachet4_abi IS

CURSOR c_emp  RETURN employees%ROWTYPE  IS
       SELECT *
       FROM   employees;

PROCEDURE p_verific(v_cod   employees.employee_id%TYPE,
                    v_job   employees.job_id%TYPE)
IS
  gasit BOOLEAN:=FALSE;
  lista employees%ROWTYPE;
BEGIN
  OPEN c_emp;
  LOOP
    FETCH c_emp INTO lista;
    EXIT WHEN c_emp%NOTFOUND;
    IF lista.employee_id=v_cod  AND lista.job_id=v_job   
       THEN  gasit:=TRUE;
    END IF;
  END LOOP;
  CLOSE c_emp;
  IF gasit=TRUE THEN 
     DBMS_OUTPUT.PUT_LINE('combinatia data exista');
  ELSE  
     DBMS_OUTPUT.PUT_LINE('combinatia data nu exista');
  END IF;
END p_verific;
END pachet4_abi;
/
   
EXECUTE pachet4_abi.p_verific(200,'AD_ASST');

--II. Pachete predefinite
--1
--1.1
DECLARE
-- paramentrii de tip OUT pt procedura GET_LINE
   linie1 VARCHAR2(255);
   stare1 INTEGER;
   linie2 VARCHAR2(255);
   stare2 INTEGER;
   linie3 VARCHAR2(255);
   stare3 INTEGER;

v_emp  employees.employee_id%TYPE;
v_job  employees.job_id%TYPE;
v_dept employees.department_id%TYPE;

BEGIN
  SELECT employee_id, job_id, department_id
  INTO   v_emp,v_job,v_dept
  FROM   employees
  WHERE  last_name='Lorentz';

-- se introduce o linie in buffer fara caracter 
-- de terminare linie
   DBMS_OUTPUT.PUT(' 1 '||v_emp|| ' ');

-- se incearca extragerea liniei introdusa 
-- in buffer si starea acesteia
   DBMS_OUTPUT.GET_LINE(linie1,stare1); 

-- se depunde informatie pe aceeasi linie in buffer
   DBMS_OUTPUT.PUT(' 2 '||v_job|| ' ');

-- se inchide linia depusa in buffer si se extrage 
-- linia din buffer
   DBMS_OUTPUT.NEW_LINE;
   DBMS_OUTPUT.GET_LINE(linie2,stare2); 

-- se introduc informatii pe aceeasi linie 
-- si se afiseaza informatia
   DBMS_OUTPUT.PUT_LINE(' 3 ' ||v_emp|| ' '|| v_job);
   DBMS_OUTPUT.GET_LINE(linie3,stare3); 

-- se afiseaza ceea ce s-a extras
   DBMS_OUTPUT.PUT_LINE('linie1 = '|| linie1||
                        '; stare1 = '||stare1);
   DBMS_OUTPUT.PUT_LINE('linie2 = '|| linie2||
                        '; stare2 = '||stare2);
   DBMS_OUTPUT.PUT_LINE('linie3 = '|| linie3||
                        '; stare3 = '||stare3);
END;
/ 

--1.2
DECLARE
-- parametru de tip OUT pentru NEW_LINES  
-- tablou de siruri de caractere
   linii DBMS_OUTPUT.CHARARR;
-- paramentru de tip IN OUT pentru NEW_LINES
   nr_linii INTEGER;

 v_emp  employees.employee_id%TYPE;
 v_job  employees.job_id%TYPE;
 v_dept employees.department_id%TYPE;

BEGIN
  SELECT employee_id, job_id, department_id
  INTO   v_emp,v_job,v_dept
  FROM   employees
  WHERE  last_name='Lorentz';

-- se mareste dimensiunea bufferului 
   DBMS_OUTPUT.ENABLE(1000000);
   DBMS_OUTPUT.PUT(' 1 '||v_emp|| ' ');
   DBMS_OUTPUT.PUT(' 2 '||v_job|| ' ');
   DBMS_OUTPUT.NEW_LINE;
   DBMS_OUTPUT.PUT_LINE(' 3 ' ||v_emp|| ' '|| v_job);
   DBMS_OUTPUT.PUT_LINE(' 4 ' ||v_emp|| ' '|| v_job||' ' ||v_dept);
-- se afiseaza ceea ce s-a extras
   nr_linii := 4;
   DBMS_OUTPUT.GET_LINES(linii,nr_linii); 
   DBMS_OUTPUT.put_line('In buffer sunt '|| nr_linii ||' linii');
   FOR i IN 1..nr_linii LOOP
       DBMS_OUTPUT.put_line(linii(i));
   END LOOP;

--  nr_linii := 4;
--  DBMS_OUTPUT.GET_LINES(linii,nr_linii); 
--  DBMS_OUTPUT.put_line('Acum in buffer sunt '|| nr_linii ||' linii');
--   FOR i IN 1..nr_linii LOOP
--       DBMS_OUTPUT.put_line(linii(i));
--   END LOOP;
--
---- DBMS_OUTPUT.disable;
---- DBMS_OUTPUT.enable;
----  
---- nr_linii := 4;
---- DBMS_OUTPUT.GET_LINES(linii,nr_linii); 
---- DBMS_OUTPUT.put_line('Acum in buffer sunt '|| nr_linii ||' linii');
END;
/ 


--2
CREATE OR REPLACE PROCEDURE marire_salariu_abi
     (id_angajat emp_abi.employee_id%type,
      valoare    number)
IS
BEGIN
  UPDATE emp_abi
  SET    salary = salary + valoare
  WHERE  employee_id = id_angajat; 
END;
/

--Varianta 1

VARIABLE nr_job NUMBER

BEGIN
 DBMS_JOB.SUBMIT(
    -- intoarce numarul jobului, printr-o variabila de legatura
    JOB => :nr_job,   
    
    -- codul PL/SQL care trebuie executat 
    WHAT => 'marire_salariu_abi(100, 1000);', 
    
    -- data de start a executiei (dupa 10 secunde)
    NEXT_DATE => SYSDATE+10/86400,  
    
    -- intervalul de timp la care se repeta executia
    INTERVAL => 'SYSDATE+1');  
   
    COMMIT;
END;
/

SELECT salary FROM emp_abi WHERE employee_id = 100;
-- asteptati 10 de secunde
SELECT salary FROM emp_abi WHERE employee_id = 100;

-- numarul jobului
PRINT nr_job;

-- informatii despre joburi
SELECT JOB, NEXT_DATE, WHAT
FROM   USER_JOBS;

-- lansarea jobului la momentul dorit
SELECT salary FROM emp_abi WHERE employee_id = 100;
BEGIN
   -- presupunand ca jobul are codul 1 atunci:
   DBMS_JOB.RUN(job => 1);
END;
/
SELECT salary FROM emp_abi WHERE employee_id = 100;

-- stergerea unui job
BEGIN
   DBMS_JOB.REMOVE(job=>1);
END;
/

SELECT JOB, NEXT_DATE, WHAT
FROM   USER_JOBS;

UPDATE emp_abi
SET    salary = 24000
WHERE  employee_id = 100;

COMMIT;

--Varianta 2

CREATE OR REPLACE PACKAGE pachet_job_abi
IS
  nr_job NUMBER;
  FUNCTION obtine_job RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE body pachet_job_abi
IS
  FUNCTION obtine_job RETURN NUMBER IS
  BEGIN
    RETURN nr_job;
  END;
END;
/

BEGIN
 DBMS_JOB.SUBMIT(
    --intoarve numarul jobului, printr-o variabila de legatura
    JOB => pachet_job_abi.nr_job,    
    
    -- codul PL/SQL care trebuie executat 
    WHAT => 'marire_salariu_abi(100, 1000);', 

    -- data de start a executiei (dupa 10 secunde)
    NEXT_DATE => SYSDATE+10/86400,  
    
    -- intervalul de timp la care se repeta executia
    INTERVAL => 'SYSDATE+1');  
   
    COMMIT;
END;
/

-- informatii despre joburi
SELECT JOB, NEXT_DATE, WHAT
FROM   USER_JOBS
WHERE  JOB = pachet_job_abi.obtine_job;

-- lansarea jobului la momentul dorit
SELECT salary FROM emp_abi WHERE employee_id = 100;
BEGIN
   DBMS_JOB.RUN(JOB => pachet_job_abi.obtine_job);
END;
/
SELECT salary FROM emp_abi WHERE employee_id = 100;

-- stergerea unui job
BEGIN
   DBMS_JOB.REMOVE(JOB=>pachet_job_abi.obtine_job);
END;
/
SELECT JOB, NEXT_DATE, WHAT
FROM   USER_JOBS
WHERE  JOB = pachet_job_abi.obtine_job;

UPDATE emp_abi
SET    salary = 24000
WHERE  employee_id = 100;

COMMIT;

--3
--TEMA: urmati pasii spcificati in suportul de curs si rulati codul pe calculatorul personal


--Exemplu: Mentinem rezultatele unei comenzi SELECT intr-un fisier.

CREATE OR REPLACE PROCEDURE scriu_fisier_abi
 (director VARCHAR2,
  fisier VARCHAR2)
IS
  v_file UTL_FILE.FILE_TYPE;
  CURSOR cursor_rez IS
     SELECT department_id departament, SUM(salary) suma
     FROM employees
     GROUP BY department_id
     ORDER BY SUM(salary);
  v_rez cursor_rez%ROWTYPE;
BEGIN
 v_file:=UTL_FILE.FOPEN(director, fisier, 'w');
 UTL_FILE.PUTF(v_file, 'Suma salariilor pe departamente \n Raport generat pe data  ');
 UTL_FILE.PUT(v_file, SYSDATE);
 UTL_FILE.NEW_LINE(v_file);
 OPEN cursor_rez;
 LOOP
     FETCH cursor_rez INTO v_rez;
     EXIT WHEN cursor_rez%NOTFOUND;
     UTL_FILE.NEW_LINE(v_file);
     UTL_FILE.PUT(v_file, v_rez.departament);
     UTL_FILE.PUT(v_file, '         ');
     UTL_FILE.PUT(v_file, v_rez.suma);
 END LOOP;
 CLOSE cursor_rez;
 UTL_FILE.FCLOSE(v_file);
END;
/

SQL> EXECUTE scriu_fisier('F:\','test.txt');


create table emp_abi as select * from employees;
create table dept_abi as select * from departments;
  
  
--ex1
create or replace PACKAGE p1a_abi AS
  PROCEDURE p_angajat(
    nume emp_abi.last_name%TYPE,
    prenume emp_abi.first_name%TYPE,
    telefon emp_abi.phone_number%TYPE,
    email emp_abi.email%TYPE,
    nume_job jobs.job_title%TYPE,
    nume_dept dept_abi.department_name%TYPE,
    nume_man emp_abi.last_name%TYPE,
    prenume_man emp_abi.first_name%TYPE
  );

  FUNCTION f_job(
    nume_job  jobs.job_title%TYPE
  ) RETURN emp_abi.job_id%TYPE;

  FUNCTION f_dep(
    nume_dep  dept_abi.department_name%TYPE
  ) RETURN emp_abi.department_id%TYPE;

  FUNCTION f_salariu(
    dept  dept_abi.department_id%TYPE,
    job jobs.job_id%TYPE
  ) RETURN emp_abi.salary%TYPE;

  FUNCTION f_manager(
    nume    emp_abi.last_name%TYPE,
    prenume emp_abi.first_name%TYPE
  ) RETURN emp_abi.employee_id%TYPE;
END p1a_abi;
/

create or replace PACKAGE BODY p1a_abi AS
  PROCEDURE  p_angajat(
    nume emp_abi.last_name%TYPE,
    prenume emp_abi.first_name%TYPE,
    telefon emp_abi.phone_number%TYPE,
    email emp_abi.email%TYPE,
    nume_job jobs.job_title%TYPE,
    nume_dept dept_abi.department_name%TYPE,
    nume_man emp_abi.last_name%TYPE,
    prenume_man emp_abi.first_name%TYPE
  )
  IS
    dept    emp_abi.department_id%TYPE;
    job     emp_abi.job_id%TYPE;
    salariu emp_abi.salary%TYPE;
    manager emp_abi.manager_id%TYPE;
  BEGIN
    dept := f_dep(nume_dept);
    job := f_job(nume_job);
    salariu := f_salariu(dept, job);
    manager := f_manager(nume_man, prenume_man);

    INSERT INTO emp_abi
    VALUES (sec_abi.nextval, prenume, nume, email, telefon, sysdate, job, salariu, 0, manager , dept);
  END p_angajat;

  FUNCTION f_job(
    nume_job  jobs.job_title%TYPE
  ) RETURN emp_abi.job_id%TYPE
  IS
    cod emp_abi.job_id%TYPE;
  BEGIN
    SELECT job_id
    INTO cod
    FROM   jobs
    WHERE  job_title = nume_job;

    RETURN cod;
  END f_job;

  FUNCTION f_dep(
    nume_dep  dept_abi.department_name%TYPE
  ) RETURN emp_abi.department_id%TYPE
  IS 
    cod emp_abi.department_id%TYPE;
  BEGIN
    SELECT department_id
    INTO cod
    FROM   dept_abi
    WHERE  department_name = nume_dep;

    RETURN cod;
  END f_dep;

  FUNCTION f_salariu(
    dept  dept_abi.department_id%TYPE,
    job jobs.job_id%TYPE
  ) RETURN emp_abi.salary%TYPE
  IS
    salariu emp_abi.salary%TYPE;
  BEGIN
    SELECT MIN(salary)
    INTO salariu
    FROM emp_abi
    WHERE department_id = dept
      AND job_id = job;

    RETURN salariu;
  END f_salariu;

  FUNCTION f_manager(
    nume    emp_abi.last_name%TYPE,
    prenume emp_abi.first_name%TYPE
  ) RETURN emp_abi.employee_id%TYPE
  IS
    manager emp_abi.employee_id%TYPE;
  BEGIN
    SELECT employee_id
    INTO manager
    FROM emp_abi
    WHERE last_name = nume
      AND first_name = prenume;

    RETURN manager;
  END f_manager;
END p1a_abi;
/

begin

  dbms_output.put_line(p1a_abi.f_salariu(p1a_abi.f_dep('Sales'), p1a_abi.f_job('Sales Manager')));
end;
/

execute p1a_abi.p_angajat('John', 'Freeman', '52862836', 'abc', 'Sales Manager', 'Sales', 'Austin', 'David');

    nume emp_abi.last_name%TYPE,
    prenume emp_abi.first_name%TYPE,
    telefon emp_abi.phone_number%TYPE,
    email emp_abi.email%TYPE,
    nume_job jobs.job_title%TYPE,
    nume_dept dept_abi.department_name%TYPE,
    nume_man emp_abi.last_name%TYPE,
    prenume_man emp_abi.first_name%TYPE
    
select * from emp_abi;
