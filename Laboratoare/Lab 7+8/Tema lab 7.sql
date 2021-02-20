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
        WHERE    j.job_id = e.job_id
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