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