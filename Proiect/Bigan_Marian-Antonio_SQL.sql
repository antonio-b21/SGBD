--4. Implementați în Oracle diagrama conceptuală realizată: definiți toate tabelele, implementând toate constrângerile de integritate necesare (chei primare, cheile externe etc).

CREATE TABLE Clienti (
  id_client NUMBER constraint pk_clienti primary key,
  prenume VARCHAR2(50),
  nume VARCHAR2(50),
  email VARCHAR2(50) constraint u_email_clienti UNIQUE,
  telefon VARCHAR2(15),
  adresa VARCHAR2(50)
);

CREATE TABLE Cosuri (
  id_cos NUMBER constraint pk_cosuri primary key constraint fk_id_cos_cosuri references Clienti (id_client) on delete cascade,
  nr_produse NUMBER constraint ck_nr_produse_valid_cosuri CHECK (nr_produse >= 0),
  total NUMBER(7, 2) constraint ck_total_valid_cosuri CHECK (total >= 0)
);

CREATE TABLE Comenzi (
  id_comanda NUMBER constraint pk_comenzi primary key,
  id_client NUMBER constraint fk_id_client_comenzi references Clienti (id_client) on delete cascade,
  data_plasare DATE,
  data_primire DATE,
  total NUMBER(7, 2) constraint ck_total_valid_comenzi CHECK (total > 0)
);

CREATE TABLE Categorii (
  id_categorie NUMBER constraint pk_categorii primary key,
  nume VARCHAR2(50),
  descriere VARCHAR2(200)
);

CREATE TABLE Produse (
  id_produs NUMBER constraint pk_produse primary key,
  id_categorie NUMBER constraint fk_id_categorie_produse references Categorii (id_categorie) on delete cascade,
  nume VARCHAR2(50),
  descriere VARCHAR2(200)
);

CREATE TABLE Recenzii (
  id_client NUMBER constraint fk_id_client_recenzii references Clienti (id_client) on delete cascade,
  id_produs NUMBER constraint fk_id_produs_recenzii references Produse (id_produs) on delete cascade,
  data_recenzie DATE,
  nota NUMBER constraint ck_nota_valid_recenzii CHECK (nota IN (1, 2, 3, 4, 5)),
  constraint pk_recenzii primary key (id_client, id_produs)
);

CREATE TABLE Comercianti (
  id_comerciant NUMBER constraint pk_comercianti primary key,
  nume VARCHAR2(50) NOT NULL,
  descriere VARCHAR2(200),
  email VARCHAR2(50) constraint u_email_comercianti UNIQUE,
  telefon VARCHAR2(15),
  adresa VARCHAR2(100)
);

CREATE TABLE Oferte (
  id_oferta NUMBER constraint pk_oferte primary key,
  id_comerciant NUMBER constraint fk_id_comerciant_oferte references Comercianti (id_comerciant) on delete cascade,
  id_produs NUMBER constraint fk_id_produs_oferte references Produse (id_produs) on delete cascade,
  pret NUMBER(7, 2) constraint ck_pret_valid_oferte CHECK (pret > 0),
  stoc NUMBER constraint ck_stoc_valid_oferte CHECK (stoc >= 0)
);

CREATE TABLE ContinutCosuri (
  id_cos NUMBER constraint fk_id_cos_continutCosuri references Cosuri (id_cos) on delete cascade,
  id_oferta NUMBER constraint fk_id_oferta_continutCosuri references Oferte (id_oferta) on delete cascade,
  cantitate NUMBER constraint ck_cantitate_valid_continutCosuri CHECK (cantitate > 0),
  constraint pk_continutCosuri primary key (id_cos, id_oferta)
);

CREATE TABLE ContinutComenzi (
  id_comanda NUMBER constraint fk_id_comanda_continutComenzi references Comenzi (id_comanda) on delete cascade,
  id_oferta NUMBER constraint fk_id_oferta_continutComenzi references Oferte (id_oferta) on delete cascade,
  cantitate NUMBER constraint ck_cantitate_valid_continutComenzi CHECK (cantitate > 0),
  constraint pk_continutComenzi primary key (id_comanda, id_oferta)
);

--5. Adăugați informații coerente în tabelele create (minim 3-5 înregistrări pentru fiecare entitate independentă; minim 10 înregistrări pentru tabela asociativă).

INSERT INTO Clienti
VALUES ('100', 'Hazel', 'Philtanker', 'HPHILTAN@gmail.com', '+40 710 887 946', NULL);

INSERT INTO Clienti
VALUES ('101', 'Renske', 'Ladwig', 'RLADWIG@gmail.com', '+40 724 486 148', NULL);

INSERT INTO Clienti
VALUES ('102', 'Stephen', 'Stiles', 'SSTILES@gmail.com', '+40 711 971 579', NULL);

INSERT INTO Clienti
VALUES ('103', 'John', 'Seo', 'JSEO@gmail.com', '+40 703 658 064', NULL);

