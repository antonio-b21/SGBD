--lab 3 PLSQL

--1
DECLARE
  v_nr    number(4);
  v_nume  departments.department_name%TYPE;
  CURSOR c IS
    SELECT department_name nume, COUNT(employee_id) nr  
    FROM   departments d, employees e
    WHERE  d.department_id=e.department_id(+) 
    GROUP BY department_name; 
BEGIN
  OPEN c;
  LOOP
      FETCH c INTO v_nume,v_nr;
      EXIT WHEN c%NOTFOUND;
      IF v_nr=0 THEN
         DBMS_OUTPUT.PUT_LINE(c%rowcount || ': In departamentul '|| v_nume||
                           ' nu lucreaza angajati');
      ELSIF v_nr=1 THEN
           DBMS_OUTPUT.PUT_LINE(c%rowcount || ': In departamentul '|| v_nume||
                           ' lucreaza un angajat');
      ELSE
         DBMS_OUTPUT.PUT_LINE(c%rowcount || ': In departamentul '|| v_nume||
                           ' lucreaza '|| v_nr||' angajati');
     END IF;
 END LOOP;
 CLOSE c;
END;
/

--2
DECLARE
  TYPE   tab_nume IS TABLE OF departments.department_name%TYPE;
  TYPE   tab_nr IS TABLE OF NUMBER(4);
  t_nr   tab_nr;
  t_nume tab_nume;
  CURSOR c IS
    SELECT department_name nume, COUNT(employee_id) nr  
    FROM   departments d, employees e
    WHERE  d.department_id=e.department_id(+)
    GROUP BY department_name; 
BEGIN
  OPEN c;
  FETCH c  BULK COLLECT INTO t_nume, t_nr;
  CLOSE c;
  FOR i IN t_nume.FIRST..t_nume.LAST LOOP
      IF t_nr(i)=0 THEN
         DBMS_OUTPUT.PUT_LINE('In departamentul '|| t_nume(i)||
                           ' nu lucreaza angajati');
      ELSIF t_nr(i)=1 THEN
           DBMS_OUTPUT.PUT_LINE('In departamentul '||t_nume(i)||
                           ' lucreaza un angajat');
      ELSE
         DBMS_OUTPUT.PUT_LINE('In departamentul '|| t_nume(i)||
                           ' lucreaza '|| t_nr(i)||' angajati');
     END IF;
  END LOOP;
END;
/

--2 cu o singura colectie
DECLARE
    TYPE   dep_rec IS RECORD (nume departments.department_name%type, nr number(4));
    TYPE   tab_dep IS TABLE OF dep_rec;
    t      tab_dep;
    CURSOR c IS
        SELECT department_name nume, COUNT(employee_id) nr  
        FROM   departments d, employees e
        WHERE  d.department_id=e.department_id(+)
        GROUP BY department_name; 
BEGIN
    OPEN c;
    FETCH c  BULK COLLECT INTO t;
    CLOSE c;
    FOR i IN t.FIRST..t.LAST LOOP
        IF t(i).nr=0 THEN
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| t(i).nume||
                           ' nu lucreaza angajati');
        ELSIF t(i).nr=1 THEN
            DBMS_OUTPUT.PUT_LINE('In departamentul '||t(i).nume||
                           ' lucreaza un angajat');
        ELSE
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| t(i).nume||
                   ' lucreaza '|| t(i).nr||' angajati');
        END IF;
    END LOOP;
END;
/


--3 ciclu cursor
DECLARE
    CURSOR c IS
        SELECT department_name nume, COUNT(employee_id) nr 
        FROM   departments d, employees e
        WHERE  d.department_id=e.department_id(+)
        GROUP BY department_name; 
BEGIN
    FOR i in c LOOP
        IF i.nr=0 THEN
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||
                           ' nu lucreaza angajati');
        ELSIF i.nr=1 THEN
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume ||
                           ' lucreaza un angajat');
        ELSE
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||
                           ' lucreaza '|| i.nr||' angajati');
        END IF;
    END LOOP;
