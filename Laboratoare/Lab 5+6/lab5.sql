--1
DECLARE
    x   NUMBER(1) := 5;
    y   x%TYPE := NULL;
BEGIN
    IF x <> y THEN
        dbms_output.put_line('valoare <> null este = true');
    ELSE
        dbms_output.put_line('valoare <> null este != true');
    END IF;

    x := NULL;
    IF x = y THEN
        dbms_output.put_line('null = null este = true');
    ELSE
        dbms_output.put_line('null = null este != true');
    END IF;

END;
/
----------------------------------------------------
--2

DECLARE
    TYPE emp_record IS RECORD (
        cod       employees.employee_id%TYPE,
        salariu   employees.salary%TYPE,
        job       employees.job_id%TYPE
    );
    v_ang emp_record;
BEGIN
    DELETE FROM emp_bma
    WHERE
        employee_id = 100
    RETURNING employee_id,
              salary,
              job_id INTO v_ang;

    dbms_output.put_line('Angajatul cu codul '
                         || v_ang.cod
                         || ' si jobul '
                         || v_ang.job
                         || ' are salariul '
                         || v_ang.salariu);

END;
/

ROLLBACK;
----------------------------------------------------
--3

DECLARE
    v_ang1   employees%rowtype;
    v_ang2   employees%rowtype;
BEGIN
-- sterg angajat 100 si mentin in variabila linia stearsa
    DELETE FROM emp_bma
    WHERE
        employee_id = 100
    RETURNING employee_id,
              first_name,
              last_name,
              email,
              phone_number,
              hire_date,
              job_id,
              salary,
              commission_pct,
              manager_id,
              department_id INTO v_ang1;
-- inserez in tabel linia stearsa

    INSERT INTO emp_bma VALUES v_ang1;
-- sterg angajat 101

    DELETE FROM emp_bma
    WHERE
        employee_id = 101;

    SELECT
        *
    INTO v_ang2
    FROM
        employees
    WHERE
        employee_id = 101;
-- inserez o linie oarecare in emp_bma

    INSERT INTO emp_bma VALUES (
        1000,
        'FN',
        'LN',
        'E',
        NULL,
        sysdate,
        'AD_VP',
        1000,
        NULL,
        100,
        90
    );
-- modific linia adaugata anterior cu valorile variabilei v_ang2

    UPDATE emp_bma
    SET
        row = v_ang2
    WHERE
        employee_id = 1000;

END;
/

----------------------------------------------------
--4

DECLARE
 TYPE tablou_indexat IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
 t tablou_indexat;
BEGIN
-- punctul a
 FOR i IN 1..10 LOOP
 t(i):=i;
 END LOOP;
 DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
 FOR i IN t.FIRST..t.LAST LOOP
 DBMS_OUTPUT.PUT(t(i) || ' ');
 END LOOP;
 DBMS_OUTPUT.NEW_LINE;
-- punctul b
 FOR i IN 1..10 LOOP
 IF i mod 2 = 0 THEN t(i):=null;
 END IF;
 END LOOP;
 DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
  FOR i IN t.FIRST..t.LAST LOOP
 DBMS_OUTPUT.PUT(nvl(t(i), 0) || ' ');
 END LOOP;
 DBMS_OUTPUT.NEW_LINE;
-- punctul c
 t.DELETE(1,3);
 t.DELETE(t.last);
 DBMS_OUTPUT.PUT_LINE('Primul element are indicele ' || t.first ||
 ' si valoarea ' || nvl(t(t.first),0));
DBMS_OUTPUT.PUT_LINE('Ultimul element are indicele ' || t.last ||
 ' si valoarea ' || nvl(t(t.last),0));
 DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
 FOR i IN t.FIRST..t.LAST LOOP
 IF t.EXISTS(i) THEN
 DBMS_OUTPUT.PUT(nvl(t(i), 0)|| ' ');
 END IF;
 END LOOP;
 DBMS_OUTPUT.NEW_LINE;
-- punctul d
 t.delete;
 DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.');
END;
/
----------------------------------------------------
--5
DECLARE
 TYPE tablou_indexat IS TABLE OF emp_bma%ROWTYPE
 INDEX BY BINARY_INTEGER;
 t tablou_indexat;