INSERT INTO Clienti
VALUES ('104', 'Joshua', 'Patel', 'JPATEL@gmail.com', '+40 702 047 973', NULL);

INSERT INTO Clienti
VALUES ('105', 'John', 'Doe', 'JDOE@gmail.com', '+40 741 326 126', NULL);


INSERT INTO Cosuri
VALUES ('100', '0', '0.0');

INSERT INTO Cosuri
VALUES ('101', '0', '0.0');

INSERT INTO Cosuri
VALUES ('102', '1', '5355.66');

INSERT INTO Cosuri
VALUES ('103', '2', '1244.99');

INSERT INTO Cosuri
VALUES ('104', '1', '2034.44');

INSERT INTO Cosuri
VALUES ('105', '0', '0');


INSERT INTO Comenzi
VALUES ('300', '103', SYSDATE -5.24, SYSDATE -0.13, '5885.62');

INSERT INTO Comenzi
VALUES ('301', '100', SYSDATE -2.86, NULL, '529.99');

INSERT INTO Comenzi
VALUES ('302', '101', SYSDATE -2.35, NULL, '1059.98');


INSERT INTO Categorii
VALUES ('20', 'Laptop, Desktop', 'Laptopuri, sisteme PC, monitoare, hard disk drive, solid state drive, placi video, placi de baza, procesoare, memorii RAM, surse de alimentare, coolere, placi de sunet, placi de retea');

INSERT INTO Categorii
VALUES ('21', 'Electrocasnice mari si mici', 'Masini de spalat rufe, uscatoare de rufe, aparate frigorifice, masini de spalat vase, aragazuri, hote, esspressoare, cafetiere, aspiratoare, fiare de calcat, roboti de bucatarie, mixere');

INSERT INTO Categorii
VALUES ('22', 'Climatizare, incalzile locuinta', 'Aeroterme, calorifere electrice, radiatoare si convectoare, seminee electrice, boilere, aer conditionat, ventilator, umidificatoare, dezumidificatoare, purificatoare aer');


INSERT INTO Produse
VALUES ('50', '20', 'Monitor LED PLS Samsung 23.5", Full HD', 'Avand doar 10 mm, panelul este de peste doua ori mai subtire decat monitoarele standard Samsung. Suport simplu circular: Un suport circular simplu completeaza elegant ecranul super slim.');

INSERT INTO Produse
VALUES ('51', '20', 'Monitor LED IPS LG 25", UWHD 2K', 'Vi se garanteaza o grafica captivanta printr-un spatiu color sRGB mai mare de 99％. Claritatea culorii este asigurata prin testele de calibrare a culorii.');

INSERT INTO Produse
VALUES ('52', '20', 'Monitor LED IPS Acer Nitro 23.8", Full HD', 'Intra in joc cu cele mai recente monitoare AMD FreeSync ™ Premium 3 care elimina ruperea imaginii, intreruperile, artefactele si lumina intermitenta cu rate de reimprospatare de pana la 165 Hz.');

INSERT INTO Produse
VALUES ('53', '21', 'Frigider cu doua usi Arctic, 306 l, Clasa A++', 'Compartiment spatios dedicat depozitarii legumelor si fructelor. Alimentele tale vor fi proaspete si gustoase o perioada indelungata!');

INSERT INTO Produse
VALUES ('54', '21', 'Frigider cu doua usi Heinner, 204 l, Clasa A+', 'Beneficiezi de un consum optim de energie electrica si o super economie, in comparatie cu produsele din clasele inferioare.');


INSERT INTO Recenzii
VALUES ('103', '53', SYSDATE -3.92, '4');

INSERT INTO Recenzii
VALUES ('101', '53', SYSDATE -3.56, '2');

INSERT INTO Recenzii
VALUES ('104', '53', SYSDATE -3.22, '5');

INSERT INTO Recenzii
VALUES ('101', '50', SYSDATE -2.75, '1');

INSERT INTO Recenzii
VALUES ('100', '50', SYSDATE -2.29, '3.');

INSERT INTO Recenzii
VALUES ('103', '50', SYSDATE -1.67, '4');

INSERT INTO Recenzii
VALUES ('101', '51', SYSDATE -1.46, '2');

INSERT INTO Recenzii
VALUES ('103', '52', SYSDATE -0.20, '3');

INSERT INTO Recenzii
VALUES ('101', '54', SYSDATE -0.74, '4');

INSERT INTO Recenzii
VALUES ('100', '51', SYSDATE -0.12, '5');


INSERT INTO Comercianti
VALUES ('10', 'Euroshop', 'NOWE KOLORY Sp. Z o.o', 'nowekolory@gmail.com', '+40 316 303 630', 'Niedzwiedzia 29b, Warszawa, Warszawa');