END;
/

--4 ciclu cursor cu subcerere
BEGIN
    FOR i in (SELECT department_name nume, COUNT(employee_id) nr 
                FROM   departments d, employees e
                WHERE  d.department_id=e.department_id(+)
                GROUP BY department_name) LOOP
        IF i.nr=0 THEN
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||
                           ' nu lucreaza angajati');
        ELSIF i.nr=1 THEN
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume ||
                           ' lucreaza un angajat');
        ELSE
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||
                           ' lucreaza '|| i.nr||' angajati');
        END IF;
    END LOOP;
END;
/

--5
DECLARE
    v_cod    employees.employee_id%TYPE;
    v_nume   employees.last_name%TYPE;
    v_nr     NUMBER(4);
    CURSOR c IS
        SELECT   sef.employee_id cod, MAX(sef.last_name) nume, 
                 count(*) nr
        FROM     employees sef, employees ang
        WHERE    ang.manager_id = sef.employee_id
        GROUP BY sef.employee_id
        ORDER BY nr DESC;
BEGIN
    OPEN c;
    LOOP
        FETCH c INTO v_cod,v_nume,v_nr;
        EXIT WHEN c%ROWCOUNT>3 OR c%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Managerul '|| v_cod || 
                           ' avand numele ' || v_nume || 
                           ' conduce ' || v_nr||' angajati');
    END LOOP;
    CLOSE c;
END;
/

--6
DECLARE
    CURSOR c IS
        SELECT   sef.employee_id cod, MAX(sef.last_name) nume, 
                 count(*) nr
        FROM     employees sef, employees ang
        WHERE    ang.manager_id = sef.employee_id
        GROUP BY sef.employee_id
        ORDER BY nr DESC;
BEGIN
    FOR i IN c LOOP
        EXIT WHEN c%ROWCOUNT>3 OR c%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Managerul '|| i.cod || 
                           ' avand numele ' || i.nume || 
                           ' conduce '|| i.nr||' angajati');
    END LOOP;
END;
/

--7
DECLARE
    top number(1):= 0; 
BEGIN
    FOR i IN (SELECT   sef.employee_id cod, MAX(sef.last_name) nume, 
                         count(*) nr
                FROM     employees sef, employees ang
                WHERE    ang.manager_id = sef.employee_id
                GROUP BY sef.employee_id
                ORDER BY nr DESC) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('Managerul '|| i.cod || 
                           ' avand numele ' || i.nume || 
                           ' conduce '|| i.nr||' angajati');
        Top := top+1;
        EXIT WHEN top=3;
    END LOOP;
END;
/

--8
DECLARE
    v_x     number(4) := &p_x;
    v_nr    number(4);
    v_nume  departments.department_name%TYPE;
    
    CURSOR c (paramentru NUMBER) IS
        SELECT department_name nume, COUNT(employee_id) nr  
        FROM   departments d, employees e
        WHERE  d.department_id=e.department_id
        GROUP BY department_name
        HAVING COUNT(employee_id)> paramentru; 
BEGIN
    OPEN c(v_x);
    LOOP
        FETCH c INTO v_nume,v_nr;
        EXIT WHEN c%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume||
                           ' lucreaza '|| v_nr||' angajati');
    END LOOP;
    CLOSE c;
END;
/

DECLARE
    v_x     number(4) := &p_x;
    CURSOR c (paramentru NUMBER) IS
        SELECT department_name nume, COUNT(employee_id) nr 
        FROM   departments d, employees e
        WHERE  d.department_id=e.department_id
        GROUP BY department_name
        HAVING COUNT(employee_id)> paramentru; 
BEGIN
    FOR i in c(v_x) LOOP
        DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||
                           ' lucreaza '|| i.nr||' angajati');
    END LOOP;
END;
/

DECLARE
    v_x     number(4) := &p_x;
