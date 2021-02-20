--4
declare
    nume member.last_name%type := '&nume';
    numar number;
    idul member.member_id%type;
    nr_titluri number;
    
begin
    select member_id
    into idul
    from member
    where lower(last_name) = lower(nume);
    
    select count(*)
    into nr_titluri
    from title;

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
    
    if numar > 0.75 * nr_titluri then
        dbms_output.put_line('Categoria 1 (a împrumutat mai mult de 
                75% din titlurile existente)');
    elsif numar > 0.5 * nr_titluri then
        dbms_output.put_line('Categoria 2 (a împrumutat mai mult de 
                50% din titlurile existente)');
    elsif numar > 0.25 * nr_titluri then
        dbms_output.put_line('Categoria 3 (a împrumutat mai mult de 
                25% din titlurile existente)');
    else
        dbms_output.put_line('Categoria 4 (altfel)');
    end if;

exception
    when no_data_found then
        dbms_output.put_line('nu exista acest membru');
    when too_many_rows then
        dbms_output.put_line('exista mai multi membri cu numele ' || nume);
end;
/

--5
create table member_bma as select * from member;

alter table member_bma
add discount number(3, 2);


declare
    cod member_bma.member_id%type := &cod;
    numar number;
    nr_titluri number;
begin
    select count(*)
    into nr_titluri
    from title;

    select count(distinct title_id)
    into numar
    from rental
    where member_id = cod;
    
    update member_bma
    set discount =
        case
            when numar > 0.75 * nr_titluri then 0.1
            when numar > 0.5 * nr_titluri then 0.05
            when numar > 0.25 * nr_titluri then 0.03
            else 0
        end
    where member_id = cod;
    
    if sql%rowcount = 0 then
        dbms_output.put_line('nu s-a produs nicio actualizare');
    else
        dbms_output.put_line('actualizarea s-a produs');
    end if;

end;
/
