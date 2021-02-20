DELETE FROM ContinutComenzi;

DELETE FROM ContinutCosuri;

DELETE FROM Oferte;

DELETE FROM Comercianti;

DELETE FROM Recenzii;

DELETE FROM Produse;

DELETE FROM Categorii;

DELETE FROM Comenzi;

DELETE FROM Cosuri;

DELETE FROM Clienti;

-- CREATE TABLE Clienti (
--   id_client NUMBER constraint pk_clienti primary key,
--   prenume VARCHAR2(50),
--   nume VARCHAR2(50),
--   email VARCHAR2(50) constraint u_email_clienti UNIQUE,
--   telefon VARCHAR2(15),
--   adresa VARCHAR2(50)
-- );
--
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

-- CREATE TABLE Cosuri (
--     id_cos NUMBER constraint pk_cosuri primary key constraint fk_id_cos_cosuri references Clienti (id_client) on delete cascade,
--     nr_produse NUMBER constraint ck_nr_produse_valid_cosuri CHECK (nr_produse >= 0),
--     total NUMBER(7, 2) constraint ck_total_valid_cosuri CHECK (total >= 0)
-- );
--
INSERT INTO Cosuri
VALUES ('100', '0', '0.0');

INSERT INTO Cosuri
VALUES ('101', '0', '0.0');

INSERT INTO Cosuri
VALUES ('102', '6', '5355.66');

INSERT INTO Cosuri
VALUES ('103', '1', '1244.99');

INSERT INTO Cosuri
VALUES ('104', '3', '2034.44');

INSERT INTO Cosuri
VALUES ('105', '0', '0');

-- CREATE TABLE Comenzi (
--   id_comanda NUMBER constraint pk_comenzi primary key,
--   id_client NUMBER constraint fk_id_client_comenzi references Clienti (id_client) on delete cascade,
--   data_plasare DATE,
--   data_primire DATE,
--   total NUMBER(7, 2) constraint ck_total_valid_comenzi CHECK (total > 0)
-- );
--
INSERT INTO Comenzi
VALUES ('300', '103', SYSDATE -5.24, SYSDATE -0.13, '5885.62');

INSERT INTO Comenzi
VALUES ('301', '100', SYSDATE -2.86, NULL, '529.99');

INSERT INTO Comenzi
VALUES ('302', '101', SYSDATE -2.35, NULL, '1059.98');

-- CREATE TABLE Categorii (
--   id_categorie NUMBER constraint pk_categorii primary key,
--   nume VARCHAR2(50),
--   descriere VARCHAR2(200)
-- );
--
INSERT INTO Categorii
VALUES ('20', 'Laptop, Desktop', 'Laptopuri, sisteme PC, monitoare, hard disk drive, solid state drive, placi video, placi de baza, procesoare, memorii RAM, surse de alimentare, coolere, placi de sunet, placi de retea');

INSERT INTO Categorii
VALUES ('21', 'Electrocasnice mari si mici', 'Masini de spalat rufe, uscatoare de rufe, aparate frigorifice, masini de spalat vase, aragazuri, hote, esspressoare, cafetiere, aspiratoare, fiare de calcat, roboti de bucatarie, mixere');

INSERT INTO Categorii
VALUES ('22', 'Climatizare, incalzile locuinta', 'Aeroterme, calorifere electrice, radiatoare si convectoare, seminee electrice, boilere, aer conditionat, ventilator, umidificatoare, dezumidificatoare, purificatoare aer');

-- CREATE TABLE Produse (
--   id_produs NUMBER constraint pk_produse primary key,
--   id_categorie NUMBER constraint fk_id_categorie_produse references Categorii (id_categorie) on delete cascade,
--   nume VARCHAR2(50),
--   descriere VARCHAR2(200)
-- );
--
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

-- CREATE TABLE Recenzii (
--   id_client NUMBER constraint fk_id_client_recenzii references Clienti (id_client) on delete cascade,
--   id_produs NUMBER constraint fk_id_produs_recenzii references Produse (id_produs) on delete cascade,
--   data_recenzie DATE,
--   nota NUMBER constraint ck_nota_valid_recenzii CHECK (nota IN (1, 2, 3, 4, 5)),
--   constraint pk_recenzii primary key (id_client, id_produs)
-- );
--
INSERT INTO Recenzii
VALUES ('103', '53', SYSDATE -3.92, '4');

INSERT INTO Recenzii
VALUES ('101', '53', SYSDATE -3.56, '2');

INSERT INTO Recenzii
VALUES ('104', '53', SYSDATE -3.22, '5.');

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

-- CREATE TABLE Comercianti (
--   id_comerciant NUMBER constraint pk_comercianti primary key,
--   nume VARCHAR2(50) NOT NULL,
--   descriere VARCHAR2(200),
--   email VARCHAR2(50) constraint u_email_comercianti UNIQUE,
--   telefon VARCHAR2(15),
--   adresa VARCHAR2(100)
-- );
--
INSERT INTO Comercianti
VALUES ('10', 'Euroshop', 'NOWE KOLORY Sp. Z o.o', 'nowekolory@gmail.com', '+40 316 303 630', 'Niedzwiedzia 29b, Warszawa, Warszawa');

INSERT INTO Comercianti
VALUES ('11', 'MELAROX', 'MELAROX COM SRL', 'melaroxcom@gmail.com', '021 9969', 'Bistrita, str. Vasile Petri, nr 1, jud Bistrita-Nasaud, Bistrita, Bistrita-Nasaud, 420005');

INSERT INTO Comercianti
VALUES ('12', 'Abbruzzami', 'ABBRUZZAMI S.r.l.', 'abbruzzami@gmail.com', '+40 722 250 000', 'VIALE ABRUZZO 35, 64025, Pineto, Teramo');

INSERT INTO Comercianti
VALUES ('13', 'VEXIO', 'FANPLACE IT SRL', 'fanplaceit@gmail.ro', '+40 374 477 115', 'Str 1 mai nr 2, Panciu, Vrancea, 625400');

-- CREATE TABLE Oferte (
--   id_oferta NUMBER constraint pk_oferte primary key,
--   id_comerciant NUMBER constraint fk_id_comerciant_oferte references Comercianti (id_comerciant) on delete cascade,
--   id_produs NUMBER constraint fk_id_produs_oferte references Produse (id_produs) on delete cascade,
--   pret NUMBER(7, 2) constraint ck_pret_valid_oferte CHECK (pret > 0),
--   stoc NUMBER constraint ck_stoc_valid_oferte CHECK (stoc >= 0)
-- );
--
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

-- CREATE TABLE ContinutCosuri (
--   id_cos NUMBER constraint fk_id_cos_continutCosuri references Cosuri (id_cos) on delete cascade,
--   id_oferta NUMBER constraint fk_id_oferta_continutCosuri references Oferte (id_oferta) on delete cascade,
--   cantitate NUMBER constraint ck_cantitate_valid_continutCosuri CHECK (cantitate > 0),
--   constraint pk_continutCosuri primary key (id_cos, id_oferta)
-- );
--
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

-- CREATE TABLE ContinutComenzi (
--   id_comanda NUMBER constraint fk_id_comanda_continutComenzi references Comenzi (id_comanda) on delete cascade,
--   id_oferta NUMBER constraint fk_id_oferta_continutComenzi references Oferte (id_oferta) on delete cascade,
--   cantitate NUMBER constraint ck_cantitate_valid_continutComenzi CHECK (cantitate > 0),
--   constraint pk_continutComenzi primary key (id_comanda, id_oferta)
-- );
--
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