INSERT INTO Comercianti
VALUES ('11', 'MELAROX', 'MELAROX COM SRL', 'melaroxcom@gmail.com', '021 9969', 'Bistrita, str. Vasile Petri, nr 1, jud Bistrita-Nasaud, Bistrita, Bistrita-Nasaud, 420005');

INSERT INTO Comercianti
VALUES ('12', 'Abbruzzami', 'ABBRUZZAMI S.r.l.', 'abbruzzami@gmail.com', '+40 722 250 000', 'VIALE ABRUZZO 35, 64025, Pineto, Teramo');

INSERT INTO Comercianti
VALUES ('13', 'VEXIO', 'FANPLACE IT SRL', 'fanplaceit@gmail.ro', '+40 374 477 115', 'Str 1 mai nr 2, Panciu, Vrancea, 625400');


INSERT INTO Oferte
VALUES ('200', '10', '50', '669.89', '24');

INSERT INTO Oferte
VALUES ('201', '10', '51', '834.56', '8');

INSERT INTO Oferte
VALUES ('202', '10', '52', '529.99', '31');

INSERT INTO Oferte
VALUES ('203', '11', '53', '1199.89', '13');

INSERT INTO Oferte
VALUES ('204', '11', '54', '876.34', '17');

INSERT INTO Oferte
VALUES ('205', '12', '53', '1244.99', '4');

INSERT INTO Oferte
VALUES ('206', '12', '54', '529.99', '0');


INSERT INTO ContinutCosuri
VALUES ('102', '200', '1');

INSERT INTO ContinutCosuri
VALUES ('102', '201', '1');

INSERT INTO ContinutCosuri
VALUES ('102', '202', '1');

INSERT INTO ContinutCosuri
VALUES ('102', '203', '1');

INSERT INTO ContinutCosuri
VALUES ('102', '204', '1');

INSERT INTO ContinutCosuri
VALUES ('102', '205', '1');

INSERT INTO ContinutCosuri
VALUES ('103', '205', '1');

INSERT INTO ContinutCosuri
VALUES ('104', '200', '1');

INSERT INTO ContinutCosuri
VALUES ('104', '201', '1');

INSERT INTO ContinutCosuri
VALUES ('104', '202', '1');


INSERT INTO ContinutComenzi
VALUES ('300', '200', '1');

INSERT INTO ContinutComenzi
VALUES ('300', '201', '1');

INSERT INTO ContinutComenzi
VALUES ('300', '202', '1');

INSERT INTO ContinutComenzi
VALUES ('300', '203', '1');

INSERT INTO ContinutComenzi
VALUES ('300', '204', '1');

INSERT INTO ContinutComenzi
VALUES ('300', '205', '1');

INSERT INTO ContinutComenzi
VALUES ('300', '206', '1');

INSERT INTO ContinutComenzi
VALUES ('301', '206', '1');

INSERT INTO ContinutComenzi
VALUES ('302', '202', '1');

INSERT INTO ContinutComenzi
VALUES ('302', '206', '1');

--6. Definiți un subprogram stocat care să utilizeze un tip de colecție studiat. Apelați subprogramul.

-- Aplicati o reducere de %5 pentru toate produsele vandute de comerciantul n ce depasesc 50% din pretul celui mai scump produs din magazin. Afisati noua a lista de preturi a comerciantului. Daca acel comerciant nu vinde niciun produs in prezent acest lucru va fi specificat.
CREATE OR REPLACE PROCEDURE AplicaReduceri (
  v_comerciant Comercianti.nume%TYPE
) IS
  v_cel_mai_scump Oferte.pret % TYPE;
  v_id_comerciant Comercianti.id_comerciant % TYPE;
  TYPE record_produs IS RECORD (
    id_oferta Oferte.id_oferta % TYPE,
    pret Oferte.pret % TYPE,
    id_produs Oferte.id_produs % TYPE,
    nume Produse.nume % TYPE
  );
  TYPE tabel_produse IS TABLE OF record_produs;
  tab_produse tabel_produse;
BEGIN 
  SELECT MAX(pret)
  INTO v_cel_mai_scump
  FROM Oferte;

  SELECT id_comerciant
  INTO v_id_comerciant
  FROM Comercianti
  WHERE LOWER(nume) = LOWER(v_comerciant);

  SELECT id_oferta, pret, id_produs, nume
  BULK COLLECT INTO tab_produse
  FROM Oferte JOIN Produse USING (id_produs)
  WHERE id_comerciant = v_id_comerciant;

  DBMS_OUTPUT.PUT_LINE('Comerciantul ' || v_comerciant);

  IF tab_produse.count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Nu vinde niciun produs in prezent');
  ELSE
    FOR i IN tab_produse.FIRST..tab_produse.LAST LOOP
      IF tab_produse(i) .pret > v_cel_mai_scump * 0.5 THEN tab_produse(i) .pret := tab_produse(i) .pret * 0.95;
        UPDATE Oferte
        SET pret = tab_produse(i).pret
        WHERE id_oferta = tab_produse(i) .id_oferta;
      END IF;

      DBMS_OUTPUT.PUT_LINE(tab_produse(i).id_produs || '  ' || tab_produse(i).nume || '  ' || tab_produse(i).pret);
    END LOOP;
  END IF;