BEGIN
    FOR i in (SELECT department_name nume, COUNT(employee_id) nr 
                FROM   departments d, employees e
                WHERE  d.department_id=e.department_id
                GROUP BY department_name 
                HAVING COUNT(employee_id)> v_x) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||
                           ' lucreaza '|| i.nr||' angajati');
    END LOOP;
END; -- sfarsit laborator!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!11
/

--1. Pentru fiecare job (titlu – care va fi afi?at o singurã datã) ob?ine?i lista angaja?ilor (nume ?i
--salariu) care lucreazã în prezent pe jobul respectiv. Trata?i cazul în care nu existã angaja?i care
--sã lucreze în prezent pe un anumit job. Rezolva?i problema folosind:
--a. cursoare clasice
--b. ciclu cursoare
--c. ciclu cursoare cu subcereri
--d. expresii cursor

--a cursor clasic
DECLARE
    v_titlu jobs.job_title%type;
    v_job   jobs.job_id%type;
    v_nr    number(4);
    vv_last_name employees.last_name%type;
    vv_salary    employees.salary%type;
    v_total_salary employees.salary%type := 0;
    CURSOR c IS
        SELECT   MAX(job_title), j.job_id,
                    COUNT(employee_id) v_nr
        FROM     jobs j, employees e
        WHERE    j.job_id = e.job_id(+)
        GROUP BY j.job_id;
    CURSOR c2 (job jobs.job_id%type) IS
        SELECT last_name, salary
        FROM employees
        where job_id = job;
BEGIN
    OPEN c;
    LOOP
        FETCH c INTO v_titlu, v_job, v_nr;
        EXIT WHEN c%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('-------------------------------');
        DBMS_OUTPUT.PUT_LINE(v_titlu);
        DBMS_OUTPUT.PUT_LINE('----');
        DBMS_OUTPUT.NEW_LINE();
        v_total_salary := 0;
        
        IF v_nr=0 THEN
            DBMS_OUTPUT.PUT_LINE('Nu lucreaza niciun angajat pe acest post');
        ELSE
            OPEN c2(v_job);
            LOOP
                FETCH c2 INTO vv_last_name, vv_salary;
                EXIT WHEN c2%NOTFOUND;
                v_total_salary := v_total_salary + vv_salary;
                
                DBMS_OUTPUT.PUT_LINE(c2%rowcount || ' ' || vv_last_name || ' ' || vv_salary);
                
            END LOOP;
            CLOSE c2;
            DBMS_OUTPUT.PUT_LINE('numar angajati: ' || v_nr);
            DBMS_OUTPUT.PUT_LINE('venituri angajati: ' || v_total_salary);
        END IF;
        
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
    CLOSE c;
END;
/

--b ciclu cursor
DECLARE
    v_total_salary employees.salary%type := 0;
    CURSOR c IS
        SELECT   MAX(job_title) job_title, j.job_id,
                    COUNT(employee_id) v_nr
        FROM     jobs j, employees e
        WHERE    j.job_id = e.job_id
        GROUP BY j.job_id;
    CURSOR c2 (job jobs.job_id%type) IS
        SELECT last_name, salary
        FROM employees
        where job_id = job;
BEGIN
    FOR i in c LOOP
        DBMS_OUTPUT.PUT_LINE('-------------------------------');
        DBMS_OUTPUT.PUT_LINE(i.job_title);
        DBMS_OUTPUT.PUT_LINE('----');
        DBMS_OUTPUT.NEW_LINE();
        v_total_salary := 0;
        
        IF i.v_nr=0 THEN
            DBMS_OUTPUT.PUT_LINE('Nu lucreaza niciun angajat pe acest post');
        ELSE
            FOR i2 in c2(i.job_id) LOOP
                v_total_salary := v_total_salary + i2.salary;
                
                DBMS_OUTPUT.PUT_LINE(c2%rowcount || ' ' || i2.last_name || ' ' || i2.salary);
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('numar angajati: ' || i.v_nr);
            DBMS_OUTPUT.PUT_LINE('venituri angajati: ' || v_total_salary);
        END IF;
        
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END;
/

