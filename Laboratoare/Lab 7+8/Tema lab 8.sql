--2
DECLARE
  v_emps_no_per_job number(4);
  v_monthly_income_per_job employees.salary%type;
  v_emps_no number(4) := 0;
  v_monthly_income employees.salary%type := 0;
  CURSOR c_jobs IS
    SELECT   job_title, job_id
    FROM     jobs;
  CURSOR c_emps (job jobs.job_id%type) IS
    SELECT last_name, salary, NVL(commission_pct, 0) comm
    FROM employees
    where job_id = job;
BEGIN
  FOR i in c_jobs LOOP
    DBMS_OUTPUT.PUT_LINE('-------------------------------');
    DBMS_OUTPUT.PUT_LINE(i.job_title);
    DBMS_OUTPUT.PUT_LINE('----');
    v_emps_no_per_job := 0;
    v_monthly_income_per_job := 0;
    
    FOR j in c_emps(i.job_id) LOOP
      DBMS_OUTPUT.PUT_LINE(c_emps%rowcount || ' ' || j.last_name || ' ' || j.salary * (1 + j.comm));
      v_emps_no_per_job := c_emps%rowcount;
      v_monthly_income_per_job := v_monthly_income_per_job + j.salary * (1 + j.comm);
    END LOOP;
    
    IF v_emps_no_per_job <> 0 THEN
      DBMS_OUTPUT.PUT_LINE('numar angajati: ' || v_emps_no_per_job);
      DBMS_OUTPUT.PUT_LINE('venituri lunare: ' || v_monthly_income_per_job);
      DBMS_OUTPUT.PUT_LINE('media veniturilor lunare: ' || ROUND(v_monthly_income_per_job / v_emps_no_per_job, 2));
      v_emps_no := v_emps_no + v_emps_no_per_job;
      v_monthly_income := v_monthly_income + v_monthly_income_per_job;
    ELSE
      DBMS_OUTPUT.PUT_LINE('Nu lucreaza niciun angajat pe acest post');
    END IF;
    DBMS_OUTPUT.NEW_LINE();
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('numar angajati: ' || v_emps_no);
  DBMS_OUTPUT.PUT_LINE('venituri lunare: ' || v_monthly_income);
  DBMS_OUTPUT.PUT_LINE('media veniturilor lunare: ' || ROUND(v_monthly_income / v_emps_no, 2));
END;
/

--3
DECLARE
  v_emps_no_per_job number(4);
  v_monthly_income employees.salary%type := 0;
  CURSOR c_jobs IS
    SELECT   job_title, job_id
    FROM     jobs;
  CURSOR c_emps (job jobs.job_id%type) IS
    SELECT last_name, salary, NVL(commission_pct, 0) comm
    FROM employees
    where job_id = job;
BEGIN
  SELECT SUM(salary * (1 + NVL(commission_pct, 0)))
  INTO v_monthly_income
  FROM employees;
  DBMS_OUTPUT.PUT_LINE('venituri lunare: ' || v_monthly_income);

  FOR i in c_jobs LOOP
    DBMS_OUTPUT.PUT_LINE('-------------------------------');
    DBMS_OUTPUT.PUT_LINE(i.job_title);
    DBMS_OUTPUT.PUT_LINE('----');
    v_emps_no_per_job := 0;
    
    FOR j in c_emps(i.job_id) LOOP
      DBMS_OUTPUT.PUT_LINE(c_emps%rowcount || ' ' || j.last_name || ' ' || j.salary * (1 + j.comm) || ' ' ||
                            TO_CHAR(j.salary * (1 + j.comm) / v_monthly_income * 100, '0.99') || '%');
      v_emps_no_per_job := c_emps%rowcount;
    END LOOP;
    
    IF v_emps_no_per_job = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Nu lucreaza niciun angajat pe acest post');
    END IF;
    DBMS_OUTPUT.NEW_LINE();
  END LOOP;
END;
/

--4
DECLARE
  v_emps_no_per_job number(4);
  CURSOR c_jobs IS
    SELECT   job_title, job_id
    FROM     jobs;
  CURSOR c_emps (job jobs.job_id%type) IS
    SELECT last_name, salary
    FROM employees
    where job_id = job
    order by 2 desc;
BEGIN
  FOR i in c_jobs LOOP
    DBMS_OUTPUT.PUT_LINE('-------------------------------');
    DBMS_OUTPUT.PUT_LINE(i.job_title);
    DBMS_OUTPUT.PUT_LINE('----');
    v_emps_no_per_job := 0;
    
    FOR j in c_emps(i.job_id) LOOP
      EXIT WHEN c_emps%rowcount > 5;
      DBMS_OUTPUT.PUT_LINE(c_emps%rowcount || ' ' || j.last_name || ' ' || j.salary);
      v_emps_no_per_job := c_emps%rowcount;
    END LOOP;
    
    IF v_emps_no_per_job = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Nu lucreaza niciun angajat pe acest post');
    ELSIF v_emps_no_per_job < 5 THEN
      DBMS_OUTPUT.PUT_LINE('Lucreaza mai putin de 5 angajati');
    END IF;
    DBMS_OUTPUT.NEW_LINE();
  END LOOP;
END;
/

--5
DECLARE
  v_emps_no_per_job number(4);
  v_fifth_highest_salary_per_job employees.salary%type;
  CURSOR c_jobs IS
    SELECT   job_title, job_id
    FROM     jobs;
  CURSOR c_emps (job jobs.job_id%type) IS
    SELECT last_name, salary
    FROM employees
    where job_id = job
    order by 2 desc;
BEGIN
  FOR i in c_jobs LOOP
    DBMS_OUTPUT.PUT_LINE('-------------------------------');
    DBMS_OUTPUT.PUT_LINE(i.job_title);
    DBMS_OUTPUT.PUT_LINE('----');
    v_emps_no_per_job := 0;
  
    BEGIN
      SELECT DISTINCT salary
      INTO v_fifth_highest_salary_per_job
      FROM employees e
      WHERE 5 = (SELECT COUNT(DISTINCT salary)
                  FROM employees
                  WHERE e.salary<=salary
                    AND job_id = i.job_id)
        AND job_id = i.job_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_fifth_highest_salary_per_job := 0;
    END;
    
    FOR j in c_emps(i.job_id) LOOP
      EXIT WHEN j.salary < v_fifth_highest_salary_per_job;
      DBMS_OUTPUT.PUT_LINE(c_emps%rowcount || ' ' || j.last_name || ' ' || j.salary);
      v_emps_no_per_job := c_emps%rowcount;
    END LOOP;
    
    
    IF v_emps_no_per_job = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Nu lucreaza niciun angajat pe acest post');
    END IF;
    DBMS_OUTPUT.NEW_LINE();
  END LOOP;
END;
/