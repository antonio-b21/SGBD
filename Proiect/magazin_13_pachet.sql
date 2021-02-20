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