EXCEPTION
  WHEN no_data_found THEN
    DBMS_OUTPUT.PUT_LINE('Nu exista comerciantul ' || v_comerciant);
END AplicaReduceri;
/ 

EXECUTE AplicaReduceri('Euroshop');
EXECUTE AplicaReduceri('Melarox');
EXECUTE AplicaReduceri('Abbruzzami');
EXECUTE AplicaReduceri('Vexio');
EXECUTE AplicaReduceri('Texo');

--7. Definiți un subprogram stocat care să utilizeze un tip de cursor studiat. Apelați subprogramul.

-- Afisati produsele din top n(1-5) pentru fiecare client conform recenziilor lasate de acestia.
CREATE OR REPLACE PROCEDURE TopProduse (
  v_nota recenzii.nota%TYPE DEFAULT 1
) IS
  v_produse_per_client number(4);
  v_a_na_cea_mai_mare_nota recenzii.nota%TYPE;
  CURSOR c_clienti IS
    SELECT   nume, id_client
    FROM     clienti;
  CURSOR c_recenzii (client clienti.id_client%TYPE) IS
    SELECT nume, nota
    FROM recenzii natural join produse
    where id_client = client
    order by 2 desc;
BEGIN
  IF v_nota <= 0 OR v_nota > 5 THEN
    DBMS_OUTPUT.PUT_LINE('Nota nu este valida');
  ELSE
    FOR i IN c_clienti LOOP
        DBMS_OUTPUT.PUT_LINE('-------------------------------');
        DBMS_OUTPUT.PUT_LINE(i.nume);
        DBMS_OUTPUT.PUT_LINE('----');
        v_produse_per_client := 0;
    
        BEGIN
        SELECT DISTINCT nota
        INTO v_a_na_cea_mai_mare_nota
        FROM recenzii r
        WHERE v_nota = (SELECT COUNT(DISTINCT nota)
                    FROM recenzii
                    WHERE r.nota <= nota
                        AND id_client = i.id_client)
            AND id_client = i.id_client;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_a_na_cea_mai_mare_nota := 0;
        END;
        
        FOR j IN c_recenzii(i.id_client) LOOP
        EXIT WHEN j.nota < v_a_na_cea_mai_mare_nota;
        DBMS_OUTPUT.PUT_LINE(c_recenzii%rowcount || ' ' || j.nume || ' (' || j.nota || '*)');
        v_produse_per_client := c_recenzii%rowcount;
        END LOOP;
        
        
        IF v_produse_per_client = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Nu a scris recenzii niciunui produs');
        END IF;
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
  END IF;
END TopProduse;
/

EXECUTE TopProduse(2);

--8. Definiți un subprogram stocat de tip funcție care să utilizeze 3 dintre tabelele definite. Tratați toate excepțiile care pot apărea. Apelați subprogramul astfel încât să evidențiați toate cazurile tratate.

-- Determinati care este comerciantul(cod, nume) cel mai de incredere pe o anumita categorie(id) de produse. Pentru a calcula gradul de incredere se foloseste media notelor din recenzii, numarul recenziilor scrise, data primei recenzii. Daca sunt mai multi, se ia in considerare doar primul in ordine alfabetica.
CREATE OR REPLACE FUNCTION CelMaiDeIncredere (
    v_categ IN Categorii.id_categorie%TYPE
) RETURN VARCHAR2 IS
    v_categorie Categorii.nume%TYPE;
    TYPE tabel_comercianti IS TABLE OF Comercianti%ROWTYPE;
    v_comercianti tabel_comercianti;
BEGIN
    SELECT nume
    INTO v_categorie
    FROM Categorii
    WHERE id_categorie = v_categ;

    SELECT Comercianti.id_comerciant, Comercianti.nume, Comercianti.descriere, Comercianti.email, Comercianti.telefon, Comercianti.adresa
    BULK COLLECT INTO v_comercianti
    FROM Comercianti
    LEFT JOIN Oferte ON (Comercianti.id_comerciant = Oferte.id_comerciant)
    LEFT JOIN Produse USING (id_produs)
    LEFT JOIN Recenzii USING (id_produs)
    WHERE id_categorie = v_categ
    GROUP BY Comercianti.id_comerciant, Comercianti.nume, Comercianti.descriere, Comercianti.email, Comercianti.telefon, Comercianti.adresa
    ORDER by AVG(nota) desc, COUNT(nota) desc, MIN(data_recenzie), 2;

    IF v_comercianti.count = 0 THEN
        RETURN v_categorie || ' : ' || 'Niciun comerciant nu a primit recenzii pentru produse vandute in aceasta categorie';
    END IF;
    
    RETURN v_categorie || ' : (' || TO_CHAR(v_comercianti(1).id_comerciant) || ') ' || v_comercianti(1).nume;
