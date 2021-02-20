--1
--DECLARE
--    v_nume, v_prenume VARCHAR2(35); -- gre?it
DECLARE
    v_nume      VARCHAR2(35);
    v_prenume   VARCHAR2(35);
BEGIN
    NULL;
END;

<< principal >> DECLARE
    v_client_id       NUMBER(4) := 1600;
    v_client_nume     VARCHAR2(50) := 'N1';
    v_nou_client_id   NUMBER(3) := 500;
BEGIN
    << secundar >> DECLARE
        v_client_id         NUMBER(4) := 0;
        v_client_nume       VARCHAR2(50) := 'N2';
        v_nou_client_id     NUMBER(3) := 300;
        v_nou_client_nume   VARCHAR2(50) := 'N3';
    BEGIN
        v_client_id := v_nou_client_id;
        principal.v_client_nume := v_client_nume
                                   || ' '
                                   || v_nou_client_nume;
        --pozi?ia 1
        dbms_output.put_line(v_client_id);
        dbms_output.put_line(v_client_nume);
        dbms_output.put_line(v_nou_client_id);
        dbms_output.put_line(v_nou_client_nume);
    END;

    v_client_id := ( v_client_id * 12 ) / 10;
    --pozi?ia 2
    dbms_output.put_line(v_client_id);
    dbms_output.put_line(v_client_nume);
END;

determina?i:
- valoarea variabilei v_client_id la pozi?ia 1; 300
- valoarea variabilei v_client_nume la pozi?ia 1; N2
- valoarea variabilei v_nou_client_id la pozi?ia 1; 300
- valoarea variabilei v_nou_client_nume la pozi?ia 1; N3
- valoarea variabilei v_client_id la pozi?ia 2; 1600 * 12 / 10
- valoarea variabilei v_client_nume la pozi?ia 2. N2 N3

--ex1

DECLARE
    numar    NUMBER(3) := 100;
    mesaj1   VARCHAR2(255) := 'text 1';
    mesaj2   VARCHAR2(255) := 'text 2';
BEGIN
    DECLARE
        numar    NUMBER(3) := 1;
        mesaj1   VARCHAR2(255) := 'text 2';
        mesaj2   VARCHAR2(255) := 'text 3';
    BEGIN
        numar := numar + 1;
        mesaj2 := mesaj2 || ' adaugat in sub-bloc';
    END;

    numar := numar + 1;
    mesaj1 := mesaj1 || ' adaugat un blocul principal';
    mesaj2 := mesaj2 || ' adaugat in blocul principal';
END;

--4. Defini?i un bloc anonim �n care s� se afle numele departamentului 
--cu cei mai mul?i angaja?i. Comenta?i cazul �n care exist� cel pu?in 
--dou� departamente cu num�r maxim de angaja?i.

 DECLARE
    v_dep
    departments.department_name%TYPE;

BEGIN
    SELECT
        department_name
    INTO v_dep
    FROM
        employees     e,
        departments   d
    WHERE
        e.department_id = d.department_id
    GROUP BY
        department_name
    HAVING
        COUNT(*) = (
            SELECT
                MAX(COUNT(*))
            FROM
                employees
            GROUP BY
                department_id
        );

    dbms_output.put_line('Departamentul ' || v_dep);
END;
/

--5. Rezolva?i problema anterioar� utiliz�nd variabile de leg�tur�. 
--Afi?a?i rezultatul at�t din bloc, c�t ?i din exteriorul acestuia.

VARIABLE rezultat VARCHAR2(35)

BEGIN
    SELECT
        department_name
    INTO :rezultat
    FROM
        employees     e,
        departments   d
    WHERE
        e.department_id = d.department_id
    GROUP BY
        department_name
    HAVING
        COUNT(*) = (
            SELECT
                MAX(COUNT(*))
            FROM
                employees
            GROUP BY
                department_id
        );

    dbms_output.put_line('Departamentul ' || :rezultat);
