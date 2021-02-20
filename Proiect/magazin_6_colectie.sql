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