--c ciclu cursor cu subcerere
DECLARE
    v_total_salary employees.salary%type := 0;
BEGIN
    FOR i in   (SELECT   MAX(job_title) job_title, j.job_id,
                            COUNT(employee_id) v_nr
                FROM     jobs j, employees e
                WHERE    j.job_id = e.job_id
                GROUP BY j.job_id)
        LOOP
        DBMS_OUTPUT.PUT_LINE('-------------------------------');
        DBMS_OUTPUT.PUT_LINE(i.job_title);
        DBMS_OUTPUT.PUT_LINE('----');
        DBMS_OUTPUT.NEW_LINE();
        v_total_salary := 0;
        
        IF i.v_nr=0 THEN
            DBMS_OUTPUT.PUT_LINE('Nu lucreaza niciun angajat pe acest post');
        ELSE
            FOR i2 in  (SELECT last_name, salary
                        FROM employees
                        WHERE job_id = i.job_id)
        LOOP
                v_total_salary := v_total_salary + i2.salary;
                
                DBMS_OUTPUT.PUT_LINE(i2.last_name || ' ' || i2.salary);
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('numar angajati: ' || i.v_nr);
            DBMS_OUTPUT.PUT_LINE('venituri angajati: ' || v_total_salary);
        END IF;
        
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END;
/

--2
DECLARE
    v_titlu jobs.job_title%type;
    v_job   jobs.job_id%type;
    v_nr    number(4);
    vv_last_name employees.last_name%type;
    vv_salary    employees.salary%type;
    vv_com       employees.commission_pct%type;
    v_total_salary employees.salary%type := 0;
    CURSOR c IS
        SELECT   MAX(job_title), j.job_id,
                    COUNT(employee_id) v_nr
        FROM     jobs j, employees e
        WHERE    j.job_id = e.job_id(+)
        GROUP BY j.job_id;
    CURSOR c2 (job jobs.job_id%type) IS
        SELECT last_name, salary, nvl(commission_pct, 0)
        FROM employees
        where job_id = job;
BEGIN
    OPEN c;
    LOOP
        FETCH c INTO v_titlu, v_job, v_nr;
        EXIT WHEN c%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('-------------------------------');
        DBMS_OUTPUT.PUT_LINE(v_titlu);
        DBMS_OUTPUT.PUT_LINE('----');
        DBMS_OUTPUT.NEW_LINE();
        v_total_salary := 0;
        
        IF v_nr=0 THEN
            DBMS_OUTPUT.PUT_LINE('Nu lucreaza niciun angajat pe acest post');
        ELSE
            OPEN c2(v_job);
            LOOP
                FETCH c2 INTO vv_last_name, vv_salary, vv_com;
                EXIT WHEN c2%NOTFOUND;
                v_total_salary := v_total_salary + vv_salary * (1 + vv_com);
                
                DBMS_OUTPUT.PUT_LINE(c2%rowcount || ' ' || vv_last_name || ' ' || vv_salary * (1 + vv_com));
                
            END LOOP;
            CLOSE c2;
            DBMS_OUTPUT.PUT_LINE('numar angajati: ' || v_nr);
            DBMS_OUTPUT.PUT_LINE('venituri angajati: ' || v_total_salary);
        END IF;
        
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
    CLOSE c;
END;
/


--9
create table emp_prof as select * from employees;

SELECT last_name, hire_date, salary
FROM   emp_prof
WHERE  TO_CHAR(hire_date, 'yyyy') = 2000;

DECLARE
  CURSOR c IS
    SELECT *
    FROM   emp_prof
    WHERE  TO_CHAR(hire_date, 'YYYY') = 2000
    FOR UPDATE OF salary NOWAIT;
BEGIN
  FOR i IN c  LOOP
    UPDATE  emp_prof
    SET     salary= salary+1000
    WHERE CURRENT OF c;
  END LOOP;
END;
/

