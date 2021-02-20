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
