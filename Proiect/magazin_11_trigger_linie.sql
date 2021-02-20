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