BEGIN
-- stergere din tabel si salvare in tablou
 DELETE FROM emp_bma
 WHERE ROWNUM<= 2
 RETURNING employee_id, first_name, last_name, email, phone_number,
 hire_date, job_id, salary, commission_pct, manager_id,
 department_id
 BULK COLLECT INTO t;
--afisare elemente tablou
 DBMS_OUTPUT.PUT_LINE (t(1).employee_id ||' ' || t(1).last_name);
 DBMS_OUTPUT.PUT_LINE (t(2).employee_id ||' ' || t(2).last_name);
--inserare cele 2 linii in tabel
 INSERT INTO emp_bma VALUES t(1);
 INSERT INTO emp_bma VALUES t(2);
 END;
/

select * from emp_bma where employee_id = 106;
----------------------------------------------------
--6
DECLARE
 TYPE tablou_imbricat IS TABLE OF NUMBER;
 t tablou_imbricat := tablou_imbricat();
BEGIN
-- punctul a
 FOR i IN 1..10 LOOP
 t.extend;
 t(i):=i;
 END LOOP;
 DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');

 FOR i IN t.FIRST..t.LAST LOOP
 DBMS_OUTPUT.PUT(t(i) || ' ');
 END LOOP;
 DBMS_OUTPUT.NEW_LINE;
  FOR i IN 1..10 LOOP
 IF i mod 2 = 1 THEN t(i):=null;
 END IF;
 END LOOP;
 DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
 FOR i IN t.FIRST..t.LAST LOOP
 DBMS_OUTPUT.PUT(nvl(t(i), 0) || ' ');
 END LOOP;
 DBMS_OUTPUT.NEW_LINE;
-- punctul c
 t.DELETE(t.first);
 t.DELETE(5,7);
 t.DELETE(t.last);
 DBMS_OUTPUT.PUT_LINE('Primul element are indicele ' || t.first ||
 ' si valoarea ' || nvl(t(t.first),0));
 DBMS_OUTPUT.PUT_LINE('Ultimul element are indicele ' || t.last ||
 ' si valoarea ' || nvl(t(t.last),0));
 DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
 FOR i IN t.FIRST..t.LAST LOOP
 IF t.EXISTS(i) THEN
 DBMS_OUTPUT.PUT(nvl(t(i), 0)|| ' ');
 END IF;
 END LOOP;
 DBMS_OUTPUT.NEW_LINE;
-- punctul d
 t.delete;
 DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.');
END;
/

----------------------------------------------------
--7
DECLARE
TYPE tablou_imbricat IS TABLE OF CHAR(1);
t tablou_imbricat := tablou_imbricat('m', 'i', 'n', 'i', 'm');
 i INTEGER;
BEGIN
i := t.FIRST;
WHILE i <= t.LAST LOOP
 DBMS_OUTPUT.PUT(t(i));
 i := t.NEXT(i);
END LOOP;
DBMS_OUTPUT.NEW_LINE;
 i := t.LAST;
WHILE i >= t.FIRST LOOP
 DBMS_OUTPUT.PUT(t(i));
 i := t.PRIOR(i);
END LOOP;
DBMS_OUTPUT.NEW_LINE;
 t.delete(2);
 t.delete(4);
i := t.FIRST;
WHILE i <= t.LAST LOOP
 DBMS_OUTPUT.PUT(t(i));
 i := t.NEXT(i);
END LOOP;
DBMS_OUTPUT.NEW_LINE;
 i := t.LAST;
WHILE i >= t.FIRST LOOP
 DBMS_OUTPUT.PUT(t(i));
 i := t.PRIOR(i);
END LOOP;
DBMS_OUTPUT.NEW_LINE;
END;
/
----------------------------------------------------
--8
DECLARE
 TYPE vector IS VARRAY(20) OF NUMBER;
 t vector:= vector();
BEGIN
-- punctul a
 FOR i IN 1..10 LOOP
 t.extend; t(i):=i;
 END LOOP;
 DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
 FOR i IN t.FIRST..t.LAST LOOP
 DBMS_OUTPUT.PUT(t(i) || ' ');
 END LOOP;
 DBMS_OUTPUT.NEW_LINE;
