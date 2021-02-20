select * from emp_bma;
select count(*) from emp_bma;
select * from emp_bma where commission_pct is not null;
select count(*) from emp_bma where commission_pct is not null;

declare
    type rec is record
        (id emp_bma.employee_id%type,
        nume emp_bma.last_name%type,
        prenume emp_bma.first_name%type,
        comision emp_bma.commission_pct%type);
    type tabel_indexat is table of rec
        index by pls_integer;
    t tabel_indexat;
begin
    delete from emp_bma
    where commission_pct is not null
    returning employee_id, last_name, first_name, commission_pct bulk collect into t;
    
    dbms_output.put_line('Au fost stersi ' || t.count || ' angajati');
    for i in t.first..t.last loop
        dbms_output.put_line(t(i).id || '  ' || 
                            t(i).nume || '  ' || 
                            t(i).prenume || '  ' || 
                            t(i).comision);
    end loop;
    rollback;
end;
/