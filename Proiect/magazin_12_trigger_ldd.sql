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