-- punctul b
 FOR i IN 1..10 LOOP
 IF i mod 2 = 1 THEN t(i):=null;
 END IF;
 END LOOP;
 DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
 FOR i IN t.FIRST..t.LAST LOOP
 DBMS_OUTPUT.PUT(nvl(t(i), 0) || ' ');
 END LOOP;
 DBMS_OUTPUT.NEW_LINE;
-- punctul c
-- metodele DELETE(n), DELETE(m,n) nu sunt valabile pentru vectori!!!
-- din vectori nu se pot sterge elemente individuale!!!
-- punctul d
 t.delete;
 DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.');
END;
/
----------------------------------------------------
--9
CREATE OR REPLACE TYPE subordonati_bma AS VARRAY(10) OF NUMBER(4);
/
CREATE TABLE manageri_bma (cod_mgr NUMBER(10),
 nume VARCHAR2(20),
 lista subordonati_bma);
DECLARE
 v_sub subordonati_bma:= subordonati_bma(100,200,300);
 v_lista manageri_bma.lista%TYPE;
BEGIN
 INSERT INTO manageri_bma
 VALUES (1, 'Mgr 1', v_sub);
 INSERT INTO manageri_bma
 VALUES (2, 'Mgr 2', null);

 INSERT INTO manageri_bma
 VALUES (3, 'Mgr 3', subordonati_bma(400,500));

 SELECT lista
 INTO v_lista
 FROM manageri_bma
 WHERE cod_mgr=1;

 FOR j IN v_lista.FIRST..v_lista.LAST loop
 DBMS_OUTPUT.PUT_LINE (v_lista(j));
 END LOOP;
END;
/
SELECT * FROM manageri_bma;
DROP TABLE manageri_bma;
DROP TYPE subordonati_bma;

--10
CREATE TABLE emp_test_bma AS
 SELECT employee_id, last_name FROM employees
 WHERE ROWNUM <= 2;
CREATE OR REPLACE TYPE tip_telefon_bma IS TABLE OF VARCHAR(12);
/
ALTER TABLE emp_test_bma
ADD (telefon tip_telefon_bma)
NESTED TABLE telefon STORE AS tabel_telefon_bma;
INSERT INTO emp_test_bma
VALUES (500, 'XYZ',tip_telefon_bma('074XXX', '0213XXX', '037XXX'));
UPDATE emp_test_bma
SET telefon = tip_telefon_bma('073XXX', '0214XXX')
WHERE employee_id=100;
SELECT a.employee_id, b.*
FROM emp_test_bma a, TABLE (a.telefon) b;
DROP TABLE emp_test_bma;
DROP TYPE tip_telefon_bma;

desc emp_test_bma;
select * from emp_test_bma;


--1 Men?ine?i �ntr-o colec?ie codurile celor mai prost 
--pl�ti?i 5 angaja?i care nu c�?tig� comision. Folosind 
--aceast� colec?ie m�ri?i cu 5% salariul acestor angaja?i. 
--Afi?a?i valoarea veche a salariului, respectiv valoarea 
--nou� a salariului. 

declare
    type tip_cod is varray(5) of emp_bma.employee_id%type;
    coduri tip_cod;
    salariu emp_bma.salary%type;
begin
    select employee_id
    bulk collect into coduri
    from (select *
            from emp_bma
            where commission_pct is null
            order by salary)
    where rownum <= 5;
    
    for i in coduri.first..coduri.last loop
        select salary into salariu
        from emp_bma
        where employee_id = coduri(i);
        dbms_output.put('Angajatul ' || coduri(i) ||
            ' a trecut de la salariul ' || salariu);
        salariu := salariu * 1.05;
        dbms_output.put_line(' la salariul ' || salariu);
    end loop;

end;
/
--pt un job dat de la tastatura afisati cati oameni lucreaza pe job-ul respectiv si care sunt acestia
select * from employees;
 
declare
    job_id_citit employees.job_id%type := '&cod_job';
    type tbl_idx is table of employees%rowtype index by pls_integer;
    t tbl_idx;
begin
    select *
    bulk collect into t
    from employees
    where lower(job_id) = lower(job_id_citit);
    
    dbms_output.put_line('lucreaza ' || t.count || ' angajati');
    
    for i in t.first..t.last loop
        dbms_output.put_line(t(i).last_name);
    end loop;
end;
/