EXCEPTION
    WHEN no_data_found THEN
        RETURN 'Nu exista categoria cu codul dat';
END CelMaiDeIncredere;
/

SELECT CelMaiDeIncredere(20) FROM dual;
SELECT CelMaiDeIncredere(21) FROM dual;
SELECT CelMaiDeIncredere(22) FROM dual;
SELECT CelMaiDeIncredere(23) FROM dual;

--9. Definiți un subprogram stocat de tip procedură care să utilizeze 5 dintre tabelele definite. Tratați toate excepțiile care pot apărea. Apelați subprogramul astfel încât să evidențiați toate cazurile tratate.

--Pentru clientul(nume, prenume, email) cu un prenume dat afisati categoria din care face parte cel mai ieftin produs cumparat. Daca sunt mai multe produse sa se afiseze multimea acestor categorii.
CREATE OR REPLACE PROCEDURE CelMaiIeftinProdus (
  v_prenume IN Clienti.prenume%TYPE
) IS
  v_client Clienti%ROWTYPE;
  v_cel_mai_mic_pret Oferte.pret%TYPE;
  TYPE v_tabel_categorii IS TABLE OF Categorii.nume%TYPE;
  v_categorii v_tabel_categorii;
BEGIN
  SELECT *
  INTO v_client
  FROM Clienti
  WHERE lower(prenume) = lower(v_prenume);

  DBMS_OUTPUT.PUT_LINE(v_client.prenume || ' ' || v_client.nume || ' ' || v_client.email);

  SELECT MIN(pret)
  INTO v_cel_mai_mic_pret
  FROM Oferte
  JOIN ContinutComenzi USING (id_oferta)
  JOIN Comenzi USING (id_comanda)
  WHERE id_client = v_client.id_client;

  SELECT DISTINCT Categorii.nume
  BULK COLLECT INTO v_categorii
  FROM Categorii
  JOIN Produse USING (id_categorie)
  JOIN Oferte USING (id_produs)
  JOIN ContinutComenzi USING (id_oferta)
  JOIN Comenzi USING (id_comanda)
  WHERE pret = v_cel_mai_mic_pret
    AND id_client = v_client.id_client
  ORDER BY 1;
  
  IF v_categorii.count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Acest client nu a cumparat niciun produs');
  ELSE
    FOR i IN v_categorii.FIRST..v_categorii.LAST LOOP
      DBMS_OUTPUT.PUT_LINE(v_categorii(i));
    END LOOP;
  END IF;
EXCEPTION
  WHEN no_data_found THEN
    DBMS_OUTPUT.PUT_LINE('Nu exista niciun client cu acest prenume');
  WHEN too_many_rows THEN
    DBMS_OUTPUT.PUT_LINE('Exista mai multi clienti cu acest prenume');
END CelMaiIeftinProdus;
/

EXECUTE CelMaiIeftinProdus('Hazel');
EXECUTE CelMaiIeftinProdus('Renske');
EXECUTE CelMaiIeftinProdus('Stephen');
EXECUTE CelMaiIeftinProdus('John');
EXECUTE CelMaiIeftinProdus('Johnny');

--10. Definiți un trigger de tip LMD la nivel de comandă. Declanșați trigger-ul.

--Un client nu poate avea doua comenzi in curs de livrare in acelasi timp. O comanda in curs de livrare este o comanda care inca nu a fost primita.
CREATE OR REPLACE TRIGGER ComenziNelivrate
    AFTER INSERT ON Comenzi
DECLARE
    numar NUMBER;
BEGIN
    SELECT MAX(COUNT(id_comanda))
    INTO numar
    FROM Comenzi
    WHERE data_primire IS NULL
    GROUP BY id_client;

    IF numar > 1 THEN
        RAISE_APPLICATION_ERROR(-20200, 'Exista deja o comanda in curs de livrare pentru acest client');
    END IF;
END;
/

INSERT INTO Comenzi
VALUES (311, 100, sysdate, null, 529.99);

DROP TRIGGER ComenziNelivrate;

--11. Definiți un trigger de tip LMD la nivel de linie. Declanșați trigger-ul.

--Atunci cand se face o noua comanda, sa se verifice daca exista in stoc cantitatea necesara pentru fiecare produs si sa se modifice cosul de cumparaturi al celorlalti clienti in cazul care stocul devine insuficient.
CREATE OR REPLACE TRIGGER VerificaStoc
    BEFORE INSERT ON ContinutComenzi
    FOR EACH ROW
DECLARE
    stoc Oferte.stoc%TYPE;
    TYPE  empref IS REF CURSOR; 
    v_emp empref;
    v_id_cos ContinutCosuri.id_cos%TYPE;
    v_id_oferta ContinutCosuri.id_oferta%TYPE;
    v_cantitate ContinutCosuri.cantitate%TYPE;
