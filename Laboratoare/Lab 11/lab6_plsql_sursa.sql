--1
CREATE OR REPLACE TRIGGER trig1_abi
      BEFORE INSERT OR UPDATE OR DELETE ON emp_abi
BEGIN
 IF (TO_CHAR(SYSDATE,'D') = 1) 
     OR (TO_CHAR(SYSDATE,'HH24') NOT BETWEEN 8 AND 20)
 THEN
    RAISE_APPLICATION_ERROR(-20001,'tabelul nu poate fi actualizat');
 END IF;
END;
/

DROP TRIGGER trig1_abi;

--2
--Varianta 1
CREATE OR REPLACE TRIGGER trig21_abi
  BEFORE UPDATE OF salary ON emp_abi
  FOR EACH ROW
BEGIN
  IF (:NEW.salary < :OLD.salary) THEN 
     RAISE_APPLICATION_ERROR(-20002,'salariul nu poate fi micsorat');
  END IF;
END;
/

UPDATE emp_abi
SET    salary = salary-100;

DROP TRIGGER trig21_abi;

--Varianta 2
CREATE OR REPLACE TRIGGER trig22_abi
  BEFORE UPDATE OF salary ON emp_abi
  FOR EACH ROW
  WHEN (NEW.salary < OLD.salary)
BEGIN
  RAISE_APPLICATION_ERROR(-20002,'salariul nu poate fi micsorat');
END;
/

UPDATE emp_abi
SET    salary = salary-100;
DROP TRIGGER trig22_abi;

--3
create table job_grades_abi as select * from job_grades;

CREATE OR REPLACE TRIGGER trig3_abi
  BEFORE UPDATE OF lowest_sal, highest_sal ON job_grades_abi
  FOR EACH ROW
DECLARE
  v_min_sal  emp_abi.salary%TYPE;
     v_max_sal  emp_abi.salary%TYPE;
  exceptie EXCEPTION;
BEGIN
  SELECT MIN(salary), MAX(salary)
  INTO   v_min_sal,v_max_sal
  FROM   emp_abi;
  IF (:OLD.grade_level=1) AND  (v_min_sal< :NEW.lowest_sal) 
     THEN RAISE exceptie;
  END IF;
  IF (:OLD.grade_level=7) AND  (v_max_sal> :NEW.highest_sal) 
     THEN RAISE exceptie;
  END IF;
EXCEPTION
  WHEN exceptie THEN
    RAISE_APPLICATION_ERROR (-20003, 'Exista salarii care se gasesc in afara intervalului'); 
END;
/

UPDATE job_grades_abi 
SET    lowest_sal =3000
WHERE  grade_level=1;

UPDATE job_grades_abi
SET    highest_sal =20000
WHERE  grade_level=7;

DROP TRIGGER trig3_abi;

--4
CREATE TABLE info_dept_abi (
  id NUMBER primary key,
  nume_dept VARCHAR2(50),
  plati NUMBER(15)
);
INSERT INTO info_dept_abi
SELECT department_id, department_name, SUM(salary*(1+NVL(commission_pct, 0)))
FROM emp_abi
JOIN dept_abi using (department_id)
GROUP BY department_id, department_name;
SELECT * from info_dept_abi;


CREATE OR REPLACE PROCEDURE modific_plati_abi
          (v_codd  info_dept_abi.id%TYPE,
           v_plati info_dept_abi.plati%TYPE) AS
BEGIN
  UPDATE  info_dept_abi
  SET     plati = NVL (plati, 0) + v_plati
  WHERE   id = v_codd;
END;
/

CREATE OR REPLACE TRIGGER trig4_abi
  AFTER DELETE OR UPDATE  OR  INSERT OF salary ON emp_abi
  FOR EACH ROW
BEGIN
  IF DELETING THEN 
     -- se sterge un angajat
     modific_plati_abi (:OLD.department_id, -1*:OLD.salary);
  ELSIF UPDATING THEN 
    --se modifica salariul unui angajat
    modific_plati_abi(:OLD.department_id,:NEW.salary-:OLD.salary);  
  ELSE 
    -- se introduce un nou angajat
    modific_plati_abi(:NEW.department_id, :NEW.salary);
  END IF;