SELECT last_name, hire_date, salary
FROM   emp_prof
WHERE  TO_CHAR(hire_date, 'yyyy') = 2000;

ROLLBACK;

--10
--varianta 1 - cursor parametrizat
BEGIN
  FOR v_dept IN (SELECT department_id, department_name
                 FROM   departments
                 WHERE  department_id IN (10,20,30,40))
  LOOP
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    DBMS_OUTPUT.PUT_LINE ('DEPARTAMENT '||v_dept.department_name);
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    FOR v_emp IN (SELECT last_name
                  FROM   employees
                  WHERE  department_id = v_dept.department_id)
    LOOP
       DBMS_OUTPUT.PUT_LINE (v_emp.last_name);
    END LOOP;
  END LOOP;
END;
/

--Varianta 2 – expresii cursor
DECLARE
  TYPE refcursor IS REF CURSOR;
  CURSOR c_dept IS
    SELECT department_name, 
           CURSOR (SELECT last_name 
                   FROM   employees e
                   WHERE  e.department_id = d.department_id)
    FROM   departments d
    WHERE  department_id IN (10,20,30,40);
  v_nume_dept   departments.department_name%TYPE;
  v_cursor      refcursor;
  v_nume_emp    employees.last_name%TYPE;
BEGIN
  OPEN c_dept;
  LOOP
    FETCH c_dept INTO v_nume_dept, v_cursor;
    EXIT WHEN c_dept%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    DBMS_OUTPUT.PUT_LINE ('DEPARTAMENT '||v_nume_dept);
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    LOOP
      FETCH v_cursor INTO v_nume_emp;
      EXIT WHEN v_cursor%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE (v_nume_emp);
    END LOOP;
  END LOOP;
  CLOSE c_dept;
END;
/

--11
-- atentie la rezultat
DECLARE
  TYPE      emp_tip IS REF CURSOR RETURN employees%ROWTYPE;
  -- sau 
  -- TYPE   emp_tip IS REF CURSOR;
  
  v_emp     emp_tip;
  v_optiune NUMBER := &p_optiune;
  v_ang    employees%ROWTYPE;
BEGIN
   IF v_optiune = 1 THEN
     OPEN v_emp FOR SELECT * 
                    FROM employees;
   ELSIF v_optiune = 2 THEN
     OPEN v_emp FOR  SELECT * 
                     FROM employees 
                     WHERE salary BETWEEN 10000 AND 20000;
   ELSIF v_optiune = 3 THEN
     OPEN v_emp FOR SELECT * 
                    FROM employees 
                    WHERE TO_CHAR(hire_date, 'YYYY') = 2000;
   ELSE
      DBMS_OUTPUT.PUT_LINE('Optiune incorecta');  
   END IF;
   LOOP
      FETCH v_emp into v_ang;
      EXIT WHEN v_emp%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(v_ang.last_name);
   END LOOP;
   
   DBMS_OUTPUT.PUT_LINE('Au fost procesate '||v_emp%ROWCOUNT 
                        || ' linii');
   CLOSE v_emp;
END;
/

--12
DECLARE
  TYPE  empref IS REF CURSOR; 
  v_emp empref;
  v_nr  INTEGER := &n;
  v_id  employees.employee_id%type;
  v_salary  employees.salary%type;
  v_comm  employees.commission_pct%type;
BEGIN
  OPEN v_emp FOR 
    'SELECT employee_id, salary, commission_pct ' ||
    'FROM employees WHERE salary > :bind_var'
     USING v_nr;
 -- introduceti liniile corespunzatoare rezolvarii problemei
  LOOP
    FETCH v_emp INTO v_id, v_salary, v_comm;
    EXIT WHEN v_emp%NOTFOUND;
    IF v_comm IS NULL THEN
      DBMS_OUTPUT.PUT_LINE(v_id || '   ' || v_salary);
    ELSE
      DBMS_OUTPUT.PUT_LINE(v_id || '   ' || v_salary || '  ' || v_comm);
    END IF;
  END LOOP;
END;
/