BEGIN
    SELECT stoc
    INTO stoc
    FROM Oferte
    WHERE id_oferta = :NEW.id_oferta;

    IF :NEW.cantitate > stoc THEN
        RAISE_APPLICATION_ERROR(-20300, 'Stoc insuficient');
    END IF;

    UPDATE Oferte
    SET stoc = stoc - :NEW.cantitate
    WHERE id_oferta = :NEW.id_oferta;

    stoc := stoc - :NEW.cantitate;

    OPEN v_emp FOR 
        SELECT *
        FROM ContinutCosuri
        WHERE id_oferta = :NEW.id_oferta;
    LOOP
        FETCH v_emp INTO v_id_cos, v_id_oferta, v_cantitate;
        EXIT WHEN v_emp%NOTFOUND;
        IF v_cantitate > stoc THEN
            IF stoc > 0 THEN
                UPDATE ContinutCosuri
                SET cantitate = stoc
                WHERE id_cos = v_id_cos
                  AND id_oferta = v_id_oferta;
            ELSE
                DELETE
                FROM ContinutCosuri
                WHERE id_cos = v_id_cos
                  AND id_oferta = v_id_oferta;
            END IF;
        END IF;
    END LOOP;
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('Oferta nu exista');
END;
/

INSERT INTO ContinutComenzi
VALUES (301, 206, 2);

SELECT * FROM ContinutCosuri;
INSERT INTO ContinutComenzi
VALUES (302, 205, 4);
SELECT * FROM ContinutCosuri;

DROP TRIGGER VerificaStoc;

--12. Definiți un trigger de tip LDD. Declanșați trigger-ul.

--Blocati orice eventuala modificare asupra bazei de date si tineti evidenta asupra tuturor acestor incercari folosind un tabel de tip audit.
CREATE TABLE Modificari (
    eveniment VARCHAR2(20),
    nume_obiect VARCHAR2(30),
    data DATE
);

CREATE OR REPLACE TRIGGER TriggerModificari
  AFTER CREATE OR DROP OR ALTER ON SCHEMA
DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO Modificari
  VALUES(SYS.SYSEVENT, SYS.DICTIONARY_OBJ_NAME, SYSDATE);
  COMMIT;
  RAISE_APPLICATION_ERROR (-20300, 'Nu se poate modifica baza de date');
END TriggerModificari;
/

DROP TABLE Recenzii;

SELECT * FROM Modificari;

DROP TRIGGER TriggerModificari;

--13. Definiți un pachet care să conțină toate obiectele definite în cadrul proiectului.

CREATE OR REPLACE PACKAGE pachet AS

    PROCEDURE AplicaReduceri (
        v_comerciant Comercianti.nume%TYPE
    );

    PROCEDURE TopProduse (
        v_nota recenzii.nota%TYPE DEFAULT 1
    );

    FUNCTION CelMaiDeIncredere (
        v_categ IN Categorii.id_categorie%TYPE
    ) RETURN VARCHAR2;

    PROCEDURE CelMaiIeftinProdus (
        v_prenume IN Clienti.prenume%TYPE
    );

END pachet;
/

