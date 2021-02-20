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