END;
/

PRINT rezultat  

--7

SET VERIFY OFF
DECLARE
    v_cod             employees.employee_id%TYPE := &p_cod;
    v_bonus           NUMBER(8);
    v_salariu_anual   NUMBER(8);
BEGIN
    SELECT
        salary * 12
    INTO v_salariu_anual
    FROM
        employees
    WHERE
        employee_id = v_cod;
    IF v_salariu_anual >= 200001 THEN
        v_bonus := 20000;
    ELSIF v_salariu_anual BETWEEN 100001 AND 200000 THEN
        v_bonus := 10000;
    ELSE
        v_bonus := 5000;
    END IF;

    dbms_output.put_line('Bonusul este ' || v_bonus);
END;
/

SET VERIFY ON


--9
create table emp_bma as select * from employees;

DEFINE p_cod_sal= 200
DEFINE p_cod_dept = 80
DEFINE p_procent =20
DECLARE
    v_cod_sal    emp_bma.employee_id%TYPE := &p_cod_sal;
    v_cod_dept   emp_bma.department_id%TYPE := &p_cod_dept;
    v_procent    NUMBER(8) := &p_procent;

BEGIN
    UPDATE emp_bma
    SET
        department_id = v_cod_dept,
        salary = salary + ( salary * v_procent / 100 )
    WHERE
        employee_id = v_cod_sal;

    IF SQL%rowcount = 0 THEN
        dbms_output.put_line('Nu exista un angajat cu acest cod');
    ELSE
        dbms_output.put_line('Actualizare realizata');
    END IF;

END;
/

select * from emp_bma where employee_id = 200;

ROLLBACK;

--10
create table zile_bma(id number(3), data date, nume_zi varchar2(20));

DECLARE
 contor NUMBER(6) := 1;
 v_data DATE;
 maxim NUMBER(2) := LAST_DAY(SYSDATE)-SYSDATE;
BEGIN
 LOOP
 v_data := sysdate+contor;
 INSERT INTO zile_bma
 VALUES (contor, v_data,to_char(v_data,'Day'));
 contor := contor + 1;
 EXIT WHEN contor > maxim;
 END LOOP;
END;
/

select last_day(sysdate) - sysdate from dual;  
select to_char(sysdate- 3800, 'year') from dual;
select * from zile_bma;
delete from zile_bma;


-- 3. Defini?i un bloc anonim �n care s� se determine num�rul de filme
-- (titluri) �mprumutate de un membru al c�rui nume este introdus de la
-- tastatur�. Trata?i urm�toarele dou� situa?ii: nu exist� nici un
-- membru cu nume dat; exist� mai mul?i membrii cu acela?i nume.

select count(distinct title_id)
from rental r
join member m on (r.member_id = m.member_id)
where lower(m.last_name) = lower('&nume');
select * from member;

declare
    nume member.last_name%type := '&nume';
    numar number;
    idul member.member_id%type;
begin
    select member_id
    into idul
    from member
    where lower(last_name) = lower(nume);

    select count(distinct title_id)
    into numar
    from rental r
    join member m on (r.member_id = m.member_id)
    where lower(m.last_name) = lower(nume);
    if numar = 0 then
    DBMS_OUTPUT.PUT_LINE('membrul ' || initcap(nume) || 
        ' nu a imprumutat filme.');
    elsif numar = 1 then
    DBMS_OUTPUT.PUT_LINE('membrul ' || initcap(nume) ||
        ' a imprumutat ' || numar || ' film.'); 
    else
    DBMS_OUTPUT.PUT_LINE('membrul ' || initcap(nume) ||
        ' a imprumutat ' || numar || ' filme.');
    end if;
exception
    when no_data_found then
        dbms_output.put_line('nu exista acest membru');
    when too_many_rows then
        dbms_output.put_line('exista mai multi membri cu numele ' || nume);
end;
/