CREATE OR REPLACE PACKAGE BODY pachet AS

    PROCEDURE AplicaReduceri (
        v_comerciant Comercianti.nume%TYPE
    ) IS
        v_cel_mai_scump Oferte.pret % TYPE;
        v_id_comerciant Comercianti.id_comerciant % TYPE;
        TYPE record_produs IS RECORD (
            id_oferta Oferte.id_oferta % TYPE,
            pret Oferte.pret % TYPE,
            id_produs Oferte.id_produs % TYPE,
            nume Produse.nume % TYPE
        );
        TYPE tabel_produse IS TABLE OF record_produs;
        tab_produse tabel_produse;
    BEGIN
        SELECT MAX(pret)
        INTO v_cel_mai_scump
        FROM Oferte;

        SELECT id_comerciant
        INTO v_id_comerciant
        FROM Comercianti
        WHERE LOWER(nume) = LOWER(v_comerciant);

        SELECT id_oferta, pret, id_produs, nume
        BULK COLLECT INTO tab_produse
        FROM Oferte JOIN Produse USING (id_produs)
        WHERE id_comerciant = v_id_comerciant;

        DBMS_OUTPUT.PUT_LINE('Comerciantul ' || v_comerciant);

        IF tab_produse.count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Nu vinde niciun produs in prezent');
        ELSE
            FOR i IN tab_produse.FIRST..tab_produse.LAST LOOP
            IF tab_produse(i) .pret > v_cel_mai_scump * 0.5 THEN tab_produse(i) .pret := tab_produse(i) .pret * 0.95;
                UPDATE Oferte
                SET pret = tab_produse(i).pret
                WHERE id_oferta = tab_produse(i) .id_oferta;
            END IF;

            DBMS_OUTPUT.PUT_LINE(tab_produse(i).id_produs || '  ' || tab_produse(i).nume || '  ' || tab_produse(i).pret);
            END LOOP;
        END IF;
    EXCEPTION
        WHEN no_data_found THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista comerciantul ' || v_comerciant);
    END AplicaReduceri;

    PROCEDURE TopProduse (
        v_nota recenzii.nota%TYPE DEFAULT 1
    ) IS
        v_produse_per_client number(4);
        v_a_na_cea_mai_mare_nota recenzii.nota%TYPE;
        CURSOR c_clienti IS
            SELECT   nume, id_client
            FROM     clienti;
        CURSOR c_recenzii (client clienti.id_client%TYPE) IS
            SELECT nume, nota
            FROM recenzii natural join produse
            where id_client = client
            order by 2 desc;
    BEGIN
        IF v_nota <= 0 OR v_nota > 5 THEN
            DBMS_OUTPUT.PUT_LINE('Nota nu este valida');
        ELSE
            FOR i IN c_clienti LOOP
                DBMS_OUTPUT.PUT_LINE('-------------------------------');
                DBMS_OUTPUT.PUT_LINE(i.nume);
                DBMS_OUTPUT.PUT_LINE('----');
                v_produse_per_client := 0;
            
                BEGIN
                SELECT DISTINCT nota
                INTO v_a_na_cea_mai_mare_nota
                FROM recenzii r
                WHERE v_nota = (SELECT COUNT(DISTINCT nota)
                            FROM recenzii
                            WHERE r.nota <= nota
                                AND id_client = i.id_client)
                    AND id_client = i.id_client;
                EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_a_na_cea_mai_mare_nota := 0;
                END;
                
                FOR j IN c_recenzii(i.id_client) LOOP
                EXIT WHEN j.nota < v_a_na_cea_mai_mare_nota;
                DBMS_OUTPUT.PUT_LINE(c_recenzii%rowcount || ' ' || j.nume || ' (' || j.nota || '*)');
                v_produse_per_client := c_recenzii%rowcount;
                END LOOP;
                
                
                IF v_produse_per_client = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Nu a scris recenzii niciunui produs');
                END IF;
                DBMS_OUTPUT.NEW_LINE();
            END LOOP;
        END IF;
    END TopProduse;

    FUNCTION CelMaiDeIncredere (
        v_categ IN Categorii.id_categorie%TYPE
    ) RETURN VARCHAR2 IS
        v_categorie Categorii.nume%TYPE;
        TYPE tabel_comercianti IS TABLE OF Comercianti%ROWTYPE;
        v_comercianti tabel_comercianti;
    BEGIN
        SELECT nume
        INTO v_categorie
        FROM Categorii
        WHERE id_categorie = v_categ;

        SELECT Comercianti.id_comerciant, Comercianti.nume, Comercianti.descriere, Comercianti.email, Comercianti.telefon, Comercianti.adresa
        BULK COLLECT INTO v_comercianti
        FROM Comercianti
        LEFT JOIN Oferte ON (Comercianti.id_comerciant = Oferte.id_comerciant)
        LEFT JOIN Produse USING (id_produs)
        LEFT JOIN Recenzii USING (id_produs)
        WHERE id_categorie = v_categ
        GROUP BY Comercianti.id_comerciant, Comercianti.nume, Comercianti.descriere, Comercianti.email, Comercianti.telefon, Comercianti.adresa
        ORDER by AVG(nota) desc, COUNT(nota) desc, MIN(data_recenzie), 2;

        IF v_comercianti.count = 0 THEN
            RETURN v_categorie || ' : ' || 'Niciun comerciant nu a primit recenzii pentru produse vandute in aceasta categorie';
        END IF;
        
        RETURN v_categorie || ' : (' || TO_CHAR(v_comercianti(1).id_comerciant) || ') ' || v_comercianti(1).nume;
    EXCEPTION
        WHEN no_data_found THEN
            RETURN 'Nu exista categoria cu codul dat';
    END CelMaiDeIncredere;

    PROCEDURE CelMaiIeftinProdus (
        v_prenume IN Clienti.prenume%TYPE
    ) IS
        v_client Clienti%ROWTYPE;
        v_cel_mai_mic_pret Oferte.pret%TYPE;
        TYPE v_tabel_categorii IS TABLE OF Categorii.nume%TYPE;
        v_categorii v_tabel_categorii;
    BEGIN
        SELECT *
        INTO v_client
        FROM Clienti
        WHERE lower(prenume) = lower(v_prenume);

        DBMS_OUTPUT.PUT_LINE(v_client.prenume || ' ' || v_client.nume || ' ' || v_client.email);

        SELECT MIN(pret)
        INTO v_cel_mai_mic_pret
        FROM Oferte
        JOIN ContinutComenzi USING (id_oferta)
        JOIN Comenzi USING (id_comanda)
        WHERE id_client = v_client.id_client;

        SELECT DISTINCT Categorii.nume
        BULK COLLECT INTO v_categorii
        FROM Categorii
        JOIN Produse USING (id_categorie)
        JOIN Oferte USING (id_produs)
        JOIN ContinutComenzi USING (id_oferta)
        JOIN Comenzi USING (id_comanda)
        WHERE pret = v_cel_mai_mic_pret
            AND id_client = v_client.id_client
        ORDER BY 1;
        
        IF v_categorii.count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Acest client nu a cumparat niciun produs');
        ELSE
            FOR i IN v_categorii.FIRST..v_categorii.LAST LOOP
            DBMS_OUTPUT.PUT_LINE(v_categorii(i));
            END LOOP;
        END IF;
    EXCEPTION
        WHEN no_data_found THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista niciun client cu acest prenume');
        WHEN too_many_rows THEN
            DBMS_OUTPUT.PUT_LINE('Exista mai multi clienti cu acest prenume');
    END CelMaiIeftinProdus;

