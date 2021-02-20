--2 
CREATE OR REPLACE TYPE tip_orase_bma IS TABLE OF VARCHAR(20);
/
drop table excursie_bma;
CREATE TABLE excursie_bma (
    cod_excursie NUMBER(4),
    denumire VARCHAR2(30),
    orase tip_orase_bma,
    status VARCHAR(15),
    constraint status_ck CHECK(lower(status) IN ('disponibila', 'anulata'))
) NESTED TABLE orase STORE AS table_orase_bma;

insert into excursie_bma
values (100, 'Excursie la Predeal', tip_orase_bma('Predeal'), 'disponibila');

insert into excursie_bma
values (101, 'Excursie in Mures', tip_orase_bma('Sighisoara', 'Sovata'), 'disponibila');

insert into excursie_bma
values (102, 'Excursie pe Transalpina', tip_orase_bma('Ranca', 'Obarsia Lotrului', 'Sebes'), 'anulata');

insert into excursie_bma
values (103, 'Excursie in Maramures', tip_orase_bma('Barsana', 'Sighetu Marmatiei', 'Sapanta'), 'anulata');

insert into excursie_bma
values (104, 'Excursie la Comana', tip_orase_bma('Comana'), 'disponibila');


declare
    v_cod excursie_bma.cod_excursie%type := &cod;
    v_orase excursie_bma.orase%type := tip_orase_bma();
    v_orase_citite tip_orase_bma:= tip_orase_bma('&oras_sf', '&oras_poz2', '&oras_sch1', '&oras_sch2', '&oras_strg');
    type tip_coduri_orase is varray(5) of number;
    v_coduri_orase tip_coduri_orase := tip_coduri_orase(-1, -1);
begin
    select orase
    into v_orase
    from excursie_bma
    where cod_excursie = v_cod;
    --a
    v_orase.extend();
    v_orase(v_orase.last) := v_orase_citite(1);
    --b
    v_orase.extend();
    for i in reverse 3..v_orase.last loop
        v_orase(i) := v_orase(i-1);
    end loop;
    v_orase(2) := v_orase_citite(2);
    --c
    for i in v_orase.first..v_orase.last loop
        if lower(v_orase(i)) = lower(v_orase_citite(3)) then
            v_coduri_orase(1) := i;
        end if;
        if lower(v_orase(i)) = lower(v_orase_citite(4)) then
            v_coduri_orase(2) := i;
        end if;
    end loop;
    if -1 not in (v_coduri_orase(1), v_coduri_orase(2))then
        v_orase_citite(1) := v_orase(v_coduri_orase(1));
        v_orase(v_coduri_orase(1)) := v_orase(v_coduri_orase(2));
        v_orase(v_coduri_orase(2 )) := v_orase_citite(1);
    end if;
    --d
    for i in v_orase.first..v_orase.last loop
        if lower(v_orase(i)) = lower(v_orase_citite(5)) then
            v_orase.delete(i);
        end if;
    end loop;
    --
    update excursie_bma
    set orase = v_orase
    where cod_excursie = v_cod;
    
   for i in v_orase.first..v_orase.last loop
       dbms_output.put_line(v_orase(i) || ' ' || i);
   end loop;
end;
/
select * from excursie_bma;



--3
CREATE OR REPLACE TYPE tip_orase_bma IS varray(20) OF VARCHAR(20);
/
drop table excursie_bma;
CREATE TABLE excursie_bma (
    cod_excursie NUMBER(4),
    denumire VARCHAR2(30),
    orase tip_orase_bma,
    status VARCHAR(15),
    constraint status_ck check(lower(status) in ('disponibila', 'anulata'))
);

insert into excursie_bma
values (100, 'Excursie la Predeal', tip_orase_bma('Predeal'), 'disponibila');

insert into excursie_bma
values (101, 'Excursie in Mures', tip_orase_bma('Sighisoara', 'Sovata'), 'disponibila');

insert into excursie_bma
values (102, 'Excursie pe Transalpina', tip_orase_bma('Ranca', 'Obarsia Lotrului', 'Sebes'), 'anulata');

insert into excursie_bma
values (103, 'Excursie in Maramures', tip_orase_bma('Barsana', 'Sighetu Marmatiei', 'Sapanta'), 'anulata');

insert into excursie_bma
values (104, 'Excursie la Comana', tip_orase_bma('Comana'), 'disponibila');


declare
    v_cod excursie_bma.cod_excursie%type := &cod;
    v_orase excursie_bma.orase%type := tip_orase_bma();
    v_orase2 excursie_bma.orase%type := tip_orase_bma();
    v_orase_citite tip_orase_bma:= tip_orase_bma('&oras_sf', '&oras_poz2', '&oras_sch1', '&oras_sch2', '&oras_strg');
    type tip_coduri_orase is varray(5) of number;
    v_coduri_orase tip_coduri_orase := tip_coduri_orase(-1, -1);
    j number;
begin
    select orase
    into v_orase
    from excursie_bma
    where cod_excursie = v_cod;
    --a
    v_orase.extend();
    v_orase(v_orase.last) := v_orase_citite(1);
    --b
    v_orase.extend();
    for i in reverse 3..v_orase.last loop
        v_orase(i) := v_orase(i-1);
    end loop;
    v_orase(2) := v_orase_citite(2);
    --c
    for i in v_orase.first..v_orase.last loop
        if lower(v_orase(i)) = lower(v_orase_citite(3)) then
            v_coduri_orase(1) := i;
        end if;
        if lower(v_orase(i)) = lower(v_orase_citite(4)) then
            v_coduri_orase(2) := i;
        end if;
    end loop;
    if -1 not in (v_coduri_orase(1), v_coduri_orase(2))then
        v_orase_citite(1) := v_orase(v_coduri_orase(1));
        v_orase(v_coduri_orase(1)) := v_orase(v_coduri_orase(2));
        v_orase(v_coduri_orase(2 )) := v_orase_citite(1);
    end if;
    --d
    j := 1;
    for i in v_orase.first..v_orase.last loop
        if lower(v_orase(i)) <> lower(v_orase_citite(5)) then
            v_orase2.extend();
            v_orase2(j) := v_orase(i);
            j := j+1;
        end if;
    end loop;
    v_orase.delete();
    v_orase := tip_orase_bma();
    for i in v_orase2.first..v_orase2.last loop
        v_orase.extend();
        v_orase(i) := v_orase2(i);
    end loop;
    v_orase2.delete();
    --
    update excursie_bma
    set orase = v_orase
    where cod_excursie = v_cod;
    
    for i in v_orase.first..v_orase.last loop
        dbms_output.put_line(v_orase(i) || ' ' || i);
    end loop;
end;
/
select * from excursie_bma;