END;
/

SELECT * FROM  info_dept_abi WHERE id=90;

INSERT INTO emp_abi (employee_id, last_name, email, hire_date, 
                     job_id, salary, department_id) 
VALUES (300, 'N1', 'n1@g.com',sysdate, 'SA_REP', 2000, 90);

SELECT * FROM  info_dept_abi WHERE id=90;

UPDATE emp_abi
SET    salary = salary + 1000
WHERE  employee_id=300;

SELECT * FROM  info_dept_abi WHERE id=90;

DELETE FROM emp_abi
WHERE  employee_id=300;   

SELECT * FROM  info_dept_abi WHERE id=90;

DROP TRIGGER trig4_abi;

--5
CREATE TABLE info_emp_abi (
  id NUMBER primary key,
  nume VARCHAR2(50),
  prenume VARCHAR2(50),
  salariu NUMBER(15),
  id_dept NUMBER constraint fk_id_dept_emp references info_dept_abi (id)
);
INSERT INTO info_emp_abi
SELECT employee_id, last_name, first_name, salary, department_id
FROM emp_abi;
SELECT * from info_emp_abi;

CREATE OR REPLACE VIEW v_info_abi AS
  SELECT e.id, e.nume, e.prenume, e.salariu, e.id_dept, 
         d.nume_dept, d.plati 
  FROM   info_emp_abi e, info_dept_abi d
  WHERE  e.id_dept = d.id;

SELECT *
FROM   user_updatable_columns
WHERE  table_name = UPPER('v_info_abi');

CREATE OR REPLACE TRIGGER trig5_abi
    INSTEAD OF INSERT OR DELETE OR UPDATE ON v_info_abi
    FOR EACH ROW
BEGIN
IF INSERTING THEN 
    -- inserarea in vizualizare determina inserarea 
    -- in info_emp_abi si reactualizarea in info_dept_abi
    -- se presupune ca departamentul exista
   INSERT INTO info_emp_abi 
   VALUES (:NEW.id, :NEW.nume, :NEW.prenume, :NEW.salariu,
           :NEW.id_dept);
     
   UPDATE info_dept_abi
   SET    plati = plati + :NEW.salariu
   WHERE  id = :NEW.id_dept;

ELSIF DELETING THEN
   -- stergerea unui salariat din vizualizare determina
   -- stergerea din info_emp_abi si reactualizarea in
   -- info_dept_abi
   DELETE FROM info_emp_abi
   WHERE  id = :OLD.id;
     
   UPDATE info_dept_abi
   SET    plati = plati - :OLD.salariu
   WHERE  id = :OLD.id_dept;

ELSIF UPDATING ('salariu') THEN
   /* modificarea unui salariu din vizualizare determina 
      modificarea salariului in info_emp_abi si reactualizarea
      in info_dept_abi    */
    	
   UPDATE  info_emp_abi
   SET     salariu = :NEW.salariu
   WHERE   id = :OLD.id;
    	
   UPDATE info_dept_abi
   SET    plati = plati - :OLD.salariu + :NEW.salariu
   WHERE  id = :OLD.id_dept;

ELSIF UPDATING ('id_dept') THEN
    /* modificarea unui cod de departament din vizualizare
       determina modificarea codului in info_emp_abi 
       si reactualizarea in info_dept_abi  */  
    UPDATE info_emp_abi
    SET    id_dept = :NEW.id_dept
    WHERE  id = :OLD.id;
    
    UPDATE info_dept_abi
    SET    plati = plati - :OLD.salariu
    WHERE  id = :OLD.id_dept;
    	
    UPDATE info_dept_abi
    SET    plati = plati + :NEW.salariu
    WHERE  id = :NEW.id_dept;
  END IF;
END;
/

SELECT *
FROM   user_updatable_columns
WHERE  table_name = UPPER('v_info_abi');

