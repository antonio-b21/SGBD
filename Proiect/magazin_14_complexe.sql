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
