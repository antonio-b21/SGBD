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
