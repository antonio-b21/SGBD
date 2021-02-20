DROP TABLE ContinutComenzi;

DROP TABLE ContinutCosuri;

DROP TABLE Oferte;

DROP TABLE Comercianti;

DROP TABLE Recenzii;

DROP TABLE Produse;

DROP TABLE Categorii;

DROP TABLE Comenzi;

DROP TABLE Cosuri;

DROP TABLE Clienti;

CREATE TABLE Clienti (
  id_client NUMBER constraint pk_clienti primary key,
  prenume VARCHAR2(50),
  nume VARCHAR2(50),
  email VARCHAR2(50) constraint u_email_clienti UNIQUE,
  telefon VARCHAR2(15),
  adresa VARCHAR2(50)
);

CREATE TABLE Cosuri (
  id_cos NUMBER constraint pk_cosuri primary key constraint fk_id_cos_cosuri references Clienti (id_client) on delete cascade,
  nr_produse NUMBER constraint ck_nr_produse_valid_cosuri CHECK (nr_produse >= 0),
  total NUMBER(7, 2) constraint ck_total_valid_cosuri CHECK (total >= 0)
);

CREATE TABLE Comenzi (
  id_comanda NUMBER constraint pk_comenzi primary key,
  id_client NUMBER constraint fk_id_client_comenzi references Clienti (id_client) on delete cascade,
  data_plasare DATE,
  data_primire DATE,
  total NUMBER(7, 2) constraint ck_total_valid_comenzi CHECK (total >= 0)
);

CREATE TABLE Categorii (
  id_categorie NUMBER constraint pk_categorii primary key,
  nume VARCHAR2(50),
  descriere VARCHAR2(200)
);

CREATE TABLE Produse (
  id_produs NUMBER constraint pk_produse primary key,
  id_categorie NUMBER constraint fk_id_categorie_produse references Categorii (id_categorie) on delete cascade,
  nume VARCHAR2(50),
  descriere VARCHAR2(200)
);

CREATE TABLE Recenzii (
  id_client NUMBER constraint fk_id_client_recenzii references Clienti (id_client) on delete cascade,
  id_produs NUMBER constraint fk_id_produs_recenzii references Produse (id_produs) on delete cascade,
  data_recenzie DATE,
  nota NUMBER constraint ck_nota_valid_recenzii CHECK (nota IN (1, 2, 3, 4, 5)),
  constraint pk_recenzii primary key (id_client, id_produs)
);

CREATE TABLE Comercianti (
  id_comerciant NUMBER constraint pk_comercianti primary key,
  nume VARCHAR2(50) NOT NULL,
  descriere VARCHAR2(200),
  email VARCHAR2(50) constraint u_email_comercianti UNIQUE,
  telefon VARCHAR2(15),
  adresa VARCHAR2(100)
);

CREATE TABLE Oferte (
  id_oferta NUMBER constraint pk_oferte primary key,
  id_comerciant NUMBER constraint fk_id_comerciant_oferte references Comercianti (id_comerciant) on delete cascade,
  id_produs NUMBER constraint fk_id_produs_oferte references Produse (id_produs) on delete cascade,
  pret NUMBER(7, 2) constraint ck_pret_valid_oferte CHECK (pret > 0),
  stoc NUMBER constraint ck_stoc_valid_oferte CHECK (stoc >= 0)
);

CREATE TABLE ContinutCosuri (
  id_cos NUMBER constraint fk_id_cos_continutCosuri references Cosuri (id_cos) on delete cascade,
  id_oferta NUMBER constraint fk_id_oferta_continutCosuri references Oferte (id_oferta) on delete cascade,
  cantitate NUMBER constraint ck_cantitate_valid_continutCosuri CHECK (cantitate > 0),
  constraint pk_continutCosuri primary key (id_cos, id_oferta)
);

CREATE TABLE ContinutComenzi (
  id_comanda NUMBER constraint fk_id_comanda_continutComenzi references Comenzi (id_comanda) on delete cascade,
  id_oferta NUMBER constraint fk_id_oferta_continutComenzi references Oferte (id_oferta) on delete cascade,
  cantitate NUMBER constraint ck_cantitate_valid_continutComenzi CHECK (cantitate > 0),
  constraint pk_continutComenzi primary key (id_comanda, id_oferta)
);

SELECT
  DISTINCT owner,
  object_name
FROM
  all_objects
WHERE
  object_type = 'TABLE'
  AND owner LIKE 'SQL_%';