END pachet;
/

EXECUTE pachet.AplicaReduceri('Euroshop');
EXECUTE pachet.AplicaReduceri('Melarox');
EXECUTE pachet.AplicaReduceri('Abbruzzami');
EXECUTE pachet.AplicaReduceri('Vexio');
EXECUTE pachet.AplicaReduceri('Texo');

EXECUTE pachet.TopProduse(2);

SELECT pachet.CelMaiDeIncredere(20) FROM dual;
SELECT pachet.CelMaiDeIncredere(21) FROM dual;
SELECT pachet.CelMaiDeIncredere(22) FROM dual;
SELECT pachet.CelMaiDeIncredere(23) FROM dual;

EXECUTE pachet.CelMaiIeftinProdus('Hazel');
EXECUTE pachet.CelMaiIeftinProdus('Renske');
EXECUTE pachet.CelMaiIeftinProdus('Stephen');
EXECUTE pachet.CelMaiIeftinProdus('John');
EXECUTE pachet.CelMaiIeftinProdus('Johnny');

--14. Definiți un pachet care să includă tipuri de date complexe și obiecte necesare pentru acțiuni integrate.

--Astazi este o zi norocoasa. S-a produs o eroare in baza de date a magazinului si toate produsele din cosurile de cumparaturi ale tuturor clientilor vor fi livrate gratis.
CREATE OR REPLACE PACKAGE Eroare AS

    TYPE tabel_continutcosuri IS TABLE OF ContinutCosuri%ROWTYPE;
    TYPE matrice_continutcosuri IS TABLE OF tabel_continutcosuri;

    FUNCTION IncarcaDate
    RETURN matrice_continutcosuri;

    PROCEDURE AplicaEroare;

END Eroare;
/

CREATE OR REPLACE PACKAGE BODY Eroare AS

    FUNCTION IncarcaDate
    RETURN matrice_continutcosuri
    IS
        indice number := 1;
        produse matrice_continutcosuri := matrice_continutcosuri();
        CURSOR c_cosuri IS
            SELECT id_cos
            FROM Cosuri;
    BEGIN
        FOR cos IN c_cosuri LOOP
            produse.extend();

            SELECT *
            BULK COLLECT INTO produse(indice)
            FROM ContinutCosuri
            WHERE id_cos = cos.id_cos;

            indice := indice + 1;
        END LOOP;

        RETURN produse;
    END IncarcaDate;

    PROCEDURE AplicaEroare
    IS
        produse matrice_continutcosuri;
        id_comanda Comenzi.id_comanda%TYPE;
    BEGIN
        produse := Eroare.IncarcaDate;

        FOR nr_cos IN produse.FIRST..produse.LAST LOOP
            IF produse(nr_cos).count > 0 THEN
                SELECT 1 + MAX(id_comanda)
                INTO id_comanda
                FROM Comenzi;

                INSERT INTO Comenzi
                VALUES (id_comanda, produse(nr_cos)(1).id_cos, SYSDATE, NULL, '0');

                FOR nr_oferta in produse(nr_cos).FIRST..produse(nr_cos).LAST LOOP
                    INSERT INTO ContinutComenzi
                    VALUES (id_comanda, produse(nr_cos)(nr_oferta).id_oferta, produse(nr_cos)(nr_oferta).cantitate);
                END LOOP;

                DELETE
                FROM ContinutCosuri;

                UPDATE Cosuri
                SET nr_produse = 0, total = 0;
            END IF;
        END LOOP; 
    END AplicaEroare;

END Eroare;
/

SELECT * FROM Cosuri NATURAL JOIN ContinutCosuri;
SELECT * FROM Comenzi NATURAL JOIN ContinutComenzi;

EXECUTE Eroare.AplicaEroare;

SELECT * FROM Cosuri NATURAL JOIN ContinutCosuri;
SELECT * FROM Comenzi NATURAL JOIN ContinutComenzi;
