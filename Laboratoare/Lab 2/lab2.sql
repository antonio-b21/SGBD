--4. Câte filme (titluri, respectiv exemplare) au fost împrumutate din cea mai cerutã
-- categorie?
select category, count(*), count(distinct title_id)
from rental
join title using (title_id)
group by category
having count(*) = (select max(count(*))
                    from rental
                    join title using (title_id)
                    group by category
                    );

select * from rental;
select * from title;

-- 5. Câte exemplare din fiecare film sunt disponibile în prezent (considera?i cã
-- statusul unui exemplar nu este setat, deci nu poate fi utilizat)?
select * from title_copy;
select * from title;
select * from rental;

select title, count(*) exemplare
from title t
join title_copy c on (c.title_id = t.title_id)
where (t.title_id, copy_id) not in (select title_id, copy_id
                                    from rental
                                    where act_ret_date is null
                                    )
group by title;

--6. Afi?a?i urmãtoarele informa?ii: titlul filmului, numãrul exemplarului, statusul setat ?i statusul corect.
select t.title, t.title_id,  tc.copy_id, tc.status, 
    case (select count(*)
            from rental
            where title_id = tc.title_id and copy_id = tc.copy_id and act_ret_date is null)
        when 0
        then 'AVAILABLE'
        else 'RENTED'
    end "STATUS CORECT"
from title t
join title_copy tc on (t.title_id = tc.title_id);

select * from rental
order by title_id;



--numele clientului care a facut cele mai multe rezervari
select max(count(title_id)) maxrez
from reservation
right join member using(member_id)
group by member_id;

select last_name
from reservation
join member using(member_id)
group by member_id, last_name
having count(title_id) = (select max(count(title_id)) maxrez
                            from reservation
                            right join member using(member_id)
                            group by member_id
                            );

-- 9. De câte ori a împrumutat un membru (nume ?i prenume) fiecare film (titlu)?

select last_name, first_name, count(title_id), title
from member m
full join rental r using(member_id)
full join title t using(title_id)
group by last_name, first_name, title
order by 1, 4;

select last_name, first_name, count(title_id), title
from member m
 join rental r using(member_id)
right join title t using(title_id)
group by last_name, first_name, title
order by 1, 4;

select last_name, first_name, title, count(r.title_id) inchirieri
from member m
cross join title t
left join rental r on (r.title_id = t.title_id and r.member_id = m.member_id)
group by last_name, first_name, title
order by 1, 3;

select last_name, first_name, title, (select count(title_id)
                                     from rental
                                     where title_id = t.title_id
                                     and member_id = m.member_id) inchirieri
 from member m
 cross join title t
 order by 1, 3;

select * from rental;

--10. De câte ori a împrumutat un membru (nume ?i prenume) fiecare exemplar (cod) al unui film (titlu)?

select m.last_name, m.first_name, t.title, c.copy_id, count(r.book_date)
from member m
cross join title_copy c
join title t on(t.title_id = c.title_id)
left join rental r on (m.member_id = r.member_id and c.title_id = r.title_id and c.copy_id = r.copy_id)
group by m.last_name, m.first_name, t.title, c.copy_id
order by 1, 3, 4;

select * from rental
order by 3, 4, 2;

--11. Ob?ine?i statusul celui mai des împrumutat exemplar al fiecãrui film (titlu).

select r.title_id, t.title, r.copy_id, count(r.book_date), max(c.status)
from title t
join title_copy c on (t.title_id = c.title_id)
join rental r on (c.copy_id = r.copy_id and c.title_id = r.title_id)
group by r.title_id, r.copy_id, t.title
having count(r.book_date) = (select max(count(book_date))
                            from rental
                            where title_id = r.title_id
                            group by title_id, copy_id)
order by 1, 3;

select * from rental
order by 4, 2;

select * from title_copy
order by 2, 1;