-- adaugarea unui nou angajat
SELECT * FROM  info_dept_abi WHERE id=10;

INSERT INTO v_info_abi 
VALUES (400, 'N1', 'P1', 3000,10, 'Nume dept', 0);

SELECT * FROM  info_emp_abi WHERE id=400;
SELECT * FROM  info_dept_abi WHERE id=10;

-- modificarea salariului unui angajat
UPDATE v_info_abi
SET    salariu=salariu + 1000
WHERE  id=400;

SELECT * FROM  info_emp_abi WHERE id=400;
SELECT * FROM  info_dept_abi WHERE id=10;

-- modificarea departamentului unui angajat
SELECT * FROM  info_dept_abi WHERE id=90;

UPDATE v_info_abi
SET    id_dept=90
WHERE  id=400;

SELECT * FROM  info_emp_abi WHERE id=400;
SELECT * FROM  info_dept_abi WHERE id IN (10,90);

-- eliminarea unui angajat
DELETE FROM v_info_abi WHERE id = 400;
SELECT * FROM  info_emp_abi WHERE id=400;
SELECT * FROM  info_dept_abi WHERE id = 90;

DROP TRIGGER trig5_abi;

--6 
CREATE OR REPLACE TRIGGER trig6_abi
  BEFORE DELETE ON emp_abi
 BEGIN
  IF USER= UPPER('grupa241') THEN
     RAISE_APPLICATION_ERROR(-20900,'Nu ai voie sa stergi!');
  END IF;
 END;
/

DROP TRIGGER trig6_abi;

--7
CREATE TABLE audit_abi
   (utilizator     VARCHAR2(30),
    nume_bd        VARCHAR2(50),
    eveniment      VARCHAR2(20),
    nume_obiect    VARCHAR2(30),
    data           DATE);
CREATE OR REPLACE TRIGGER trig7_abi
  AFTER CREATE OR DROP OR ALTER ON SCHEMA
BEGIN
  INSERT INTO audit_abi
  VALUES (SYS.LOGIN_USER, SYS.DATABASE_NAME, SYS.SYSEVENT, 
          SYS.DICTIONARY_OBJ_NAME, SYSDATE);
END;
/

CREATE INDEX ind_abi ON info_emp_abi(nume);
DROP INDEX ind_abi;
SELECT * FROM audit_abi;

DROP TRIGGER trig7_abi;

--8
CREATE OR REPLACE PACKAGE pachet_abi
AS
	smin emp_abi.salary%type;
	smax emp_abi.salary%type;
	smed emp_abi.salary%type;
END pachet_abi;
/

CREATE OR REPLACE TRIGGER trig81_abi
BEFORE UPDATE OF salary ON emp_abi
BEGIN
  SELECT MIN(salary),AVG(salary),MAX(salary)
  INTO pachet_abi.smin, pachet_abi.smed, pachet_abi.smax
  FROM emp_abi;
END;
/

CREATE OR REPLACE TRIGGER trig82_abi
BEFORE UPDATE OF salary ON emp_abi
FOR EACH ROW
BEGIN
IF(:OLD.salary=pachet_abi.smin)AND (:NEW.salary>pachet_abi.smed) 
 THEN
   RAISE_APPLICATION_ERROR(-20001,'Acest salariu depaseste valoarea medie');
ELSIF (:OLD.salary= pachet_abi.smax) 
       AND (:NEW.salary<  pachet_abi.smed) 
 THEN
   RAISE_APPLICATION_ERROR(-20001,'Acest salariu este sub valoarea medie');
END IF;
END;
/

SELECT AVG(salary)
FROM   emp_abi;

UPDATE emp_abi 
SET    salary=10000 
WHERE  salary=(SELECT MIN(salary) FROM emp_abi);

UPDATE emp_abi 
SET    salary=1000 
WHERE  salary=(SELECT MAX(salary) FROM emp_abi);

DROP TRIGGER trig81_abi;
DROP TRIGGER trig82_abi;
